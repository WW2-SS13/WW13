/datum/train_controller
	var/faction = null
	var/list/train_car_centers = list()
	var/list/reverse_train_car_centers = list()
	var/list/train_connectors = list()
	var/list/train_railings = list()
	var/list/reverse_train_connectors = list()
	var/list/reverse_train_railings = list()
	var/officer_cars = TRUE
	var/storage_cars = TRUE
	var/soldier_cars = TRUE
	var/conductor_cars = TRUE
	var/total_cars = FALSE
	var/total_height = FALSE
	var/total_width = FALSE

	var/obj/effect/landmark/train/starting_point = null
	var/obj/effect/landmark/train/limit_point = null

	var/orientation = VERTICAL
	var/direction = "FORWARDS" // right now, trains only move north to south (forwards) and south to north (backwards)
	// They don't reverse yet, because that's fucking annoying to do.
	var/moving = FALSE // are we moving?
	var/halting = FALSE // did the conductor stop us?
//	var/finishing_halting = FALSE // did we halt recently? don't play movement sounds
	var/velocity = 2.50 // previously 3.0
	var/started_moving = FALSE  // calls train_start hook when set to TRUE for the first time
	var/list/last_played[2] // movement, halting sounds
	var/playing = "" // ditto
	var/obj/train_car_center/last_car = null // the car closest to the front of the train
	var/obj/train_car_center/first_car = null // the car closest to the back of the train
	var/inc[2] // FORWARDS = -1, BACKWARDS = +1
	var/my_tcc_type = null

	var/halting_sound_delay = 100
	var/movement_sound_delay = 50

	var/invisible = FALSE // disappear into the void

/datum/train_controller/proc/get_lever()
	for (var/obj/train_lever/lever in world)
		if (lever.loc && lever.faction == faction && lever.real)
			return lever
	return null

/datum/train_controller/german/get_lever()
	for (var/obj/train_lever/lever in world)
		if (lever.loc && istype(lever, /obj/train_lever/german) && lever.real)
			return lever
	return null

/datum/train_controller/german_supply_controller/get_lever()
	return null

/datum/train_controller/russian/get_lever()
	for (var/obj/train_lever/lever in world)
		if (lever.loc && istype(lever, /obj/train_lever/russian) && lever.real)
			return lever
	return null
/*
/datum/train_controller/proc/get_next_mob_move(var/mob/m, var/dir)

	switch (dir)
		if (NORTH)
			return list("x" = FALSE, "y" = TRUE)
		if (SOUTH)
			return list("x" = FALSE, "y" = -1)
		if (EAST)
			return list("x" = TRUE, "y" = FALSE)
		if (WEST)
			return list("x" = -1, "y" = FALSE)*/
