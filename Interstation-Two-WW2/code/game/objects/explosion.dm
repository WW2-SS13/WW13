
/proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = TRUE, z_transfer = UP|DOWN, is_rec = config.use_recursive_explosions)
	src = null	//so we don't abort once src is deleted
	var/datum/explosiondata/data = new
	data.epicenter = epicenter
	data.devastation_range = devastation_range
	data.heavy_impact_range = heavy_impact_range
	data.light_impact_range = light_impact_range
	data.flash_range = flash_range
	data.adminlog = adminlog
	data.z_transfer = z_transfer
	data.is_rec = is_rec
	data.rec_pow = max(0,devastation_range) * 2 + max(0,heavy_impact_range) + max(0,light_impact_range)

	// queue work
	spawn (1)
		bomb_processor.queue(data)

	return data

// == Recursive Explosions stuff ==
/*
/client/proc/kaboom()
	var/power = input(src, "power?", "power?") as num
	var/turf/T = get_turf(mob)
	var/datum/explosiondata/d = new
	d.is_rec = TRUE
	d.epicenter = T
	d.rec_pow = power
	bomb_processor.queue(d)
*/
/obj
	var/explosion_resistance

/turf
	var/explosion_resistance

/turf/space
	explosion_resistance = 3

/turf/floor
	explosion_resistance = TRUE

/turf/mineral
	explosion_resistance = 2

/turf/shuttle/floor
	explosion_resistance = TRUE

/turf/shuttle/floor4
	explosion_resistance = TRUE

/turf/shuttle/plating
	explosion_resistance = TRUE

/turf/shuttle/wall
	explosion_resistance = 10

/turf/wall
	explosion_resistance = 10