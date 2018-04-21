/obj/structure/wild
	icon = 'icons/obj/wild.dmi'
	anchored = TRUE
	var/sways = FALSE
/*
/obj/structure/wild/New()
	..()*/
/*
	spawn (50)
		for (var/obj/structure/S in get_turf(src))
			if (S && istype(S) && S != src)
				qdel(src)
				return
*/
/obj/structure/wild/Destroy()
	for (var/obj/o in get_turf(src))
		if (o.special_id == "seasons")
			qdel(o)
	..()

/obj/structure/wild/fire_act(temperature)
	if (sprob(35 * (temperature/500)))
		visible_message("<span class = 'warning'>[src] is burned away.</span>")
		qdel(src)

// it's windy out
/obj/structure/wild/proc/sway()
	if (!sways)
		return
	icon_state = "[initial(icon_state)]_swaying_[spick("left", "right")]"

/obj/structure/wild/CanPass()
	return FALSE // perfect protection from bullets until it dies

/obj/structure/wild/bullet_act(var/obj/item/projectile/proj)
	if (sprob(proj.damage))
		visible_message("<span class = 'danger'>[src] collapses!</span>")
		qdel(src)

/obj/structure/wild/tree
	name = "tree"
	icon_state = "tree"
	opacity = TRUE
	density = TRUE
	sways = TRUE

/obj/structure/wild/tree/fire_act(temperature)
	if (sprob(15 * (temperature/500)))
		visible_message("<span class = 'warning'>[src] collapses.</span>")
		qdel(src)

/obj/structure/wild/tree/anchored

/obj/structure/wild/tree/New()
	..()
	if (!istype(src, /obj/structure/wild/tree/anchored))
		pixel_x = srand(-8,8)

/obj/structure/wild/bush
	name = "bush"
	icon_state = "small_bush"
	opacity = FALSE
	density = FALSE

/* todo: bush sounds
/obj/structure/wild/bush/Crossed(var/atom/movable/am)
	if (!istype(src, /obj/structure/wild/bush/tame))
		if (istype(am, /mob/living))
			playsound(get_turf(src), "rustle", srand(50,70))
	..(am)
*/

/obj/structure/wild/bush/tame
	name = "cultivated bush"

/obj/structure/wild/bush/tame/big
	name = "large cultivated bush"
	icon_state = "big_bush"

/obj/structure/wild/bush/New()
	..()

	if (istype(src, /obj/structure/wild/bush/tame))
		return

	if (sprob(25))
		icon_state = "grassybush_[srand(1,4)]"
	else if (sprob(25))
		icon_state = "leafybush_[srand(1,3)]"
	else if (sprob(25))
		icon_state = "palebush_[srand(1,4)]"
	else
		icon_state = "stalkybush_[srand(1,3)]"