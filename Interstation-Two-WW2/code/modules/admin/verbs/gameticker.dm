/client/proc/show_custom_roundstart_tip()
	set name = "Show Custom Roundstart Tip"
	set category = "Fun"

	if(!check_rights(R_FUN))	return

	var/text = input(src, "What? Type nothing to cancel") as text
	if (text)
		text = sanitize(text, 1000)
		roundstart_tips.Cut()
		roundstart_tips += text
		var/M = "[key_name(src)] changed the roundstart tip to '[text]'"
		message_admins(M)
		log_admin(M)