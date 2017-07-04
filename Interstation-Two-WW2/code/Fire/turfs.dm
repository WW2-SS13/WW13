/turf/simulated/var/fire_protection = 0 //Protects newly extinguished tiles from being overrun again.
/turf/proc/apply_fire_protection()
/turf/simulated/apply_fire_protection()
	fire_protection = world.time

/turf/var/obj/fire/fire = null

//Some legacy definitions so fires can be started.
/atom/proc/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return null


turf/proc/hotspot_expose(exposed_temperature, exposed_volume, soh = 0)
	return

/turf/simulated/hotspot_expose(exposed_temperature, exposed_volume, soh)
	if(fire_protection > world.time-300)
		return 0
	if(locate(/obj/fire) in src)
		return 1
	var/datum/gas_mixture/air_contents = return_air()
	if(!air_contents || exposed_temperature < PLASMA_MINIMUM_BURN_TEMPERATURE)
		return 0

	var/igniting = 0
	var/obj/effect/decal/cleanable/liquid_fuel/liquid = locate() in src

	if(air_contents.check_combustability(liquid))
		igniting = 1

		create_fire(exposed_temperature)
	return igniting

/turf/proc/create_fire(fl, temp)
	return 0

/turf/simulated/create_fire(fl, temp)

	if(fire)
		fire.firelevel = max(fl, fire.firelevel)
		fire.temperature = max(temp, fire.temperature)
		return 1

	fire = new(src, fl)

	fire.temperature = temp

	var/obj/effect/decal/cleanable/liquid_fuel/fuel = locate() in src

	if (fuel)

		fire.time_limit += rand(10,20)

	return 0
