var/disabled_jobs[100]

/client/proc/toggle_jobs()
	set name = "Toggle Jobs"
	set category = "WW2"

	if(!check_rights(R_ADMIN))
		src << "<span class = 'danger'>You don't have the permissions.</span>"
		return
	if (!istype(ticker.mode, /datum/game_mode/ww2))
		src << "<span class = 'danger'>You can't do this on this game mode.</span>"
		return

	var/list/jobs_linked_list = list()
	for (var/datum/job/j in job_master.occupations)
		if (istype(j))
			jobs_linked_list[j.title] = j

	var/list/choices = list()

	for (var/jobtitle in jobs_linked_list)
		if (!disabled_jobs[jobtitle])
			choices += "[jobtitle] (ENABLED)"
		else
			choices += "[jobtitle] (DISABLED)"

	choices += "CANCEL"

	var/choice = input("Enable/Disable what job?") in choices
	if (choice == "CANCEL")
		return 0

	var/jobtitle = replacetext(choice, " (ENABLED)", "")
	jobtitle = replacetext(choices, " (DISABLED)", "")
	var/datum/job/j = jobs_linked_list[jobtitle]
	if (j)
		j.enabled = !j.enabled
		src << "<span class = 'warning'>[j.title] is now <b>[j.enabled ? "ENABLED" : "DISABLED"]</b>.</span>"