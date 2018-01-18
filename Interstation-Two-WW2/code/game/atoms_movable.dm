/atom/movable
	layer = 3
	var/last_move = null
	var/anchored = FALSE
	// var/elevation = 2    - not used anywhere
	var/move_speed = 10
	var/l_move_time = TRUE
	var/m_flag = TRUE
	var/throwing = FALSE
	var/thrower
	var/turf/throw_source = null
	var/turf/last_throw_source = null // when we need a longterm reference
	var/throw_speed = 2
	var/throw_range = 7
	var/moved_recently = FALSE
	var/mob/pulledby = null
	var/item_state = null // Used to specify the item state for the on-mob overlays.

	var/auto_init = TRUE
	var/nothrow = FALSE

/atom/movable/New()
	..()
	if(auto_init && ticker && ticker.current_state == GAME_STATE_PLAYING)
		initialize()

/atom/movable/Del()
	if(isnull(gcDestroyed) && loc)
		testing("GC: -- [type] was deleted via del() rather than qdel() --")
		crash_with("GC: -- [type] was deleted via del() rather than qdel() --") // stick a stack trace in the runtime logs
//	else if(isnull(gcDestroyed))
//		testing("GC: [type] was deleted via GC without qdel()") //Not really a huge issue but from now on, please qdel()
//	else
//		testing("GC: [type] was deleted via GC with qdel()")
	..()

/atom/movable/Destroy()
	. = ..()
	for(var/atom/movable/AM in contents)
		qdel(AM)
	forceMove(null)
	if (pulledby)
		if (pulledby.pulling == src)
			pulledby.pulling = null
		pulledby = null



//Convenience function for atoms to update turfs they occupy
/atom/movable/proc/update_nearby_tiles(need_rebuild)
/*	if(!air_master)
		return FALSE

	for(var/turf/turf in locs)
		air_master.mark_for_update(turf)*/

	return TRUE

/atom/movable/proc/initialize()
	if(!isnull(gcDestroyed))
		crash_with("GC: -- [type] had initialize() called after qdel() --")

/atom/movable/Bump(var/atom/A, yes)

	if(throwing)
		throw_impact(A)
		throwing = FALSE

	spawn(0)
		if (A && yes)
			A.last_bumped = world.time
			A.Bumped(src)
		return

	..()
	return

/atom/movable/proc/forceMove(atom/destination, var/special_event)
	if(loc == destination)
		return FALSE

	var/is_origin_turf = isturf(loc)
	var/is_destination_turf = isturf(destination)
	// It is a new area if:
	//  Both the origin and destination are turfs with different areas.
	//  When either origin or destination is a turf and the other is not.
	var/is_new_area = (is_origin_turf ^ is_destination_turf) || (is_origin_turf && is_destination_turf && loc.loc != destination.loc)

	var/atom/origin = loc
	loc = destination

	if(origin)
		origin.Exited(src, destination)
		if(is_origin_turf)
			for(var/atom/movable/AM in origin)
				AM.Uncrossed(src)
			if(is_new_area && is_origin_turf)
				origin.loc.Exited(src, destination)

	if(destination)
		destination.Entered(src, origin, special_event)
		if(is_destination_turf) // If we're entering a turf, cross all movable atoms
			for(var/atom/movable/AM in loc)
				if(AM != src)
					AM.Crossed(src)
			if(is_new_area && is_destination_turf)
				destination.loc.Entered(src, origin)
	return TRUE

/atom/movable/proc/forceMoveOld(atom/destination)
	if(destination)
		if(loc)
			loc.Exited(src)
		loc = destination
		loc.Entered(src)
		return TRUE
	return FALSE

//called when src is thrown into hit_atom
/atom/movable/proc/throw_impact(atom/hit_atom, var/speed)
	if(istype(hit_atom,/mob/living))
		var/mob/living/M = hit_atom
		M.hitby(src,speed)

	else if(isobj(hit_atom))
		var/obj/O = hit_atom
		if(!O.anchored)
			step(O, last_move)
		O.hitby(src,speed)

	else if(isturf(hit_atom))
		throwing = FALSE
		var/turf/T = hit_atom
		if(T.density)
			spawn(2)
				step(src, turn(last_move, 180))
			if(istype(src,/mob/living))
				var/mob/living/M = src
				M.turf_collision(T, speed)

//decided whether a movable atom being thrown can pass through the turf it is in.
/atom/movable/proc/hit_check(var/speed)
	if(throwing)
		for(var/atom/A in get_turf(src))
			if(A == src) continue
			if(istype(A,/mob/living))
				if(A:lying) continue
				throw_impact(A,speed)
			if(isobj(A))
				if(A.density && !A.throwpass)	// **TODO: Better behaviour for windows which are dense, but shouldn't always stop movement
					throw_impact(A,speed)

