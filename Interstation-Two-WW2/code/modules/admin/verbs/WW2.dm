/client/proc/send_german_train()
	set category = "WW2 (Admin)"
	set name = "Send train (German)"

	var/direction = input("Make the train go forwards, backwards, or stop?") in list("Forwards", "Backwards", "Stop", "Cancel")

	if (!direction || direction == "Cancel")
		return

	for (var/obj/train_lever/german/lever in world)
		if (istype(lever))
			lever.automatic_function(direction, src)
			break

	if (direction == "Forwards")
		direction = "to the FOB"

	else if (direction == "Backwards")
		direction = "back to the base"

	else if (direction == "Stop")
		message_admins("[key_name(src)] tried to stop the german train.")
		return

	message_admins("[key_name(src)] tried to send the german train [direction].")

/client/proc/allow_join_geforce()
	set category = "WW2 (Admin)"
	set name = "Toggle joining (German)"

	ticker.can_latejoin_geforce = !ticker.can_latejoin_geforce
	world << "<font color=red>You [(ticker.can_latejoin_geforce) ? "can" : "can't"] join the Germans [(ticker.can_latejoin_geforce) ? "now" : "anymore"].</font>"
	message_admins("[key_name(src)] changed the geforce latejoin setting.")

/client/proc/allow_join_ruforce()
	set category = "WW2 (Admin)"
	set name = "Toggle joining (Russian)"

	ticker.can_latejoin_ruforce = !ticker.can_latejoin_ruforce
	world << "<font color=red>You [(ticker.can_latejoin_ruforce) ? "can" : "can't"] join the Russians [(ticker.can_latejoin_ruforce) ? "now" : "anymore"].</font>"
	message_admins("[key_name(src)] changed the ruforce latejoin setting.")

/client/proc/allow_rjoin_geforce()
	set category = "WW2 (Admin)"
	set name = "Toggle reinforcements (German)"

	if (reinforcements_master)
		reinforcements_master.locked[GERMAN] = !reinforcements_master.locked[GERMAN]
		world << "<font color=red>Reinforcements [(!reinforcements_master.locked[GERMAN]) ? "can" : "can't"] join the Germans [(!reinforcements_master.locked[GERMAN]) ? "now" : "anymore"].</font>"
		message_admins("[key_name(src)] changed the geforce reinforcements setting.")
	else
		src << "<span class = danger>WARNING: No reinforcements master found.</span>"

/client/proc/allow_rjoin_ruforce()
	set category = "WW2 (Admin)"
	set name = "Toggle reinforcements (Russian)"

	if (reinforcements_master)
		reinforcements_master.locked[SOVIET] = !reinforcements_master.locked[SOVIET]
		world << "<font color=red>Reinforcements [(!reinforcements_master.locked[SOVIET]) ? "can" : "can't"] join the Russians [(!reinforcements_master.locked[SOVIET]) ? "now" : "anymore"].</font>"
		message_admins("[key_name(src)] changed the ruforce reinforcements setting.")
	else
		src << "<span class = danger>WARNING: No reinforcements master found.</span>"


/client/proc/force_reinforcements_geforce()
	set category = "WW2 (Admin)"
	set name = "Quickspawn reinforcements (German)"

	var/list/l = reinforcements_master.reinforcement_pool[GERMAN]

	if (reinforcements_master)
		if (l.len)
			reinforcements_master.allow_quickspawn[GERMAN] = TRUE
			reinforcements_master.german_countdown = 0
		else
			src << "<span class = danger>Nobody is in the German reinforcement pool.</span>"
	else
		src << "<span class = danger>WARNING: No reinforcements master found.</span>"

	message_admins("[key_name(src)] tried to send reinforcements for the Germans.")

	reinforcements_master.lock_check()

/client/proc/force_reinforcements_ruforce()
	set category = "WW2 (Admin)"
	set name = "Quickspawn reinforcements (Russian)"

	var/list/l = reinforcements_master.reinforcement_pool[SOVIET]

	if (reinforcements_master)
		if (l.len)
			reinforcements_master.allow_quickspawn[SOVIET] = TRUE
			reinforcements_master.soviet_countdown = 0
		else
			src << "<span class = danger>Nobody is in the Russian reinforcement pool.</span>"
	else
		src << "<span class = danger>WARNING: No reinforcements master found.</span>"

	message_admins("[key_name(src)] tried to send reinforcements for the Russians.")

	reinforcements_master.lock_check()

