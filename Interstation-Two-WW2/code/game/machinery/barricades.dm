/*
CONTAINS:

Deployable items
Barricades

for reference:

	access_security = TRUE
	access_brig = 2
	access_armory = 3
	access_forensics_lockers= 4
	access_medical = 5
	access_morgue = 6
	access_tox = 7
	access_tox_storage = 8
	access_genetics = 9
	access_engine = 10
	access_engine_equip= 11
	access_maint_tunnels = 12
	access_external_airlocks = 13
	access_emergency_storage = 14
	access_change_ids = 15
	access_ai_upload = 16
	access_teleporter = 17
	access_eva = 18
	access_heads = 19
	access_captain = 20
	access_all_personal_lockers = 21
	access_chapel_office = 22
	access_tech_storage = 23
	access_atmospherics = 24
	access_bar = 25
	access_janitor = 26
	access_crematorium = 27
	access_kitchen = 28
	access_robotics = 29
	access_rd = 30
	access_cargo = 31
	access_construction = 32
	access_chemistry = 33
	access_cargo_bot = 34
	access_hydroponics = 35
	access_manufacturing = 36
	access_library = 37
	access_lawyer = 38
	access_virology = 39
	access_cmo = 40
	access_qm = 41
	access_court = 42
	access_clown = 43
	access_mime = 44

*/

//Barricades!
/obj/structure/barricade
	name = "barricade"
	desc = "This space is blocked off by a barricade."
	icon = 'icons/obj/structures.dmi'
	icon_state = "barricade"
	anchored = TRUE

	density = TRUE
	var/health = 200
	var/maxhealth = 200
	var/material/material

/obj/structure/barricade/New(var/newloc, var/material_name)
	..(newloc)
	if(!material_name)
		material_name = "wood"
	material = get_material_by_name("[material_name]")
	if(!material)
		qdel(src)
		return
	name = "[material.display_name] barricade"
	desc = "This space is blocked off by a barricade made of [material.display_name]."
	color = material.icon_colour
	maxhealth = material.integrity
	health = maxhealth

/obj/structure/barricade/get_material()
	return material

/obj/structure/barricade/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/stack))
		var/obj/item/stack/D = W
		if(D.get_material_name() != material.name)
			return //hitting things with the wrong type of stack usually doesn't produce messages, and probably doesn't need to.
		if (health < maxhealth)
			if (D.get_amount() < TRUE)
				user << "<span class='warning'>You need one sheet of [material.display_name] to repair \the [src].</span>"
				return
			visible_message("<span class='notice'>[user] begins to repair \the [src].</span>")
			if(do_after(user,20,src) && health < maxhealth)
				if (D.use(1))
					health = maxhealth
					visible_message("<span class='notice'>[user] repairs \the [src].</span>")
				return
		return
	else
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		switch(W.damtype)
			if("fire")
				health -= W.force * TRUE
			if("brute")
				health -= W.force * 0.75

		playsound(get_turf(src), 'sound/weapons/smash.ogg', 100)

		try_destroy()

		..()

/obj/structure/barricade/proc/try_destroy()
	if (health <= FALSE)
		visible_message("<span class='danger'>The barricade is smashed apart!</span>")
		dismantle()
		qdel(src)
		return

/obj/structure/barricade/proc/dismantle()
	material.place_dismantled_product(get_turf(src))
	qdel(src)
	return

/obj/structure/barricade/ex_act(severity)
	switch(severity)
		if(1.0)
			visible_message("<span class='danger'>\The [src] is blown apart!</span>")
			qdel(src)
			return
		if(2.0)
			health -= 25
			if (health <= FALSE)
				visible_message("<span class='danger'>\The [src] is blown apart!</span>")
				dismantle()
			return


/* the only barricades still in the code are wood barricades, which SHOULD
  be hit by bullets, at least sometimes - hence these changes. */