/*
	var/dir2x[0]
	var/dir2y[0]

	// use dir2text because maps don't support numerical keys

	dir2x[dir2text(EAST)] = TRUE
	dir2x[dir2text(WEST)] = -1
	dir2x[dir2text(NORTH)] = FALSE
	dir2x[dir2text(SOUTH)] = FALSE

	dir2y[dir2text(EAST)] = FALSE
	dir2y[dir2text(WEST)] = FALSE
	dir2y[dir2text(NORTH)] = TRUE
	dir2y[dir2text(SOUTH)] = -1

	if (moving)
		switch (direction)
			if ("FORWARDS")
				return locate(m.x+dir2x[dir2text(dir)], m.y-1+dir2y[dir2text(dir)], m.z)
			if ("BACKWARDS")
				return locate(m.x+dir2x[dir2text(dir)], m.y+1+dir2y[dir2text(dir)], m.z)
	else
		return null
*/
/datum/train_controller/New(_faction)

	faction = _faction

	inc["FORWARDS"] = -1
	inc["BACKWARDS"] = TRUE

	last_played["movement"] = -1
	last_played["halting"] = -1

	switch (faction)
		if (GERMAN)
			my_tcc_type = /obj/train_car_center/german
			officer_cars = config.german_train_cars_officer
			storage_cars = config.german_train_cars_storage
			soldier_cars = config.german_train_cars_soldier
			conductor_cars = config.german_train_cars_conductor
			total_cars = officer_cars + storage_cars + soldier_cars + conductor_cars

			starting_point = locate(/obj/effect/landmark/train/german_train_start) in world
			limit_point = locate(/obj/effect/landmark/train/german_train_limit) in world

			if (!starting_point || !limit_point || !istype(starting_point) || !istype(limit_point))
				return // nope

			var/starting_y = starting_point.y
			var/starting_x = starting_point.x
			var/starting_z = starting_point.z

			var/off_di = getAreaDimensions(src, "officer")
			var/st_di = getAreaDimensions(src, "storage")
			var/so_di = getAreaDimensions(src, "soldier")
			var/con_di = getAreaDimensions(src, "conductor")

		//	var/cars_width = (off_di["width"] + st_di["width"] + so_di["width"] + con_di["width"])
			var/cars_height = (off_di["height"] + st_di["height"] + so_di["height"] + con_di["height"])

			var/num_spaces = total_cars - TRUE // 2 cars = TRUE space, etc
			var/extra_height = SPACES_BETWEEN_CARS * num_spaces

			total_height = cars_height + extra_height

			var/max_dist = abs(starting_point.y - limit_point.y) + TRUE

			if (total_height > max_dist)
				return // we fucked up. This is a huge train, or there isn't much space between the starting and limit
						// points.

			//	otherwise, continue

			var/y_inc = FALSE
			var/found_first_car = FALSE

			for (var/v in TRUE to officer_cars)
				var/obj/train_car_center/tcc = new/obj/train_car_center/german/officer(locate(starting_x, starting_y + y_inc, starting_z), src)
				y_inc -= off_di["height"]
				y_inc -= SPACES_BETWEEN_CARS
				train_car_centers += tcc
				last_car = tcc

				if (!found_first_car)
					first_car = tcc
					found_first_car = TRUE

			for (var/v in TRUE to soldier_cars)
				var/obj/train_car_center/tcc = new/obj/train_car_center/german/soldier(locate(starting_x, starting_y + y_inc, starting_z), src)
				y_inc -= so_di["height"]
				y_inc -= SPACES_BETWEEN_CARS
				train_car_centers += tcc
				last_car = tcc

				if (!found_first_car)
					first_car = tcc
					found_first_car = TRUE

			for (var/v in TRUE to storage_cars) // this makes unboarding way easier
				var/obj/train_car_center/tcc = new/obj/train_car_center/german/storage(locate(starting_x, starting_y + y_inc, starting_z), src)
				y_inc -= st_di["height"]
				y_inc -= SPACES_BETWEEN_CARS
				train_car_centers += tcc
				last_car = tcc

				if (!found_first_car)
					first_car = tcc
					found_first_car = TRUE

			for (var/v in TRUE to conductor_cars)
				var/obj/train_car_center/tcc = new/obj/train_car_center/german/conductor(locate(starting_x, starting_y + y_inc, starting_z), src)
				y_inc -= con_di["height"]
				y_inc -= SPACES_BETWEEN_CARS
				train_car_centers += tcc
				last_car = tcc

				if (!found_first_car)
					first_car = tcc
					found_first_car = TRUE

			generate_connectors()
			reverse_train_car_centers = reverselist(train_car_centers)

			// and we're done

		if (SOVIET)
			return // not implemented lmao

		if ("GERMAN-SUPPLY")

			// reverse our movement because BYOND uses a meme y axis
			inc["FORWARDS"] = TRUE
			inc["BACKWARDS"] = -1

			orientation = HORIZONTAL

			my_tcc_type = /obj/train_car_center/germansupply
			storage_cars = config.german_train_cars_supply
			total_cars = storage_cars

			starting_point = locate(/obj/effect/landmark/train/german_supplytrain_start) in world
			limit_point = locate(/obj/effect/landmark/train/german_supplytrain_limit) in world

			if (!starting_point || !limit_point || !istype(starting_point) || !istype(limit_point))
				return // nope

			var/starting_y = starting_point.y
			var/starting_x = starting_point.x
			var/starting_z = starting_point.z

			var/st_di = getAreaDimensions(src, "supply")

			var/cars_width = st_di["width"]

			var/num_spaces = total_cars - TRUE // 2 cars = TRUE space, etc
			var/extra_width = SPACES_BETWEEN_CARS * num_spaces

			total_width = cars_width + extra_width

			var/max_dist = abs(limit_point.x - starting_point.x) + TRUE

			if (total_width > max_dist)
				return // we fucked up. This is a huge train, or there isn't much space between the starting and limit
						// points.

			//	otherwise, continue

			var/x_inc = FALSE
			var/found_first_car = FALSE

			for (var/v in TRUE to storage_cars) // this makes unboarding way easier
				var/obj/train_car_center/tcc = new/obj/train_car_center/germansupply(locate(starting_x+x_inc, starting_y, starting_z), src)
				x_inc += st_di["width"]
				x_inc += SPACES_BETWEEN_CARS
				train_car_centers += tcc
				last_car = tcc

				if (!found_first_car)
					first_car = tcc
					found_first_car = TRUE

			generate_connectors()
			reverse_train_car_centers = reverselist(train_car_centers)

			spawn (0)
				var/datum/train_controller/german_supplytrain_controller/train = src
				for (var/obj/item/weapon/paper/supply_train_requisitions_sheet/paper in world)
					paper.memo = "<br><i>As of the time this was printed, you have [train.supply_points] Supply Requisition Points remaining.</i>"
					paper.regenerate_info()


