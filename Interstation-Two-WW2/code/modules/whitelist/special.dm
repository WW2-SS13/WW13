/* the jobs whitelist has special behavior for validate() and must be called
   with two args. Job datums have their own validate proc, which is used
   as a wrapper for the whitelist procedure. */

/datum/whitelist/jobs
	name = "jobs"

/datum/whitelist/jobs/validate(_arg, var/desired_job_title)
	if (!enabled)
		return 1
	var/list/datalist = splittext(data, "&")
	if (isclient(_arg))
		var/client/C = _arg
		for (var/datum in datalist)
			if (findtext(datum, C.ckey) && findtext(datum, desired_job_title))
				return 1
	else if (istext(_arg))
		var/ckey = ckey(_arg)
		for (var/datum in datalist)
			if (findtext(datum, ckey) && findtext(datum, desired_job_title))
				return 1
	return 0