// debugging
/client/proc/reset_roundstart_autobalance()
	set category = "WW2 (Admin)"
	set name = "Reset Roundstart Autobalance"

	if(!check_rights(R_HOST))
		src << "<span class = 'danger'>You don't have the permissions.</span>"
		return

	var/_clients = input("How many clients?") as num
	job_master.toggle_roundstart_autobalance(_clients)

	message_admins("[key_name(src)] reset the roundstart autobalance for [_clients] players.")

/client/proc/end_all_grace_periods()
	set category = "WW2 (Admin)"
	set name = "End All Grace Periods"
	var/conf = input(src, "Are you sure you want to end all grace periods?") in list("Yes", "No")
	if (conf == "Yes")
		map.admin_ended_all_grace_periods = TRUE
		message_admins("[key_name(src)] ended all grace periods!")
		log_admin("[key_name(src)] ended all grace periods.")

/client/proc/show_battle_report()
	set category = "WW2 (Admin)"
	set name = "Show Battle Report"

	show_global_battle_report(src)

/proc/show_global_battle_report(var/shower)

	var/total_germans = alive_germans.len + dead_germans.len + heavily_injured_germans.len
	var/total_russians = alive_russians.len + dead_russians.len + heavily_injured_russians.len
	var/total_civilians = alive_civilians.len + dead_civilians.len + heavily_injured_civilians.len
	var/total_partisans = alive_partisans.len + dead_partisans.len + heavily_injured_partisans.len

	var/mortality_coefficient_german = 0
	var/mortality_coefficient_russian = 0
	var/mortality_coefficient_civilian = 0
	var/mortality_coefficient_partisan = 0

	if (dead_germans.len > 0)
		mortality_coefficient_german = dead_germans.len/total_germans

	if (dead_russians.len > 0)
		mortality_coefficient_russian = dead_russians.len/total_russians

	if (dead_civilians.len > 0)
		mortality_coefficient_civilian = dead_civilians.len/total_civilians

	if (dead_partisans.len > 0)
		mortality_coefficient_partisan = dead_partisans.len/total_partisans

	var/mortality_german = round(mortality_coefficient_german*100)
	var/mortality_russian = round(mortality_coefficient_russian*100)
	var/mortality_civilian = round(mortality_coefficient_civilian*100)
	var/mortality_partisan = round(mortality_coefficient_partisan*100)

	var/msg1 = "German Side: [alive_germans.len] alive, [heavily_injured_germans.len] heavily injured or unconscious, [dead_germans.len] deceased. Mortality rate: [mortality_german]%"
	var/msg2 = "Soviet Side: [alive_russians.len] alive, [heavily_injured_russians.len] heavily injured or unconscious, [dead_russians.len] deceased. Mortality rate: [mortality_russian]%"
	var/msg3 = "Civilians: [alive_civilians.len] alive, [heavily_injured_civilians.len] heavily injured or unconscious, [dead_civilians.len] deceased. Mortality rate: [mortality_civilian]%"
	var/msg4 = "Partisans: [alive_partisans.len] alive, [heavily_injured_partisans.len] heavily injured or unconscious, [dead_partisans.len] deceased. Mortality rate: [mortality_partisan]%"

	var/public = "Yes"

	if (shower)
		public = alert(shower, "Show it to the entire server?",,"Yes", "No")

	if(public == "Yes")
		if (!shower || (input(shower, "Are you sure you want to show the battle report? Unless the Battle Controller Process died, it will happen automatically!", "Battle Report") in list ("Yes", "No")) == "Yes")
			world << "<font size=4>Battle status report:</font>"
			world << "<font size=3>[msg1]</font>"
			world << "<font size=3>[msg2]</font>"
			world << "<font size=3>[msg3]</font>"
			world << "<font size=3>[msg4]</font>"
			if (shower)
				message_admins("[key_name(shower)] showed everyone the battle report.")
			else
				message_admins("the <b>Battle Controller Process</b> showed everyone the battle report.")
	else
		shower << msg1
		shower << msg2
		shower << msg3
		shower << msg4

