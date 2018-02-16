/obj/structure/grille/fence
	icon_state = "fence4-8"

/obj/structure/anti_tank
	icon_state = "anti-tank"
	bound_width = 32
	bound_height = 32
	density = TRUE

/obj/structure/flag
	icon = 'icons/obj/flags.dmi'
	layer = MOB_LAYER + 0.01
	bound_width = 32
	bound_height = 32
	density = TRUE
	anchored = TRUE

/obj/structure/flag/soviet
	icon_state = "soviet"
	name = "Soviet Flag"

/obj/structure/flag/german
	icon_state = "german"
	name = "German Flag"

/obj/structure/flag/italian
	icon_state = "italian"
	name = "Italian Flag"

/obj/structure/flag/ukrainian
	icon_state = "ukrainian"
	name = "Ukrainian Flag"

/obj/structure/noose
	icon = 'icons/obj/noose.dmi'
	icon_state = ""
	layer = MOB_LAYER + 1.0
	anchored = TRUE
	var/mob/living/carbon/human/hanging = null

/obj/structure/noose/New()
	..()
	processing_objects += src

/obj/structure/noose/Del()
	processing_objects -= src
	..()

/obj/structure/noose/process()
	if (hanging)
		hanging.dir = SOUTH
		icon_state = "noose-hanging"
		if (pixel_x == 0)
			pixel_x = 1
		else if (pixel_x == 1)
			pixel_x = 0
		else if (pixel_x == 0)
			pixel_x = -1

		if (hanging.stat != DEAD)
			hanging.pixel_x = pixel_x
			hanging.adjustOxyLoss(5)
			density = TRUE
			if (prob(5))
				visible_message("<span class = 'danger'>[hanging]'s neck snaps.</span>")
				playsound(get_turf(src), 'sound/effects/gore/bullethit3.ogg')
				hanging.death()
	else
		icon_state = ""
		density = FALSE

/obj/structure/noose/MouseDrop_T(var/atom/dropping, var/mob/user as mob)
	if (!ismob(dropping))
		return

	if (hanging)
		return

	var/mob/living/carbon/human/target = dropping
	var/mob/living/carbon/human/hangman = user

	if (!istype(target) || !istype(hangman))
		return

	visible_message("<span class = 'danger'>[hangman] starts to hang [target == hangman ? "themselves" : target]...</span>")
	if (do_after(hangman, 50, target))
		if (src)
			visible_message("<span class = 'danger'>[hangman] hangs [target == hangman ? "themselves" : target]!</span>")
			animate(target, pixel_y = 3, 0, -1)
			hanging = target
			target.loc = get_turf(src)
			target.dir = SOUTH

/obj/structure/noose/attack_hand(var/mob/living/carbon/human/H)
	if (!istype(H))
		return

	if (!hanging)
		return

	if (hanging == H)
		return

	visible_message("<span class = 'danger'>[H] starts to free [hanging] from the noose...</span>")
	if (do_after(H, 75, src))
		if (src)
			visible_message("<span class = 'danger'>[H] frees [hanging] from the noose!</span>")
			animate(hanging, pixel_y = 0, 0, -1)
			hanging = null