/datum/train_controller/proc/start_moving(var/_direction) // when the conductor decides to move

	direction = _direction
	moving = TRUE

	var/obj/train_lever/lever = get_lever()

	if (lever)

		switch (direction)
			if ("FORWARDS")
				lever.icon_state = lever.pushed_state
			if ("BACKWARDS")
				lever.icon_state = lever.pulled_state

		lever.direction = direction

/datum/train_controller/proc/stop_moving()

	moving = FALSE
	halting = FALSE

	var/obj/train_lever/lever = get_lever()
	if (lever)
		lever.icon_state = lever.none_state
		lever.direction = "NONE"

/datum/train_controller/proc/update_invisibility(var/on = FALSE)
	if (faction != "GERMAN-SUPPLY")
		return
	invisible = on

	if (on) // make us invisible
		spawn (20)
			for (var/obj/train_car_center/tcc in train_car_centers)
				for (var/obj/train_pseudoturf/tpt in tcc.forwards_pseudoturfs)
					tpt.invisibility = 100
					tpt.density = FALSE
					tpt.opacity = FALSE
					for (var/atom/movable/a in get_turf(tpt))
						if (!istype(a, /obj/effect) && !istype(a, /obj/train_track) && !istype(a, /obj/structure/closet))
							a.invisibility = 100
							a.density = FALSE
							a.opacity = FALSE
						if (istype(a, /obj/machinery/light))
							var/obj/machinery/light/L = a
							L.on = FALSE
							L.update(0, TRUE, TRUE)

			for (var/atom/a in train_connectors)
				a.invisibility = 100
				a.density = FALSE
				a.opacity = FALSE
			for (var/atom/a in train_railings)
				a.invisibility = 100
				a.density = FALSE
				a.opacity = FALSE
	else
		for (var/obj/train_car_center/tcc in train_car_centers)
			for (var/obj/train_pseudoturf/tpt in tcc.forwards_pseudoturfs)
				tpt.invisibility = FALSE
				tpt.density = tpt.initial_density
				tpt.opacity = tpt.initial_opacity
				for (var/atom/movable/a in get_turf(tpt))
					if (!istype(a, /obj/effect) && !istype(a, /obj/train_track) && !istype(a, /obj/structure/closet))
						a.invisibility = FALSE
						a.density = a.initial_density
						a.opacity = a.initial_opacity
					if (istype(a, /obj/machinery/light))
						var/obj/machinery/light/L = a
						L.on = TRUE
						L.update(0, TRUE, TRUE)
					if (istype(a, /obj/structure/simple_door/key_door/anyone/train))
						var/obj/structure/simple_door/key_door/anyone/train/door = a
						door.density = TRUE
						door.opacity = TRUE
						door.state = FALSE
						door.icon_state = door.material.name

		for (var/atom/a in train_connectors)
			a.invisibility = FALSE
			a.density = a.initial_density
			a.opacity = a.initial_opacity
		for (var/atom/a in train_railings)
			a.invisibility = FALSE
			a.density = a.initial_density
			a.opacity = a.initial_opacity

/datum/train_controller/proc/stop_moving_slow() // when the conductor decides to stop
	velocity = 1.0
	halting = TRUE

	spawn (50)
		moving = FALSE
		halting = FALSE
		velocity = initial(velocity)
		var/obj/train_lever/lever = get_lever()
		lever.icon_state = lever.none_state
		lever.direction = "NONE"

