/obj/structure/displaycase
	name = "display case"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "glassbox1"
	desc = "A display case for prized possessions. It taunts you to kick it."
	density = TRUE
	anchored = TRUE
//	unacidable = TRUE//Dissolving the case would also delete the gun.
	var/health = 30
	var/occupied = TRUE
	var/destroyed = FALSE

/obj/structure/displaycase/ex_act(severity)
	switch(severity)
		if (1)
			new /obj/item/weapon/material/shard( loc )
			if (occupied)
				new /obj/item/weapon/gun/energy/captain( loc )
				occupied = FALSE
			qdel(src)
		if (2)
			if (prob(50))
				health -= 15
				healthcheck()
		if (3)
			if (prob(50))
				health -= 5
				healthcheck()


/obj/structure/displaycase/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.get_structure_damage()
	..()
	healthcheck()
	return

/obj/structure/displaycase/proc/healthcheck()
	if (health <= FALSE)
		if (!( destroyed ))
			density = FALSE
			destroyed = TRUE
			new /obj/item/weapon/material/shard( loc )
			playsound(src, "shatter", 70, TRUE)
			update_icon()
	else
		playsound(loc, 'sound/effects/Glasshit.ogg', 75, TRUE)
	return

/obj/structure/displaycase/update_icon()
	if(destroyed)
		icon_state = "glassboxb[occupied]"
	else
		icon_state = "glassbox[occupied]"
	return


/obj/structure/displaycase/attackby(obj/item/weapon/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	health -= W.force
	healthcheck()
	..()
	return

/obj/structure/displaycase/attack_hand(mob/user as mob)
	if (destroyed && occupied)
		new /obj/item/weapon/gun/energy/captain( loc )
		user << "<span class='notice'>You deactivate the hover field built into the case.</span>"
		occupied = FALSE
		add_fingerprint(user)
		update_icon()
		return
	else
		usr << text("<span class='warning'>You kick the display case.</span>")
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				O << "<span class='warning'>[usr] kicks the display case.</span>"
		health -= 2
		healthcheck()
		return
