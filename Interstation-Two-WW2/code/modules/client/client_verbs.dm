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