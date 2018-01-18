/*
#define BRUTE "brute"
#define BURN "burn"
#define TOX "tox"
#define OXY "oxy"
#define CLONE "clone"

#define ADD "add"
#define SET "set"
*/

/obj/item/projectile
	name = "projectile"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bullet"
	density = TRUE
	anchored = TRUE //There's a reason this is here, Mport. God fucking damn it -Agouri. Find&Fix by Pete. The reason this is here is to stop the curving of emitter shots.
	pass_flags = PASSTABLE
	mouse_opacity = FALSE
	var/bumped = FALSE		//Prevents it from hitting more than one guy at once
	var/hitsound_wall = ""//"ricochet"
	var/def_zone = ""	//Aiming at
	var/mob/firer = null//Who shot it
	var/obj/item/weapon/gun/firedfrom = null // gun which shot it
	var/silenced = FALSE	//Attack message
	var/yo = null
	var/xo = null
	var/current = null
	var/shot_from = "" // name of the object which shot us
	var/atom/original = null // the target clicked (not necessarily where the projectile is headed). Should probably be renamed to 'target' or something.
	var/turf/starting = null // the projectile's starting turf
	var/list/permutated = list() // we've passed through these atoms, don't try to hit them again

	var/p_x = 16
	var/p_y = 16 // the pixel location of the tile that the player clicked. Default is the center

	var/accuracy = FALSE
	var/dispersion = 0.0

	var/damage = 10
	var/damage_type = BRUTE //BRUTE, BURN, TOX, OXY, CLONE, HALLOSS are the only things that should be in here
	var/nodamage = FALSE //Determines if the projectile will skip any damage inflictions
	var/taser_effect = FALSE //If set then the projectile will apply it's agony damage using stun_effect_act() to mobs it hits, and other damage will be ignored
	var/check_armour = "bullet" //Defines what armor to use when it hits things.  Must be set to bullet, laser, energy,or bomb	//Cael - bio and rad are also valid
	var/projectile_type = /obj/item/projectile
	var/penetrating = FALSE //If greater than zero, the projectile will pass through dense objects as specified by on_penetrate()
	var/kill_count = 30 //This will de-increment every process(). When == 0, it will delete the projectile.
		//Effects
	var/stun = FALSE
	var/weaken = FALSE
	var/paralyze = FALSE
	var/irradiate = FALSE
	var/stutter = FALSE
	var/eyeblur = FALSE
	var/drowsy = FALSE
	var/agony = FALSE
	var/embed = FALSE // whether or not the projectile can embed itself in the mob

	var/hitscan = FALSE		// whether the projectile should be hitscan
	var/step_delay = TRUE	// the delay between iterations if not a hitscan projectile

	// effect types to be used
	var/muzzle_type
	var/tracer_type
	var/impact_type

	var/datum/plot_vector/trajectory	// used to plot the path of the projectile
	var/datum/vector_loc/location		// current location of the projectile in pixel space
	var/matrix/effect_transform			// matrix to rotate and scale projectile effects - putting it here so it doesn't
										//  have to be recreated multiple times

	armor_penetration = 90

	var/speed = 1.5 // was 1.0

	/* since a lot of WW2 guns use similar ammo, this is calculated during runtime
	 * based on gun type and the distance between the firer and person hit.
	 * Right now, only boltactions & heavysniper guns get a high KD chance. */
	var/KD_chance = 5

//TODO: make it so this is called more reliably, instead of sometimes by bullet_act() and sometimes not
/obj/item/projectile/proc/on_hit(var/atom/target, var/blocked = FALSE, var/def_zone = null)
	if(blocked >= 2)		return FALSE//Full block
	if(!isliving(target))	return FALSE
	if(isanimal(target))	return FALSE
	var/mob/living/L = target
	L.apply_effects(stun, weaken, paralyze, irradiate, stutter, eyeblur, drowsy, agony, blocked) // add in AGONY!
	return TRUE

/obj/item/projectile/proc/on_impact(var/atom/A)
	impact_effect(effect_transform)		// generate impact effect
	playsound(src, "ric_sound", 50, TRUE, -2)
	return TRUE

//Checks if the projectile is eligible for embedding. Not that it necessarily will.
/obj/item/projectile/proc/can_embed()
	//embed must be enabled and damage type must be brute
	if(!embed || damage_type != BRUTE)
		return FALSE
	return TRUE

/obj/item/projectile/proc/get_structure_damage()
	if(damage_type == BRUTE || damage_type == BURN)
		return damage
	return FALSE

//return TRUE if the projectile should be allowed to pass through after all, FALSE if not.
/obj/item/projectile/proc/check_penetrate(var/atom/A)
	return TRUE

/obj/item/projectile/proc/check_fire(atom/target as mob, var/mob/living/user as mob)  //Checks if you can hit them or not.
	check_trajectory(target, user, pass_flags, flags)

