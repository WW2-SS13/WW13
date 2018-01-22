/mob/living/carbon/human/var/stored_tally = 0
/mob/living/carbon/human/var/next_calculate_tally = -1

/mob/living/carbon/human/movement_delay()

	if (world.timeofday <= next_calculate_tally)
		return stored_tally

	var/tally = 0

	if(species.slowdown)
		tally = species.slowdown

	if (istype(loc, /turf/space)) return -1 // It's hard to be slowed down in space by... anything

	if(embedded_flag)
		handle_embedded_objects() //Moving with objects stuck in you can cause bad times.

	if (chem_effects.Find(CE_SPEEDBOOST))
		return -1

	var/health_deficiency = (maxHealth - health)
	if(health_deficiency >= 40) tally += (health_deficiency / 25)

	if (!(species && (species.flags & NO_PAIN)))
		if(halloss >= 10) tally += (halloss / 10) //halloss shouldn't slow you down if you can't even feel it

	if (nutrition <= 0)
		var/hungry = (500 - nutrition)/5 // So overeat would be 100 and default level would be 80
		if (hungry >= 100) tally += hungry/70

	if(wear_suit)
		tally += wear_suit.slowdown

	if(buckled && istype(buckled, /obj/structure/bed/chair/wheelchair))
		for(var/organ_name in list("l_hand","r_hand","l_arm","r_arm"))
			var/obj/item/organ/external/E = get_organ(organ_name)
			if(!E || E.is_stump())
				tally += 3
			if(E.status & ORGAN_SPLINTED)
				tally += 0.4
			else if(E.status & ORGAN_BROKEN)
				tally += 1.2
	else
		if(shoes)
			tally += shoes.slowdown

		for(var/organ_name in list("l_foot","r_foot","l_leg","r_leg"))
			var/obj/item/organ/external/E = get_organ(organ_name)
			if(!E || E.is_stump())
				tally += 4
			else if(E.status & ORGAN_SPLINTED)
				tally += 0.5
			else if(E.status & ORGAN_BROKEN)
				tally += 1.5

	var/obj/item/organ/external/E = get_organ("chest")
	if(!E || ((E.status & ORGAN_BROKEN) && E.brute_dam > E.min_broken_damage) || (E.status & ORGAN_MUTATED))
		tally += 4

	if(shock_stage >= 10) tally += 3

	if(aiming && aiming.aiming_at) tally += 5 // Iron sights make you slower, it's a well-known fact.

	if(FAT in mutations)
		tally += 1.5
	if (bodytemperature < 283.222)
		tally += (283.222 - bodytemperature) / 10 * 1.75

	tally += max(2 * stance_damage, FALSE) //damaged/missing feet or legs is slow

	if(mRun in mutations)
		tally = 0

	// no more huge speedups from wearing shoes
	. = max(0, (tally+config.human_delay))
	stored_tally = .

	next_calculate_tally = world.timeofday + 50

/mob/living/carbon/human/Process_Spacemove(var/check_drift = FALSE)
	return FALSE

/mob/living/carbon/human/slip_chance(var/prob_slip = 5)
	if(!..())
		return FALSE

	//Check hands and mod slip
	if(!l_hand)	prob_slip -= 2
	else if(l_hand.w_class <= 2)	prob_slip -= TRUE
	if (!r_hand)	prob_slip -= 2
	else if(r_hand.w_class <= 2)	prob_slip -= TRUE

	return prob_slip

/mob/living/carbon/human/Check_Shoegrip()
	if(species.flags & NO_SLIP)
		return TRUE
	if(shoes && (shoes.item_flags & NOSLIP) && istype(shoes, /obj/item/clothing/shoes/magboots))  //magboots + dense_object = no floating
		return TRUE
	return FALSE
