/turf/sky
	icon = 'icons/turf/sky.dmi'
	icon_state = ""
	name = "the sky"

// this is probably laggy as hell but oh well - Kachnov
/turf/sky/Entered(var/atom/movable/mover)
	..(mover)
	var/area/prishtina/void/sky/A = get_area(src)
	if (!istype(A))
		return
	if (!A.corresponding_area_type)
		return
	if (!istype(mover, /mob/observer))
		if (A.corresponding_area_allow_subtypes )
			for (var/area/AA in world)
				if (istype(AA, A.corresponding_area_type))
					mover.forceMove(pick(AA.contents))
					mover.loc = get_turf(mover.loc)
					break
		else
			var/area/AA = locate(A.corresponding_area_type)
			mover.forceMove(pick(AA.contents))
			mover.loc = get_turf(mover.loc)

	if (paratrooper_plane_master.isLethalToJump())
		if (ishuman(mover))
			var/mob/living/carbon/human/H = mover
			H << "<span class = 'userdanger'>You land hard on the ground.</span>"
			H.adjustBruteLossByPart(75, "l_leg")
			H.adjustBruteLossByPart(75, "r_leg")
		else if (isliving(mover))
			var/mob/living/L = mover
			L.adjustBruteLoss(150)
	else
		if (ishuman(mover))
			mover << "<span class = 'good'>You land softly on the ground.</span>"