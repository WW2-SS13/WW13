/client/proc/see_spies()
	set name = "See Spies"
	set category = "WW2"

	if(!check_rights(R_MOD))
		src << "<span class = 'danger'>You don't have the permissions.</span>"
		return
	if (!istype(ticker.mode, /datum/game_mode/ww2))
		src << "<span class = 'danger'>What spies?</span>"
		return

	src << "<big>Spies:</big><br><br>"

	for (var/mob/living/carbon/human/H in player_list)
		if (H.is_spy)
			if (istype(H.original_job, /datum/job/german))
				src << "[H]/[H.ckey] - German soldier spying for the Russians.<br>"
			else if (istype(H.original_job, /datum/job/russian))
				src << "[H]/[H.ckey] - Russian soldier spying for the Germans.<br>"