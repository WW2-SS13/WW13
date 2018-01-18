/obj/tank/proc/my_name()
	return "the [name]"

/obj/tank/proc/set_name(x)
	name = x
	named = TRUE

/obj/tank/var/displayed_damage_message[10]

/obj/tank/proc/x_percent_of_max_damage(x)
	return (max_damage/100) * x

/obj/tank/proc/update_damage_status()
	var/damage_percentage = (damage/max_damage) * 100
	switch (damage_percentage)
		if (0 to 5) // who cares
			if (!displayed_damage_message["0-5"])
				displayed_damage_message["6-15"] = FALSE
		//		tank_message("<span class = 'danger'>[src] looks a bit damaged.</span>")
				displayed_damage_message["0-5"] = TRUE
		if (6 to 15)
			if (!displayed_damage_message["6-15"])
				displayed_damage_message["16-25"] = FALSE
				tank_message("<span class = 'danger'>[src] looks a bit damaged.</span>")
				displayed_damage_message["6-15"] = TRUE
		if (16 to 25)
			if (!displayed_damage_message["16-25"])
				displayed_damage_message["25-49"] = FALSE
				tank_message("<span class = 'danger'>[src] looks damaged.</span>")
				displayed_damage_message["16-25"] = TRUE
		if (25 to 49)
			if (!displayed_damage_message["25-49"])
				displayed_damage_message["50-79"] = FALSE
				tank_message("<span class = 'danger'>[src] looks quite damaged.</span>")
				displayed_damage_message["25-49"] = TRUE
		if (50 to 79)
			if (!displayed_damage_message["50-79"])
				displayed_damage_message["80-97"] = FALSE
				tank_message("<span class = 'danger'>[src] looks really damaged!</span>")
				displayed_damage_message["50-79"] = TRUE
		if (80 to 97)
			if (!displayed_damage_message["80-97"])
				displayed_damage_message["97-INFINITY"] = FALSE
				tank_message("<span class = 'danger'>[src] looks extremely damaged!</span>")
				displayed_damage_message["80-97"] = TRUE
		if (97 to INFINITY)
			if (!displayed_damage_message["97-INFINITY"])
				tank_message("<span class = 'danger'><big>[src] looks like its going to explode!!</big></span>")
				displayed_damage_message["97-INFINITY"] = TRUE

/obj/tank/proc/tank_message(x)
	var/ox = x
	x = replacetext(x, "The tank", name)
	visible_message(x)
	internal_tank_message(x)
	for (var/obj/tank/other in range(10, src))
		if (other != src)
			for (var/mob/m in other)
				m << ox // they aren't in the same tank so they get normal messages

/obj/tank/proc/internal_tank_message(x)
	for (var/mob/m in src)
		m << "<span class = 'notice'>(YOUR TANK)</span> <big>[x]</big>"

