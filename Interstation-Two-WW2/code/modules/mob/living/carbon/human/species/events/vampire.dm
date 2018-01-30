// normal stats with the exception of strength & survival
/mob/living/carbon/human/vampire
	takes_less_damage = TRUE
	movement_speed_multiplier = 1.50
	use_initial_stats = TRUE
	stats = list(
		"strength" = list(300,300),
		"engineering" = list(100,100),
		"rifle" = list(100,100),
		"mg" = list(100,100),
		"pistol" = list(100,100),
		"heavyweapon" = list(100,100),
		"medical" = list(100,100),
		"survival" = list(125,125))

	var/blood = 0.50

	color = "#FFB2B2"

	var/absorbing = FALSE

/mob/living/carbon/human/vampire/New(_loc, var/clothes = TRUE)
	..(_loc)
	spawn (10)
		if (!original_job)
			var/oloc = get_turf(src)
			job_master.EquipRank(src, "Vampire")
			if (!clothes)
				for (var/obj/item/clothing/I in contents)
					drop_from_inventory(I)
					qdel(I)
			loc = oloc

/mob/living/carbon/human/vampire/proc/drink(var/mob/living/carbon/human/H)
	if (!istype(H))
		return FALSE
	if (H.type == type)
		return FALSE
	if (H.vessel.total_volume <= 0)
		src << "<span class = 'danger'>[H] has no blood left to offer us.</span>"
		return
	if (absorbing)
		return FALSE
	absorbing = TRUE
	visible_message("<span class = 'danger'>[src] starts to absorb [H]'s blood through his fingers!</span>")
	playsound(get_turf(src), 'sound/effects/bloodsuck.ogg', 100)
	for (var/v in 1 to 5)
		spawn ((v-1) * 10)
			if (do_after(src, 10, H))
				visible_message("<span class = 'danger'>[src] absorbs [H]'s blood through his fingers!</span>")
				blood = min(1.50, blood+pick(0.03,0.04,0.05))
				var/H_bloodloss = min(50, H.vessel.total_volume)
				H.drip(H_bloodloss)
				drip(-H_bloodloss)
				for (var/datum/reagent/blood/B in vessel.reagent_list)
					B.volume = min(B.volume, vessel.maximum_volume)
				H.adjustOxyLoss(7)
				if (H.vessel.total_volume <= 0)
					src << "<span class = 'danger'>[H] has no blood left to offer us.</span>"
					return
	spawn (50)
		absorbing = FALSE

/mob/living/carbon/human/vampire/Life()
	..()
	var/heal_damage = 7 * (blood * blood)
	heal_overall_damage(heal_damage)

/mob/living/carbon/human/vampire/Stat()
	. = ..()
	if (.)
		stat("Blood:", "[round(blood*100)]%")