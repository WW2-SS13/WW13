/datum/game_mode/ww2
	name = "World War 2"
	config_tag = "ww2"
	required_players = 0
	round_description = ""
	extended_round_description = ""
	var/time_both_sides_locked = -1

/datum/game_mode/ww2/check_finished()
	if (..())
		return 1
	else
		if (time_both_sides_locked != -1)
			if ((time_both_sides_locked - world.realtime) > 7500)
				if (WW2_soldiers_en_ru_ratio() > 2.2) // germans win
					return 1
				else if (WW2_soldiers_en_ru_ratio() < 0.5) // soviets win
					return 1
		else if (reinforcements_master.is_permalocked("GERMAN"))
			if (reinforcements_master.is_permalocked("RUSSIAN"))
				time_both_sides_locked = world.realtime

/datum/game_mode/ww2/declare_completion()
	var/list/soldiers = WW2_soldiers_alive()
	var/WW2_soldiers_en_ru_coeff = WW2_soldiers_en_ru_ratio()

	var/winning_side = ""
	if (WW2_soldiers_en_ru_coeff > 1)
		winning_side = "German Army"
	else if (WW2_soldiers_en_ru_coeff < 1)
		winning_side = "Soviet Army"
	else
		winning_side = null

	var/text = ""
	text += "[soldiers["en"]] Wehrmacht and S.S. soldiers survived.<br>"
	text += "[soldiers["ru"]] Soviet soldiers survived.<br><br>"
	if (winning_side)
		text += "<big><span class = 'danger'>The [winning_side] wins!</span></big>"
	else
		text += "<big><span class = 'danger'>Nobody wins!</span></big>"
	world << text

/datum/game_mode/ww2/announce() //to be called when round starts
	world << "<B>The current game mode is World War II!</B>"
