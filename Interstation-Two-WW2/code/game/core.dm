//#define WINTER_TESTING
#define TANK_LOWPOP_THRESHOLD 12
#define ARTILLERY_LOWPOP_THRESHOLD 15

/hook/startup/proc/seasons()
	#ifdef WINTER_TESTING
	season = "WINTER"
	#else
	if (config && config.allowed_seasons && config.allowed_seasons.len)
		switch (config.allowed_seasons[1])
			if (1) // all seasons
				season = pick("SPRING", "SUMMER", "FALL", "WINTER")
			if (0) // no seasons = spring
				season = "SPRING"
			else
				season = pick(config.allowed_seasons)
	else
		season = pick("SPRING", "SUMMER", "FALL", "WINTER")
	#endif

/hook/roundstart/proc/mainstuff()
	world << "<b><big>The round has started!</big></b>"
	for (var/client/C in clients)
		winset(C, null, "mainwindow.flash=1")
	supply_codes[GERMAN] = rand(1000,9999)
	supply_codes[SOVIET] = rand(1000,9999)
	// announce after some other stuff, like system setups, are announced
	spawn (3)

		// this may have already happened, do it again w/o announce
		setup_autobalance(0)

		// let new players see the join link
		for (var/mob/new_player/np in world)
			if (np.client)
				np.new_player_panel_proc()

		// no tanks on lowpop
		if (clients.len <= TANK_LOWPOP_THRESHOLD)
			if (locate(/obj/tank) in world)
				for (var/obj/tank/T in world)
					if (!T.admin)
						qdel(T)
				world << "<i>Due to lowpop, there are no tanks.</i>"

		if (clients.len <= ARTILLERY_LOWPOP_THRESHOLD)
			for (var/obj/structure/artillery/A in world)
				qdel(A)
			for (var/obj/structure/closet/crate/artillery/C in world)
				qdel(C)
			for (var/obj/structure/closet/crate/artillery_gas/C in world)
				qdel(C)
			if (map)
				german_supply_crate_types -= "7,5 cm FK 18 Artillery Piece"
				german_supply_crate_types -= "Artillery Ballistic Shells Crate"
				german_supply_crate_types -= "Artillery Gas Shells Crate"
				map.katyushas = FALSE
			for (var/obj/structure/mortar/M in world)
				qdel(M)
			for (var/obj/item/weapon/shovel/spade/mortar/S in world)
				qdel(S)
			for (var/obj/structure/closet/crate/mortar_shells/C in world)
				qdel(C)
			if (map)
				german_supply_crate_types -= "Mortar Shells"
				soviet_supply_crate_types -= "Mortar Shells"
				soviet_supply_crate_types -= "37mm Spade Mortar"
			world << "<i>Due to lowpop, there is no artillery or mortars.</i>"

		if (clients.len <= 12)
			for (var/obj/structure/simple_door/key_door/soviet/QM/D in world)
				D.Open()
			for (var/obj/structure/simple_door/key_door/soviet/medic/D in world)
				D.Open()
			for (var/obj/structure/simple_door/key_door/soviet/engineer/D in world)
				D.Open()
			for (var/obj/structure/simple_door/key_door/german/QM/D in world)
				D.Open()
			for (var/obj/structure/simple_door/key_door/german/medic/D in world)
				D.Open()
			for (var/obj/structure/simple_door/key_door/german/engineer/D in world)
				D.Open()
			world << "<b>Due to lowpop, some doors have started open.</b>"