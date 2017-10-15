var/roundstart_time = 0
var/grace_period = 1
var/game_started = 0
var/train_checked = 0
var/secret_ladder_message = null
var/list/list_of_germans_who_crossed_the_river = list()
var/GRACE_PERIOD_LENGTH = 10

/proc/WW2_train_check()
	if (locate(/obj/effect/landmark/train/german_train_start) in world || train_checked)
		train_checked = 1
		return 1
	else
		return 0

/turf/proc/check_prishtina_block(var/mob/m, var/actual_movement = 0)

	if (isobserver(m))
		return 0

	for (var/obj/prishtina_block/pb in src)
		if (!istype(pb, /obj/prishtina_block/attackers) && !istype(pb, /obj/prishtina_block/defenders))
			return 1 // nobody passes these
		else
			if (istype(pb, /obj/prishtina_block/attackers))
				if (!game_started)
					return 1 // if the game has not started, nobody passes. For benefit of attacking commanders/defenders - prevents ramboing, allows setting up
			else if (istype(pb, /obj/prishtina_block/defenders))
				if (grace_period)
					var/mob/living/carbon/human/H = m
					if (H && H.original_job && istype(H.original_job, /datum/job/german))
						if (actual_movement)
							if (!istype(H.original_job, /datum/job/german/paratrooper))
								list_of_germans_who_crossed_the_river |= H
								if (list_of_germans_who_crossed_the_river.len > 10 && grace_period)
									world << "<span class = 'notice'><big>A number of Germans have crossed the river; the Grace Period has been ended early.</span>"
									grace_period = 0
						return 0 // germans can pass
					return 1 // if the grace period is active, nobody south of the river passes. For the benefit of attackers, so they get time to set up.
	return 0

/obj/prishtina_block
	icon = null
	icon_state = null
	density = 0
	anchored = 1.0
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	name = ""

	New()
		icon = null
		icon_state = null
		layer = -1000

	ex_act(severity)
		return 0

/obj/prishtina_block/attackers // block the Germans (or whoever is attacking) from attacking early
	icon = null
	icon_state = null
	density = 0
	anchored = 1.0
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	name = ""

	New()
		icon = null
		icon_state = null
		layer = -1000


/obj/prishtina_block/defenders // block the Russian (or whoever is defending) from attacking early
	icon = null
	icon_state = null
	density = 0
	anchored = 1.0
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	name = ""

	New()
		icon = null
		icon_state = null
		layer = -1000

/hook/startup/proc/nature()
	for (var/obj/structure/wild/tree/T in world)
		if (prob(25))
			new /obj/structure/wild/bush(get_turf(T))
			qdel(T)

/hook/roundstart/proc/game_start()

	roundstart_time = world.time

	// after the game mode has been announced.
	spawn (5)
		var/season = "SPRING"
		if (ticker.mode.vars.Find("season"))
			season = ticker.mode:season
		world << "<br><font size=3><span class = 'notice'>It's <b>[lowertext(time_of_day)]</b>, and the season is <b>[capitalize(lowertext(season))]</b>.</span></font>"

	// spawn mice so soviets have something to eat after they start starving

	var/mice_spawned = 0
	var/max_mice = rand(40,50)

	for (var/area/prishtina/soviet/bunker/area in world)
		for (var/turf/t in area.contents)
			if (t.density)
				continue
			if (istype(t, /turf/open))
				continue
			if (prob(1))
				new/mob/living/simple_animal/mouse/gray(t)
				++mice_spawned
				if (mice_spawned > max_mice)
					return 1

	// open squad preparation doors
	for (var/obj/structure/simple_door/key_door/keydoor in world)
		if (findtext(keydoor.name, "Squad"))
			if (findtext(keydoor.name, "Preparation"))
				keydoor.Open()
	return 1

/hook/roundstart/proc/do_seasonal_stuff()

	var/datum/game_mode/ww2/mode = ticker.mode
	if (istype(mode))
		for (var/turf/floor/plating/grass/G in grass_turf_list)
			G.season = mode.season
			if (G.uses_winter_overlay && G.season == "WINTER")
				var/obj/o = new
				o.icon = 'icons/turf/snow.dmi'
				o.icon_state = ""
				o.alpha = 200
				o.name = ""
				G.overlays += o

	return 1

var/mission_announced = 0
var/allow_paratroopers = 1

/hook/train_move/proc/announce_mission_start()

	if(mission_announced)
		return 1

	mission_announced = 1

	var/preparation_time = world.time - roundstart_time

	world << "<font size=4>The German assault has started after [preparation_time / 600] minutes of preparation.</font><br>"

	if (grace_period && WW2_train_check())
		world << "<font size=3>The Russian side can't attack until after 10 minutes.</font><br>"

	game_started = 1
//	ticker.can_latejoin_ruforce = 0
//	ticker.can_latejoin_geforce = 0

	if (WW2_train_check())
		spawn (5 MINUTES)
			allow_paratroopers = 0
		spawn (GRACE_PERIOD_LENGTH MINUTES) // because byond minutes are a long fucking time, this should be long enough to build defenses. maybe. - Kachnov
			if (grace_period)
				grace_period = 0
				world << "<font size=4>The 10 minute grace period has ended. Soviets and Partisans may now cross the river.</font>"

	world << "<font size=3>Balance report: [job_master.geforce_count] German, [job_master.ruforce_count] Soviet and [job_master.civilian_count] Civilians/Partisans.</font>"