//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

//NOTE: Breathing happens once per FOUR TICKS, unless the last breath fails. In which case it happens once per ONE TICK! So oxyloss healing is done once per 4 ticks while oxyloss damage is applied once per tick!
#define HUMAN_MAX_OXYLOSS TRUE //Defines how much oxyloss humans can get per tick. A tile with no air at all (such as space) applies this value, otherwise it's a percentage of it.
#define HUMAN_CRIT_MAX_OXYLOSS ( 2.0 / 6) //The amount of damage you'll get when in critical condition. We want this to be a 5 minute deal = 300s. There are 50HP to get through, so (1/6)*last_tick_duration per second. Breaths however only happen every 4 ticks. last_tick_duration = ~2.0 on average

#define HEAT_DAMAGE_LEVEL_1 2 //Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 4 //Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 8 //Amount of damage applied when your body temperature passes the 1000K point

#define COLD_DAMAGE_LEVEL_1 2 //Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_2 4 //Amount of damage applied when your body temperature passes the 200K point
#define COLD_DAMAGE_LEVEL_3 8 //Amount of damage applied when your body temperature passes the 120K point
/*
//Note that gas heat damage is only applied once every FOUR ticks.
#define HEAT_GAS_DAMAGE_LEVEL_1 2 //Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_2 4 //Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_3 8 //Amount of damage applied when the current breath's temperature passes the 1000K point

#define COLD_GAS_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_3 3 //Amount of damage applied when the current breath's temperature passes the 120K point
*/


//#define RADIATION_SPEED_COEFFICIENT 0.1

/mob/living/carbon/human
	var/oxygen_alert = FALSE
	var/plasma_alert = FALSE
	var/co2_alert = FALSE
	var/fire_alert = FALSE
	var/pressure_alert = FALSE
	var/temperature_alert = FALSE
	var/in_stasis = FALSE
	var/heartbeat = FALSE
	var/global/list/overlays_cache = null

/mob/living/carbon/human/var/next_weather_sound = -1
/mob/living/carbon/human/Life()
	set invisibility = FALSE
	set background = BACKGROUND_ENABLED

	if (client)
		if (world.timeofday >= next_weather_sound)
			var/area/A = get_area(src)
			if (A.weather == WEATHER_RAIN)
				src << sound('sound/ambience/rain.ogg', channel = 777)
				next_weather_sound = world.timeofday + 1500
		else
			var/area/A = get_area(src)
			if (A.weather == WEATHER_NONE)
				src << sound(null, channel = 777)
				next_weather_sound = world.timeofday

	handle_zoom_stuff()

	if (transforming)
		return

	if (stat == UNCONSCIOUS || stat == DEAD || lying)
		if (istype(back, /obj/item/weapon/storage/backpack/flammenwerfer))
			var/obj/item/weapon/storage/backpack/flammenwerfer/flamethrower_backpack = back
			if (flamethrower_backpack.flamethrower && flamethrower_backpack.flamethrower.loc != flamethrower_backpack)
				flamethrower_backpack.reclaim_flamethrower()

	fire_alert = FALSE //Reset this here, because both breathe() and handle_environment() have a chance to set it.

	//TODO: seperate this out
	// update the current life tick, can be used to e.g. only do something every 4 ticks
	life_tick++

	// handle nutrition stuff before we handle stomach stuff in the callback

	var/nutrition_water_loss_multiplier = mob_process.schedule_interval/20

	switch (stat)
		if (CONSCIOUS) // takes about 1333 ticks to start starving, or ~44 minutes
			nutrition -= (0.30/getStatCoeff("survival")) * nutrition_water_loss_multiplier
			water -= (0.30/getStatCoeff("survival")) * nutrition_water_loss_multiplier
		if (UNCONSCIOUS) // takes over an hour to starve
			nutrition -= (0.20/getStatCoeff("survival")) * nutrition_water_loss_multiplier
			water -= (0.20/getStatCoeff("survival")) * nutrition_water_loss_multiplier

	if (stamina == max_stamina-1 && m_intent == "walk")
		src << "<span class = 'good'>You feel like you can run for a while.</span>"

	nutrition = min(nutrition, max_nutrition)
	nutrition = max(nutrition, -max_nutrition)

	water = min(water, max_water)
	water = max(water, -max_water)

	..()

	stamina = min(stamina + rand(2,3), max_stamina)

	if(life_tick%30==15)
		hud_updateflag = 1022

	voice = GetVoice()

	//No need to update all of these procs if the guy is dead.
	if(stat != DEAD && !in_stasis)
		//Organs and blood
		handle_organs()

		handle_blood()

		adjust_body_temperature()
		stabilize_body_temperature()

		handle_shock()

		handle_pain()

		handle_medical_side_effects()

		if (original_job && base_faction)
			faction_hud_users |= src
			process_faction_hud(src)

		if(!client)
			species.handle_npc(src)

	if(!handle_some_updates())
		return											//We go ahead and process them 5 times for HUD images and other stuff though.

	//Update our name based on whether our face is obscured/disfigured
	name = get_visible_name()

/mob/living/carbon/human/proc/handle_some_updates()
	if(life_tick > 5 && timeofdeath && (timeofdeath < 5 || world.time - timeofdeath > 6000))	//We are long dead, or we're junk mobs spawned like the clowns on the clown shuttle
		return FALSE
	return TRUE

/mob/living/carbon/human/breathe()
	if(!in_stasis)
		..()

/mob/living/carbon/human/handle_disabilities()
	..()
	//Vision
	var/obj/item/organ/vision
	if(species.vision_organ)
		vision = internal_organs_by_name[species.vision_organ]

	if(!species.vision_organ) // Presumably if a species has no vision organs, they see via some other means.
		eye_blind =  FALSE
		blinded =    FALSE
		eye_blurry = FALSE
	else if(!vision || (vision && vision.is_broken()))   // Vision organs cut out or broken? Permablind.
		eye_blind =  TRUE
		blinded =    TRUE
		eye_blurry = TRUE
	else
		//blindness
		if(!(sdisabilities & BLIND))
			if(equipment_tint_total >= TINT_BLIND)	// Covered eyes, heal faster
				eye_blurry = max(eye_blurry-2, FALSE)

	if (disabilities & EPILEPSY)
		if ((prob(1) && paralysis < TRUE))
			src << "\red You have a seizure!"
			for(var/mob/O in viewers(src, null))
				if(O == src)
					continue
				O.show_message(text("<span class='danger'>[src] starts having a seizure!</span>"), TRUE)
			Paralyse(10)
			make_jittery(1000)
	if (disabilities & COUGHING)
		if ((prob(5) && paralysis <= TRUE))
			drop_item()
			spawn( FALSE )
				emote("cough")
				return
	if (disabilities & TOURETTES)
		speech_problem_flag = TRUE
		if ((prob(10) && paralysis <= TRUE))
			Stun(10)
			spawn( FALSE )
				switch(rand(1, 3))
					if(1)
						emote("twitch")
					if(2 to 3)
						say("[prob(50) ? ";" : ""][pick("SHIT", "PISS", "FUCK", "CUNT", "COCKSUCKER", "MOTHERFUCKER", "TITS")]")
				make_jittery(100)
				return
	if (disabilities & NERVOUS)
		speech_problem_flag = TRUE
		if (prob(10))
			stuttering = max(10, stuttering)

	if(stat != DEAD)
		var/rn = rand(0, 200)
		if(getBrainLoss() >= 5)
			if(0 <= rn && rn <= 3)
				custom_pain("Your head feels numb and painful.")
		if(getBrainLoss() >= 15)
			if(4 <= rn && rn <= 6) if(eye_blurry <= FALSE)
				src << "<span class='warning'>It becomes hard to see for some reason.</span>"
				eye_blurry = 10
		if(getBrainLoss() >= 35)
			if(7 <= rn && rn <= 9) if(get_active_hand())
				src << "<span class='danger'>Your hand won't respond properly, you drop what you're holding!</span>"
				drop_item()
		if(getBrainLoss() >= 45)
			if(10 <= rn && rn <= 12)
				if(prob(50))
					src << "<span class='danger'>You suddenly black out!</span>"
					Paralyse(10)
				else if(!lying)
					src << "<span class='danger'>Your legs won't respond properly, you fall down!</span>"
					Weaken(10)


