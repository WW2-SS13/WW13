/mob/living/carbon/human/mechahitler
	takes_less_bullet_damage = TRUE
	movement_speed_multiplier = 1.50
	size_multiplier = 2.50
	use_initial_stats = TRUE
	stats = list(
		"strength" = list(400,400),
		"engineering" = list(400,400),
		"rifle" = list(400,400),
		"mg" = list(400,400),
		"pistol" = list(400,400),
		"heavyweapon" = list(400,400),
		"medical" = list(400,400),
		"survival" = list(400,400))

	f_style = "Square Mustache"

/mob/living/carbon/human/mechahitler/New()
	..()
	var/oloc = loc
	job_master.EquipRank(src, "Oberleutnant")
	spawn (1)
		loc = oloc
		name = "MECHA HITLER"
		real_name = "MECHA HITLER"