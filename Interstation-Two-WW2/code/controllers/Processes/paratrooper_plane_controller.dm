var/datum/controller/process/paratrooper_plane_controller/paratrooper_plane_master = null

/datum/controller/process/paratrooper_plane_controller
	var/altitude = 7000
	var/first_nonlethal_altitude = 500
	var/tmpTime = 0
	var/list/my_turfs = list()

/datum/controller/process/paratrooper_plane_controller/setup()
	name = "paratrooper plane controller"
	schedule_interval = 20
	start_delay = 50
	if (!paratrooper_plane_master)
		paratrooper_plane_master = src

/datum/controller/process/paratrooper_plane_controller/doWork()
	try
		if (!my_turfs.len)
			if (latejoin_turfs["Fallschirm"] && latejoin_turfs["Fallschirm"]:len)
				for (var/turf/T in range(10, latejoin_turfs["Fallschirm"][1]))
					my_turfs += T

		var/shift = pick(-4, 0, 4)
		var/mobs = 0

		for (var/turf/T in my_turfs)
			for (var/atom/movable/AM in T.contents)
				if (!ismob(AM))
					AM.pixel_x = shift
				else
					++mobs

		tmpTime += schedule_interval
		if (tmpTime >= 300)
			tmpTime = 0
			if (altitude == 1500 && mobs)
				radio2soviets("We've received reports of Paratroopers. It is recommended that at least [mobs+1] people stay behind to guard the base.")
			if (altitude == 500)
				return // we're done
			altitude -= 500 // takes ~4.5 minutes to get to nonlethal altitude
			for (var/mob/living/carbon/human/H in player_list)
				if (H.original_job && istype(H.original_job, /datum/job/german/paratrooper))
					if (H.z == 2)
						H << "<big><span class = 'red'>The Plane's current altitude is [altitude]m. It is lethal to jump until it has descended to [first_nonlethal_altitude]m."

	catch(var/exception/e)
		catchException(e)
	SCHECK

/datum/controller/process/paratrooper_plane_controller/proc/isLethalToJump()
	return altitude > first_nonlethal_altitude