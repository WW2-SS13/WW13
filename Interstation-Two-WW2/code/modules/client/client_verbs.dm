/client/verb/clear_cache()
	set category = "OOC"
	set name = "Clear Cache"
	if (mob)
		nanomanager.close_uis(mob)
	cache.Cut()
	sending.Cut()
	src << "<span class = 'good'>Cache successfully cleared!</span>"

/client/verb/MOTD()
	set category = "OOC"
	set name = "See MOTD"
	if (mob) // sanity
		mob.see_personalized_MOTD()
/* todo: fix this shit
/client/verb/change_lobby_music_volume()
	set category = "OOC"
	set name = "Change Lobby Music Volume"

	var/original = lobby_music_volume
	lobby_music_volume = CLAMP0100(input(src, "Change lobby music volume to what %?", "Lobby Music Volume", lobby_music_volume))
	if (original != lobby_music_volume)
		if (prefs)
			prefs.saveGlobalSettings()
			prefs.loadGlobalSettings()
			onload_preferences("SOUND_LOBBY")
*/
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