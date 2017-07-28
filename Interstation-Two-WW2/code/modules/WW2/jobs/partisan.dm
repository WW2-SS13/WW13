/datum/job/partisan

/datum/job/partisan/give_random_name(var/mob/living/carbon/human/H)
	H.name = H.species.get_random_russian_name(H.gender)
	H.real_name = H.name

/datum/job/partisan/civilian
	title = "Civilian"
	flag = BOTANIST
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	selection_color = "#530909"
	access = list(access_ru_soldier, access_nato_squad_leader, access_ru_medic, access_ru_surgerist, access_ru_engineer, access_ru_heavy_weapon, access_ru_squad_leader, access_ru_cook, access_ru_commander)
	minimal_access = list(access_ru_soldier, access_nato_squad_leader, access_ru_medic, access_ru_surgerist, access_ru_engineer, access_ru_heavy_weapon, access_ru_squad_leader, access_ru_cook, access_ru_commander)
	spawn_location = "JoinLateCivilian"
	additional_languages = list( "Russian" = 100, "German" = 100 )

/datum/job/partisan/soldier
	title = "Partisan Soldier"
	flag = ASSISTANT
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	selection_color = "#530909"
	access = list(access_ru_soldier, access_nato_squad_leader, access_ru_medic, access_ru_surgerist, access_ru_engineer, access_ru_heavy_weapon, access_ru_squad_leader, access_ru_cook, access_ru_commander)
	minimal_access = list(access_ru_soldier, access_nato_squad_leader, access_ru_medic, access_ru_surgerist, access_ru_engineer, access_ru_heavy_weapon, access_ru_squad_leader, access_ru_cook, access_ru_commander)
	spawn_location = "JoinLatePartisan"
	additional_languages = list( "Russian" = 100, "German" = 100 )

/datum/job/partisan/commander
	flag = HOP
	department_flag = CIVILIAN
	title = "Partisan Commander"
	is_officer = 1
	is_commander = 1
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	head_position = 1
	selection_color = "#2d2d63"
	access = list(access_nato_soldier, access_nato_medic, access_nato_surgerist, access_nato_engineer, access_nato_heavy_weapon, access_nato_cook, access_nato_squad_leader, access_nato_commander)
	minimal_access = list(access_nato_soldier, access_nato_medic, access_nato_surgerist, access_nato_engineer, access_nato_heavy_weapon, access_nato_cook, access_nato_squad_leader, access_nato_commander)
	spawn_location = "JoinLatePartisanLeader"
	additional_languages = list( "Russian" = 100, "German" = 100)