/datum/train_controller/proc/started_moving()
	if (!started_moving)
		started_moving = TRUE
		if (faction != "GERMAN-SUPPLY")
			callHook("train_move")
			spawn (1200)
				if (istype(src, /datum/train_controller/german_train_controller))
					train_arrived = TRUE

/datum/train_controller/proc/getMoveInc()
	return inc[direction] * TRUE

/datum/train_controller/german_supplytrain_controller/Process()
	..()

	if (prob((train_loop_interval/10)*100))
		supply_points += (rand(supply_points_per_second_min*100, supply_points_per_second_max*100))/100

	if (direction == "BACKWARDS" && !moving)
		for (var/obj/train_car_center/tcc in train_car_centers)
			for (var/obj/train_pseudoturf/tpt in tcc.forwards_pseudoturfs)
				for (var/obj/item/weapon/paper/supply_train_requisitions_sheet/paper in get_turf(tpt))
					paper.supplytrain_process(src)


/datum/train_controller/proc/Process()
	if (moving)
		if (can_move_check())
			spawn (10)
				started_moving() // regardless of what triggers us to move, make it start the round.

			if (direction == "FORWARDS")
				move_connectors(0)
				for (var/obj/train_car_center/tcc in train_car_centers)
					tcc._Move(direction)
			else if (direction == "BACKWARDS")
				move_connectors(1)
				for (var/obj/train_car_center/tcc in reverse_train_car_centers)
					tcc._Move(direction)
		else
			moving = FALSE
			var/obj/train_lever/lever = get_lever()
			if (lever)
				lever.icon_state = lever.none_state
				lever.direction = "NONE"

/datum/train_controller/proc/move_connectors(var/reverse = FALSE)

	if (!moving)
		return

	var/list/moving_objs = list()

	var/list/tcs = train_connectors
	var/list/trs = train_railings

	if (reverse)
		tcs = reverse_train_connectors
		trs = reverse_train_railings

	for (var/obj/train_connector/tc in tcs)
		if (tc.loc)
			moving_objs += tc

	for (var/obj/structure/railing/train_railing/tr in trs)
		if (tr.loc)
			moving_objs += tr

	for (var/obj/o in moving_objs)
		if (istype(o, /obj/train_connector))
			var/obj/train_connector/tc = o
			tc.save_contents_as_refs()

	for (var/obj/o in moving_objs)
		o:_Move()
		if (istype(o, /obj/train_connector))
			var/obj/train_connector/tc = o
			tc.move_mobs()

	for (var/obj/o in moving_objs)
		if (istype(o, /obj/train_connector))
			var/obj/train_connector/tc = o
			tc.remove_contents_refs()

/datum/train_controller/proc/generate_connectors()

	unoccupy_connectors()
	unoccupy_railings()

	for (var/v in TRUE to train_car_centers.len-1)
		var/obj/train_car_center/current = train_car_centers[v]
		var/obj/train_car_center/next = train_car_centers[v+1]
		current.connect_to(next)

	reverse_train_connectors = reverselist(train_connectors)
	reverse_train_railings = reverselist(train_railings)

/datum/train_controller/proc/unoccupy_connectors()
	for (var/obj/train_connector/tc in train_connectors)
		tc.occupied = FALSE
		tc.loc = null

/datum/train_controller/proc/unoccupy_railings()
	for (var/obj/structure/railing/train_railing/tr in train_railings)
		tr.occupied = FALSE
		tr.loc = null

/datum/train_controller/proc/add_connector(var/turf/t)

	var/obj/train_connector/using = null

	for (var/obj/train_connector/tc in train_connectors)
		if (!tc.occupied)
			using = tc
			break

	if (!using)
		var/obj/train_connector/newc = new/obj/train_connector() // experimental location unique to this map
		using = newc
		train_connectors += newc

	using.master = src
	using.occupied = TRUE
	using.loc = t

/datum/train_controller/proc/add_railing(var/turf/t, var/_dir)

	var/obj/train_connector/using = null

	for (var/obj/structure/railing/train_railing/tr in train_railings)
		if (!tr.occupied)
			using = tr
			break

	if (!using)
		var/obj/structure/railing/train_railing/tr = new/obj/structure/railing/train_railing() // experimental location unique to this map
		using = tr
		train_railings += tr

	using.master = src
	using.occupied = TRUE
	using.loc = t
	using.dir = _dir