/obj/structure/barricade/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)//So bullets will fly over and stuff.
	if(air_group || (height==0))
		if (prob(30))
			return TRUE
	if(istype(mover) && mover.checkpass(PASSTABLE))
		if (prob(30))
			return TRUE
	else
		return FALSE

/obj/structure/barricade/bullet_act(var/obj/item/projectile/proj)
	health -= proj.damage
	visible_message("<span class='warning'>\The [src] is hit by the bullet!</span>")
	try_destroy()
/*
//Actual Deployable machinery stuff
/obj/machinery/deployable
	name = "deployable"
	desc = "deployable"
	icon = 'icons/obj/objects.dmi'
	req_access = list(access_security)//I'm changing this until these are properly tested./N

/obj/machinery/deployable/barrier
	name = "deployable barrier"
	desc = "A deployable barrier. Swipe your ID card to lock/unlock it."
	icon = 'icons/obj/objects.dmi'
	anchored = 0.0
	density = 1.0
	icon_state = "barrier0"
	var/health = 100.0
	var/maxhealth = 100.0
	var/locked = 0.0
//	req_access = list(access_maint_tunnels)

	New()
		..()

		icon_state = "barrier[locked]"

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if (istype(W, /obj/item/weapon/card/id/))
			if (allowed(user))
				if	(emagged < 2.0)
					locked = !locked
					anchored = !anchored
					icon_state = "barrier[locked]"
					if ((locked == 1.0) && (emagged < 2.0))
						user << "Barrier lock toggled on."
						return
					else if ((locked == 0.0) && (emagged < 2.0))
						user << "Barrier lock toggled off."
						return
				else
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(2, TRUE, src)
					s.start()
					visible_message("<span class='warning'>BZZzZZzZZzZT</span>")
					return
			return
		else if (istype(W, /obj/item/weapon/wrench))
			if (health < maxhealth)
				health = maxhealth
				emagged = FALSE
				req_access = list(access_security)
				visible_message("<span class='warning'>[user] repairs \the [src]!</span>")
				return
			else if (emagged > FALSE)
				emagged = FALSE
				req_access = list(access_security)
				visible_message("<span class='warning'>[user] repairs \the [src]!</span>")
				return
			return
		else
			switch(W.damtype)
				if("fire")
					health -= W.force * 0.75
				if("brute")
					health -= W.force * 0.5
				else
			if (health <= FALSE)
				explode()
			..()

	ex_act(severity)
		switch(severity)
			if(1.0)
				explode()
				return
			if(2.0)
				health -= 25
				if (health <= FALSE)
					explode()
				return
	emp_act(severity)
		if(stat & (BROKEN|NOPOWER))
			return
		if(prob(50/severity))
			locked = !locked
			anchored = !anchored
			icon_state = "barrier[locked]"

	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)//So bullets will fly over and stuff.
		if(air_group || (height==0))
			return TRUE
		if(istype(mover) && mover.checkpass(PASSTABLE))
			return TRUE
		else
			return FALSE

	proc/explode()

		visible_message("<span class='danger'>[src] blows apart!</span>")
		var/turf/Tsec = get_turf(src)

	/*	var/obj/item/stack/rods/ =*/
		PoolOrNew(/obj/item/stack/rods, Tsec)

		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, TRUE, src)
		s.start()

		explosion(loc,-1,-1,0)
		if(src)
			qdel(src)


/obj/machinery/deployable/barrier/emag_act(var/remaining_charges, var/mob/user)
	if (emagged == FALSE)
		emagged = TRUE
		req_access.Cut()
		req_one_access.Cut()
		user << "You break the ID authentication lock on \the [src]."
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(2, TRUE, src)
		s.start()
		visible_message("<span class='warning'>BZZzZZzZZzZT</span>")
		return TRUE
	else if (emagged == TRUE)
		emagged = 2
		user << "You short out the anchoring mechanism on \the [src]."
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(2, TRUE, src)
		s.start()
		visible_message("<span class='warning'>BZZzZZzZZzZT</span>")
		return TRUE
*/