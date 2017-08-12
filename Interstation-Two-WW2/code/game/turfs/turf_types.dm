var/list/exterior_turfs = list(/turf/simulated/floor/plating/grass,
							/turf/simulated/floor/plating/dirt,
							/turf/simulated/floor/plating/sand,
							/turf/simulated/floor/plating/concrete,
							/turf/simulated/floor/plating/road,
							/turf/simulated/floor/plating/asteroid
							)

var/list/interior_areas = list(/area/prishtina/houses,
							/area/prishtina/train
							)


/turf
	icon = 'icons/turf/floors.dmi'
	level = 1
	var/holy = 0

	// Initial air contents (in moles)
	var/oxygen = 0
	var/carbon_dioxide = 0
	var/nitrogen = 0
	var/plasma = 0

	//Properties for airtight tiles (/wall)
	var/thermal_conductivity = 0.05
	var/heat_capacity = 1

	//Properties for both
	var/temperature = T20C      // Initial turf temperature.
	var/blocks_air = 0          // Does this turf contain air/let air through?

	// General properties.
	var/icon_old = null
	var/pathweight = 1          // How much does it cost to pathfind over this turf?
	var/blessed = 0             // Has the turf been blessed?

	var/list/decals

/turf/New()
	..()
	for(var/atom/movable/AM as mob|obj in src)
		spawn( 0 )
			src.Entered(AM)
			return
	turfs |= src

/turf/proc/update_icon()
	return

/turf/proc/neighbors()
	var/list/l = list()
	for (var/turf/t in range(1, src))
		l += t
	return l

/turf/Destroy()
	turfs -= src
	..()

/turf/ex_act(severity)
	return 0

/turf/proc/is_space()
	return 0

/turf/proc/is_intact()
	return 0

/turf/attack_hand(mob/user)
	if(!(user.canmove) || user.restrained() || !(user.pulling))
		return 0
	if(user.pulling.anchored || !isturf(user.pulling.loc))
		return 0
	if(user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1)
		return 0
	if(ismob(user.pulling))
		var/mob/M = user.pulling
		var/atom/movable/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return 1

/turf/Enter(atom/movable/mover as mob|obj, atom/forget as mob|obj|turf|area)
	if(movement_disabled && usr.ckey != movement_disabled_exception)
		usr << "<span class='warning'>Movement is admin-disabled.</span>" //This is to identify lag problems
		return

	..()

	if (!mover || !isturf(mover.loc) || isobserver(mover))
		return 1

	//First, check objects to block exit that are not on the border
	for(var/obj/obstacle in mover.loc)
		if(!(obstacle.flags & ON_BORDER) && (mover != obstacle) && (forget != obstacle))
			if(!obstacle.CheckExit(mover, src))
				mover.Bump(obstacle, 1)
				return 0

	//Now, check objects to block exit that are on the border
	for(var/obj/border_obstacle in mover.loc)
		if((border_obstacle.flags & ON_BORDER) && (mover != border_obstacle) && (forget != border_obstacle))
			if(!border_obstacle.CheckExit(mover, src))
				mover.Bump(border_obstacle, 1)
				return 0

	//Next, check objects to block entry that are on the border
	for(var/obj/border_obstacle in src)
		if(border_obstacle.flags & ON_BORDER)
			if(!border_obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != border_obstacle))
				mover.Bump(border_obstacle, 1)
				return 0

	//Then, check the turf itself
	if (!src.CanPass(mover, src))
		mover.Bump(src, 1)
		return 0

	//Finally, check objects/mobs to block entry that are not on the border
	for(var/atom/movable/obstacle in src)
		if(!(obstacle.flags & ON_BORDER))
			if(!obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != obstacle))
				mover.Bump(obstacle, 1)
				return 0
	return 1 //Nothing found to block so return success!

var/const/enterloopsanity = 100
/turf/Entered(atom/atom as mob|obj)

	if(movement_disabled)
		usr << "<span class='warning'>Movement is admin-disabled.</span>" //This is to identify lag problems
		return
	..()

	if(!istype(atom, /atom/movable))
		return

	var/atom/movable/A = atom

	if(ismob(A))
		var/mob/M = A
		if(!M.lastarea)
			M.lastarea = get_area(M.loc)
		if(M.lastarea.has_gravity == 0)
			inertial_drift(M)
		else if(is_space())
			M.inertia_dir = 0
			M.make_floating(0)

	var/objects = 0
	if(A && (A.flags & PROXMOVE))
		for(var/atom/movable/thing in range(1))
			if(objects > enterloopsanity) break
			objects++
			spawn(0)
				if(A)
					A.HasProximity(thing, 1)
					if ((thing && A) && (thing.flags & PROXMOVE))
						thing.HasProximity(A, 1)
	return

/turf/proc/adjacent_fire_act(turf/simulated/floor/source, temperature, volume)
	return

/turf/proc/is_plating()
	return 0

