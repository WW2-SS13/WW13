/client/verb/clear_cache()
	set category = "OOC"
	set name = "Clear Cache"
	cache.Cut()
	sending.Cut()
	src << "<span class = 'good'>Cache successfully cleared!</span>"

/client/verb/MOTD()
	set category = "OOC"
	set name = "See MOTD"
	if (mob) // sanity
		mob.see_personalized_MOTD()

/client/proc/hide_status_tabs()
	set category = "OOC"
	set name = "Hide Status Tabs"
	status_tabs = FALSE
	verbs -= /client/proc/hide_status_tabs
	verbs += /client/proc/show_status_tabs

/client/proc/show_status_tabs()
	set category = "OOC"
	set name = "Show Status Tabs"
	status_tabs = TRUE
	verbs -= /client/proc/show_status_tabs
	verbs += /client/proc/hide_status_tabs