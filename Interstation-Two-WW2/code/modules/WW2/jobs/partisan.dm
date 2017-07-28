/datum/job/partisan

/datum/job/partisan/soldier
	title = "Partisan Soldier"
	flag = ASSISTANT
	department_flag = CIVILIAN

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
	spawn_location = "JoinLatePartisanCO"
	additional_languages = list( "Russian" = 100, "German" = 100)

