// poor stats with the exception of strength & survival
/mob/living/carbon/human/pillarman
	takes_less_damage = TRUE
	movement_speed_multiplier = 1.75
	size_multiplier = 1.50
	use_initial_stats = TRUE
	stats = list(
		"strength" = list(500,500),
		"engineering" = list(50,50),
		"rifle" = list(50,50),
		"mg" = list(50,50),
		"pistol" = list(50,50),
		"heavyweapon" = list(50,50),
		"medical" = list(50,50),
		"survival" = list(150,150))

	var/next_pose = -1
	var/energy = 0.50

	var/absorbing = FALSE

	var/next_shoot_burning_blood = -1

/mob/living/carbon/human/pillarman/New()
	..()
	spawn (10)
		if (!original_job)
			var/oloc = get_turf(src)
			job_master.EquipRank(src, "Pillar Man")
			loc = oloc

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
		var/absorbed = pick(0.19,0.20,0.21)
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
	var/heal_damage = 20 * (energy * energy)
	heal_overall_damage(heal_damage)

/mob/living/carbon/human/pillarman/Stat()
	. = ..()
	if (.)
		stat("Energy:", "[round(energy*100)]%")
