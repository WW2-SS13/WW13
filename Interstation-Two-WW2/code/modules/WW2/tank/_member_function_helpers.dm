/obj/tank/proc/my_name()
	return "the [name]"

/obj/tank/proc/set_name(x)
	name = x
	named = 1

/obj/tank/var/displayed_damage_message[10]

/obj/tank/proc/x_percent_of_max_damage(x)
	return (max_damage/100) * x

/obj/tank/proc/update_damage_status()
	var/damage_percentage = (damage/max_damage) * 100
	switch (damage_percentage)
		if (0 to 5) // who cares
			if (!displayed_damage_message["0-5"])
				displayed_damage_message["6-15"] = 0
		//		tank_message("<span class = 'danger'>[src] looks a bit damaged.</span>")
				displayed_damage_message["0-5"] = 1
		if (6 to 15)
			if (!displayed_damage_message["6-15"])
				displayed_damage_message["16-25"] = 0
				tank_message("<span class = 'danger'>[src] looks a bit damaged.</span>")
				displayed_damage_message["6-15"] = 1
		if (16 to 25)
			if (!displayed_damage_message["16-25"])
				displayed_damage_message["25-49"] = 0
				tank_message("<span class = 'danger'>[src] looks damaged.</span>")
				displayed_damage_message["16-25"] = 1
		if (25 to 49)
			if (!displayed_damage_message["25-49"])
				displayed_damage_message["50-79"] = 0
				tank_message("<span class = 'danger'>[src] looks quite damaged.</span>")
				displayed_damage_message["25-49"] = 1
		if (50 to 79)
			if (!displayed_damage_message["50-79"])
				displayed_damage_message["80-97"] = 0
				tank_message("<span class = 'danger'>[src] looks really damaged!</span>")
				displayed_damage_message["50-79"] = 1
		if (80 to 97)
			if (!displayed_damage_message["80-97"])
				displayed_damage_message["97-INFINITY"] = 0
				tank_message("<span class = 'danger'>[src] looks extremely damaged!</span>")
				displayed_damage_message["80-97"] = 1
		if (97 to INFINITY)
			if (!displayed_damage_message["97-INFINITY"])
				tank_message("<span class = 'danger'><big>[src] looks like its going to explode!!</big></span>")
				displayed_damage_message["97-INFINITY"] = 1

/obj/tank/proc/tank_message(x)
	x = replacetext(x, "The tank", istype(src, /obj/tank/german) ? "German Panzer" : "Soviet Tank")
	visible_message(x)
	internal_tank_message(x)
	for (var/obj/tank/other in range(10, src))
		if (other != src)
			for (var/mob/m in other)
				m << x // they aren't in the same tank so they get normal messages

/obj/tank/proc/internal_tank_message(x)
	for (var/mob/m in src)
		m << "<span class = 'notice'>(YOUR TANK)</span> <big>[x]</big>"