//sets the click point of the projectile using mouse input params
/obj/item/projectile/proc/set_clickpoint(var/params)
	var/list/mouse_control = params2list(params)
	if(mouse_control["icon-x"])
		p_x = text2num(mouse_control["icon-x"])
	if(mouse_control["icon-y"])
		p_y = text2num(mouse_control["icon-y"])

	//randomize clickpoint a bit based on dispersion
	if(dispersion)
		var/radius = round((dispersion*0.443)*world.icon_size*0.8) //0.443 = sqrt(pi)/4 = 2a, where a is the side length of a square that shares the same area as a circle with diameter = dispersion
		p_x = between(0, p_x + rand(-radius, radius), world.icon_size)
		p_y = between(0, p_y + rand(-radius, radius), world.icon_size)

//called to launch a projectile from a gun
/obj/item/projectile/proc/launch(atom/target, mob/user, obj/item/weapon/gun/launcher, var/target_zone, var/x_offset=0, var/y_offset=0)

	var/turf/curloc = get_turf(launcher)
	var/turf/targloc = get_turf(target)

	if (!istype(targloc) || !istype(curloc))
		qdel(src)
		return TRUE

	firer = user
	firedfrom = launcher
	def_zone = target_zone

	if(user == target) //Shooting yourself
		user.pre_bullet_act(src)
		user.bullet_act(src, target_zone)
		on_impact(user)
		qdel(src)
		return FALSE
	if(targloc == curloc) //Shooting something in the same turf
		target.pre_bullet_act(src)
		target.bullet_act(src, target_zone)
		on_impact(target)
		qdel(src)
		return FALSE

	original = target
	loc = curloc
	starting = curloc
	current = curloc
	yo = targloc.y - curloc.y + y_offset
	xo = targloc.x - curloc.x + x_offset

	shot_from = launcher
	silenced = launcher.silenced

	spawn()
		process()

	return FALSE

// fixes grenades?
/obj/item/projectile/proc/launch_fragment(atom/target)

	var/turf/targloc = get_turf(target)

	if (!istype(targloc))
		qdel(src)
		return TRUE

	if(targloc == get_turf(src)) //Shooting something in the same turf
		target.pre_bullet_act(src)
		target.bullet_act(src, "chest")
		on_impact(target)
		qdel(src)
		return FALSE

	original = target
	loc = get_turf(src)
	starting = get_turf(src)
	current = get_turf(src)
	yo = targloc.y - y
	xo = targloc.x - x

	silenced = FALSE

	spawn()
		process()

	return FALSE

//called to launch a projectile from a gun
/obj/item/projectile/proc/launch_from_gun(atom/target, mob/user, obj/item/weapon/gun/launcher, var/target_zone, var/x_offset=0, var/y_offset=0)
	if(user == target) //Shooting yourself
		user.pre_bullet_act(src)
		user.bullet_act(src, target_zone)
		qdel(src)
		return FALSE

	loc = get_turf(user) //move the projectile out into the world

	firer = user
	firedfrom = launcher
	shot_from = launcher.name
	silenced = launcher.silenced

	return launch(target, target_zone, x_offset, y_offset)

//Used to change the direction of the projectile in flight.
/obj/item/projectile/proc/redirect(var/new_x, var/new_y, var/atom/starting_loc, var/mob/new_firer=null)
	var/turf/new_target = locate(new_x, new_y, z)

	original = new_target
	if(new_firer)
		firer = src

	setup_trajectory(starting_loc, new_target)

//Called when the projectile intercepts a mob. Returns TRUE if the projectile hit the mob, FALSE if it missed and should keep flying.
/obj/item/projectile/proc/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier=0)
	if(!istype(target_mob))
		return

	//roll to-hit
