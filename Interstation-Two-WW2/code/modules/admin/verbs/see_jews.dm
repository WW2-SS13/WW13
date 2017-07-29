/client/proc/see_jews()
	set name = "See Jews"
	set category = "WW2"

	if(!check_rights(R_MOD))
		src << "<span class = 'danger'>You don't have the permissions.</span>"
		return
	if (!istype(ticker.mode, /datum/game_mode/ww2))
		src << "<span class = 'danger'>What (((jews)))?</span>"
		return

	print_jews(src, 1)

/proc/print_jews(whomst, var/notroundend = 0)

	if (notroundend)
		whomst << "<big>Jews:</big><br><br>"
	else
		whomst << "<big>Jews at the end of the round:</big><br><br>"

	var/list/mobs = getrussianmobs(0)|getgermanmobs(0)

	for (var/mob/living/carbon/human/H in mobs)
		if (istype(H) && H.is_jew)
			var/H_stat = (H.stat == DEAD ? "DEAD" : H.stat == UNCONSCIOUS ? "UNCONSCIOUS" : "ALIVE")
			var/is_ghosted = (H.client ? "IN BODY" : "GHOSTED OR LOGGED OUT")
			var/spanstyle = H.stat == DEAD ? "warning" : "notice"
			if (istype(H.original_job, /datum/job/german))
				whomst << "<span style = '[spanstyle]'>[H][notroundend ? "/" : ""][notroundend ? H.ckey : ""] - German soldier jew. ([H_stat]) ([is_ghosted])</span><br>"
			else if (istype(H.original_job, /datum/job/russian))
				whomst << "<span style = '[spanstyle]'>[H][notroundend ? "/" : ""][notroundend ? H.ckey : ""] - Russian soldierjew. ([H_stat]) ([is_ghosted])</span><br>"
			if (!notroundend && H.stat == CONSCIOUS && !H.restrained())
				whomst << "<span style = 'notice'>The Jew survived!</span><br>"