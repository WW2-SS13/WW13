var/process/battlereport/battlereport

/process/battlereport
	var/BR_ticks = 0
	var/max_BR_ticks = 600 // 10 minutes
	var/german_deaths_this_cycle = 0
	var/soviet_deaths_this_cycle = 0
	var/current_extra_cost_for_air_raid = 0
	var/next_can_grant_points = -1

/process/battlereport/setup()
	name = "Battle Report"
	schedule_interval = 10 // every second
	fires_at_gamestates = list(GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	battlereport = src

/process/battlereport/statProcess()
	..()
	stat(null, "Next battle report: [max_BR_ticks - BR_ticks] seconds")

/process/battlereport/htmlProcess()
	return ..() + "Next battle report: [max_BR_ticks - BR_ticks] seconds"

/process/battlereport/fire()
	SCHECK

	++BR_ticks
	if (BR_ticks >= max_BR_ticks)
		show_global_battle_report(null)

		var/german_death_coeff = (german_deaths_this_cycle+1)/(alive_germans.len + 1)
		var/soviet_death_coeff = (soviet_deaths_this_cycle+1)/(alive_russians.len + 1)

		// because admins can cause this to happen a lot
		if (world.time >= next_can_grant_points && map && map.germans_can_cross_blocks())

			if (german_deaths_this_cycle && german_death_coeff > soviet_death_coeff)
				radio2soviets("Due to your triumphs in the battlefield, we are rewarding you with 200 supply points, comrades.")
				supply_points[SOVIET] += 200

			else if (soviet_deaths_this_cycle && soviet_death_coeff > german_death_coeff)
				radio2germans("Due to your triumphs in the battlefield, we are rewarding you with 200 supply points.")
				supply_points[GERMAN] += 200

			next_can_grant_points = world.time + 5500

		BR_ticks = 0
		german_deaths_this_cycle = 0
		soviet_deaths_this_cycle = 0

	if (sprob(3))
		current_extra_cost_for_air_raid = srand(-20,20)