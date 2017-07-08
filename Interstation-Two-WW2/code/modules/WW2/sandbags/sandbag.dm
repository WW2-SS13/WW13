// this now inherits from window as its an easy way to give it the same
// multidirectional collision behavior

/mob/living/carbon/human/var/crouching = 0

/obj/structure/window/sandbag
	name = "sandbag"
	icon_state = "sandbag"
	layer = MOB_LAYER + 0.01 //just above mobs
	anchored = 1

/obj/structure/window/sandbag/attack_hand(var/mob/user as mob)
	if (alert(user, "Dismantle the sandbag?", "", "Continue", "Stop") == "Continue")
		visible_message("<span class='danger'>[user] starts dismantling the sandbag wall.</span>", "<span class='danger'>You start dismantling the sandbag wall.</span>")
		if (do_after(user, rand(70,80), src))
			visible_message("<span class='danger'>[user] finishes dismantling the sandbag wall.</span>", "<span class='danger'>You finish dismantling the sandbag wall.</span>")
			qdel(src)
/*
/obj/structure/window/sandbag/verb/crouch()
	set category = "Sandbag"
	set src in oview(2, usr)
	if (ishuman(usr))
		var/mob/living/carbon/human/H = usr
		if (istype(src, /obj/structure/window/sandbag/incomplete))
			H << "<span class = 'warning'>Crouching under this one won't do you any good.</span>"
			return
		H.crouching = !H.crouching
		if (locate(src) in get_step(H, H.dir) || locate(src) in get_step(get_step(H, H.dir), H.dir))
			// shitcode inbound - Kachnov
			if (H.crouching)
				H.pixel_y -= 16
				H.layer = MOB_LAYER - 0.06
				H << "<span class = 'warning'>You squat behind the sandbag wall.</span>"
			else
				H.pixel_y += 16
				H.layer = initial(H.layer)
				H << "<span class = 'warning'>You stop squatting behind the sandbag wall.</span>"
	else
		usr << "<span class = 'warning'>You can't do that.</span>"
*/
/obj/structure/window/sandbag/ex_act(severity)
	switch(severity)
		if(1.0)
			PoolOrNew(/obj/structure/window/sandbag, src.loc)
			PoolOrNew(/obj/structure/window/sandbag, src.loc)
			PoolOrNew(/obj/structure/window/sandbag, src.loc)
			qdel(src)
			return
		if(2.0)
			PoolOrNew(/obj/structure/window/sandbag, src.loc)
			PoolOrNew(/obj/structure/window/sandbag, src.loc)
			qdel(src)
			return
		else
			if (prob(50))
				return ex_act(2.0)
	return

/obj/structure/window/sandbag/New(location, var/mob/creator)
	loc = location
	flags |= ON_BORDER

	if (creator && ismob(creator))
		dir = creator.dir
	else
		var/ndir = creator
		dir = ndir

	set_dir(dir)

	switch (dir)
		if (NORTH)
			layer = MOB_LAYER - 0.01
			pixel_y = 0
		if (SOUTH)
			layer = MOB_LAYER + 0.01
			pixel_y = 0
		if (EAST)
			layer = MOB_LAYER - 0.05
			pixel_x = 0
		if (WEST)
			layer = MOB_LAYER - 0.05
			pixel_x = 0

//incomplete sandbag structures
/obj/structure/window/sandbag/incomplete
	name = "incomplete sandbag"
	icon_state = "sandbag_33%"
	var/progress = 0
	var/maxProgress = 5


/obj/structure/window/sandbag/incomplete/ex_act(severity)
	qdel(src)

/obj/structure/window/sandbag/incomplete/attackby(obj/O as obj, mob/user as mob)
	if (istype(O, /obj/item/weapon/sandbag))
		var/obj/item/weapon/sandbag/sandbag = O
		progress += (sandbag.sand_amount + 1)
		if (progress >= maxProgress/2)
			icon_state = "sandbag_66%"
			if (progress >= maxProgress)
				icon_state = "sandbag"
				new/obj/structure/window/sandbag(loc, dir)
				qdel(src)
		visible_message("<span class='danger'>[user] adds a bag to [src].</span>")
		qdel(O)

/obj/structure/window/sandbag/set_dir(direction)
	dir = direction

// sandbag window overrides


/obj/structure/window/sandbag/examine(mob/user)
	user << "That's a sandbag."
	return 1

/obj/structure/window/sandbag/take_damage(var/damage = 0, var/sound_effect = 1)
	return 0

/obj/structure/window/sandbag/apply_silicate(var/amount)
	return 0

/obj/structure/window/sandbag/updateSilicate()
	return 0

/obj/structure/window/sandbag/shatter(var/display_message = 1)
	return 0

/obj/structure/window/sandbag/bullet_act(var/obj/item/projectile/Proj)
	return 0

/obj/structure/window/sandbag/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			if(prob(50))
				qdel(src)

/obj/structure/window/sandbag/is_full_window()
	return 0

/obj/structure/window/sandbag/proc/is_beyond(var/atom/a)
	if (dir == EAST && x > a.x)
		return 1
	if (dir == WEST && x < a.x)
		return 1
	if (dir == NORTH && y > a.y)
		return 1
	if (dir == SOUTH && y < a.y)
		return 1
	return 0


/obj/structure/window/sandbag/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(get_dir(O.loc, target) == dir)
		if (ismob(O))
			return 0
	return 1

/obj/structure/window/hitby(AM as mob|obj)
	return 0 // don't move

/obj/structure/window/sandbag/attack_tk(mob/user as mob)
	return 0

/obj/structure/window/sandbag/attack_generic(var/mob/user, var/damage)
	return 0

/obj/structure/window/sandbag/rotate()
	return


/obj/structure/window/sandbag/revrotate()
	return

/obj/structure/window/sandbag/is_fulltile()
	return 0

/obj/structure/window/sandbag/update_verbs()
	verbs -= /obj/structure/window/proc/rotate
	verbs -= /obj/structure/window/proc/revrotate

//merges adjacent full-tile windows into one (blatant ripoff from game/smoothwall.dm)
/obj/structure/window/sandbag/update_icon()
	return

/obj/structure/window/sandbag/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return

/obj/item/weapon/sandbag
	name = "sandbag"
	icon_state = "sandbag"
	icon = 'icons/obj/items.dmi'
	w_class = 1
	var/sand_amount = 0

/*

/obj/item/weapon/sandbag/attack_self(mob/user as mob)
	if(sand_amount < 4)
		user << "\red You need more sand to make wall."
		return
	for(var/obj/structure/window/sandbag/baggy in src.loc)
		if(baggy.dir == user.dir)
			user << "\red There is no more space."
			return

	var/obj/structure/window/sandbag/bag = new(src.loc)
	bag.set_dir(user.dir)
	user.drop_item()
	qdel(src)
	*/

/obj/item/weapon/sandbag/attackby(obj/O as obj, mob/user as mob)
	if(istype(O, /obj/item/weapon/ore/glass))
		if(sand_amount >= 4)
			user << "\red [name] is full!"
			return
		user.drop_item()
		qdel(O)
		sand_amount++
		w_class++
		update_icon()
		user << "You need [4 - sand_amount] more units."



//obj/item/weapon/ore/glass
