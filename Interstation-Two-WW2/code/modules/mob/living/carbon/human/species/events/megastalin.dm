/mob/living/carbon/human/megastalin
	takes_less_bullet_damage = TRUE
	movement_speed_multiplier = 1.50
	size_multiplier = 3.00
	use_initial_stats = TRUE
	stats = list(
		"strength" = list(500,500),
		"engineering" = list(350,350),
		"rifle" = list(350,350),
		"mg" = list(350,350),
		"pistol" = list(350,350),
		"heavyweapon" = list(350,350),
		"medical" = list(350,350),
		"survival" = list(350,350))

	f_style = "Selleck Mustache"

/mob/living/carbon/human/megastalin/New()
	..()
	var/oloc = loc
	job_master.EquipRank(src, "Comandir Batalyona")
	spawn (1)
		loc = oloc
		name = "MEGA STALIN"
		real_name = "MEGA STALIN"