/turf/proc/inertial_drift(atom/movable/A as mob|obj)
	if(!(A.last_move))	return
	if((istype(A, /mob/) && src.x > 2 && src.x < (world.maxx - 1) && src.y > 2 && src.y < (world.maxy-1)))
		var/mob/M = A
		if(M.Process_Spacemove(1))
			M.inertia_dir  = 0
			return
		spawn(5)
			if((M && !(M.anchored) && !(M.pulledby) && (M.loc == src)))
				if(M.inertia_dir)
					step(M, M.inertia_dir)
					return
				M.inertia_dir = M.last_move
				step(M, M.inertia_dir)
	return

/turf/proc/levelupdate()
	for(var/obj/O in src)
		O.hide(O.hides_under_flooring() && !is_plating())

/turf/proc/AdjacentTurfs()
	var/L[] = new()
	for(var/turf/simulated/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/proc/CardinalTurfs()
	var/L[] = new()
	for(var/turf/simulated/T in AdjacentTurfs())
		if(T.x == src.x || T.y == src.y)
			L.Add(T)
	return L

/turf/proc/Distance(turf/t)
	if(get_dist(src,t) == 1)
		var/cost = (src.x - t.x) * (src.x - t.x) + (src.y - t.y) * (src.y - t.y)
		cost *= (pathweight+t.pathweight)/2
		return cost
	else
		return get_dist(src,t)

/turf/proc/AdjacentTurfsSpace()
	var/L[] = new()
	for(var/turf/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/proc/process()
	return PROCESS_KILL

/turf/proc/contains_dense_objects()
	if(density)
		return 1
	for(var/atom/A in src)
		if(A.density && !(A.flags & ON_BORDER))
			return 1
	return 0

//expects an atom containing the reagents used to clean the turf
/turf/proc/clean(atom/source, mob/user)
	if(source.reagents.has_reagent("water", 1) || source.reagents.has_reagent("cleaner", 1))
		clean_blood()
		if(istype(src, /turf/simulated))
			var/turf/simulated/T = src
			T.dirt = 0
		for(var/obj/effect/O in src)
			if(istype(O,/obj/effect/decal/cleanable) || istype(O,/obj/effect/overlay))
				qdel(O)
	else
		user << "<span class='warning'>\The [source] is too dry to wash that.</span>"
	source.reagents.trans_to_turf(src, 1, 10)	//10 is the multiplier for the reaction effect. probably needed to wet the floor properly.

/turf/proc/update_blood_overlays()
	return

/turf/simulated
	name = "station"
	var/wet = 0
	var/image/wet_overlay = null

	//Mining resources (for the large drills).
	var/has_resources
	var/list/resources

	var/thermite = 0
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	var/to_be_destroyed = 0 //Used for fire, if a melting temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The max temperature of the fire which it was subjected to
	var/dirt = 0

	var/datum/scheduled_task/unwet_task
	var/interior = 1
	var/stepsound = null
	var/floor_type= null
	var/intact = 1

// This is not great.
/turf/simulated/proc/wet_floor(var/wet_val = 1)
	if(wet_val < wet)
		return

	if(!wet)
		wet = wet_val
		wet_overlay = image('icons/effects/water.dmi',src,"wet_floor")
		overlays += wet_overlay

	if(unwet_task)
		unwet_task.trigger_task_in(8 SECONDS)
	else
		unwet_task = schedule_task_in(8 SECONDS)
		task_triggered_event.register(unwet_task, src, /turf/simulated/proc/task_unwet_floor)

/turf/simulated/proc/task_unwet_floor(var/triggered_task)
	if(triggered_task == unwet_task)
		unwet_task = null
		unwet_floor(TRUE)

/turf/simulated/proc/unwet_floor(var/check_very_wet)
	if(check_very_wet && wet >= 2)
		return

	wet = 0
	if(wet_overlay)
		overlays -= wet_overlay
		wet_overlay = null

/turf/simulated/clean_blood()
	for(var/obj/effect/decal/cleanable/blood/B in contents)
		B.clean_blood()
	..()

/turf/simulated/New()
	..()
	levelupdate()

/turf/simulated/Destroy()
	qdel(unwet_task)
	unwet_task = null
	return ..()

/turf/simulated/proc/initialize()
	return

/turf/simulated/proc/AddTracks(var/typepath,var/bloodDNA,var/comingdir,var/goingdir,var/bloodcolor="#A10808")
	var/obj/effect/decal/cleanable/blood/tracks/tracks = locate(typepath) in src
	if(!tracks)
		tracks = new typepath(src)
	tracks.AddTracks(bloodDNA,comingdir,goingdir,bloodcolor)

/turf/simulated/proc/update_dirt()
	dirt = min(dirt+1, 101)
	var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, src)
	if (dirt > 50)
		if (!dirtoverlay)
			dirtoverlay = new/obj/effect/decal/cleanable/dirt(src)
		dirtoverlay.alpha = min((dirt - 50) * 5, 255)

/turf/simulated/Entered(atom/A, atom/OL)
	if(movement_disabled && usr.ckey != movement_disabled_exception)
		usr << "<span class='danger'>Movement is admin-disabled.</span>" //This is to identify lag problems
		return

	if (istype(A,/mob/living))
		var/mob/living/M = A
		if(M.lying)
			return ..()

		// Dirt overlays.
		update_dirt()

		if(istype(M, /mob/living/carbon/human))
			var/footstepsound
			var/mob/living/carbon/human/H = M
			// Tracking blood
			var/list/bloodDNA = null
			var/bloodcolor=""

			if(H.shoes)
				var/obj/item/clothing/shoes/S = H.shoes
				if(istype(S))
					S.handle_movement(src,(H.m_intent == "run" ? 1 : 0))
					if(S.track_blood && S.blood_DNA)
						bloodDNA = S.blood_DNA
						bloodcolor=S.blood_color
						S.track_blood--
			else
				if(H.track_blood && H.feet_blood_DNA)
					bloodDNA = H.feet_blood_DNA
					bloodcolor = H.feet_blood_color
					H.track_blood--

			if (bloodDNA)
				src.AddTracks(/obj/effect/decal/cleanable/blood/tracks/footprints,bloodDNA,H.dir,0,bloodcolor) // Coming
				var/turf/simulated/from = get_step(H,reverse_direction(H.dir))
				if(istype(from) && from)
					from.AddTracks(/obj/effect/decal/cleanable/blood/tracks/footprints,bloodDNA,0,H.dir,bloodcolor) // Going

				bloodDNA = null

			//Shoe sounds
			if 		(istype(src, /turf/simulated/floor/grass))
				footstepsound = "grassfootsteps"
			//else 	if(istype(src, /turf/stalker/floor/tropa))//Not needed for now.
			//	footstepsound = "sandfootsteps"
			else 	if(istype(src, /turf/simulated/floor/beach/water))
				footstepsound = "waterfootsteps"
			else 	if(istype(src, /turf/simulated/floor/wood))
				footstepsound = "woodfootsteps"
			else 	if(istype(src, /turf/simulated/floor/carpet))
				footstepsound = "carpetfootsteps"
			else 	if(istype(src, /turf/simulated/floor/dirt))
				footstepsound = "dirtfootsteps"
			else
				footstepsound = "erikafootsteps"

			if(istype(H.shoes, /obj/item/clothing/shoes))//This is probably the worst possible way to handle walking sfx.
				if(M.m_intent == "run")
					if(M.footstep >= 1)//Every two steps.
						M.footstep = 0
						playsound(src, footstepsound, 100, 1)
					else
						M.footstep++
				else
					if(M.footstep >= 6)
						M.footstep = 0
						playsound(src, footstepsound, 100, 1)
					else
						M.footstep++



		if(src.wet)

			if(M.buckled || (src.wet == 1 && M.m_intent == "walk"))
				return

			var/slip_dist = 1
			var/slip_stun = 6
			var/floor_type = "wet"

			switch(src.wet)
				if(2) // Lube
					floor_type = "slippery"
					slip_dist = 4
					slip_stun = 10
				if(3) // Ice
					floor_type = "icy"
					slip_stun = 4

			if(M.slip("the [floor_type] floor",slip_stun))
				for(var/i = 0;i<slip_dist;i++)
					step(M, M.dir)
					sleep(1)
			else
				M.inertia_dir = 0
		else
			M.inertia_dir = 0

	..()

//returns 1 if made bloody, returns 0 otherwise
/turf/simulated/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return 0

	if(istype(M))
		for(var/obj/effect/decal/cleanable/blood/B in contents)
	/*		if(!B.blood_DNA)
				B.blood_DNA = list()
			if(!B.blood_DNA[M.dna.unique_enzymes])
				B.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
				B.virus2 = virus_copylist(M.virus2)*/
			return 1 //we bloodied the floor
		blood_splatter(src,M.get_blood(M.vessel),1)
		return 1 //we bloodied the floor
	return 0

// Only adds blood on the floor -- Skie
/turf/simulated/proc/add_blood_floor(mob/living/carbon/M as mob)
	if( istype(M, /mob/living/carbon/alien ))
		var/obj/effect/decal/cleanable/blood/xeno/this = new /obj/effect/decal/cleanable/blood/xeno(src)
		this.blood_DNA["UNKNOWN BLOOD"] = "X*"
	else if( istype(M, /mob/living/silicon/robot ))
		new /obj/effect/decal/cleanable/blood/oil(src)

/turf/simulated/proc/can_build_cable(var/mob/user)
	return 0

/turf/simulated/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing, /obj/item/stack/cable_coil) && can_build_cable(user))
		var/obj/item/stack/cable_coil/coil = thing
		coil.turf_place(src, user)
		return
	return ..()