/atom/movable/proc/throw_at(atom/target, range, speed, thrower)
	. = TRUE
	if(!target || !src)	return FALSE

	//use a modified version of Bresenham's algorithm to get from the atom's current position to that of the target

	throwing = TRUE
	if(target.allow_spin && allow_spin)
		SpinAnimation(5,1)
	thrower = thrower
	throw_source = get_turf(src)	//store the origin turf
	last_throw_source = throw_source

	if(usr)
		if(HULK in usr.mutations)
			throwing = 2 // really strong throw!

	var/dist_x = abs(target.x - x)
	var/dist_y = abs(target.y - y)

	var/dx
	if (target.x > x)
		dx = EAST
	else
		dx = WEST

	var/dy
	if (target.y > y)
		dy = NORTH
	else
		dy = SOUTH
	var/dist_travelled = FALSE
	var/dist_since_sleep = FALSE
	var/area/a = get_area(loc)
	if(dist_x > dist_y)
		var/error = dist_x/2 - dist_y

		while(src && target &&((((x < target.x && dx == EAST) || (x > target.x && dx == WEST)) && dist_travelled < range) || (a && a.has_gravity == FALSE)  || istype(loc, /turf/space)) && throwing && istype(loc, /turf))
			// only stop when we've gone the whole distance (or max throw range) and are on a non-space tile, or hit something, or hit the end of the map, or someone picks it up
			if(error < FALSE)
				var/atom/step = get_step(src, dy)
				if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				if (map.check_prishtina_block(thrower, get_turf(step)))
					if (istype(src, /obj/item/weapon/grenade))
						var/obj/item/weapon/grenade/G = src
						G.active = FALSE
					break
				Move(step)
				hit_check(speed)
				error += dist_x
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = FALSE
					sleep(1)
			else
				var/atom/step = get_step(src, dx)
				if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				if (map.check_prishtina_block(thrower, get_turf(step)))
					if (istype(src, /obj/item/weapon/grenade))
						var/obj/item/weapon/grenade/G = src
						G.active = FALSE
					break
				Move(step)
				hit_check(speed)
				error -= dist_y
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = FALSE
					sleep(1)
			a = get_area(loc)
	else
		var/error = dist_y/2 - dist_x
		while(src && target &&((((y < target.y && dy == NORTH) || (y > target.y && dy == SOUTH)) && dist_travelled < range) || (a && a.has_gravity == FALSE)  || istype(loc, /turf/space)) && throwing && istype(loc, /turf))
			// only stop when we've gone the whole distance (or max throw range) and are on a non-space tile, or hit something, or hit the end of the map, or someone picks it up
			if(error < FALSE)
				var/atom/step = get_step(src, dx)
				if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				if (map.check_prishtina_block(thrower, get_turf(step)))
					if (istype(src, /obj/item/weapon/grenade))
						var/obj/item/weapon/grenade/G = src
						G.active = FALSE
					break
				Move(step)
				hit_check(speed)
				error += dist_y
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = FALSE
					sleep(1)
			else
				var/atom/step = get_step(src, dy)
				if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				if (map.check_prishtina_block(thrower, get_turf(step)))
					if (istype(src, /obj/item/weapon/grenade))
						var/obj/item/weapon/grenade/G = src
						G.active = FALSE
					break
				Move(step)
				hit_check(speed)
				error -= dist_x
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = FALSE
					sleep(1)

			a = get_area(loc)

	//done throwing, either because it hit something or it finished moving
	var/turf/new_loc = get_turf(src)
	if(isobj(src)) throw_impact(new_loc,speed)
	if (src && new_loc)
		new_loc.Entered(src)
		throwing = FALSE
		thrower = null
		throw_source = null


//Overlays
/atom/movable/overlay
	var/atom/master = null
	anchored = TRUE

/atom/movable/overlay/New()
	for(var/x in verbs)
		verbs -= x
	..()

/atom/movable/overlay/attackby(a, b)
	if (master)
		return master.attackby(a, b)
	return

/atom/movable/overlay/attack_hand(a, b, c)
	if (master)
		return master.attack_hand(a, b, c)
	return

/atom/movable/proc/touch_map_edge()
	if(z in config.sealed_levels)
		return

	var/move_to_z = get_transit_zlevel()
	if(move_to_z)
		z = move_to_z

		if(x <= TRANSITIONEDGE)
			x = world.maxx - TRANSITIONEDGE - 2
			y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

		else if (x >= (world.maxx - TRANSITIONEDGE + TRUE))
			x = TRANSITIONEDGE + TRUE
			y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

		else if (y <= TRANSITIONEDGE)
			y = world.maxy - TRANSITIONEDGE -2
			x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

		else if (y >= (world.maxy - TRANSITIONEDGE + TRUE))
			y = TRANSITIONEDGE + TRUE
			x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

		spawn(0)
			if(loc) loc.Entered(src)

//This list contains the z-level numbers which can be accessed via space travel and the percentile chances to get there.
var/list/accessible_z_levels = list("1" = 5, "3" = 10, "4" = 15, "6" = 60)

//by default, transition randomly to another zlevel
/atom/movable/proc/get_transit_zlevel()
	var/list/candidates = accessible_z_levels.Copy()
	candidates.Remove("[z]")

	if(!candidates.len)
		return null
	return text2num(pickweight(candidates))

