#define SMOOTH_MOVEMENT

var/process/paratrooper_plane_controller/paratrooper_plane_master = null

/process/paratrooper_plane_controller
	var/altitude = 7000
	var/first_nonlethal_altitude = 500
	var/tmpTime = 0
	var/list/my_turfs = list()

/process/paratrooper_plane_controller/setup()
	name = "paratrooper plane controller"
	schedule_interval = 50
	start_delay = 50
	fires_at_gamestates = list(GAME_STATE_PLAYING)
	if (!paratrooper_plane_master)
		paratrooper_plane_master = src

/process/paratrooper_plane_controller/fire()
	SCHECK
	if (altitude == 500)
		return
	try
		if (!my_turfs.len)
			if (latejoin_turfs["Fallschirm"] && latejoin_turfs["Fallschirm"]:len)
				for (var/turf/T in range(10, latejoin_turfs["Fallschirm"][1]))
					my_turfs += T
					SCHECK

		var/shift = pick(-4, 0, 4)
		var/mobs = 0

		FORNEXT(my_turfs)
			var/turf/T = current
			FORNEXT(T.contents)
				var/atom/movable/AM = current
				if (!ismob(AM))
					AM.pixel_x = shift
				else
					++mobs
				#ifndef SMOOTH_MOVEMENT
				SCHECK
				#endif
			#ifndef SMOOTH_MOVEMENT
			SCHECK
			#endif

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
				SCHECK

	catch(var/exception/e)
		catchException(e)

/process/paratrooper_plane_controller/proc/isLethalToJump()
	return altitude > first_nonlethal_altitude

#undef SMOOTH_MOVEMENT