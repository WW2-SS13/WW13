/datum/game_mode/flag_town

	name = "World War 2 Flag Town"
	config_tag = "ww2FT"
	required_players = 0
	round_description = "Russian defend the flag in the town, germans try to take it."
	extended_round_description = "The center town has a flag in the town square.  The Nazi's must capture it for ten minutes (cumulative), or the russian must fend them off for 30 minutes"
	var/list/data
	var/time_both_sides_locked = -1
	var/german_win_coeff = 1.1 // germans gets S.S.
	var/soviet_win_coeff = 1.0 // and soviets don't

	var/russian_tim_win_check = 0
	var/cond_2_1_nextcheck = -1

	var/cond_2_2_check1 = 0
	var/cond_2_2_nextcheck = -1

	var/cond_2_3_check1 = 0
	var/cond_2_3_nextcheck = -1

	var/cond_2_4_check1 = 0
	var/cond_2_4_nextcheck = -1

	var/win_condition = ""
	var/winning_side = ""

	var/admins_triggered_roundend = 0
	var/admins_triggered_noroundend = 0

// win conditions for one side already exist, make sure we
// don't active another
/datum/game_mode/flag_town/proc/trying_to_win()
	//return (cond_2_1_check1 || cond_2_2_check1 || cond_2_3_check1 || cond_2_4_check1)


/datum/game_mode/ww2/check_finished()
	if (admins_triggered_noroundend)
		return 0 // no matter what, don't end
	else if (..() == 1 || admins_triggered_roundend)
		return 1
		//Condition one the germans have captured the flag for 10 miuntes total
		//Condition two the russian have defended for 30 minutes since the assault

	return 0


/datum/game_mode/ww2/declare_completion()
	var/list/soldiers = WW2_soldiers_alive()
	var/WW2_soldiers_en_ru_coeff = WW2_soldiers_en_ru_ratio()

	var/winners = winning_side

	if (!winners)
		if (WW2_soldiers_en_ru_coeff >= german_win_coeff)
			winners = "German Army"
		else if (WW2_soldiers_en_ru_coeff <= soviet_win_coeff)
			winners = "Soviet Army"

	var/text = ""
	text += "[soldiers["en"]] Wehrmacht and SS soldiers survived.<br>"
	text += "[soldiers["ru"]] Soviet soldiers survived.<br><br>"

	if (winning_side)
		text += "<big><span class = 'danger'>The [winning_side] wins!</span></big><br><br>"
	else
		text += "<big><span class = 'danger'>Neither side wins.</span></big><br><br>"

	if (win_condition)
		text += "<big>[win_condition]</big>"
	else
		if (winning_side)
			text += "<big><i>The [winning_side] won by a war of attrition.</i></big>"

	world << text

	for (var/client/client in clients)
		client << "<br>"
		print_spies(client, 0)
		print_jews(client, 0)

/datum/game_mode/ww2/announce() //to be called when round starts
	world << "<b>The current game mode is World War II!</b>"

/datum/game_mode/ww2/declare_completion()
	name = "World War 2" // fixes capitalization error - Kachnov
	..()
