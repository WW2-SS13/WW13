/mob/living/carbon/human/mechahitler
	takes_less_damage = TRUE
	movement_speed_multiplier = 1.50
	size_multiplier = 2.50
	f_style = "Square Mustache"
	has_hunger_and_thirst = FALSE

/mob/living/carbon/human/mechahitler/New(_loc, new_species, snowflake = FALSE)
	..(_loc, new_species)
	var/oloc = loc
	job_master.EquipRank(src, "Hauptmann")
	if (snowflake)
		spawn (1)
			loc = oloc
			name = "MECHA HITLER"
			real_name = "MECHA HITLER"
			setStat("strength", 450)
			setStat("engineering", 500)
			setStat("rifle", 500)
			setStat("mg", 500)
			setStat("smg", 500)
			setStat("pistol", 500)
			setStat("heavyweapon", 500)
			setStat("medical", 500)
			setStat("shotgun", 500)
			setStat("survival", 100)


/mob/living/carbon/human/megastalin
	takes_less_damage = TRUE
	movement_speed_multiplier = 1.50
	size_multiplier = 3.00
	f_style = "Selleck Mustache"
	has_hunger_and_thirst = FALSE

/mob/living/carbon/human/megastalin/New(_loc, new_species, snowflake = FALSE)
	..(_loc, new_species)
	var/oloc = loc
	job_master.EquipRank(src, "Kapitan")
	if (snowflake)
		spawn (1)
			loc = oloc
			name = "MEGA STALIN"
			real_name = "MEGA STALIN"
			setStat("strength", 500)
			setStat("engineering", 450)
			setStat("rifle", 450)
			setStat("mg", 450)
			setStat("smg", 450)
			setStat("pistol", 450)
			setStat("heavyweapon", 450)
			setStat("medical", 450)
			setStat("shotgun", 450)
			setStat("survival", 100)

/mob/living/carbon/human/megaroosevelt
	takes_less_damage = TRUE
	movement_speed_multiplier = 1.50
	size_multiplier = 3.00
	has_hunger_and_thirst = FALSE

/mob/living/carbon/human/megaroosevelt/New(_loc, new_species, snowflake = FALSE)
	..(_loc, new_species)
	var/oloc = loc
	job_master.EquipRank(src, "Captain")
	if (snowflake)
		spawn (1)
			loc = oloc
			name = "MEGA ROOSEVELT"
			real_name = "MEGA ROOSEVELT"
			setStat("strength", 500)
			setStat("engineering", 450)
			setStat("rifle", 600)
			setStat("mg", 450)
			setStat("smg", 450)
			setStat("pistol", 450)
			setStat("heavyweapon", 450)
			setStat("medical", 450)
			setStat("shotgun", 450)
			setStat("survival", 100)