/*
/mob/living/carbon/human/handle_mutations_and_radiation()
	return*/

	/** breathing **/

/mob/living/carbon/human/handle_chemical_smoke(var/datum/gas_mixture/environment)
	if(wear_mask && (wear_mask.item_flags & BLOCK_GAS_SMOKE_EFFECT))
		return
	if(glasses && (glasses.item_flags & BLOCK_GAS_SMOKE_EFFECT))
		return
	if(head && (head.item_flags & BLOCK_GAS_SMOKE_EFFECT))
		return
	..()

/mob/living/carbon/human/get_breath_from_internal(volume_needed=BREATH_VOLUME)
	if(internal)

		var/obj/item/weapon/tank/rig_supply

		if (!rig_supply && (!contents.Find(internal) || !((wear_mask && (wear_mask.item_flags & AIRTIGHT)) || (head && (head.item_flags & AIRTIGHT)))))
			internal = null

		if(internal)
			return internal.remove_air_volume(volume_needed)
		else if(HUDneed.Find("internal"))
			var/obj/screen/HUDelm = HUDneed["internal"]
			HUDelm.icon_state = "internal0"
/*		else if(internals)
			internals.icon_state = "internal0"*/
	return null

/mob/living/carbon/human/handle_breath(datum/gas_mixture/breath)
	if(status_flags & GODMODE)
		return

	//check if we actually need to process breath
	if(!breath)
		failed_last_breath = TRUE
		if(prob(20))
			emote("gasp")
		if(health > config.health_threshold_crit)
			adjustOxyLoss(HUMAN_MAX_OXYLOSS)
		else
			adjustOxyLoss(HUMAN_CRIT_MAX_OXYLOSS)

		oxygen_alert = max(oxygen_alert, TRUE)
		return FALSE
	var/obj/item/organ/lungs/L = internal_organs_by_name["lungs"]
	if(L && L.handle_breath(breath))
		failed_last_breath = FALSE
	else
		failed_last_breath = TRUE
	return TRUE

/mob/living/carbon/human/var/loc_temperature = -1 // for debugging.
/mob/living/carbon/human/handle_environment()

	//Stuff like the xenomorph's plasma regen happens here.
	species.handle_environment_special(src)

	//Moved pressure calculations here for use in skip-processing check.
//	var/pressure = NORMAL_PRESSURE
	var/loc_temp = 293
	var/area/mob_area = get_area(src)

	if (mob_area.location == AREA_OUTSIDE)

		var/game_season = "SPRING"
		if (ticker.mode.vars.Find("season"))
			game_season = ticker.mode:season

		switch (game_season)
			if ("WINTER")
				loc_temp = 264 - 20
			if ("FALL")
				loc_temp = 285
			if ("SUMMER")
				loc_temp = 303

		switch (time_of_day)
			if ("Midday")
				loc_temp *= 1.03
			if ("Afternoon")
				loc_temp *= 1.02
			if ("Morning")
				loc_temp *= 1.01
			if ("Evening")
				loc_temp *= 1.00 // default
			if ("Early Morning")
				loc_temp *= 0.99
			if ("Night")
				loc_temp *= 0.98
			if ("Midnight")
				loc_temp *= 0.97

		switch (mob_area.weather)
			if (WEATHER_NONE)
				loc_temp *= 1.00
			if (WEATHER_SNOW)
				switch (mob_area.weather_intensity)
					if (1.0)
						loc_temp *= 0.97
					if (2.0)
						loc_temp *= 0.96
					if (3.0)
						loc_temp *= 0.95
			if (WEATHER_RAIN)
				switch (mob_area.weather_intensity)
					if (1.0)
						loc_temp *= 0.99
					if (2.0)
						loc_temp *= 0.985
					if (3.0)
						loc_temp *= 0.98

		loc_temp = round(loc_temp)

	for (var/obj/snow/S in get_turf(src))
		loc_temp -= (S.amount * 20)

	loc_temperature = loc_temp

	// todo: wind adjusting effective loc_temp

	if(abs(loc_temp - bodytemperature) < 0.5 && bodytemperature < species.heat_level_1 && bodytemperature > species.cold_level_1)
		return // Temperatures are within normal ranges, fuck all this processing. ~Ccomp

	//Body temperature adjusts depending on surrounding atmosphere based on your thermal protection (convection)
	var/temp_adj = FALSE
	if(loc_temp < bodytemperature)			//Place is colder than we are
		var/thermal_protection = get_cold_protection(loc_temp) //This returns a FALSE - TRUE value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
		if(thermal_protection < TRUE)
			temp_adj = (1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_COLD_DIVISOR)	//this will be negative
	else if (loc_temp > bodytemperature)			//Place is hotter than we are
		var/thermal_protection = get_heat_protection(loc_temp) //This returns a FALSE - TRUE value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
		if(thermal_protection < TRUE)
			temp_adj = (1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_HEAT_DIVISOR)

	//Use heat transfer as proportional to the gas density. However, we only care about the relative density vs standard 101 kPa/20 C air. Therefore we can use mole ratios
