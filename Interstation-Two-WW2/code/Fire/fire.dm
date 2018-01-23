// New version of fire that doesn't require ZAS. Mostly copypasta - Kachnov

/turf/var/fire_protection = FALSE //Protects newly extinguished tiles from being overrun again.
/turf/proc/apply_fire_protection()
/turf/apply_fire_protection()
	fire_protection = world.time

//Some legacy definitions so fires can be started.
/atom/proc/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return null


turf/proc/hotspot_expose(exposed_temperature, exposed_volume, soh = FALSE)
	return

/turf/hotspot_expose(exposed_temperature, exposed_volume, soh)
	if(fire_protection > world.time-300)
		return FALSE
	if(locate(/obj/fire) in src)
		return TRUE
	var/datum/gas_mixture/air_contents = return_air()
	if(!air_contents || exposed_temperature < PLASMA_MINIMUM_BURN_TEMPERATURE)
		return FALSE

	var/igniting = FALSE
	//var/obj/effect/decal/cleanable/liquid_fuel/liquid = locate() in src

/*	if(air_contents.check_combustability(liquid))
		igniting = TRUE*/

	//	create_fire(exposed_temperature)
	return igniting

/turf/var/obj/fire/fire = null

/turf/proc/create_fire(fl, temp, spread = TRUE)
	return FALSE

/turf/Entered(atom/movable/am,atom/oldloc)
	..(am,oldloc)
	if (isliving(am))
		var/mob/living/L = am
		if (fire)
			fire.Burn(L, 0.33) // sucks to die by trying to walk out of fire

/turf/create_fire(fl, temp, spread = TRUE)

	if(fire)
		fire.firelevel = max(fl, fire.firelevel)
		fire.temperature = max(temp, fire.temperature)
		return TRUE

	fire = new(src, fl)

	if (!spread)
		fire.nospread = TRUE

	fire.temperature = temp

	var/obj/effect/decal/cleanable/liquid_fuel/fuel = locate() in src

	if (fuel)

		fire.time_limit += rand(10,20)

	return fire

/obj/fire

	anchored = TRUE
	mouse_opacity = FALSE

	blend_mode = BLEND_ADD

	icon = 'icons/effects/fire.dmi'
	icon_state = "1"
	light_color = "#ED9200"
	layer = MOB_LAYER + 0.01 // above train pseudoturfs, stairs, and now MOBs

	var/firelevel = TRUE
	var/default_damage = 4
	var/spread_range = TRUE
	var/spread_prob = 10
	var/spread_fuel_prob = 80
	var/temperature = 500
	var/default_temperature = 500

	var/time_limit = 2

	var/ticks = FALSE

	var/nospread = FALSE

/obj/fire/process()
	. = TRUE

	var/turf/my_tile = loc

	if(!istype(my_tile))
		if(my_tile.fire == src)
			my_tile.fire = null
			RemoveFire()
		return TRUE

	if(firelevel > 6)
		icon_state = "3"
		set_light(7, 3)
	else if(firelevel > 2.5)
		icon_state = "2"
		set_light(5, 2)
	else
		icon_state = "1"
		set_light(3, TRUE)

	for(var/mob/m in my_tile)
		Burn(m)

	for (var/obj/structure/window/W in my_tile)
		if (!istype(W, /obj/structure/window/sandbag))
			if (prob((temperature/default_temperature) * 70))
				W.shatter()

	for (var/obj/structure/grille/G in my_tile)
		if (prob((temperature/default_temperature) * 30))
			G.visible_message("<span class = 'warning'>[G] melts.</span>")
			G.health = FALSE
			G.healthcheck()

	for (var/obj/snow/S in my_tile)
		if (prob(25))
			S.visible_message("<span class = 'warning'>The snow melts.</span>")
			qdel(S)

	for (var/obj/structure/wild/W in my_tile)
		if (istype(W, /obj/structure/wild/tree))
			if (prob(15))
				W.visible_message("<span class = 'warning'>[W] collapses.</span>")
				qdel(W)
		else
			if (prob(35))
				W.visible_message("<span class = 'warning'>[W] is burned away.</span>")
				qdel(W)

	for (var/obj/tank/T in my_tile)
		T.damage += T.x_percent_of_max_damage(0.5 * (temperature/default_temperature))
		T.update_damage_status()
	//loc.fire_act(air_contents, air_contents.temperature, air_contents.volume)

