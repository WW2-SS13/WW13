
/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/msg = "<b>Current Players:</b>\n"

	var/list/Lines = list()

	if(holder && (R_ADMIN & holder.rights || R_MOD & holder.rights))
		for(var/client/C in clients)
			var/entry = "\t[C.key]"
			if(C.holder && C.holder.fakekey)
				entry += " <i>(as [C.holder.fakekey])</i>"
			entry += " - Playing as [C.mob.real_name]"
			switch(C.mob.stat)
				if(UNCONSCIOUS)
					entry += " - <font color='darkgray'><b>Unconscious</b></font>"
				if(DEAD)
					if(isghost(C.mob))
						var/mob/observer/ghost/O = C.mob
						if(O.started_as_observer)
							entry += " - <font color='gray'>Observing</font>"
						else
							entry += " - <font color='black'><b>DEAD</b></font>"
					else
						entry += " - <font color='black'><b>DEAD</b></font>"

			var/age
			if(isnum(C.player_age))
				age = C.player_age
			else
				age = FALSE

			if(age <= TRUE)
				age = "<font color='#ff0000'><b>[age]</b></font>"
			else if(age < 10)
				age = "<font color='#ff8c00'><b>[age]</b></font>"

			entry += " - [age]"

			if(is_special_character(C.mob))
				entry += " - <b><font color='red'>Antagonist</font></b>"
			if(C.is_afk())
				entry += " (AFK - [C.inactivity2text()])"
			entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
			Lines += entry
	else
		for(var/client/C in clients)
			if(C.holder && C.holder.fakekey)
				Lines += C.holder.fakekey
			else
				Lines += C.key

	for(var/line in sortList(Lines))
		msg += "[line]\n"

	msg += "<b>Total Players: [length(Lines)]</b>"
	src << msg

/client/verb/adminwho()
	set category = "Help!"
	set name = "Staff Who"

	var/highstaff_message = ""
	var/adminmsg = ""
	var/modmsg = ""
	var/mentmsg = ""
	var/devmsg = ""

	var/num_highstaff_online = FALSE
	var/num_mods_online = FALSE
	var/num_admins_online = FALSE
	var/num_mentors_online = FALSE
	var/num_devs_online = FALSE

	if(holder)
		for(var/client/C in admins)
			if(!C.visible_in_who)
				continue

			if (C.holder.rank == "SenateChairman" || C.holder.rank == "Senator" || findtext(C.holder.rank, "Host") || C.holder.rank == "Manager")
				highstaff_message += "\t[C] is a [C.holder.rank]"

				if(isobserver(C.mob))
					highstaff_message += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					highstaff_message += " - Lobby"
				else
					highstaff_message += " - Playing"

				if(C.is_afk())
					highstaff_message += " (AFK - [C.inactivity2text()])"
				highstaff_message += "\n"
				num_highstaff_online++

			else if(R_ADMIN & C.holder.rights || (!R_MOD & C.holder.rights && !R_MENTOR & C.holder.rights))	//Used to determine who shows up in admin rows

				if(C.holder.fakekey && (!R_ADMIN & holder.rights && !R_MOD & holder.rights))		//Mentors can't see stealthmins
					continue

				adminmsg += "\t[C] is a [C.holder.rank]"

				if(C.holder.fakekey)
					adminmsg += " <i>(as [C.holder.fakekey])</i>"

				if(isobserver(C.mob))
					adminmsg += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					adminmsg += " - Lobby"
				else
					adminmsg += " - Playing"

				if(C.is_afk())
					adminmsg += " (AFK - [C.inactivity2text()])"
				adminmsg += "\n"

				num_admins_online++

			else if((R_MOD & C.holder.rights) && C.holder.rank != "Developer")				//Who shows up in mod/mentor rows.
				modmsg += "\t[C] is a [C.holder.rank]"

				if(isobserver(C.mob))
					modmsg += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					modmsg += " - Lobby"
				else
					modmsg += " - Playing"

				if(C.is_afk())
					modmsg += " (AFK - [C.inactivity2text()])"
				modmsg += "\n"
				num_mods_online++


			else if((R_MOD & C.holder.rights) && C.holder.rank == "Developer")				//Who shows up in mod/mentor rows.
				devmsg += "\t[C] is a [C.holder.rank]"

				if(isobserver(C.mob))
					devmsg += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					devmsg += " - Lobby"
				else
					devmsg += " - Playing"

				if(C.is_afk())
					devmsg += " (AFK - [C.inactivity2text()])"
				devmsg += "\n"
				num_devs_online++

			else if(R_MENTOR & C.holder.rights)
				mentmsg += "\t[C] is a [C.holder.rank]"
				if(isobserver(C.mob))
					mentmsg += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					mentmsg += " - Lobby"
				else
					mentmsg += " - Playing"

				if(C.is_afk())
					mentmsg += " (AFK - [C.inactivity2text()])"
				mentmsg += "\n"
				num_mentors_online++

	else
		for(var/client/C in admins)
			if(R_ADMIN & C.holder.rights || (!R_MOD & C.holder.rights && !R_MENTOR & C.holder.rights))
				if(!C.holder.fakekey)
					adminmsg += "\t[C] is a [C.holder.rank]\n"
					num_admins_online++
			else if (R_MOD & C.holder.rights)
				modmsg += "\t[C] is a [C.holder.rank]\n"
				num_mods_online++
			else if (R_MENTOR & C.holder.rights)
				mentmsg += "\t[C] is a [C.holder.rank]\n"
				num_mentors_online++
/* todo: discord bot
	if(config.admin_irc)
		src << "<span class='info'>Adminhelps are also sent to IRC. If no admins are available in game try anyway and an admin on IRC may see it and respond.</span>"*/

	var/msg = "<b>Current High Staff ([num_highstaff_online]):</b>\n" + highstaff_message

	msg += "\n<b>Current Admins ([num_admins_online]):</b>\n" + adminmsg

	if(config.show_mods)
		msg += "\n<b> Current Moderators ([num_mods_online]):</b>\n" + modmsg

	if(config.show_mentors)
		msg += "\n<b> Current Mentors ([num_mentors_online]):</b>\n" + mentmsg

	msg += "\n<b> Current Developers ([num_devs_online]):</b>\n" + devmsg


	src << msg