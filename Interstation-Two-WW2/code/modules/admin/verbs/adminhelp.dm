/client/verb/adminhelp(msg as text)
	set category = "Help!"
	set name = "Adminhelp"

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "<span class = 'red'>Speech is currently admin-disabled.</span>"
		return

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		src << "<span class = 'red'>Error: Admin-PM: You cannot send adminhelps (Muted).</span>"
		return

	adminhelped = TRUE //Determines if they get the message to reply by clicking the name.

	if(handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	//clean the input msg
	if(!msg)
		return
	msg = sanitize(msg)
	if(!msg)
		return

	if(!mob) //this doesn't happen
		return

	//show it to the person adminhelping too
	src << "<span class = 'notice'>PM to-<b>Staff </b>: [msg]</span>"
	if (config.discordurl)
		src << "<i>If no admins are online, please ping @Admin Team <a href = '[config.discordurl]'>in the discord</a>.</i>"
	log_admin("HELP: [key_name(src)]: [msg]")

	msg = "<span class = 'notice'><b><font color=red>Request for Help: </span>[get_options_bar(mob, 2, TRUE, TRUE)]:</b> [msg]</span>"

	for(var/client/X in admins)
		if((R_ADMIN|R_MOD) & X.holder.rights)

			if(X.is_preference_enabled(/datum/client_preference/holder/play_adminhelp_ping))
				X << 'sound/effects/adminhelp.ogg'
			X << msg