//	miss_modifier = max(15*(distance-2) - round(15*accuracy) + miss_modifier, FALSE)
//	var/zoomed = (accuracy >= firedfrom.scoped_accuracy && firedfrom.scoped_accuracy > firedfrom.accuracy)
	var/miss_chance = get_miss_chance(def_zone, distance, accuracy, miss_modifier)
	var/hit_zone = get_zone_with_miss_chance(def_zone, target_mob, miss_chance, ranged_attack=(distance > TRUE || original != target_mob), range = abs_dist(target_mob, firer)) //if the projectile hits a target we weren't originally aiming at then retain the chance to miss
	var/result = PROJECTILE_FORCE_MISS

	if(hit_zone)
		var/def_zone = hit_zone //set def_zone, so if the projectile ends up hitting someone else later (to be implemented), it is more likely to hit the same part
		target_mob.pre_bullet_act(src)
		result = target_mob.bullet_act(src, def_zone)

	if(result == PROJECTILE_FORCE_MISS)
		if(!silenced)
			visible_message("<span class='notice'>\The [src] misses [target_mob] narrowly!</span>")
			playsound(target_mob, "miss_sound", 60, TRUE)

		return FALSE

	//hit messages
	if(silenced)
		target_mob << "<span class='danger'>You've been hit in the [parse_zone(def_zone)] by \the [src]!</span>"
	else
		visible_message("<span class='danger'>\The [target_mob] is hit by \the [src] in the [parse_zone(def_zone)]!</span>")//X has fired Y is now given by the guns so you cant tell who shot you if you could not see the shooter


	//admin logs
	if(!no_attack_log)
		if(istype(firer, /mob))

			var/attacker_message = "shot with \a [type]"
			var/victim_message = "shot with \a [type]"
			var/admin_message = "shot (\a [type])"

			admin_attack_log(firer, target_mob, attacker_message, victim_message, admin_message)
		else
			target_mob.attack_log += "\[[time_stamp()]\] <b>UNKNOWN SUBJECT (No longer exists)</b> shot <b>[target_mob]/[target_mob.ckey]</b> with <b>\a [src]</b>"
			msg_admin_attack("UNKNOWN shot [target_mob] ([target_mob.ckey]) with \a [src] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[target_mob.x];Y=[target_mob.y];Z=[target_mob.z]'>JMP</a>)")

	//sometimes bullet_act() will want the projectile to continue flying
	if (result == PROJECTILE_CONTINUE)
		return FALSE

	return TRUE

/obj/item/projectile/Bump(atom/A as mob|obj|turf|area, forced=0)
	if(A == src)
		return FALSE //no

	if(A == firer)
		loc = A.loc
		return FALSE //cannot shoot yourself

	if((bumped && !forced) || (A in permutated))
		return FALSE

	var/passthrough = FALSE //if the projectile should continue flying
	var/distance = max(abs(loc.x - starting.x), abs(loc.y - starting.y))
	//get_dist(starting,loc)
	bumped = TRUE
	if(ismob(A))
		var/mob/M = A
		if(istype(A, /mob/living))
			//if they have a neck grab on someone, that person gets hit instead
			var/obj/item/weapon/grab/G = locate() in M
			if(G && G.state >= GRAB_NECK)
				visible_message("<span class='danger'>\The [M] uses [G.affecting] as a shield!</span>")
				if(Bump(G.affecting, forced=1))
					return //If Bump() returns FALSE (keep going) then we continue on to attack M.
			M.pre_bullet_act(src)
			passthrough = !attack_mob(M, distance)
		else
			passthrough = TRUE //so ghosts don't stop bullets
	else
		A.pre_bullet_act(src)
		passthrough = (A.bullet_act(src, def_zone) == PROJECTILE_CONTINUE) //backwards compatibility
		if(isturf(A))
			for(var/obj/O in A)
				O.pre_bullet_act(src)
				O.bullet_act(src, "chest")
			for(var/mob/living/M in A)
				M.pre_bullet_act(src)
				attack_mob(M, distance)

	//penetrating projectiles can pass through things that otherwise would not let them
	if(!passthrough && penetrating > FALSE)
		if(check_penetrate(A))
			passthrough = TRUE
		penetrating--

	//the bullet passes through a dense object!
	if(passthrough)
		//move ourselves onto A so we can continue on our way.
		if(A)
			if(istype(A, /turf))
				loc = A
			else
				loc = A.loc
			permutated.Add(A)
		bumped = FALSE //reset bumped variable!
		return FALSE

	//stop flying
	on_impact(A)

	density = FALSE
	invisibility = 101

	qdel(src)
	return TRUE

/obj/item/projectile/ex_act()
	return //explosions probably shouldn't delete projectiles

/obj/item/projectile/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return TRUE


/obj/item/projectile/process()
	var/first_step = 1

	//plot the initial trajectory
	setup_trajectory()

	spawn while(src && loc)
		if(--kill_count < 1)
			loc.pre_bullet_act(src)
			on_impact(loc) //for any final impact behaviours
			spawn (1)
				qdel(src)
			return
		if (firer && map.check_prishtina_block(firer, loc))
			spawn (1)
				qdel(src)
			return
		if((!( current ) || loc == current))
			current = locate(min(max(x + xo, TRUE), world.maxx), min(max(y + yo, TRUE), world.maxy), z)
		if((x == 1 || x == world.maxx || y == TRUE || y == world.maxy))
			loc.pre_bullet_act(src)
			on_impact(loc)
			spawn (1)
				qdel(src)
			return

		trajectory.increment()	// increment the current location
		location = trajectory.return_location(location)		// update the locally stored location data

		if(!location)
			qdel(src)	// if it's left the world... kill it
			return

		for (var/obj/structure/structure in loc)
			if (!structure.CanPass(src, loc))
				qdel(src)
				return

		before_move()
		Move(location.return_turf())

		if(!bumped && !isturf(original))
			if(loc == get_turf(original))
				if(!(original in permutated))
					if(Bump(original))
						return

		if(first_step)
			muzzle_effect(effect_transform)
			first_step = FALSE
		else if(!bumped)
			tracer_effect(effect_transform)

		if(!hitscan)
			if (prob(100/speed))
				sleep(step_delay)	//add delay between movement iterations if it's not a hitscan weapon

