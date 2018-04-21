/client/verb/clear_cache()
	set category = "OOC"
	set name = "Clear Cache"
	cache.Cut()
	sending.Cut()
	src << "<span class = 'good'>Cache successfully cleared!</span>"

/client/verb/MOTD()
	set category = "OOC"
	set name = "See MOTD"
	src << "<div class=\"motd\">[join_motd]</div>"

/client/verb/hide_status_tabs()
	set category = "OOC"
	set name = "Hide Status Tabs"
	status_tabs = FALSE
	verbs -= /client/verb/hide_status_tabs
	verbs += /client/verb/show_status_tabs

/client/verb/show_status_tabs()
	set category = "OOC"
	set name = "Show Status Tabs"
	status_tabs = TRUE
	verbs -= /client/verb/show_status_tabs
	verbs += /client/verb/hide_status_tabs