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

// season defines used in this file
#define WINTER_COLOR "#FFFAFA"
#define SUMMER_COLOR "#FDBD88"
#define FALL_COLOR "#C37D69"

// this is roundstart because we need to wait for objs to be created
/hook/roundstart/proc/nature()

	// create wild grasses
	world << "<span class = 'notice'>Setting up wild grasses.</span>"
	for (var/turf/floor/plating/grass/G in grass_turf_list)
		if (prob(50))
			if (locate(/atom/movable) in G)
				goto next
			new /obj/structure/wild/bush(G)
		next

	do_seasonal_stuff()
//	correct_seasonal_stuff()

// freaking seasons dude
/proc/do_seasonal_stuff()
	world << "<span class = 'notice'>Setting up seasonal stuff.</span>"
	var/datum/game_mode/ww2/mode = ticker.mode
	if (istype(mode))
		for (var/turf/floor/plating/grass/G in grass_turf_list)
			G.season = mode.season

			if (G.season != "SPRING")
				G.overlays.Cut()

			if (G.uses_winter_overlay)
				if (G.season == "WINTER")

					var/obj/snow/S = new(G)
					S.icon = 'icons/turf/snow.dmi'
					S.icon_state = ""
					S.layer = G.layer
					S.alpha = 200
					S.name = ""
					S.special_id = "seasons"

					for (var/obj/structure/wild/W in G.contents)
						if (istype(W))
							W.color = "#521515" // make us look dead
							var/obj/W_overlay = new(G)
							W_overlay.icon = W.icon
							W_overlay.icon_state = W.icon_state
							W_overlay.layer = W.layer + 0.01
							W_overlay.alpha = 200
							W_overlay.name = ""
							var/icon/W_overlay_icon = icon(W_overlay.icon, W_overlay.icon_state)
							W_overlay_icon.Blend(icon('icons/turf/snow.dmi', ""), ICON_MULTIPLY)
							W_overlay.icon = W_overlay_icon
							W_overlay.special_id = "seasons"
							W.overlays.Insert(1, W_overlay)

				else if (G.season == "SUMMER")
					G.color = "#FDBD88"
					for (var/obj/structure/wild/W in G.contents)
						if (istype(W) && !istype(W, /obj/structure/wild/tree))
							var/obj/W_overlay = new(G)
							W_overlay.icon = W.icon
							W_overlay.icon_state = W.icon_state
							W_overlay.layer = W.layer + 0.01
							W_overlay.alpha = 100
							W_overlay.name = ""
							W_overlay.color = "#fc913a"
							W_overlay.special_id = "seasons"
							W.overlays.Insert(1, W_overlay)

				else if (G.season == "FALL")
					G.color = "#C37D69"
					for (var/obj/structure/wild/W in G.contents)
						if (istype(W) && !istype(W, /obj/structure/wild/tree))
							var/obj/W_overlay = new(G)
							W_overlay.icon = W.icon
							W_overlay.icon_state = W.icon_state
							W_overlay.layer = W.layer + 0.01
							W_overlay.alpha = 100
							W_overlay.name = ""
							W_overlay.color = "#9C2706"
							W_overlay.special_id = "seasons"
							W.overlays.Insert(1, W_overlay)

			if (G.season != "SPRING")
				for (var/cache_key in G.floor_decal_cache_keys)
					var/image/decal = floor_decals[cache_key]
					var/obj/o = new(G)
					o.icon = decal.icon
					o.icon_state = decal.icon_state
					o.dir = decal.dir
					o.color = decal.color
					o.layer = G.layer+0.02
					o.alpha = decal.alpha
					o.name = ""

	return 1


// must come after do_seasonal_stuff() or things break,
//notably the entire game

// this exists to prevent floor_decal objs from taking on seasonal colors
// belonging to their turf

/proc/correct_seasonal_stuff()
	world << "<span class = 'notice'>Correcting seasonal icon errors.</span>"
	for (var/turf/floor/plating/grass/G in grass_turf_list)
		if (istype(G))
			if (G.color == SUMMER_COLOR || G.color == FALL_COLOR)
				if (G.overlays.len)
					G.overlays.Cut()
					world << "editing grass [G] floor decal"
					for (var/cache_key in G.floor_decal_cache_keys)
						var/image/decal = floor_decals[cache_key]
						var/obj/o = new(G)
						o.icon = decal.icon
						o.icon_state = decal.icon_state
						o.color = decal.color
						o.layer = G.layer+0.02
						o.alpha = decal.alpha
						o.name = ""

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

	// let the new players see reinforcements now
	spawn (1)
		for (var/mob/new_player/np in world)
			if (np.client)
				np.new_player_panel_proc()

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