/client/proc/generate_hit_table()
	set category = "WW2 (Admin)"
	set name = "Hit tables"
	set background = TRUE

	var/list/types = typesof(/obj/item/weapon/gun/projectile)

	var/gun_type = input(usr, "Select gun type", "Hit tables") as null|anything in types
	if(!gun_type)
		return

	var/obj/item/weapon/gun/projectile/gun = new gun_type()
	var/mob/living/carbon/human/dummy = new()

	usr << "Generating hit table..."
	var/list/distances = list(3, 5, 7, 9)
	var/dat = "<h3>Generated hit table for [gun.name]. Target: chest.</h3><b>Simulated!</b><br>"
	//Wielded
	if(gun.can_wield)
		dat += "<h4>----Wielded----</h4>"
		dat += "<table><tr><td>Distance</td>"
		for(var/dist in distances)
			dat += "<td>[dist] tiles</td>"
		dat += "</tr>"
		for(var/datum/firemode/fm in gun.firemodes)
			dat += "<tr><td>[fm.name]</td>"
			for(var/dist in distances)
				var/text = ""
				for(var/i = TRUE to min(fm.burst, 5))
					var/acc = fm.accuracy[min(i, fm.accuracy.len)] + gun.accuracy
					var/miss_mod = min(max(15 * (dist - 2) - round( 15 * acc), FALSE), 100)
					var/hits = FALSE
					for(var/shot = TRUE to 1000)
						if(get_zone_with_miss_chance("chest", dummy, miss_mod, TRUE) != null)
							hits++
					if(hits <= FALSE)
						text += "0"
					else
						text += "[round(hits / 10)]"
					if(i != min(fm.burst, 5))
						text += "/"
					else
						text += "%"
				dat += "<td>[text]</td>"
			dat += "</tr>"
		dat += "</table>"
	//Unwielded
	if((gun.can_wield && !gun.must_wield) || !gun.can_wield)
		dat += "<h4>----Unwielded----</h4>"
		dat += "<table><tr><td>Distance</td>"
		for(var/dist in distances)
			dat += "<td>[dist] tiles</td>"
		dat += "</tr>"
		for(var/datum/firemode/fm in gun.firemodes)
			dat += "<tr><td>[fm.name]</td>"
			for(var/dist in distances)
				var/text = ""
				for(var/i = TRUE to min(fm.burst, 5))
					var/acc = fm.accuracy[min(i, fm.accuracy.len)] + gun.accuracy - 2
					var/miss_mod = min(max(15 * (dist - 2) - round( 15 * acc), FALSE), 100)
					var/hits = FALSE
					for(var/shot = TRUE to 1000)
						if(get_zone_with_miss_chance("chest", dummy, miss_mod, TRUE) != null)
							hits++
					if(hits <= FALSE)
						text += "0"
					else
						text += "[round(hits / 10)]"
					if(i != min(fm.burst, 5))
						text += "/"
					else
						text += "%"
				dat += "<td>[text]</td>"
			dat += "</tr>"
		dat += "</table>"
	if(gun.can_scope)
		dat += "<h4>----Scoped----</h4>"
		dat += "<table><tr><td>Distance</td>"
		for(var/dist in distances)
			dat += "<td>[dist] tiles</td>"
		dat += "</tr>"
		for(var/datum/firemode/fm in gun.firemodes)
			dat += "<tr><td>[fm.name]</td>"
			for(var/dist in distances)
				var/text = ""
				for(var/i = TRUE to min(fm.burst, 5))
					var/acc = fm.accuracy[min(i, fm.accuracy.len)] + gun.scoped_accuracy
					var/miss_mod = min(max(15 * (dist - 2) - round( 15 * acc), FALSE), 100)
					var/hits = FALSE
					for(var/shot = TRUE to 1000)
						if(get_zone_with_miss_chance("chest", dummy, miss_mod, TRUE) != null)
							hits++
					if(hits <= FALSE)
						text += "0"
					else
						text += "[round(hits / 10)]"
					if(i != min(fm.burst, 5))
						text += "/"
					else
						text += "%"
				dat += "<td>[text]</td>"
			dat += "</tr>"
		dat += "</table>"

	usr << browse(dat, "window='Hit table';size=800x400;can_close=1;can_resize=1;can_minimize=1;titlebar=1")

/*
/client/proc/set_daytime()
	set category = "Prishtina"
	set name = "Set daytime"

	var/list/modes = list("Brighty day" = "#FFFFFF", "Cloudy day" = "#999999", "Very cloudy day" = "#777777", "Sunset" = "#FFC966", "Bright night" = "#444444", "Dark night" = "#111111", "Sunrise" = "#DEDF64", "Special" = "#FF77FF")

	var/daytime = input(usr, "Select daytime", "Daytime changing.") as null|anything in modes

	if(!daytime)
		return

	var/color = modes[daytime]
	config.starlight_color = color

	world << "Changing daytime and weather to [daytime]. This may take a while. Be patient."
	spawn(10)
		for (var/area/prishtina/a_p in world)
			if (istype(a_p, /area/prishtina))
				a_p.changeDayTime(dayime)*/
	/*	for(var/turf/T)
			if(T.z == TRUE)
				T.update_starlight()*/

/client/proc/message_russians()
	set category = "WW2 (Admin)"
	set name = "Message Russians"

	var/msg = input(usr, "Send what?", "Message Russians") as text

	var/ick_ock = input(usr, "Make this an IC message?", "Message Russians") in list("Yes", "No")
	if (ick_ock == "Yes")
		ick_ock = TRUE
	else
		ick_ock = FALSE

	if (msg)
		if (!ick_ock || !radio2soviets(msg))
			for (var/mob/living/carbon/human/H in player_list)
				if (istype(H) && H.client)
					if (H.original_job && H.original_job.base_type_flag() == SOVIET)
						var/msg_start = ick_ock ? "<b>IMPORTANT MESSAGE FROM THE SOVIET HIGH COMMAND:</b>" : "<b>MESSAGE TO THE SOVIET TEAM FROM ADMINS:</b>"
						H << "[msg_start] <span class = 'notice'>[msg]</span>"

		src << "You sent '[msg]' to the Russian team."
		message_admins("[key_name(src)] sent '[msg]' to the Russian team. (IC = [ick_ock ? "yes" : "no"])")

/client/proc/message_germans()
	set category = "WW2 (Admin)"
	set name = "Message Germans"

	var/msg = input(usr, "Send what?", "Message Germans") as text

	var/ick_ock = input(usr, "Make this an IC message?", "Message Germans") in list("Yes", "No")

	if (ick_ock == "Yes")
		ick_ock = TRUE
	else
		ick_ock = FALSE

	if (msg)
		if (!ick_ock || !radio2germans(msg))
			for (var/mob/living/carbon/human/H in player_list)
				if (istype(H) && H.client)
					if (H.original_job && H.original_job.base_type_flag() == GERMAN)
						var/msg_start = ick_ock ? "<b>IMPORTANT MESSAGE FROM THE GERMAN HIGH COMMAND:</b>" : "<b>MESSAGE TO THE GERMAN TEAM FROM ADMINS:</b>"
						H << "[msg_start] <span class = 'notice'>[msg]</span>"

		src << "You sent '[msg]' to the German team."
		message_admins("[key_name(src)] sent '[msg]' to the German team. (IC = [ick_ock ? "yes" : "no"])")

/client/proc/message_SS()
	set category = "WW2 (Admin)"
	set name = "Message the SS"

	var/msg = input(usr, "Send what?", "Message the SS") as text

	var/ick_ock = input(usr, "Make this an IC message?", "Message the SS") in list("Yes", "No")

	if (ick_ock == "Yes")
		ick_ock = TRUE
	else
		ick_ock = FALSE

	if (msg)
		for (var/mob/living/carbon/human/H in player_list)
			if (istype(H) && H.client)
				if (H.original_job && H.original_job.base_type_flag() == GERMAN && H.original_job.is_SS)
					var/msg_start = ick_ock ? "<b>IMPORTANT MESSAGE FROM THE GERMAN HIGH COMMAND TO THE SS:</b>" : "<b>MESSAGE TO THE SS FROM ADMINS:</b>"
					H << "[msg_start] <span class = 'notice'>[msg]</span>"

		src << "You sent '[msg]' to the SS."
		message_admins("[key_name(src)] sent '[msg]' to the SS")


