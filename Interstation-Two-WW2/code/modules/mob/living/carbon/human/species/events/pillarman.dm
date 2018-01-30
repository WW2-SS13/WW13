// poor stats with the exception of strength & survival
/mob/living/carbon/human/pillarman
	takes_less_damage = TRUE
	movement_speed_multiplier = 1.75
	size_multiplier = 1.50
	use_initial_stats = TRUE
	stats = list(
		"strength" = list(900,900),
		"engineering" = list(50,50),
		"rifle" = list(50,50),
		"mg" = list(50,50),
		"pistol" = list(50,50),
		"heavyweapon" = list(50,50),
		"medical" = list(50,50),
		"survival" = list(150,150))

	has_hunger_and_thirst = FALSE
	has_pain = FALSE

	var/next_pose = -1
	var/energy = 0.50

	var/absorbing = FALSE

	var/next_shoot_burning_blood = -1

	var/frozen = FALSE

/mob/living/carbon/human/pillarman/New()
	..()
	spawn (10)
		if (!original_job)
			var/oloc = get_turf(src)
			job_master.EquipRank(src, "Pillar Man")
			loc = oloc

/mob/living/carbon/human/pillarman/proc/may_absorb()
	return energy <= 1.40

/mob/living/carbon/human/pillarman/proc/absorb(var/mob/living/carbon/human/H)
	if (!istype(H))
		return FALSE
	if (H.type == type)
		return FALSE
	if (absorbing)
		return FALSE
	absorbing = TRUE
	visible_message("<span class = 'danger'>[src] starts to absorb [H] through his fingers!</span>")
	playsound(get_turf(src), 'sound/effects/bloodsuck.ogg', 100)
	if (do_after(src, 25, H))
		visible_message("<span class = 'danger'>[src] absorbs [H] through his fingers!</span>")
		var/absorbed = 0.50
		if (istype(H, /mob/living/carbon/human/vampire))
			absorbed *= 2
		energy = min(1.50, energy+absorbed)
		drip(-500)
		for (var/datum/reagent/blood/B in vessel.reagent_list)
			B.volume = min(B.volume, vessel.maximum_volume)
		H.crush()
	absorbing = FALSE

/mob/living/carbon/human/pillarman/proc/shoot_burning_blood()

	visible_message("<span class = 'danger'>[src] ejects burning blood from their veins!</span>")

	next_shoot_burning_blood = world.time + 50

	var/steps = 0
	var/turf/T = get_step(src, dir)
	while (!T.density && !locate(/obj/structure) in T && steps < 10)
		T = get_step(T, dir)
		++steps

	if (!steps)
		return FALSE

	var/obj/O = new/obj/burning_blood(get_turf(src))
	O.throw_at(T, 10, 1, src)

	return TRUE

/mob/living/carbon/human/pillarman/Life()
	..()

	nutrition = max_nutrition
	water = max_water

	// takes 625 ticks (21 minutse) for us to start starving, if we don't consume any blood
	// while blood == 0, we don't heal either

	// update: now it takes 3x as many ticks because we use blood when healing
	// too
	energy = max(0, energy - (0.0008/3))
	if (energy <= 0)
		if (prob(10))
			adjustBruteLoss(72)
			src << "<span class = 'danger'>You're starving from a lack of life energy!</span>"
		return

	var/loss = getTotalLoss()

	var/heal_damage = (14 * (energy * energy)) + 2
	adjustBruteLoss(-heal_damage*getStatCoeff("strength"))
	adjustFireLoss(-heal_damage*getStatCoeff("strength"))
	adjustToxLoss(-heal_damage*getStatCoeff("strength"))
	adjustOxyLoss((-heal_damage*getStatCoeff("strength"))/10)

	var/healedLoss = loss - getTotalLoss()
	if (healedLoss > 0)
		if (energy >= 0.25)
			energy -= healedLoss/4000 // lose 2.5% blood for every 100 brute taken

	var/area/A = get_area(src)
	if (A.location == AREA_OUTSIDE)
		if (list("Early Morning", "Morning", "Afternoon", "Midday").Find(time_of_day))
			frozen = TRUE
			return

	frozen = FALSE

/mob/living/carbon/human/pillarman/Move()
	if (frozen)
		src << "<span class = 'danger'>You're frozen in place by the sunlight!</span>"
		return FALSE
	..()

/mob/living/carbon/human/pillarman/Stat()
	. = ..()
	if (.)
		stat("Energy:", "[round(energy*100)]%")
