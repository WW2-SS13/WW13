var/datum/controller/process/paratrooper_plane_controller/paratrooper_plane_master = null

/datum/controller/process/paratrooper_plane_controller
	var/altitude = 5000
	var/first_nonlethal_altitude = 500

/datum/controller/process/paratrooper_plane_controller/setup()
	name = "paratrooper plane controller"
	schedule_interval = 300
	start_delay = 50
	if (!paratrooper_plane_master)
		paratrooper_plane_master = src

/datum/controller/process/paratrooper_plane_controller/doWork()
	if (altitude == 500)
		return // we're done
	altitude -= 500 // takes ~4.5 minutes to get to nonlethal altitude
	for (var/mob/living/carbon/human/H in player_list)
		if (H.original_job && istype(H.original_job, /datum/job/german/paratrooper))
			if (H.z == 2)
				H << "<big><span class = 'red'>The Plane's current altitude is [altitude]m. It is lethal to jump until it has descended to [first_nonlethal_altitude]m."

/datum/controller/process/paratrooper_plane_controller/proc/isLethalToJump()
	return altitude > first_nonlethal_altitude