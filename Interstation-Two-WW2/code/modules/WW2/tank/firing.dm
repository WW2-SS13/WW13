/obj/tank/var/last_fire = -1
/obj/tank/var/fire_delay = 100


/obj/tank/proc/density_check(var/turf/_loc)
	if (_loc.density)
		return 1
	for (var/atom/movable/am in _loc)
		if (am.density && am != src && am != front_seat() && am != back_seat())
			return 1
	return 0

/obj/tank/proc/get_x_steps_in_dir(steps)

	var/_loc = null
	switch (dir)
		if (NORTH)
			for (var/v in min(3,steps) to steps)
				_loc = locate(x, y+v, z)
				if (!_loc || density_check(_loc))
					return locate(x, y+v-1, z)
		if (SOUTH)
			for (var/v in min(3,steps) to steps)
				_loc = locate(x, y-v, z)
				if (!_loc || density_check(_loc))
					return locate(x, y-v+1, z)
		if (EAST)
			for (var/v in min(3,steps) to steps)
				_loc = locate(x+v, y, z)
				if (!_loc || density_check(_loc))
					return locate(x+v-1, y, z)
		if (WEST)
			for (var/v in min(3,steps) to steps)
				_loc = locate(x-v, y, z)
				if (!_loc || density_check(_loc))
					return locate(x-v+1, y, z)
	if (_loc)
		return _loc

	return get_step(src, src.dir)

/mob/verb/use_tank_guns()

	set category = null

	if (!ishuman(src))
		return 0
	if (!istype(loc, /obj/tank))
		return 0

	var/obj/tank/tank = loc
	tank.receive_command_from(src, "FIRE")

/obj/tank/proc/tank_explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1, z_transfer = UP|DOWN, is_rec = config.use_recursive_explosions)
	var/datum/explosiondata/data = explosion(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog, z_transfer, is_rec)
	data.objects_with_immunity += src

/obj/tank/proc/Fire()

	var/atom/target = get_x_steps_in_dir(10)

	if(!target) return

	var/mob/user = back_seat() ? back_seat() : front_seat() // for debugging

	if (!user) return

	if(world.time - last_fire < fire_delay && last_fire != -1)
		(back_seat() ? back_seat() : front_seat()) << "<span class = 'danger'>You can't fire again so quickly!</span>"
		return

	playsound(get_turf(src), 'sound/weapons/WW2/tank_fire.ogg', 100)

	last_fire = world.time

	var/abs_dist = abs_dist(src, target)

	tank_explosion(target, min(2, abs_dist), 3, 4, 5)