/obj/item/projectile/proc/before_move()
	return FALSE

/obj/item/projectile/proc/setup_trajectory()
	// trajectory dispersion
	var/offset = FALSE
	if(dispersion)
		var/radius = round(dispersion*9, TRUE)
		offset = rand(-radius, radius)

	// plot the initial trajectory
	trajectory = new()
	trajectory.setup(starting, original, pixel_x, pixel_y, angle_offset=offset)

	// generate this now since all visual effects the projectile makes can use it
	effect_transform = new()
	effect_transform.Scale(trajectory.return_hypotenuse(), TRUE)
	effect_transform.Turn(-trajectory.return_angle())		//no idea why this has to be inverted, but it works

	transform = turn(transform, -(trajectory.return_angle() + 90)) //no idea why 90 needs to be added, but it works

/obj/item/projectile/proc/muzzle_effect(var/matrix/T)
	if(silenced)
		return

	if(ispath(muzzle_type))
		var/obj/effect/projectile/M = new muzzle_type(get_turf(src))

		if(istype(M))
			M.set_transform(T)
			M.pixel_x = location.pixel_x
			M.pixel_y = location.pixel_y
			M.activate()

/obj/item/projectile/proc/tracer_effect(var/matrix/M)
	if(ispath(tracer_type))
		var/obj/effect/projectile/P = new tracer_type(location.loc)

		if(istype(P))
			P.set_transform(M)
			P.pixel_x = location.pixel_x
			P.pixel_y = location.pixel_y
			if(!hitscan)
				P.activate(step_delay)	//if not a hitscan projectile, remove after a single delay
			else
				P.activate()

/obj/item/projectile/proc/impact_effect(var/matrix/M)
	if(ispath(tracer_type))
		var/obj/effect/projectile/P = new impact_type(location.loc)

		if(istype(P))
			P.set_transform(M)
			P.pixel_x = location.pixel_x
			P.pixel_y = location.pixel_y
			P.activate()

//"Tracing" projectile
/obj/item/projectile/test //Used to see if you can hit them.
	invisibility = 101 //Nope!  Can't see me!
	yo = null
	xo = null
	var/result = FALSE //To pass the message back to the gun.

/obj/item/projectile/test/Bump(atom/A as mob|obj|turf|area)
	if(A == firer)
		loc = A.loc
		return //cannot shoot yourself
	if(istype(A, /obj/item/projectile))
		return
	if(istype(A, /mob/living) || istype(A, /obj/vehicle))
		result = 2 //We hit someone, return TRUE!
		return
	result = TRUE
	return

/obj/item/projectile/test/launch(atom/target)

	var/turf/curloc = get_turf(src)
	var/turf/targloc = get_turf(target)

	if(!curloc || !targloc)
		qdel(src)
		return FALSE

	original = target

	//plot the initial trajectory
	setup_trajectory(curloc, targloc)
	return process(targloc)

/obj/item/projectile/test/process(var/turf/targloc)
	while(src) //Loop on through!
		if(result)
			return (result - TRUE)
		if((!( targloc ) || loc == targloc))
			targloc = locate(min(max(x + xo, TRUE), world.maxx), min(max(y + yo, TRUE), world.maxy), z) //Finding the target turf at map edge

		trajectory.increment()	// increment the current location
		location = trajectory.return_location(location)		// update the locally stored location data

		Move(location.return_turf())

		var/mob/living/M = locate() in get_turf(src)
		if(istype(M)) //If there is someting living...
			return TRUE //Return TRUE
		else
			M = locate() in get_step(src,targloc)
			if(istype(M))
				return TRUE

//Helper proc to check if you can hit them or not.
/proc/check_trajectory(atom/target as mob|obj, atom/firer as mob|obj, var/pass_flags=PASSTABLE|PASSGLASS|PASSGRILLE, flags=null)
	if(!istype(target) || !istype(firer))
		return FALSE

	var/obj/item/projectile/test/trace = new /obj/item/projectile/test(get_turf(firer)) //Making the test....

	//Set the flags and pass flags to that of the real projectile...
	if(!isnull(flags))
		trace.flags = flags
	trace.pass_flags = pass_flags

	var/output = trace.launch(target) //Test it!
	qdel(trace) //No need for it anymore
	return output //Send it back to the gun!
