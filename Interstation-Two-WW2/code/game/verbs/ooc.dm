/client/verb/ooc(msg as text)
	set name = "OOC"
	set category = "OOC"

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "<span class='warning'>Speech is currently admin-disabled.</span>"
		return

	if(!mob)	return
	if(IsGuestKey(key))
		src << "Guests may not use OOC."
		return

	if(!is_preference_enabled(/datum/client_preference/show_ooc))
		src << "<span class='warning'>You have OOC muted.</span>"
		return

	var/msg_prefix = ""

	if (dd_hasprefix(msg, ">>") && (isPatron("$3+") || holder.rights))
		msg = copytext(msg, 3, lentext(msg)+1)
		msg_prefix = "<span style = 'color:green'>></span>"

	msg = sanitize(msg)
	msg = "[msg_prefix][msg]"
	if(!msg)	return

	/* mentioning clients with @key or @ckey */
	for (var/client/C in clients)
		var/imsg = msg
		msg = replacetext(msg, "@[C.key]", "<span class=\"log_message\">@[capitalize(C.key)]</span>")
		msg = replacetext(msg, "@[C.ckey]", "<span class=\"log_message\">@[capitalize(C.key)]</span>")
		if (msg != imsg)
			winset(C, "mainwindow", "flash=2;")
			C << sound('sound/machines/ping.ogg')

	/* mentioning @everyone: staff only */
	if (holder && holder.rights & R_ADMIN)
		var/imsg = msg
		msg = replacetext(msg, "@everyone", "<span class=\"log_message\">@everyone</span>")
		if (msg != imsg)
			for (var/client/C in clients)
				winset(C, "mainwindow", "flash=2;")
				C << sound('sound/machines/ping.ogg')

	/* mentioning specific roles: */

	// @admins: ping secondary admins, primary admins, and the head admin.
	var/imsg = msg
	msg = replacetext(msg, "@admins", "<span class=\"log_message\">@admins</span>")
	msg = replacetext(msg, "@Admins", "<span class=\"log_message\">@admins</span>")
	if (msg != imsg)
		for (var/client/C in clients)
			if (C.holder && C.holder.rights & R_MOD && !(C.holder.rights & R_PERMISSIONS))
				winset(C, "mainwindow", "flash=2;")
				C << sound('sound/machines/ping.ogg')

	// @highstaff: ping managers, hosts, and senators
	imsg = msg
	msg = replacetext(msg, "@highstaff", "<span class=\"log_message\">@highstaff</span>")
	msg = replacetext(msg, "@Highstaff", "<span class=\"log_message\">@highstaff</span>")
	if (msg != imsg)
		for (var/client/C in clients)
			if (C.holder && C.holder.rights & R_PERMISSIONS)
				winset(C, "mainwindow", "flash=2;")
				C << sound('sound/machines/ping.ogg')

	if(!holder)
		if(!config.ooc_allowed)
			src << "<span class='danger'>OOC is globally muted.</span>"
			return
		if(!config.dooc_allowed && (mob.stat == DEAD))
			usr << "<span class='danger'>OOC for dead mobs has been turned off.</span>"
			return
		if(prefs.muted & MUTE_OOC)
			src << "<span class='danger'>You cannot use OOC (muted).</span>"
			return
		if(handle_spam_prevention(msg,MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			src << "<B>Advertising other servers is not allowed.</B>"
			log_admin("[key_name(src)] has attempted to advertise in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return

	log_ooc("[mob.name]/[key] : [msg]")

	var/ooc_style = "everyone"
	if(holder && !holder.fakekey)
		ooc_style = "elevated"
		if(holder.rights & R_MOD)
			ooc_style = "moderator"
		if(holder.rights & R_DEBUG)
			ooc_style = "developer"
		if(holder.rights & R_ADMIN)
			ooc_style = "admin"

	for(var/client/target in clients)
		if(target.is_preference_enabled(/datum/client_preference/show_ooc))
			var/display_name = key
			if(holder)
				if(holder.fakekey)
					if(target.holder)
						display_name = "[holder.fakekey]/([key])"
					else
						display_name = holder.fakekey
				else
					display_name = "<span class=\"log_message\">[holder.OOC_rank()]</span> [display_name]"

			// patrons get OOC colors too, now - kachnov

			var/admin_patron_check = FALSE
			if (holder && !holder.fakekey && (holder.rights & R_ADMIN))
				admin_patron_check = TRUE
			if (isPatron("$3+"))
				admin_patron_check = TRUE

			if(admin_patron_check && config.allow_admin_ooccolor && (prefs.ooccolor != initial(prefs.ooccolor))) // keeping this for the badmins
				target << "<font color='[prefs.ooccolor]'><span class='ooc'>" + create_text_tag("ooc", "OOC:", target) + " <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></font>"
			else
				target << "<span class='ooc'><span class='[ooc_style]'>" + create_text_tag("ooc", "OOC:", target) + " <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></span>"

/client/verb/looc(msg as text)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view."
	set category = "OOC"

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "<span class='danger'>Speech is currently admin-disabled.</span>"
		return

	if(!mob)
		return

	if(IsGuestKey(key))
		src << "Guests may not use OOC."
		return

	msg = sanitize(msg)
	if(!msg)
		return

	if(!is_preference_enabled(/datum/client_preference/show_looc))
		src << "<span class='danger'>You have LOOC muted.</span>"
		return

	if(!holder)
		if(!config.looc_allowed)
			src << "<span class='danger'>LOOC is globally muted.</span>"
			return
		if(!config.dooc_allowed && (mob.stat == DEAD))
			usr << "<span class='danger'>OOC for dead mobs has been turned off.</span>"
			return
		if(prefs.muted & MUTE_OOC)
			src << "<span class='danger'>You cannot use OOC (muted).</span>"
			return
		if(handle_spam_prevention(msg, MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			src << "<B>Advertising other servers is not allowed.</B>"
			log_admin("[key_name(src)] has attempted to advertise in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return

	log_ooc("(LOCAL) [mob.name]/[key] : [msg]")

	var/mob/source = mob.get_looc_source()

	var/display_name = key
	if(holder && holder.fakekey)
		display_name = holder.fakekey
	if(mob.stat != DEAD)
		display_name = mob.name

	var/turf/T = get_turf(source)
	var/list/listening = list()
	listening |= src	// We can always hear ourselves.
	var/list/listening_obj = list()
	var/list/eye_heard = list()

		// This is essentially a copy/paste from living/say() the purpose is to get mobs inside of objects without recursing through
		// the contents of every mob and object in get_mobs_or_objects_in_view() looking for PAI's inside of the contents of a bag inside the
		// contents of a mob inside the contents of a welded shut locker we essentially get a list of turfs and see if the mob is on one of them.

	if(T)
		var/list/hear = hear(7,T)
		var/list/hearturfs = list()

		for(var/I in hear)
			if(ismob(I))
				var/mob/M = I
				listening |= M.client
				hearturfs += M.locs[1]
			else if(isobj(I))
				var/obj/O = I
				hearturfs |= O.locs[1]
				listening_obj |= O

		for(var/mob/M in player_list)
			if(!M.is_preference_enabled(/datum/client_preference/show_looc))
				continue
		/*	if(isAI(M))
				var/mob/living/silicon/ai/A = M
				if(A.eyeobj && (A.eyeobj.locs[1] in hearturfs))
					eye_heard |= M.client
					listening |= M.client
					continue*/

			if(M.loc && M.locs[1] in hearturfs)
				listening |= M.client


	for(var/client/t in listening)
		var/admin_stuff = ""
		var/prefix = ""
		if(t in admins)
			admin_stuff += "/([key])"
			if(t != src)
				admin_stuff += "([admin_jump_link(mob, t.holder)])"
		if(isAI(t.mob))
			if(t in eye_heard)
				prefix = "(Eye) "
			else
				prefix = "(Core) "
		t << "<span class='ooc'><span class='looc'>" + create_text_tag("looc", "LOOC:", t) + " <span class='prefix'>[prefix]</span><EM>[display_name][admin_stuff]:</EM> <span class='message'>[msg]</span></span></span>"


	for(var/client/adm in admins)	//Now send to all admins that weren't in range.
		if(!(adm in listening))
			var/admin_stuff = "/([key])([admin_jump_link(mob, adm.holder)])"
			var/prefix = "(R)"

			adm << "<span class='ooc'><span class='looc'>" + create_text_tag("looc", "LOOC:", adm) + " <span class='prefix'>[prefix]</span><EM>[display_name][admin_stuff]:</EM> <span class='message'>[msg]</span></span></span>"

/mob/proc/get_looc_source()
	return src