//	var/relative_density = environment.total_moles / MOLES_CELLSTANDARD
	var/relative_density = 1.0
	bodytemperature += between(BODYTEMP_COOLING_MAX, temp_adj*relative_density, BODYTEMP_HEATING_MAX)
	// +/- 50 degrees from 310.15K is the 'safe' zone, where no damage is dealt.
	if(bodytemperature >= species.heat_level_1)
		//Body temperature is too hot.
		fire_alert = max(fire_alert, TRUE)
		if(status_flags & GODMODE)	return TRUE	//godmode
		var/burn_dam = FALSE
		switch(bodytemperature)
			if(species.heat_level_1 to species.heat_level_2)
				burn_dam = HEAT_DAMAGE_LEVEL_1
			if(species.heat_level_2 to species.heat_level_3)
				burn_dam = HEAT_DAMAGE_LEVEL_2
			if(species.heat_level_3 to INFINITY)
				burn_dam = HEAT_DAMAGE_LEVEL_3
		take_overall_damage(burn=burn_dam, used_weapon = "High Body Temperature")
		fire_alert = max(fire_alert, 2)

	else if(bodytemperature <= species.cold_level_1)
		fire_alert = max(fire_alert, TRUE)
		if(status_flags & GODMODE)	return TRUE	//godmode

		if(!istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
			var/burn_dam = FALSE
			switch(bodytemperature)
				if(-INFINITY to species.cold_level_3)
					burn_dam = COLD_DAMAGE_LEVEL_3
				if(species.cold_level_3 to species.cold_level_2)
					burn_dam = COLD_DAMAGE_LEVEL_2
				if(species.cold_level_2 to species.cold_level_1)
					burn_dam = COLD_DAMAGE_LEVEL_1
			take_overall_damage(burn=burn_dam, used_weapon = "Low Body Temperature")
			fire_alert = max(fire_alert, TRUE)

	// tell src they're dying
	species.get_environment_discomfort(src, "cold")
	species.get_environment_discomfort(src, "heat")

	// Account for massive pressure differences.  Done by Polymorph
	// Made it possible to actually have something that can protect against high pressure... Done by Errorage. Polymorph now has an axe sticking from his head for his previous hardcoded nonsense!
	if(status_flags & GODMODE)	return TRUE	//godmode

	return

/mob/living/carbon/human/proc/adjust_body_temperature(current, loc_temp, boost)
	var/temperature = current
	var/difference = abs(current-loc_temp)	//get difference
	var/increments// = difference/10			//find how many increments apart they are
	if(difference > 50)
		increments = difference/50
	else
		increments = difference/100
	var/change = increments*boost	// Get the amount to change by (x per increment)
	var/temp_change
	if(current < loc_temp)
		temperature = min(loc_temp, temperature+change)
	else if(current > loc_temp)
		temperature = max(loc_temp, temperature-change)
	temp_change = (temperature - current)
	return temp_change


/mob/living/carbon/human/proc/stabilize_body_temperature()
	if (species.passive_temp_gain) // We produce heat naturally.
		bodytemperature += species.passive_temp_gain
	if (species.body_temperature == null)
		return //this species doesn't have metabolic thermoregulation

	var/body_temperature_difference = species.body_temperature - bodytemperature

	if (abs(body_temperature_difference) < 0.5)
		return //fuck this precision
	if (on_fire)
		return //too busy for pesky metabolic regulation

	if(bodytemperature < species.cold_level_1) //260.15 is 310.15 - 50, the temperature where you start to feel effects.
		if(nutrition >= 2) //If we are very, very cold we'll use up quite a bit of nutriment to heat us up.
			nutrition -= 0.5
		var/recovery_amt = max((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), BODYTEMP_AUTORECOVERY_MINIMUM)
		//world << "Cold. Difference = [body_temperature_difference]. Recovering [recovery_amt]"
//				log_debug("Cold. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
		bodytemperature += recovery_amt
	else if(species.cold_level_1 <= bodytemperature && bodytemperature <= species.heat_level_1)
		var/recovery_amt = body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR
		//world << "Norm. Difference = [body_temperature_difference]. Recovering [recovery_amt]"
//				log_debug("Norm. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
		bodytemperature += recovery_amt
	else if(bodytemperature > species.heat_level_1) //360.15 is 310.15 + 50, the temperature where you start to feel effects.
		//We totally need a sweat system cause it totally makes sense...~
		var/recovery_amt = min((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), -BODYTEMP_AUTORECOVERY_MINIMUM)	//We're dealing with negative numbers
		//world << "Hot. Difference = [body_temperature_difference]. Recovering [recovery_amt]"
//				log_debug("Hot. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
		bodytemperature += recovery_amt


//This proc returns a number made up of the flags for body parts which you are protected on. (such as HEAD, UPPER_TORSO, LOWER_TORSO, etc. See setup.dm for the full list)
/mob/living/carbon/human/proc/get_heat_protection_flags(temperature) //Temperature is the temperature you're being exposed to.
	. = FALSE
	//Handle normal clothing
	for(var/obj/item/clothing/C in list(head,wear_suit,w_uniform,shoes,gloves,wear_mask))
		if(C)
			if(C.max_heat_protection_temperature && C.max_heat_protection_temperature >= temperature)
				. |= C.heat_protection

//See proc/get_heat_protection_flags(temperature) for the description of this proc.
/mob/living/carbon/human/proc/get_cold_protection_flags(temperature)
	. = FALSE
	//Handle normal clothing
	for(var/obj/item/clothing/C in list(head,wear_suit,w_uniform,shoes,gloves,wear_mask))
		if(C)
			if(C.min_cold_protection_temperature && C.min_cold_protection_temperature <= temperature)
				. |= C.cold_protection

/mob/living/carbon/human/get_heat_protection(temperature) //Temperature is the temperature you're being exposed to.
	var/thermal_protection_flags = get_heat_protection_flags(temperature)
	return get_thermal_protection(thermal_protection_flags)

/mob/living/carbon/human/get_cold_protection(temperature)
	if(COLD_RESISTANCE in mutations)
		return TRUE //Fully protected from the cold.

	temperature = max(temperature, 2.7) //There is an occasional bug where the temperature is miscalculated in ares with a small amount of gas on them, so this is necessary to ensure that that bug does not affect this calculation. Space's temperature is 2.7K and most suits that are intended to protect against any cold, protect down to 2.0K.
	var/thermal_protection_flags = get_cold_protection_flags(temperature)
	return get_thermal_protection(thermal_protection_flags)

/mob/living/carbon/human/proc/get_thermal_protection(var/flags)
	.=0
	if(flags)
		if(flags & HEAD)
			. += THERMAL_PROTECTION_HEAD
		if(flags & UPPER_TORSO)
			. += THERMAL_PROTECTION_UPPER_TORSO
		if(flags & LOWER_TORSO)
			. += THERMAL_PROTECTION_LOWER_TORSO
		if(flags & LEG_LEFT)
			. += THERMAL_PROTECTION_LEG_LEFT
		if(flags & LEG_RIGHT)
			. += THERMAL_PROTECTION_LEG_RIGHT
		if(flags & FOOT_LEFT)
			. += THERMAL_PROTECTION_FOOT_LEFT
		if(flags & FOOT_RIGHT)
			. += THERMAL_PROTECTION_FOOT_RIGHT
		if(flags & ARM_LEFT)
			. += THERMAL_PROTECTION_ARM_LEFT
		if(flags & ARM_RIGHT)
			. += THERMAL_PROTECTION_ARM_RIGHT
		if(flags & HAND_LEFT)
			. += THERMAL_PROTECTION_HAND_LEFT
		if(flags & HAND_RIGHT)
			. += THERMAL_PROTECTION_HAND_RIGHT
	return min(1,.)

/mob/living/carbon/human/handle_chemicals_in_body()
	if(in_stasis)
		return

	if(reagents)
		chem_effects.Cut()
		analgesic = FALSE

		if(touching) touching.metabolize()
		if(ingested) ingested.metabolize()
		if(bloodstr) bloodstr.metabolize()

		if(CE_PAINKILLER in chem_effects)
			analgesic = chem_effects[CE_PAINKILLER]

		var/total_plasmaloss = FALSE
	/*	for(var/obj/item/I in src)
			if(I.contaminated)
				total_plasmaloss += vsc.plc.CONTAMINATION_LOSS*/
		if(!(status_flags & GODMODE)) adjustToxLoss(total_plasmaloss)

	if(status_flags & GODMODE)	return FALSE	//godmode

	if(species.light_dam)
		var/light_amount = FALSE
		if(isturf(loc))
			var/turf/T = loc
			light_amount = round((T.get_lumcount()*10)-5)

		if(light_amount > species.light_dam) //if there's enough light, start dying
			take_overall_damage(1,1)
		else //heal in the dark
			heal_overall_damage(1,1)
/*
	// nutrition decrease
	if (nutrition > FALSE && stat != 2)
		nutrition = max (0, nutrition - species.hunger_factor)*/

	// TODO: stomach and bloodstream organ.
	handle_trace_chems()

	updatehealth()

	return //TODO: DEFERRED

/mob/living/carbon/human/handle_regular_status_updates()
	if(!handle_some_updates())
		return FALSE

	if(status_flags & GODMODE)	return FALSE

	//SSD check, if a logged player is awake put them back to sleep!
	if(species.show_ssd && !client && !teleop)
		Sleeping(2)
	if(stat == DEAD)	//DEAD. BROWN BREAD. SWIMMING WITH THE SPESS CARP
		blinded = TRUE
		silent = FALSE
	else				//ALIVE. LIGHTS ARE ON
		updatehealth()	//TODO

		if(health <= config.health_threshold_dead || (species.has_organ["brain"] && !has_brain()))
			death()
			blinded = TRUE
			silent = FALSE
			return TRUE

		//UNCONSCIOUS. NO-ONE IS HOME
		if((getOxyLoss() > (species.total_health/2)) || (health <= config.health_threshold_crit))
			Paralyse(3)


		if(paralysis || sleeping)
			blinded = TRUE
			stat = UNCONSCIOUS
			animate_tail_reset()
			adjustHalLoss(-3)

		if(paralysis)
			AdjustParalysis(-1)

		else if(sleeping)
			speech_problem_flag = TRUE
			handle_dreams()
			if (mind)
				//Are they SSD? If so we'll keep them asleep but work off some of that sleep var in case of stoxin or similar.
				if(client || sleeping > 3)
					AdjustSleeping(-1)
			if( prob(2) && health)
				spawn(0)
					emote("snore")
		//CONSCIOUS
		else
			stat = CONSCIOUS

		// Check everything else.

		//Periodically double-check embedded_flag
		if(embedded_flag && !(life_tick % 10))
			if(!embedded_needs_process())
				embedded_flag = FALSE

		//Ears
		if(sdisabilities & DEAF)	//disabled-deaf, doesn't get better on its own
			ear_deaf = max(ear_deaf, TRUE)
		else if(ear_deaf)			//deafness, heals slowly over time
			ear_deaf = max(ear_deaf-1, FALSE)
		else if(istype(l_ear, /obj/item/clothing/ears/earmuffs) || istype(r_ear, /obj/item/clothing/ears/earmuffs))	//resting your ears with earmuffs heals ear damage faster
			ear_damage = max(ear_damage-0.15, FALSE)
			ear_deaf = max(ear_deaf, TRUE)
		else if(ear_damage < 25)	//ear damage heals slowly under this threshold. otherwise you'll need earmuffs
			ear_damage = max(ear_damage-0.05, FALSE)

		//Resting
		if(resting)
			dizziness = max(0, dizziness - 15)
			jitteriness = max(0, jitteriness - 15)
			adjustHalLoss(-3)
		else
			dizziness = max(0, dizziness - 3)
			jitteriness = max(0, jitteriness - 3)
			adjustHalLoss(-1)

		//Other
		handle_statuses()

		if (drowsyness)
			drowsyness--
			eye_blurry = max(2, eye_blurry)
			if (prob(5))
				sleeping += TRUE
				Paralyse(5)

		confused = max(0, confused - TRUE)

		// If you're dirty, your gloves will become dirty, too.
		if(gloves && germ_level > gloves.germ_level && prob(10))
			gloves.germ_level += TRUE

	return TRUE

/mob/living/carbon/human/handle_regular_hud_updates()
	for (var/obj/screen/H in HUDprocess)
//		var/obj/screen/B = H
		H.process()
	if(!overlays_cache)
		overlays_cache = list()
		overlays_cache.len = 23
		overlays_cache[1] = image('icons/mob/screen1_full.dmi', "icon_state" = "passage1")
		overlays_cache[2] = image('icons/mob/screen1_full.dmi', "icon_state" = "passage2")
		overlays_cache[3] = image('icons/mob/screen1_full.dmi', "icon_state" = "passage3")
		overlays_cache[4] = image('icons/mob/screen1_full.dmi', "icon_state" = "passage4")
		overlays_cache[5] = image('icons/mob/screen1_full.dmi', "icon_state" = "passage5")
		overlays_cache[6] = image('icons/mob/screen1_full.dmi', "icon_state" = "passage6")
		overlays_cache[7] = image('icons/mob/screen1_full.dmi', "icon_state" = "passage7")
		overlays_cache[8] = image('icons/mob/screen1_full.dmi', "icon_state" = "passage8")
		overlays_cache[9] = image('icons/mob/screen1_full.dmi', "icon_state" = "passage9")
		overlays_cache[10] = image('icons/mob/screen1_full.dmi', "icon_state" = "passage10")
		overlays_cache[11] = image('icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay1")
		overlays_cache[12] = image('icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay2")
		overlays_cache[13] = image('icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay3")
		overlays_cache[14] = image('icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay4")
		overlays_cache[15] = image('icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay5")
		overlays_cache[16] = image('icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay6")
		overlays_cache[17] = image('icons/mob/screen1_full.dmi', "icon_state" = "oxydamageoverlay7")
		overlays_cache[18] = image('icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay1")
		overlays_cache[19] = image('icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay2")
		overlays_cache[20] = image('icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay3")
		overlays_cache[21] = image('icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay4")
		overlays_cache[22] = image('icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay5")
		overlays_cache[23] = image('icons/mob/screen1_full.dmi', "icon_state" = "brutedamageoverlay6")

	if(hud_updateflag || never_updated_hud_list) // update our mob's hud overlays, AKA what others see flaoting above our head
		handle_hud_list()

	// now handle what we see on our screen

	if(!..())
		return

//	if(damageoverlay.overlays)
//		damageoverlay.overlays = list()

/*	if(stat == UNCONSCIOUS)
		//Critical damage passage overlay
		if(health <= FALSE)
			var/image/I
			switch(health)
				if(-20 to -10)
					I = overlays_cache[1]
				if(-30 to -20)
					I = overlays_cache[2]
				if(-40 to -30)
					I = overlays_cache[3]
				if(-50 to -40)
					I = overlays_cache[4]
				if(-60 to -50)
					I = overlays_cache[5]
				if(-70 to -60)
					I = overlays_cache[6]
				if(-80 to -70)
					I = overlays_cache[7]
				if(-90 to -80)
					I = overlays_cache[8]
				if(-95 to -90)
					I = overlays_cache[9]
				if(-INFINITY to -95)
					I = overlays_cache[10]
			damageoverlay.overlays += I
	else
		//Oxygen damage overlay
		if(oxyloss)
			var/image/I
			switch(oxyloss)
				if(10 to 20)
					I = overlays_cache[11]
				if(20 to 25)
					I = overlays_cache[12]
				if(25 to 30)
					I = overlays_cache[13]
				if(30 to 35)
					I = overlays_cache[14]
				if(35 to 40)
					I = overlays_cache[15]
				if(40 to 45)
					I = overlays_cache[16]
				if(45 to INFINITY)
					I = overlays_cache[17]
			damageoverlay.overlays += I

		//Fire and Brute damage overlay (BSSR)
		var/hurtdamage = getBruteLoss() + getFireLoss() + damageoverlaytemp
		damageoverlaytemp = FALSE // We do this so we can detect if someone hits us or not.
		if(hurtdamage)
			var/image/I
			switch(hurtdamage)
				if(10 to 25)
					I = overlays_cache[18]
				if(25 to 40)
					I = overlays_cache[19]
				if(40 to 55)
					I = overlays_cache[20]
				if(55 to 70)
					I = overlays_cache[21]
				if(70 to 85)
					I = overlays_cache[22]
				if(85 to INFINITY)
					I = overlays_cache[23]
			damageoverlay.overlays += I*/

/*		if(healths  && stat != DEAD) // They are dead, let death() handle their hud update on this.
			if (analgesic > 100)
				healths.icon_state = "health_numb"
			else
				switch(hal_screwyhud)
					if(1)	healths.icon_state = "health6"
					if(2)	healths.icon_state = "health7"
					else
						//switch(health - halloss)
						switch(100 - ((species.flags & NO_PAIN) ? FALSE : traumatic_shock))
							if(100 to INFINITY)		healths.icon_state = "health0"
							if(80 to 100)			healths.icon_state = "health1"
							if(60 to 80)			healths.icon_state = "health2"
							if(40 to 60)			healths.icon_state = "health3"
							if(20 to 40)			healths.icon_state = "health4"
							if(0 to 20)				healths.icon_state = "health5"
							else					healths.icon_state = "health6"

		if(nutrition_icon)
			switch(nutrition)
				if(450 to INFINITY)				nutrition_icon.icon_state = "nutrition0"
				if(350 to 450)					nutrition_icon.icon_state = "nutrition1"
				if(250 to 350)					nutrition_icon.icon_state = "nutrition2"
				if(150 to 250)					nutrition_icon.icon_state = "nutrition3"
				else							nutrition_icon.icon_state = "nutrition4"

		if(pressure)
			pressure.icon_state = "pressure[pressure_alert]"

//			if(rest)	//Not used with new UI
//				if(resting || lying || sleeping)		rest.icon_state = "rest1"
//				else									rest.icon_state = "rest0"
		if(toxin)
			if(hal_screwyhud == 4 || plasma_alert)	toxin.icon_state = "tox1"
			else									toxin.icon_state = "tox0"
		if(oxygen)
			if(hal_screwyhud == 3 || oxygen_alert)	oxygen.icon_state = "oxy1"
			else									oxygen.icon_state = "oxy0"
		if(fire)
			if(fire_alert)							fire.icon_state = "fire[fire_alert]" //fire_alert is either FALSE if no alert, TRUE for cold and 2 for heat.
			else									fire.icon_state = "fire0"

		if(bodytemp)
			if (!species)
				switch(bodytemperature) //310.055 optimal body temp
					if(370 to INFINITY)		bodytemp.icon_state = "temp4"
					if(350 to 370)			bodytemp.icon_state = "temp3"
					if(335 to 350)			bodytemp.icon_state = "temp2"
					if(320 to 335)			bodytemp.icon_state = "temp1"
					if(300 to 320)			bodytemp.icon_state = "temp0"
					if(295 to 300)			bodytemp.icon_state = "temp-1"
					if(280 to 295)			bodytemp.icon_state = "temp-2"
					if(260 to 280)			bodytemp.icon_state = "temp-3"
					else					bodytemp.icon_state = "temp-4"
			else
				//TODO: precalculate all of this stuff when the species datum is created
				var/base_temperature = species.body_temperature
				if(base_temperature == null) //some species don't have a set metabolic temperature
					base_temperature = (species.heat_level_1 + species.cold_level_1)/2

				var/temp_step
				if (bodytemperature >= base_temperature)
					temp_step = (species.heat_level_1 - base_temperature)/4

					if (bodytemperature >= species.heat_level_1)
						bodytemp.icon_state = "temp4"
					else if (bodytemperature >= base_temperature + temp_step*3)
						bodytemp.icon_state = "temp3"
					else if (bodytemperature >= base_temperature + temp_step*2)
						bodytemp.icon_state = "temp2"
					else if (bodytemperature >= base_temperature + temp_step*1)
						bodytemp.icon_state = "temp1"
					else
						bodytemp.icon_state = "temp0"

				else if (bodytemperature < base_temperature)
					temp_step = (base_temperature - species.cold_level_1)/4

					if (bodytemperature <= species.cold_level_1)
						bodytemp.icon_state = "temp-4"
					else if (bodytemperature <= base_temperature - temp_step*3)
						bodytemp.icon_state = "temp-3"
					else if (bodytemperature <= base_temperature - temp_step*2)
						bodytemp.icon_state = "temp-2"
					else if (bodytemperature <= base_temperature - temp_step*1)
						bodytemp.icon_state = "temp-1"
					else
						bodytemp.icon_state = "temp0"
*/
	return TRUE

/mob/living/carbon/human/handle_random_events()
	if(in_stasis)
		return

	// Puke if toxloss is too high
	if(!stat)
		if (getToxLoss() >= 45 && nutrition > 20)
			vomit()

	//0.1% chance of playing a scary sound to someone who's in complete darkness
	if(isturf(loc) && rand(1,1000) == TRUE)
		var/turf/T = loc
		if(T.get_lumcount() == FALSE)
			playsound_local(src,pick(scarySounds),50, TRUE, -1)

/mob/living/carbon/human/handle_stomach()
	spawn(0)
		for(var/mob/living/M in stomach_contents)
			if(M.loc != src)
				stomach_contents.Remove(M)
				continue
			if(iscarbon(M)|| isanimal(M))
				if(M.stat == 2)
					M.death(1)
					stomach_contents.Remove(M)
					qdel(M)
					continue

		handle_starvation()
		handle_dehydration()

/*Hardcore mode stuff. This was moved here because constants that are only used
  at one spot in the code shouldn't be in the __defines folder */

#define STARVATION_MIN FALSE //If you have less nutrition than this value, the hunger indicator starts flashing

#define STARVATION_NOTICE -15 //If you have more nutrition than this value, you get an occasional message reminding you that you're going to starve soon

#define STARVATION_WEAKNESS -40 //Otherwise, if you have more nutrition than this value, you occasionally become weak and receive minor damage

#define STARVATION_NEARDEATH -55 //Otherwise, if you have more nutrition than this value, you have seizures and occasionally receive damage

#define STARVATION_NEGATIVE_INFINITY -10000 // because trying to parse INFINITY into text is bad

//If you have less nutrition than STARVATION_NEARDEATH, you start getting damage

#define STARVATION_OXY_DAMAGE 2.5
#define STARVATION_TOX_DAMAGE 2.5
#define STARVATION_BRAIN_DAMAGE 2.5
#define STARVATION_OXY_HEAL_RATE TRUE //While starving, THIS much oxygen damage is restored per life tick (instead of the default 5)

/mob/living/carbon/human/var/list/informed_starvation[4]

/mob/living/carbon/human/proc/handle_starvation()//Making this it's own proc for my sanity's sake - Matt

	if(nutrition < 350 && nutrition >= 200)
		if (prob(3))
			src << "<span class = 'warning'>You're getting a bit hungry.</span>"

	else if(nutrition < 200 && nutrition >= 100)
		if (prob(5))
			src << "<span class = 'warning'>You're pretty hungry.</span>"

	else if (nutrition < 100 && nutrition >= 20)
		if (prob(8))
			src << "<span class = 'danger'>You're getting really hungry!</span>"

	else if (nutrition < 20) //Nutrition is below 20 = starvation

		var/list/hunger_phrases = list(
			"You feel weak and malnourished. You must find something to eat now!",
			"You haven't eaten in ages, and your body feels weak! It's time to eat something.",
			"You can barely remember the last time you had a proper, nutritional meal. Your body will shut down soon if you don't eat something!",
			"Your body is running out of essential nutrients! You have to eat something soon.",
			"If you don't eat something very soon, you're going to starve to death."
			)

		//When you're starving, the rate at which oxygen damage is healed is reduced by 80% (you only restore TRUE oxygen damage per life tick, instead of 5)

		switch(nutrition)
			if(STARVATION_NOTICE to STARVATION_MIN)
				if(sleeping) return

				if (!informed_starvation[num2text(-STARVATION_NOTICE)])
					src << "<span class='warning'>[pick("You're very hungry.","You really could use a meal right now.")]</span>"

				informed_starvation[num2text(-STARVATION_NOTICE)] = TRUE
				informed_starvation[num2text(-STARVATION_WEAKNESS)] = FALSE
				informed_starvation[num2text(-STARVATION_NEARDEATH)] = FALSE
				informed_starvation[num2text(-STARVATION_NEGATIVE_INFINITY)] = FALSE

				if(prob(10))
					src << "<span class='warning'>[pick("You're very hungry.","You really could use a meal right now.")]</span>"

			if(STARVATION_WEAKNESS to STARVATION_NOTICE)
				if(sleeping) return

				if (!informed_starvation[num2text(-STARVATION_WEAKNESS)])
					src << "<span class='danger'>[pick(hunger_phrases)]</span>"

				informed_starvation[num2text(-STARVATION_NOTICE)] = TRUE
				informed_starvation[num2text(-STARVATION_WEAKNESS)] = TRUE
				informed_starvation[num2text(-STARVATION_NEARDEATH)] = FALSE
				informed_starvation[num2text(-STARVATION_NEGATIVE_INFINITY)] = FALSE

				if(prob(6)) //6% chance of a tiny amount of oxygen damage (1-5)

					adjustOxyLoss(rand(1,5))
					src << "<span class='danger'>[pick(hunger_phrases)]</span>"

				else if(prob(5)) //5% chance of being weakened

					eye_blurry += 10
					Weaken(10)
					adjustOxyLoss(rand(1,15))
					src << "<span class='danger'>You're starving! The lack of strength makes you black out for a few moments...</span>"

			if(STARVATION_NEARDEATH to STARVATION_WEAKNESS) //5-30, 5% chance of weakening and TRUE-230 oxygen damage. 5% chance of a seizure. 10% chance of dropping item
				if(sleeping) return

				if (!informed_starvation[num2text(-STARVATION_NEARDEATH)])
					src << "<span class='danger'>You're starving. You feel your life force slowly leaving your body...</span>"

				informed_starvation[num2text(-STARVATION_NOTICE)] = TRUE
				informed_starvation[num2text(-STARVATION_WEAKNESS)] = TRUE
				informed_starvation[num2text(-STARVATION_NEARDEATH)] = TRUE
				informed_starvation[num2text(-STARVATION_NEGATIVE_INFINITY)] = FALSE

				if(prob(7))

					adjustOxyLoss(rand(1,20))
					src << "<span class='danger'>You're starving. You feel your life force slowly leaving your body...</span>"
					eye_blurry += 20
					if(weakened < TRUE) Weaken(20)

				else if(paralysis<1 && prob(7)) //Mini seizure (25% duration and strength of a normal seizure)

					visible_message("<span class='danger'>\The [src] starts having a seizure!</span>", \
							"<span class='warning'>You have a seizure!</span>")
					Paralyse(5)
					make_jittery(500)
					adjustOxyLoss(rand(1,25))
					eye_blurry += 20

			if(-INFINITY to STARVATION_NEARDEATH) //Fuck the whole body up at this point

				if (!informed_starvation[num2text(-STARVATION_NEGATIVE_INFINITY)])
					src << "<span class='danger'>You are dying from starvation!</span>"

				informed_starvation[num2text(-STARVATION_NOTICE)] = TRUE
				informed_starvation[num2text(-STARVATION_WEAKNESS)] = TRUE
				informed_starvation[num2text(-STARVATION_NEARDEATH)] = TRUE
				informed_starvation[num2text(-STARVATION_NEGATIVE_INFINITY)] = TRUE

				if (prob(10))
					src << "<span class='danger'>You are dying from starvation!</span>"

				adjustToxLoss(STARVATION_TOX_DAMAGE)
				adjustOxyLoss(STARVATION_OXY_DAMAGE)
				adjustBrainLoss(STARVATION_BRAIN_DAMAGE)

				if(prob(10))
					Weaken(15)

#define DEHYDRATION_MIN FALSE
#define DEHYDRATION_NOTICE -15
#define DEHYDRATION_WEAKNESS -40
#define DEHYDRATION_NEARDEATH -55
#define DEHYDRATION_NEGATIVE_INFINITY -10000

#define DEHYDRATION_OXY_DAMAGE 2.5
#define DEHYDRATION_TOX_DAMAGE 2.5
#define DEHYDRATION_BRAIN_DAMAGE 2.5
#define DEHYDRATION_OXY_HEAL_RATE TRUE

/mob/living/carbon/human/var/list/informed_dehydration[4]

/mob/living/carbon/human/proc/handle_dehydration()//Making this it's own proc for my sanity's sake - Matt

	if (water < 300 && water >= 200)
		if (prob(3))
			src << "<span class = 'warning'>You're getting a bit thirsty.</span>"

	else if (water < 200 && water >= 100)
		if (prob(5))
			src << "<span class = 'warning'>You're pretty thirsty.</span>"

	else if (water < 100 && water >= 20)
		if (prob(8))
			src << "<span class = 'danger'>You're really thirsty.</span>"

	else if (water < 20) //Nutrition is below 20 = dehydration

		var/list/thirst_phrases = list(
			"You feel weak and malnourished. You must find something to drink now!",
			"You haven't drank in ages, and your body feels weak! It's time to drink something.",
			"You can barely remember the last time you had something to drink!",
			"Your body is starting to dehydrate! You have to drink something soon.",
			"If you don't drink something very soon, you're going to dehydrate to death."
			)

		//When you're starving, the rate at which oxygen damage is healed is reduced by 80% (you only restore TRUE oxygen damage per life tick, instead of 5)

		switch(water)
			if(DEHYDRATION_NOTICE to DEHYDRATION_MIN)
				if(sleeping) return

				if (!informed_dehydration[num2text(-DEHYDRATION_NOTICE)])
					src << "<span class='warning'>[pick("You're very thirsty.","You really could use some water right now.")]</span>"

				informed_dehydration[num2text(-DEHYDRATION_NOTICE)] = TRUE
				informed_dehydration[num2text(-DEHYDRATION_WEAKNESS)] = FALSE
				informed_dehydration[num2text(-DEHYDRATION_NEARDEATH)] = FALSE
				informed_dehydration[num2text(-DEHYDRATION_NEGATIVE_INFINITY)] = FALSE

				if(prob(10))
					src << "<span class='warning'>[pick("You're very thirsty.","You really could use some water right now.")]</span>"

			if(DEHYDRATION_WEAKNESS to DEHYDRATION_NOTICE)
				if(sleeping) return

				if (!informed_dehydration[num2text(-DEHYDRATION_WEAKNESS)])
					src << "<span class='danger'>[pick(thirst_phrases)]</span>"

				informed_dehydration[num2text(-DEHYDRATION_NOTICE)] = TRUE
				informed_dehydration[num2text(-DEHYDRATION_WEAKNESS)] = TRUE
				informed_dehydration[num2text(-DEHYDRATION_NEARDEATH)] = FALSE
				informed_dehydration[num2text(-DEHYDRATION_NEGATIVE_INFINITY)] = FALSE

				if(prob(6)) //6% chance of a tiny amount of oxygen damage (1-5)

					adjustOxyLoss(rand(1,5))
					src << "<span class='danger'>[pick(thirst_phrases)]</span>"

				else if(prob(5)) //5% chance of being weakened

					eye_blurry += 10
					Weaken(10)
					adjustOxyLoss(rand(1,15))
					src << "<span class='danger'>You're dehydrating! The lack of strength makes you black out for a few moments...</span>"

			if(DEHYDRATION_NEARDEATH to DEHYDRATION_WEAKNESS) //5-30, 5% chance of weakening and TRUE-230 oxygen damage. 5% chance of a seizure. 10% chance of dropping item
				if(sleeping) return

				if (!informed_dehydration[num2text(-DEHYDRATION_NEARDEATH)])
					src << "<span class='danger'>You're dehydrating. You feel your life force slowly leaving your body...</span>"

				informed_dehydration[num2text(-DEHYDRATION_NOTICE)] = TRUE
				informed_dehydration[num2text(-DEHYDRATION_WEAKNESS)] = TRUE
				informed_dehydration[num2text(-DEHYDRATION_NEARDEATH)] = TRUE
				informed_dehydration[num2text(-DEHYDRATION_NEGATIVE_INFINITY)] = FALSE

				if(prob(7))

					adjustOxyLoss(rand(1,20))
					src << "<span class='danger'>You're dehydrating. You feel your life force slowly leaving your body...</span>"
					eye_blurry += 20
					if(weakened < TRUE) Weaken(20)

				else if(paralysis<1 && prob(7)) //Mini seizure (25% duration and strength of a normal seizure)

					visible_message("<span class='danger'>\The [src] starts having a seizure!</span>", \
							"<span class='warning'>You have a seizure!</span>")
					Paralyse(5)
					make_jittery(500)
					adjustOxyLoss(rand(1,25))
					eye_blurry += 20

			if(-INFINITY to DEHYDRATION_NEARDEATH) //Fuck the whole body up at this point

				if (!informed_dehydration[num2text(-DEHYDRATION_NEGATIVE_INFINITY)])
					src << "<span class='danger'>You are dying from dehydration!</span>"

				informed_dehydration[num2text(-DEHYDRATION_NOTICE)] = TRUE
				informed_dehydration[num2text(-DEHYDRATION_WEAKNESS)] = TRUE
				informed_dehydration[num2text(-DEHYDRATION_NEARDEATH)] = TRUE
				informed_dehydration[num2text(-DEHYDRATION_NEGATIVE_INFINITY)] = TRUE

				if (prob(10))
					src << "<span class='danger'>You are dying from dehydration!</span>"

				adjustToxLoss(DEHYDRATION_TOX_DAMAGE)
				adjustOxyLoss(DEHYDRATION_OXY_DAMAGE)
				adjustBrainLoss(DEHYDRATION_BRAIN_DAMAGE)

				if(prob(10))
					Weaken(15)

/mob/living/carbon/human/handle_shock()
	..()
	if(status_flags & GODMODE)	return FALSE	//godmode
	if(species && species.flags & NO_PAIN) return

	if(health < config.health_threshold_softcrit)// health FALSE makes you immediately collapse
		shock_stage = max(shock_stage, 61)

	if(traumatic_shock >= 80)
		shock_stage += TRUE

	else if(health < config.health_threshold_softcrit)
		shock_stage = max(shock_stage, 61)
	else
		shock_stage = min(shock_stage, 160)
		shock_stage = max(shock_stage-1, FALSE)
		return

	if(shock_stage == 10)
		src << "<span class='danger'>[pick("It hurts so much", "You really need some painkillers", "Dear god, the pain")]!</span>"

	if(shock_stage >= 30)
		if(shock_stage == 30) emote("me",1,"is having trouble keeping their eyes open.")
		eye_blurry = max(2, eye_blurry)
		stuttering = max(stuttering, 5)

	if(shock_stage == 40)
		src << "<span class='danger'>[pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going numb")]!</span>"

	if (shock_stage >= 60)
		if(shock_stage == 60) emote("me",1,"'s body becomes limp.")
		if (prob(2))
			src << "<span class='danger'>[pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going numb")]!</span>"
			Weaken(20)

	if(shock_stage >= 80)
		if (prob(5))
			src << "<span class='danger'>[pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going numb")]!</span>"
			Weaken(20)

	if(shock_stage >= 120)
		if (prob(2))
			src << "<span class='danger'>[pick("You black out", "You feel like you could die any moment now", "You're about to lose consciousness")]!</span>"
			Paralyse(5)

	if(shock_stage == 150)
		emote("me",1,"can no longer stand, collapsing!")
		Weaken(20)

	if(shock_stage >= 150)
		Weaken(20)
/*
	Called by life(), instead of having the individual hud items update icons each tick and check for status changes
	we only set those statuses and icons upon changes.  Then those HUD items will simply add those pre-made images.
	This proc below is only called when those HUD elements need to change as determined by the mobs hud_updateflag.
*/


/mob/living/carbon/human/var/never_updated_hud_list = TRUE

/mob/living/carbon/human/proc/handle_hud_list()

	#ifdef HUD_LIST_DEBUG
	world << "called [src]'s handle_hud_list()"
	#endif

	never_updated_hud_list = FALSE

	if (original_job && base_faction)

		if (base_faction && BITTEST(hud_updateflag, FACTION_TO_ENEMIES))
			var/image/holder = hud_list[FACTION_TO_ENEMIES]
			holder.icon = null
			holder.icon_state = null
			hud_list[FACTION_TO_ENEMIES] = holder
			#ifdef HUD_LIST_DEBUG
			world << "updated [src]'s FACTION_TO_ENEMIES hud"
			#endif

		if (spy_faction && BITTEST(hud_updateflag, SPY_FACTION))
			var/image/holder = hud_list[SPY_FACTION]
			holder.icon = 'icons/mob/hud_WW2.dmi'
			switch (original_job.base_type_flag())
				if (SOVIET)
					holder.icon_state = spy_faction.icon_state
				if (GERMAN)
					holder.icon_state = spy_faction.icon_state
				if (PARTISAN)
					holder.icon_state = spy_faction.icon_state
				if (CIVILIAN)
					holder.icon_state = ""
			hud_list[SPY_FACTION] = holder
			#ifdef HUD_LIST_DEBUG
			world << "updated [src]'s SPY_FACTION hud"
			#endif

		if (officer_faction && BITTEST(hud_updateflag, OFFICER_FACTION))
			var/image/holder = hud_list[OFFICER_FACTION]
			holder.icon = 'icons/mob/hud_WW2.dmi'
			switch (original_job.base_type_flag())
				if (SOVIET)
					holder.icon_state = officer_faction.icon_state
				if (GERMAN)
					holder.icon_state = officer_faction.icon_state
				if (PARTISAN)
					holder.icon_state = officer_faction.icon_state
				if (CIVILIAN)
					holder.icon_state = ""
			hud_list[OFFICER_FACTION] = holder
			#ifdef HUD_LIST_DEBUG
			world << "updated [src]'s OFFICER_FACTION hud"
			#endif

		if (base_faction && BITTEST(hud_updateflag, BASE_FACTION))
			var/image/holder = hud_list[BASE_FACTION]
			holder.icon = 'icons/mob/hud_WW2.dmi'
			switch (original_job.base_type_flag())
				if (SOVIET)
					holder.icon_state = base_faction.icon_state
				if (GERMAN)
					holder.icon_state = base_faction.icon_state
				if (PARTISAN)
					holder.icon_state = base_faction.icon_state
				if (CIVILIAN)
					holder.icon_state = ""
			hud_list[BASE_FACTION] = holder
			#ifdef HUD_LIST_DEBUG
			world << "updated [src]'s BASE_FACTION hud"
			#endif

		if (squad_faction && BITTEST(hud_updateflag, SQUAD_FACTION))
			var/image/holder = hud_list[SQUAD_FACTION]
			holder.icon = 'icons/mob/hud_WW2.dmi'
			switch (original_job.base_type_flag())
				if (SOVIET)
					holder.icon_state = squad_faction.icon_state
				if (GERMAN)
					holder.icon_state = squad_faction.icon_state
				if (PARTISAN)
					holder.icon_state = squad_faction.icon_state
				if (CIVILIAN)
					holder.icon_state = ""
			hud_list[SQUAD_FACTION] = holder
			#ifdef HUD_LIST_DEBUG
			world << "updated [src]'s SQUAD_FACTION hud"
			#endif

	if (BITTEST(hud_updateflag, HEALTH_HUD))
		var/image/holder = hud_list[HEALTH_HUD]
		if(stat == DEAD)
			holder.icon_state = "hudhealth-100" 	// X_X
		else
			var/percentage_health = RoundHealth((health-config.health_threshold_crit)/(maxHealth-config.health_threshold_crit)*100)
			holder.icon_state = "hud[percentage_health]"
		hud_list[HEALTH_HUD] = holder

	if (BITTEST(hud_updateflag, LIFE_HUD))
		var/image/holder = hud_list[LIFE_HUD]
		if(stat == DEAD)
			holder.icon_state = "huddead"
		else
			holder.icon_state = "hudhealthy"
		hud_list[LIFE_HUD] = holder

	if (BITTEST(hud_updateflag, STATUS_HUD))
		var/foundVirus = FALSE
	/*	for (var/ID in virus2)
			if (ID in virusDB)
				foundVirus = TRUE
				break*/

		var/image/holder = hud_list[STATUS_HUD]
		if(stat == DEAD)
			holder.icon_state = "huddead"
		else if(status_flags & XENO_HOST)
			holder.icon_state = "hudxeno"
		else if(foundVirus)
			holder.icon_state = "hudill"

		var/image/holder2 = hud_list[STATUS_HUD_OOC]
		if(stat == DEAD)
			holder2.icon_state = "huddead"
		else if(status_flags & XENO_HOST)
			holder2.icon_state = "hudxeno"
		else if(has_brain_worms())
			holder2.icon_state = "hudbrainworm"
		else
			holder2.icon_state = "hudhealthy"

		hud_list[STATUS_HUD] = holder
		hud_list[STATUS_HUD_OOC] = holder2

	if (BITTEST(hud_updateflag, ID_HUD))
		var/image/holder = hud_list[ID_HUD]
		holder.icon_state = "hudunknown"
		hud_list[ID_HUD] = holder
/*
	if (BITTEST(hud_updateflag, WANTED_HUD))
		var/image/holder = hud_list[WANTED_HUD]
		holder.icon_state = "hudblank"
		var/perpname = name
		if(wear_id)
			var/obj/item/weapon/card/id/I = wear_id.GetID()
			if(I)
				perpname = I.registered_name

		for(var/datum/data/record/E in data_core.general)
			if(E.fields["name"] == perpname)
				for (var/datum/data/record/R in data_core.security)
					if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "*Arrest*"))
						holder.icon_state = "hudwanted"
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Incarcerated"))
						holder.icon_state = "hudprisoner"
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Parolled"))
						holder.icon_state = "hudparolled"
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Released"))
						holder.icon_state = "hudreleased"
						break
		hud_list[WANTED_HUD] = holder*/

	if (  BITTEST(hud_updateflag, IMPLOYAL_HUD) \
	   || BITTEST(hud_updateflag,  IMPCHEM_HUD) \
	   || BITTEST(hud_updateflag, IMPTRACK_HUD))

		var/image/holder1 = hud_list[IMPTRACK_HUD]
		var/image/holder2 = hud_list[IMPLOYAL_HUD]
		var/image/holder3 = hud_list[IMPCHEM_HUD]

		holder1.icon_state = "hudblank"
		holder2.icon_state = "hudblank"
		holder3.icon_state = "hudblank"

		for(var/obj/item/weapon/implant/I in src)
			if(I.implanted)
				if(istype(I,/obj/item/weapon/implant/chem))
					holder3.icon_state = "hud_imp_chem"

		hud_list[IMPTRACK_HUD] = holder1
		hud_list[IMPLOYAL_HUD] = holder2
		hud_list[IMPCHEM_HUD]  = holder3

	if (BITTEST(hud_updateflag, SPECIALROLE_HUD))
		var/image/holder = hud_list[SPECIALROLE_HUD]
		holder.icon_state = "hudblank"
		if(mind && mind.special_role)
			if(hud_icon_reference[mind.special_role])
				holder.icon_state = hud_icon_reference[mind.special_role]
			else
				holder.icon_state = "hudsyndicate"
			hud_list[SPECIALROLE_HUD] = holder
	hud_updateflag = FALSE

/mob/living/carbon/human/handle_silent()
	if(..())
		speech_problem_flag = TRUE
	return silent

/mob/living/carbon/human/handle_slurring()
	if(..())
		speech_problem_flag = TRUE
	return slurring

/mob/living/carbon/human/handle_stunned()
	if(species.flags & NO_PAIN)
		stunned = FALSE
		return FALSE
	if(..())
		speech_problem_flag = TRUE
	return stunned

/mob/living/carbon/human/handle_stuttering()
	if(..())
		speech_problem_flag = TRUE
	return stuttering

/mob/living/carbon/human/handle_fire()
	if(..())
		return

	var/burn_temperature = fire_burn_temperature()
	var/thermal_protection = get_heat_protection(burn_temperature)

	if (thermal_protection < TRUE && bodytemperature < burn_temperature)
		bodytemperature += round(BODYTEMP_HEATING_MAX*(1-thermal_protection), TRUE)

/mob/living/carbon/human/rejuvenate()
	restore_blood()
	..()

/mob/living/carbon/human/handle_vision()

	if(client)
		client.screen.Remove(global_hud.blurry, global_hud.druggy, global_hud.vimpaired, global_hud.darkMask, global_hud.nvg, global_hud.thermal, global_hud.meson, global_hud.science)

	if (!laddervision)
		if(machine)
			var/viewflags = machine.check_eye(src)
			if(viewflags < FALSE)
				reset_view(null, FALSE)
			else if(viewflags)
				sight |= viewflags
	/*	else if(eyeobj)
			if(eyeobj.owner != src)
				reset_view(null)*/
		else
			var/isRemoteObserve = FALSE
			if((mRemote in mutations) && remoteview_target)
				if(remoteview_target.stat==CONSCIOUS)
					isRemoteObserve = TRUE
			if(!isRemoteObserve && client && !client.adminobs)
				remoteview_target = null
				reset_view(null, FALSE)
	else if (client)
		client.perspective = EYE_PERSPECTIVE
		client.eye = laddervision

	update_equipment_vision()
	species.handle_vision(src)

/mob/living/carbon/human/update_sight()
	..()
	if(stat == DEAD)
		return
	if(XRAY in mutations)
		sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS