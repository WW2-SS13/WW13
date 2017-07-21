//based off the old system - Kachnov

#define WHITELISTFILE "config/job_white_list.txt"

var/list/job_whitelist = list()

/proc/load_job_whitelist()
	if(config.use_job_whitelist)
		load_whitelist()
	return 1

/proc/load_whitelist()
	job_whitelist = file2list(WHITELISTFILE)
	if(!job_whitelist.len)	job_whitelist = null

/proc/check_job_whitelist(mob/M, var/rank)
	if(!job_whitelist)
		return 0
	for (var/line in job_whitelist)
		line = lowertext(line)
		rank = lowertext(rank)

		if (findtext(line, rank) && findtext(line, M.ckey))
			return 1
	return 0


#undef WHITELISTFILE
