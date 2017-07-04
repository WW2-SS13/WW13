// New version of fire that doesn't require ZAS. Mostly copypasta - Kachnov

//#define FIREDBG

/obj/fire

	anchored = 1
	mouse_opacity = 0

	blend_mode = BLEND_ADD

	icon = 'icons/effects/fire.dmi'
	icon_state = "1"
	light_color = "#ED9200"
	layer = TURF_LAYER

	var/firelevel = 1
	var/default_damage = 6 // 10 was really fucking overpowered if you crossed it a lot
	var/spread_range = 1
	var/spread_prob = 10
	var/spread_fuel_prob = 80
	var/temperature = 500
	var/default_temperature = 500

	var/time_limit = 4

	var/ticks = 0

/obj/fire/process()
	. = 1

	var/turf/simulated/my_tile = loc
	if(!istype(my_tile))
		if(my_tile.fire == src)
			my_tile.fire = null
			RemoveFire()
		return 1

	if(firelevel > 6)
		icon_state = "3"
		set_light(7, 3)
	else if(firelevel > 2.5)
		icon_state = "2"
		set_light(5, 2)
	else
		icon_state = "1"
		set_light(3, 1)

	for(var/mob/m in loc)
		Burn(m)

	//loc.fire_act(air_contents, air_contents.temperature, air_contents.volume)

//	for(var/atom/A in loc)
	//	A.fire_act(air_contents, air_contents.temperature, air_contents.volume)

	//spread
	for(var/direction in cardinal)
		var/turf/simulated/enemy_tile = get_step(my_tile, direction)

		if(istype(enemy_tile))
			if(my_tile.open_directions & direction) //Grab all valid bordering tiles
				if(enemy_tile.fire)
					continue

				//if(!enemy_tile.zone.fire_tiles.len) TODO - optimize
				var/datum/gas_mixture/acs = enemy_tile.return_air()
				var/obj/effect/decal/cleanable/liquid_fuel/liquid = locate() in enemy_tile
				if(!acs || !acs.check_combustability(liquid))
					continue

				//If extinguisher mist passed over the turf it's trying to spread to, don't spread and
				//reduce firelevel.

				if(enemy_tile.fire_protection > world.time-30)
					firelevel -= 1.5
					continue

				//Spread the fire.

				if(prob( 50 + 50 * (firelevel/vsc.fire_firelevel_multiplier) ) && my_tile.CanPass(null, enemy_tile, 0,0) && enemy_tile.CanPass(null, my_tile, 0,0))
					enemy_tile.create_fire(firelevel)

		//	else
			//	enemy_tile.adjacent_fire_act(loc, air_contents, air_contents.temperature, air_contents.volume)

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

	var/datum/gas_mixture/air_contents = loc.return_air()
	color = fire_color(air_contents.temperature)
	set_light(3, 1, color)

	firelevel = fl

	processing_objects += src

/obj/fire/proc/fire_color(var/env_temperature)
	var/temperature = max(4000*sqrt(firelevel/vsc.fire_firelevel_multiplier), env_temperature)
	return heat2color(temperature)

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


/obj/fire/proc/Burn(var/mob/m)
	if (!istype(m, /mob/living))
		return
	else
		var/mob/living/l = m
		l.fire_act()

		if (!istype(m, /mob/living/carbon/human))
			var/mob/living/L = m
			L.apply_damage(get_damage(), BURN)
		else
			var/mob/living/carbon/human/H = m

			var/damage = get_damage()

			var/head_exposure = 1
			var/chest_exposure = 1
			var/groin_exposure = 1
			var/legs_exposure = 1
			var/arms_exposure = 1

			//Get heat transfer coefficients for clothing.

			for(var/obj/item/clothing/C in src)
				if(H.l_hand == C || H.r_hand == C)
					continue

				if( C.max_heat_protection_temperature >= temperature )
					if(C.body_parts_covered & HEAD)
						head_exposure = 0
					if(C.body_parts_covered & UPPER_TORSO)
						chest_exposure = 0
					if(C.body_parts_covered & LOWER_TORSO)
						groin_exposure = 0
					if(C.body_parts_covered & LEGS)
						legs_exposure = 0
					if(C.body_parts_covered & ARMS)
						arms_exposure = 0

			H.apply_damage(damage*1.0*head_exposure, BURN, "head", 0, 0, "Fire")
			H.apply_damage(damage*0.8*chest_exposure, BURN, "chest", 0, 0, "Fire")
			H.apply_damage(damage*0.8*groin_exposure, BURN, "groin", 0, 0, "Fire")
			H.apply_damage(damage*0.2*legs_exposure, BURN, "l_leg", 0, 0, "Fire")
			H.apply_damage(damage*0.2*legs_exposure, BURN, "r_leg", 0, 0, "Fire")
			H.apply_damage(damage*0.15*arms_exposure, BURN, "l_arm", 0, 0, "Fire")
			H.apply_damage(damage*0.15*arms_exposure, BURN, "r_arm", 0, 0, "Fire")
/*
/mob/living/proc/FireBurn(var/firelevel, var/last_temperature, var/pressure)
	var/mx = 5 * firelevel/vsc.fire_firelevel_multiplier * min(pressure / ONE_ATMOSPHERE, 1)
	apply_damage(2.5*mx, BURN)

/mob/living/carbon/human/FireBurn(var/firelevel, var/last_temperature, var/pressure)
	//Burns mobs due to fire. Respects heat transfer coefficients on various body parts.
	//Due to TG reworking how fireprotection works, this is kinda less meaningful.

	var/head_exposure = 1
	var/chest_exposure = 1
	var/groin_exposure = 1
	var/legs_exposure = 1
	var/arms_exposure = 1

	//Get heat transfer coefficients for clothing.

	for(var/obj/item/clothing/C in src)
		if(l_hand == C || r_hand == C)
			continue

		if( C.max_heat_protection_temperature >= last_temperature )
			if(C.body_parts_covered & HEAD)
				head_exposure = 0
			if(C.body_parts_covered & UPPER_TORSO)
				chest_exposure = 0
			if(C.body_parts_covered & LOWER_TORSO)
				groin_exposure = 0
			if(C.body_parts_covered & LEGS)
				legs_exposure = 0
			if(C.body_parts_covered & ARMS)
				arms_exposure = 0
	//minimize this for low-pressure enviroments
	var/mx = 5 * firelevel/vsc.fire_firelevel_multiplier * min(pressure / ONE_ATMOSPHERE, 1)

	//Always check these damage procs first if fire damage isn't working. They're probably what's wrong.

	apply_damage(2.5*mx*head_exposure, BURN, "head", 0, 0, "Fire")
	apply_damage(2.5*mx*chest_exposure, BURN, "chest", 0, 0, "Fire")
	apply_damage(2.0*mx*groin_exposure, BURN, "groin", 0, 0, "Fire")
	apply_damage(0.6*mx*legs_exposure, BURN, "l_leg", 0, 0, "Fire")
	apply_damage(0.6*mx*legs_exposure, BURN, "r_leg", 0, 0, "Fire")
	apply_damage(0.4*mx*arms_exposure, BURN, "l_arm", 0, 0, "Fire")
	apply_damage(0.4*mx*arms_exposure, BURN, "r_arm", 0, 0, "Fire")
*/