//	for(var/atom/A in loc)
	//	A.fire_act(air_contents, air_contents.temperature, air_contents.volume)

	//spread

	if (!nospread)
		for(var/direction in cardinal)
			var/turf/enemy_tile = get_step(my_tile, direction)

			if(istype(enemy_tile))
				if(my_tile.open_directions & direction) //Grab all valid bordering tiles
					if(enemy_tile.fire)
						continue

					//if(!enemy_tile.zone.fire_tiles.len) TODO - optimize
				//	var/datum/gas_mixture/acs = enemy_tile.return_air()
				//	var/obj/effect/decal/cleanable/liquid_fuel/liquid = locate() in enemy_tile
				//	if(!acs || !acs.check_combustability(liquid))
					//	continue

					//If extinguisher mist passed over the turf it's trying to spread to, don't spread and
					//reduce firelevel.

					if(enemy_tile.fire_protection > world.time-30)
						firelevel -= 1.5
						continue

					//Spread the fire.

				/*	if(prob( 50 + 50 * (firelevel/vsc.fire_firelevel_multiplier) ) && my_tile && my_tile.CanPass(null, enemy_tile, FALSE,0) && enemy_tile && enemy_tile.CanPass(null, my_tile, FALSE,0))
						enemy_tile.create_fire(firelevel)*/

		//	else
			//	enemy_tile.adjacent_fire_act(loc, air_contents, air_contents.temperature, air_contents.volume)
	else
		firelevel -= 1.5

	animate(src, color = fire_color(temperature), 5)
	set_light(l_color = color)

	++ticks

	if (ticks > time_limit)

		qdel (src)

/obj/fire/New(newLoc,fl)
	..()

	if(!istype(loc, /turf))
		qdel(src)
		return

	set_dir(pick(cardinal))

	color = fire_color(temperature)
	set_light(3, TRUE, color)

	firelevel = fl

	processing_objects += src

	spawn (200)
		if (src)
			qdel(src) // crappy workaround because fire won't process aaa

	for (var/obj/fire/F in get_turf(src))
		if (F != src)
			qdel(F)

/obj/fire/proc/fire_color(var/env_temperature)
	//var/temperature = max(4000*sqrt(firelevel/vsc.fire_firelevel_multiplier), env_temperature)
	//return heat2color(temperature)
	return heat2color(env_temperature)

/obj/fire/Destroy()
	RemoveFire()
	processing_objects -= src
	..()

/obj/fire/proc/RemoveFire()

	var/turf/T = loc
	if (istype(T))
		set_light(0)
		T.fire = null
		loc = null

/obj/fire/proc/get_damage()
	return (temperature/default_temperature) * default_damage

/obj/fire/proc/Burn(var/mob/living/L, var/power = 1.0)
	if (!istype(L))
		return

	var/damage = get_damage() * power

	if (prob((temperature/default_temperature) * 40))
		L.fire_act()

	if (!istype(L, /mob/living/carbon/human))
		L.apply_damage(damage*5)
	else
		var/mob/living/carbon/human/H = L

		var/head_exposure = TRUE
		var/chest_exposure = TRUE
		var/groin_exposure = TRUE
		var/legs_exposure = TRUE
		var/arms_exposure = TRUE

		//Get heat transfer coefficients for clothing.

		for(var/obj/item/clothing/C in src)
			if(H.l_hand == C || H.r_hand == C)
				continue

			if( C.max_heat_protection_temperature >= temperature )
				if(C.body_parts_covered & HEAD)
					head_exposure = FALSE
				if(C.body_parts_covered & UPPER_TORSO)
					chest_exposure = FALSE
				if(C.body_parts_covered & LOWER_TORSO)
					groin_exposure = FALSE
				if(C.body_parts_covered & LEGS)
					legs_exposure = FALSE
				if(C.body_parts_covered & ARMS)
					arms_exposure = FALSE

		H.apply_damage(damage*1.0*head_exposure, BURN, "head", FALSE, FALSE, "Fire")
		H.apply_damage(damage*0.8*chest_exposure, BURN, "chest", FALSE, FALSE, "Fire")
		H.apply_damage(damage*0.8*groin_exposure, BURN, "groin", FALSE, FALSE, "Fire")
		H.apply_damage(damage*0.2*legs_exposure, BURN, "l_leg", FALSE, FALSE, "Fire")
		H.apply_damage(damage*0.2*legs_exposure, BURN, "r_leg", FALSE, FALSE, "Fire")
		H.apply_damage(damage*0.15*arms_exposure, BURN, "l_arm", FALSE, FALSE, "Fire")
		H.apply_damage(damage*0.15*arms_exposure, BURN, "r_arm", FALSE, FALSE, "Fire")