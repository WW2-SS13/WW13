
/obj/structure/barbwire
	name = "barbwire"
	icon_state = "barbwire"
	anchored = 1
	var/capture = 0

/obj/structure/barbwire/ex_act(severity)
	switch (severity)
		if (3.0)
			if (prob(50))
				qdel(src)
		else
			qdel(src)

/obj/structure/barbwire/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return 1


/obj/structure/barbwire/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover = get_turf(src)
	if(!cover)
		return 1
	if (get_dist(P.starting, loc) <= 1) //Tables won't help you if people are THIS close
		return 1

	var/chance = 50 - (P.penetrating * 3)
	if(prob(chance))
		visible_message("<span class='warning'>[P] hits \the [src]!</span>")
		return 0
	else
		return 1


/obj/structure/barbwire/Crossed(AM as mob|obj)
	if(ismob(AM))
		var/mob/M = AM
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if (prob (33))
				playsound(src.loc, 'sound/effects/glass_step.ogg', 50, 1)
				var/obj/item/organ/external/affecting = H.get_organ(pick("l_foot", "r_foot", "l_leg", "r_leg"))
				if(affecting.status & ORGAN_ROBOT)
					return
				if(affecting.take_damage(10, 0))
					H.UpdateDamageIcon()
				H.updatehealth()
				if(!(H.species && (H.species.flags)))
					H.Weaken(3)
				M << "\red <B>Your [affecting.name] gets slightly cut by \the [src]!</B>"
				return ..()
			if (prob (33))
				playsound(src.loc, 'sound/effects/glass_step.ogg', 50, 1)
				var/obj/item/organ/external/affecting = H.get_organ(pick("l_foot", "r_foot", "l_leg", "r_leg"))
				if(affecting.status & ORGAN_ROBOT)
					return
				if(affecting.take_damage(20, 0))
					H.UpdateDamageIcon()
				H.updatehealth()
				if(!(H.species && (H.species.flags)))
					H.Weaken(5)
				M << "\red <B>Your [affecting.name] gets cut by \the [src]!</B>"
				return ..()
			if (prob (33))
				playsound(src.loc, 'sound/effects/glass_step.ogg', 50, 1)
				var/obj/item/organ/external/affecting = H.get_organ(pick("l_foot", "r_foot", "l_leg", "r_leg"))
				if(affecting.status & ORGAN_ROBOT)
					return
				if(affecting.take_damage(30, 0))
					H.UpdateDamageIcon()
				H.updatehealth()
				if(!(H.species && (H.species.flags)))
					H.Weaken(7)
				M << "\red <B>Your [affecting.name] gets deeply cut by \the [src]!</B>"
				return ..()
	..()

/obj/structure/barbwire/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wirecutters))
		if(anchored)
			user.visible_message("\blue \The [user] starts to cut through \the [src] with [W].")
			if(!do_after(user,60))
				user.visible_message("\blue \The [user] decides not to cut through the \the [src].")
				return
			user.visible_message("\blue \The [user] finishes cutting through \the [src]!")
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
			qdel(src)
			return
			
	else if(istype(W, /obj/item/weapon/material/knife))
		if(anchored)
			user.visible_message("\blue \The [user] starts to cut through \the [src] with [W].")
			if(!do_after(user,80))
				user.visible_message("\blue \The [user] decides not to cut through \the [src].")
				return
			if(prob(40))
				user.visible_message("\blue \The [user] finishes cutting through \the [src]!")
				playsound(src.loc, 'sound/items/Wirecutter.ogg', 50, 1)
				qdel(src)
				return
			else
				if(ishuman(user))
					var/mob/living/carbon/human/H = user
					var/obj/item/organ/external/affecting = null
					if (istype(H.l_hand, /obj/item/weapon/material/knife))
						affecting = H.get_organ("l_hand")
					else
						affecting = H.get_organ("r_hand")
						
					user << "\red <B>Your hand slips, causing \the [src] to cut your [affecting.name] open!</B>"
					playsound(src.loc, 'sound/effects/glass_step.ogg', 50, 1)
					if(affecting.status & ORGAN_ROBOT)
						return
					if(affecting.take_damage(10, 0))
						H.UpdateDamageIcon()
					H.updatehealth()
					if(!(H.species && (H.species.flags)))
						H.Weaken(2)
