/client/verb/mentorhelp(msg as text)
	set category = "Help!"
	set name = "Mentorhelp"

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "\red Speech is currently admin-disabled."
		return

	//handle muting and automuting
	if(prefs.muted & MUTE_MENTORHELP) // todo: add this
		src << "<font color='red'>Error: Mentor-PM: You cannot send mentorhelps (Muted).</font>"
		return

	mentorhelped = TRUE //Determines if they get the message to reply by clicking the name.

	if(handle_spam_prevention(msg,MUTE_MENTORHELP))
		return

	//clean the input msg
	if(!msg)
		return
	msg = sanitize(msg)
	if(!msg)
		return

	if(!mob) //this doesn't happen
		return

	src << "<font color=green>PM to-<b>Mentors </b>: [msg]</font>"

	var/mentormsg = "<b><font color=green>Request for Help:</font>[get_options_bar(mob, 4, FALSE, TRUE, FALSE)]:</b> [msg]</font>"
	var/adminmsg = "(MENTORHELP) [mentormsg]"

	for(var/client/X in admins)
		if((R_MENTOR & X.holder.rights) && !((R_ADMIN|R_MOD) & X.holder.rights))
			if(X.is_preference_enabled(/datum/client_preference/holder/play_adminhelp_ping))
				X << 'sound/effects/adminhelp.ogg'
			X << mentormsg

		else if ((R_ADMIN|R_MOD) & X.holder.rights)
			X << adminmsg

	return

