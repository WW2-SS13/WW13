var/roundstart_time = 0
var/grace_period = TRUE
var/game_started = FALSE
var/train_checked = FALSE
var/secret_ladder_message = null
var/list/list_of_germans_who_crossed_the_river = list()
var/GRACE_PERIOD_LENGTH = 7

/proc/WW2_train_check()
	if (locate(/obj/effect/landmark/train/german_train_start) in world || train_checked)
		train_checked = TRUE
		return TRUE
	else
		return FALSE

/hook/roundstart/proc/game_start()

	roundstart_time = world.realtime

	// after the game mode has been announced.
	spawn (5)
		var/season = "SPRING"
		if (ticker.mode.vars.Find("season"))
			season = ticker.mode:season
		update_lighting(announce = FALSE)
		world << "<br><font size=3><span class = 'notice'>It's <b>[lowertext(time_of_day)]</b>, and the season is <b>[capitalize(lowertext(season))]</b>.</span></font>"

	// spawn mice so soviets have something to eat after they start starving

	var/mice_spawned = FALSE
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
					return TRUE

	// open squad preparation doors
	for (var/obj/structure/simple_door/key_door/keydoor in world)
		if (findtext(keydoor.name, "Squad"))
			if (findtext(keydoor.name, "Preparation"))
				keydoor.Open()
	return TRUE

// this is roundstart because we need to wait for objs to be created
/hook/roundstart/proc/nature()

	var/nature_chance = 100

	var/datum/game_mode/ww2/mode = ticker.mode
	if (mode.season == "WINTER")
		nature_chance = 70

	// create wild grasses in "clumps"
	world << "<span class = 'notice'>Setting up wild grasses.</span>"

	for (var/turf/floor/plating/grass/G in grass_turf_list)
		if (!G || G.z > TRUE)
			continue

		if (prob(nature_chance))
			G.plant()

	do_seasonal_stuff()

	if (!WW2_train_check())
		callHook("train_move")

// freaking seasons dude
/proc/do_seasonal_stuff()
	world << "<span class = 'notice'>Setting up seasonal stuff.</span>"
	var/datum/game_mode/ww2/mode = ticker.mode

	if (istype(mode))

		var/use_snow = FALSE

		// first, make all water into ice if it's winter
		if (mode.season == "WINTER")
			for (var/turf/floor/plating/beach/water/W in turfs)
				if (!istype(W, /turf/floor/plating/beach/water/sewage))
					new /turf/floor/plating/beach/water/ice (W)
			if (prob(50))
				use_snow = TRUE

		for (var/turf/floor/G in turfs)

			if (!G || G.z > TRUE || (!G.uses_winter_overlay && !locate(/obj/snow_maker) in G))
				continue

			G.season = mode.season

			var/area/A = get_area(G)

			if (A.location == AREA_INSIDE && !locate(/obj/snow_maker) in G)
				continue

			if (G.season != "SPRING")
				G.overlays.Cut()

			if (G.uses_winter_overlay || locate(/obj/snow_maker) in G)
				if (G.season == "WINTER")

					if (G.uses_winter_overlay)
						G.color = DEAD_COLOR

					if (use_snow)
						new/obj/snow(G)

					for (var/obj/structure/wild/W in G.contents)
						if (istype(W))

							W.color = DEAD_COLOR
							var/icon/W_icon = icon(W.icon, W.icon_state)
							if (use_snow)
								W_icon.Blend(icon('icons/turf/snow.dmi', (istype(W, /obj/structure/wild/tree) ? "wild_overlay" : "tree_overlay")), ICON_MULTIPLY)
								W.icon = W_icon

				else if (G.season == "SUMMER")
					if (G.uses_winter_overlay)
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
					if (G.uses_winter_overlay)
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

			if (G.season != "SPRING" && G.uses_winter_overlay)
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

			for (var/obj/snow_maker/SM in G)
				qdel(SM)

	return TRUE

/hook/roundstart/proc/show_battle_report()
	if (istype(map, /obj/map_metadata/forest))
		spawn (600)
			world << "<font size=3>Balance report: [n_of_side(GERMAN)] German, [n_of_side(SOVIET)] Soviet and [n_of_side(CIVILIAN)+n_of_side(PARTISAN)] Civilians/Partisans.</font>"

var/mission_announced = FALSE
var/train_arrived = FALSE
var/allow_paratroopers = TRUE

/hook/train_move/proc/announce_mission_start()

	if(mission_announced)
		return TRUE

	mission_announced = tickerProcess.time_elapsed

	var/preparation_time = world.realtime - roundstart_time

	if (map)
		map.announce_mission_start(preparation_time)

	game_started = TRUE

	// let the new players see reinforcements now
	spawn (1)
		for (var/mob/new_player/np in world)
			if (np.client)
				np.new_player_panel_proc()

	var/show_report_after = 0
	if (istype(map, /obj/map_metadata/minicity))
		show_report_after = 600
	spawn (show_report_after)
		world << "<font size=3>Balance report: [n_of_side(GERMAN)] German, [n_of_side(SOVIET)] Soviet and [n_of_side(CIVILIAN)+n_of_side(PARTISAN)] Civilians/Partisans.</font>"