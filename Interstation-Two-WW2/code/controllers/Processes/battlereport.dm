var/datum/controller/process/battlereport/battlereport

/datum/controller/process/battlereport
	var/BR_ticks = 0
	var/max_BR_ticks = 600 // 10 minutes
	var/german_deaths_this_cycle = 0
	var/soviet_deaths_this_cycle = 0
	var/current_extra_cost_for_air_raid = 0

/datum/controller/process/battlereport/setup()
	name = "Battle Report"
	schedule_interval = 10 // every second
	battlereport = src

/datum/controller/process/battlereport/statProcess()
	..()
	stat(null, "Next battle report: [max_BR_ticks - BR_ticks] seconds")

/datum/controller/process/battlereport/doWork()
	++BR_ticks
	if (BR_ticks >= max_BR_ticks)
		show_global_battle_report(null)

		var/german_death_coeff = (german_deaths_this_cycle+1)/(alive_germans.len + 1)
		var/soviet_death_coeff = (soviet_deaths_this_cycle+1)/(alive_russians.len + 1)

		if (german_deaths_this_cycle && german_death_coeff > soviet_death_coeff)
			radio2soviets("Due to your triumphs in the battlefield, we are rewarding you with 200 supply points, comrades.")
			supply_points[SOVIET] += 200

		else if (soviet_deaths_this_cycle && soviet_death_coeff > german_death_coeff)
			radio2germans("Due to your triumphs in the battlefield, we are rewarding you with 200 supply points.")
			supply_points[GERMAN] += 200

		BR_ticks = 0
		german_deaths_this_cycle = 0
		soviet_deaths_this_cycle = 0

	if (prob(3))
		current_extra_cost_for_air_raid = rand(-20,20)