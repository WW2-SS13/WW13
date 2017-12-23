var/roundstart_time = 0
var/grace_period = 1
var/game_started = 0
var/train_checked = 0
var/secret_ladder_message = null
var/list/list_of_germans_who_crossed_the_river = list()
var/GRACE_PERIOD_LENGTH = 7

/proc/WW2_train_check()
	if (locate(/obj/effect/landmark/train/german_train_start) in world || train_checked)
		train_checked = 1
		return 1
	else
		return 0

/hook/roundstart/proc/game_start()

	roundstart_time = world.time

	// after the game mode has been announced.
	spawn (5)
		var/season = "SPRING"
		if (ticker.mode.vars.Find("season"))
			season = ticker.mode:season
		update_lighting(announce = 0)
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

// this is roundstart because we need to wait for objs to be created
/hook/roundstart/proc/nature()

	var/nature_chance = 100

	var/datum/game_mode/ww2/mode = ticker.mode
	if (mode.season == "WINTER")
		nature_chance = 70

	// create wild grasses in "clumps"
	world << "<span class = 'notice'>Setting up wild grasses.</span>"

	for (var/turf/floor/plating/grass/G in grass_turf_list)
		if (!G || G.z > 1)
			continue

		if (prob(nature_chance))
			G.plant()

	do_seasonal_stuff()

// freaking seasons dude
/proc/do_seasonal_stuff()
	world << "<span class = 'notice'>Setting up seasonal stuff.</span>"
	var/datum/game_mode/ww2/mode = ticker.mode

	if (istype(mode))

		// first, make all water into ice if it's winter
		if (mode.season == "WINTER")
			for (var/turf/floor/plating/beach/water/W in turfs)
				new /turf/floor/plating/beach/water/ice (W)

		for (var/turf/floor/G in turfs)

			if (!G || G.z > 1 || !G.uses_winter_overlay)
				continue

			G.season = mode.season

			var/area/A = get_area(G)

			if (A.location == AREA_INSIDE)
				continue

			if (G.season != "SPRING")
				G.overlays.Cut()

			if (G.uses_winter_overlay)
				if (G.season == "WINTER")

					G.color = DEAD_COLOR
					new/obj/snow(G)

					for (var/obj/structure/wild/W in G.contents)
						if (istype(W))

							W.color = DEAD_COLOR
							var/icon/W_icon = icon(W.icon, W.icon_state)
							W_icon.Blend(icon('icons/turf/snow.dmi', (istype(W, /obj/structure/wild/tree) ? "wild_overlay" : "tree_overlay")), ICON_MULTIPLY)
							W.icon = W_icon

				else if (G.season == "SUMMER")
					G.color = SUMMER_COLOR
					for (var/obj/structure/wild/W in G.contents)
						if (istype(W))
							var/obj/W_overlay = new(G)
							W_overlay.icon = W.icon
							W_overlay.icon_state = W.icon_state
							W_overlay.layer = W.layer + 0.01
							W_overlay.alpha = 133
							W_overlay.pixel_x = W.pixel_x
							W_overlay.pixel_y = W.pixel_y
							W_overlay.name = ""
							W_overlay.color = SUMMER_COLOR
							W_overlay.special_id = "seasons"

				else if (G.season == "FALL")
					G.color = FALL_COLOR
					for (var/obj/structure/wild/W in G.contents)
						if (istype(W))
							var/obj/W_overlay = new(G)
							W_overlay.icon = W.icon
							W_overlay.icon_state = W.icon_state
							W_overlay.layer = W.layer + 0.01
							W_overlay.alpha = 133
							W_overlay.pixel_x = W.pixel_x
							W_overlay.pixel_y = W.pixel_y
							W_overlay.name = ""
							W_overlay.color = FALL_COLOR
							W_overlay.special_id = "seasons"

			if (G.season != "SPRING")
				for (var/cache_key in G.floor_decal_cache_keys)
					var/image/decal = floor_decals[cache_key]
					var/obj/o = new(G)
					o.icon = decal.icon
					o.icon_state = decal.icon_state
					o.dir = decal.dir
					o.color = decal.color
					o.layer = 2.04 // above snow
					o.alpha = decal.alpha
					o.name = ""

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
		spawn (GRACE_PERIOD_LENGTH MINUTES)
			if (grace_period)
				grace_period = 0
				world << "<font size=4>The grace period has ended. Soviets and Partisans may now cross the river.</font>"

	world << "<font size=3>Balance report: [n_of_side(GERMAN)] German, [n_of_side(RUSSIAN)] Soviet and [n_of_side(CIVILIAN)+n_of_side(PARTISAN)] Civilians/Partisans.</font>"