/datum/train_controller/proc/can_move_check()

	switch (direction)

		if ("FORWARDS")
			for (var/obj/train_car_center/tcc in train_car_centers)
				if (!last_car || last_car == tcc)
					for (var/obj/train_pseudoturf/tpt in tcc.forwards_pseudoturfs)
						switch (orientation)
							if (VERTICAL)
								if (tpt.y + getMoveInc() < limit_point.y) // since y decreases as we go down
									if (istype(src, /datum/train_controller/german_train_controller))
										train_arrived = TRUE
									return FALSE // + getMoveInc() because getMoveInc() handles signs
							if (HORIZONTAL)
								if (tpt.x + getMoveInc() > limit_point.x)
									return FALSE // + getMoveInc() because getMoveInc() handles signs

		if ("BACKWARDS")
			for (var/obj/train_car_center/tcc in reverse_train_car_centers)
				if (!first_car || first_car == tcc)
					for (var/obj/train_pseudoturf/tpt in tcc.backwards_pseudoturfs)
						switch (orientation)
							if (VERTICAL)
								if (tpt.y + getMoveInc() > starting_point.y)
									return FALSE
							if (HORIZONTAL)
								if (tpt.x + getMoveInc() < starting_point.x)
									return FALSE
	return TRUE

/datum/train_controller/proc/coming_to_halt()
	if (moving && can_move_check())

		if (halting)
			return TRUE

		switch (direction)

			if ("FORWARDS")
				for (var/obj/train_car_center/tcc in train_car_centers)
					for (var/obj/train_pseudoturf/tpt in tcc.forwards_pseudoturfs)
						switch (orientation)
							if (VERTICAL)
								if (abs(tpt.y - limit_point.y) < 20) // since y decreases as we go down
									return TRUE
							if (HORIZONTAL)
								if (abs(tpt.x - limit_point.x) < 20) // since y decreases as we go down
									return TRUE
			if ("BACKWARDS")
				for (var/obj/train_car_center/tcc in train_car_centers)
					for (var/obj/train_pseudoturf/tpt in tcc.backwards_pseudoturfs)
						switch (orientation)
							if (VERTICAL)
								if (abs(tpt.y - starting_point.y) < 20) // since y decreases as we go down
									return TRUE
							if (HORIZONTAL)
								if (abs(tpt.x - starting_point.x) < 20) // since y decreases as we go down
									return TRUE
	return FALSE


/datum/train_controller/proc/sound_loop()

	//prioritize haltings
	if (last_played["halting"] == -1 || world.time - last_played["halting"] >= halting_sound_delay)
		if (coming_to_halt() && playing == "")
			last_played["halting"] = world.time
			play_halting_sound()
			playing = "halting"
			spawn (halting_sound_delay)
				playing = ""

	if (last_played["movement"] == -1 || world.time - last_played["movement"] >= movement_sound_delay)
		if (moving && can_move_check() && playing == "")
			last_played["movement"] = world.time
			play_movement_sound()
			playing = "movement"
			spawn (movement_sound_delay)
				playing = ""


/datum/train_controller/proc/play_movement_sound()
	play_train_sound("train_movement")

/datum/train_controller/proc/play_halting_sound()
	play_train_sound("train_halting")

/datum/train_controller/proc/play_train_sound(var/sound)
	for (var/mob/m in player_list)
		if (istype(m) && m.client)
			var/obj/train_car_center/german/tcc = locate(my_tcc_type) in range(20, m)
			if (tcc && istype(tcc))
				var/volume = 100
				if (!locate(/obj/train_connector) in get_turf(m))
					var/abs_dist_from_tcc = abs(m.x - tcc.x) + abs(m.y - tcc.y)
					volume = rand(80,90) - abs_dist_from_tcc
					m.client.playsound_personal(sound, volume)
				else
					m.client.playsound_personal(sound, volume)

/datum/train_controller/proc/check_can_move_mob(var/mob/m)
	return TRUE

/datum/train_controller/proc/opposing_directions_check(var/mob/m)
	if (direction == "FORWARDS" && m.dir == NORTH)
		return TRUE
	else if (direction == "BACKWARDS" && m.dir == SOUTH)
		return TRUE
	return FALSE