/client/proc/message_paratroopers()
	set category = "WW2 (Admin)"
	set name = "Messages Paratroopers"

	var/msg = input(usr, "Send what?", "Message Paratroopers") as text

	var/ick_ock = input(usr, "Make this an IC message?", "Message Paratroopers") in list("Yes", "No")

	if (ick_ock == "Yes")
		ick_ock = TRUE
	else
		ick_ock = FALSE

	if (msg)
		for (var/mob/living/carbon/human/H in player_list)
			if (istype(H) && H.client)
				if (H.original_job && H.original_job.base_type_flag() == GERMAN && istype(H.original_job, /datum/job/german/paratrooper))
					var/msg_start = ick_ock ? "<b>IMPORTANT MESSAGE FROM THE GERMAN HIGH COMMAND TO THE PARATROOPER SQUAD:</b>" : "<b>MESSAGE TO THE PARATROOPER SQUAD FROM ADMINS:</b>"
					H << "[msg_start] <span class = 'notice'>[msg]</span>"

		src << "You sent '[msg]' to the paratroopers."
		message_admins("[key_name(src)] sent '[msg]' to the paratroopers")

/client/proc/message_civilians()
	set category = "WW2 (Admin)"
	set name = "Message Civilians"

	var/msg = input(usr, "Send what? Note that this messages Partisans too!", "Message Civilians") as text

	var/ick_ock = input(usr, "Make this an IC message?", "Message Civilians") in list("Yes", "No")

	if (ick_ock == "Yes")
		ick_ock = TRUE
	else
		ick_ock = FALSE

	if (msg)
		for (var/mob/living/carbon/human/H in player_list)
			if (istype(H) && H.client)
				if (H.original_job && (H.original_job.base_type_flag() == CIVILIAN || H.original_job.base_type_flag() == PARTISAN))
					var/msg_start = ick_ock ? "<b>IMPORTANT MESSAGE FROM ???? to Civilians:</b>" : "<b>MESSAGE TO THE CIVILIANS FROM ADMINS:</b>"
					H << "[msg_start] <span class = 'notice'>[msg]</span>"

		src << "You sent '[msg]' to all Civilians."
		message_admins("[key_name(src)] sent '[msg]' to all Civilians")

/client/proc/message_partisans()
	set category = "WW2 (Admin)"
	set name = "Message Partisans"

	var/msg = input(usr, "Send what?", "Message Partisans") as text

	var/ick_ock = input(usr, "Make this an IC message?", "Message Partisans") in list("Yes", "No")

	if (ick_ock == "Yes")
		ick_ock = TRUE
	else
		ick_ock = FALSE

	if (msg)
		for (var/mob/living/carbon/human/H in player_list)
			if (istype(H) && H.client)
				if (H.original_job || H.original_job.base_type_flag() == PARTISAN)
					var/msg_start = ick_ock ? "<b>IMPORTANT MESSAGE FROM THE UKRAINIAN PARTISAN COMMAND TO PARTISANS:</b>" : "<b>MESSAGE TO PARTISANS FROM ADMINS:</b>"
					H << "[msg_start] <span class = 'notice'>[msg]</span>"

		src << "You sent '[msg]' to all Partisans."
		message_admins("[key_name(src)] sent '[msg]' to all Partisans")

var/german_civilian_mode = FALSE
var/soviet_civilian_mode = FALSE

/client/proc/toggle_german_civilian_mode()
	set category = "WW2 (Admin)"
	set name = "Toggle German Civilian Mode"
	german_civilian_mode = !german_civilian_mode
	var/M = "[key_name(src)] [german_civilian_mode ? "enabled" : "disabled"] German Civilian Mode - Civilians will [german_civilian_mode ? "now" : "no longer"] count towards the amount of Germans."
	message_admins(M)
	log_admin(M)

/client/proc/toggle_soviet_civilian_mode()
	set category = "WW2 (Admin)"
	set name = "Toggle Soviet Civilian Mode"
	soviet_civilian_mode = !soviet_civilian_mode
	var/M = "[key_name(src)] [soviet_civilian_mode ? "enabled" : "disabled"] Soviet Civilian Mode - Civilians will [soviet_civilian_mode ? "now" : "no longer"] count towards the amount of Soviets."
	message_admins(M)
	log_admin(M)

var/respawn_delays = TRUE
/client/proc/toggle_respawn_delays()
	set category = "WW2 (Admin)"
	set name = "Toggle Respawn Delays"
	respawn_delays = !respawn_delays
	var/M = "[key_name(src)] [respawn_delays ? "enabled" : "disabled"] respawn delays."
	message_admins(M)
	log_admin(M)
	world << "<font size = 3><span class = 'notice'>Respawn delays are now <b>[respawn_delays ? "enabled" : "disabled"]</b>.</span></font>"