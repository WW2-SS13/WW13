//parent object
/obj/machinery/artillery
	name = "Artillery"

/obj/machinery/artillery/New(var/loc, var/mob/builder, var/dir)

	if (!dir)
		dir = SOUTH

	if (!artillery_master)
		artillery_master = new/datum/artillery_controller

	var/fake_builder = FALSE

	if (builder == null && dir != null)
		builder = new/mob(loc)
		builder.dir = dir
		fake_builder = TRUE

	var/obj/machinery/artillery/base/base = new/obj/machinery/artillery/base(loc)
	var/obj/machinery/artillery/tube/tube = new/obj/machinery/artillery/tube(get_step(base, base.dir))
	base.dir = builder.dir
	tube.dir = builder.dir
	base.other = tube
	tube.other = base
	base.anchored = FALSE
	tube.anchored = TRUE

	if (fake_builder)
		qdel(builder)

	qdel(src)

#define BLIND_FIRE_RANGES list("SHORT", "MEDIUM", "LONG")
#define BLIND_FIRE_DISTANCES list("SHORT" = "25:30", "MEDIUM" = "50:60", "LONG" = "75:90")

//first piece
/obj/machinery/artillery/base
	var/list/ejections = list()
	var/obj/item/artillery_ammo/loaded = null
	var/obj/machinery/artillery/tube/other
	var/offset_x = FALSE
	var/offset_y = FALSE
	var/mob/user = null
	var/state = "CLOSED"
	var/casing_state = "casing"

	// setting for 'blind firing'
	var/blind_fire_toggle = FALSE
	var/blind_fire_dir = SOUTH
	var/blind_fire_dir2 = "NONE"
	var/blind_fire_range = "SHORT"

	density = TRUE
	name = "7,5 cm FK 18"
	icon = 'icons/WW2/artillery_piece.dmi'
	icon_state = "base"
	layer = MOB_LAYER + TRUE //just above mobs

	proc/get_blind_fire_dir()
		switch (blind_fire_dir)
			if (NORTH)
				return "NORTH"
			if (EAST)
				return "EAST"
			if (SOUTH)
				return "SOUTH"
			if (WEST)
				return "WEST"

	proc/get_blind_fire_dir2()
		switch (blind_fire_dir2)
			if (EAST)
				return "EAST"
			if (WEST)
				return "WEST"
			if ("NONE")
				return "NONE"

	proc/do_html(var/mob/m)


		if (m)

			m << browse({"

			<html>

			<body style='background-color:#1D2951; color:#ffffff'>

			<script language="javascript">

			function set(input) {
			  window.location="byond://?src=\ref[src];action="+input.name+"&value="+input.value;
			}

			</script>

			<center>
			<big><b>[name]</b></big><br><br>
			<a href='?src=\ref[src];open=1'>Open the shell slot</a><br>
			<a href='?src=\ref[src];close=1'>Close the shell slot</a><br><br>
			<b>Loaded Shells</b><br><br>
			<a href='?src=\ref[src];load_slot_1=1'>[loaded.name]</a><br><br>
			<b>Firing Options</b><br><br>
			Artillery Piece X-coordinate:<input type="text" name="xcoord" readonly value="[x]" onchange="set(this);" /><br>
			Artillery Piece Y-coordinate:<input type="text" name="ycoord" readonly value="[y]" onchange="set(this);" /><br>
			Offset X-coordinate:<input type="text" name="xocoord" value="[offset_x]" onchange="set(this);" /><br>
			Offset Y-coordinate:<input type="text" name="yocoord" value="[offset_y]" onchange="set(this);" /><br>
			Fire At X-coordinate:<input type="text" name="xplusxocoord" value="[offset_x + x]" onchange="set(this);" /><br>
			Fire At Y-coordinate:<input type="text" name="yplusyocoord" value="[offset_y + y]" onchange="set(this);" /><br>
			Blind Firing:
			&nbsp;<a href='?src=\ref[src];blind_fire_toggle=1'>[blind_fire_toggle ? "YES" : "NO"]</a>
			&nbsp;<a href='?src=\ref[src];blind_fire_dir=1'>[get_blind_fire_dir()]</a>
			&nbsp;<a href='?src=\ref[src];blind_fire_dir2=1'>[get_blind_fire_dir2()]</a>
			&nbsp;<a href='?src=\ref[src];blind_fire_dist=1'>[blind_fire_range]</a>
			<br>
			<br>
			<a href='?src=\ref[src];fire=1'><b><big>FIRE!</big></b></a>
			</center>

			</body>

			</html>
			"},  "window=artillery_window;border=1;can_close=1;can_resize=1;can_minimize=0;titlebar=1;size=500x500")
		//		<A href = '?src=\ref[src];topic_type=[topic_custom_input];continue_num=1'>

	interact(var/mob/m)
		restart
		if (user && user != m)
			if (user.client)
				return
			else
				user = null
				goto restart
		else
			user = m
			do_html(user)


	Move()
		global.valid_coordinates["[x],[y]"] = FALSE
		..()
		other.loc = (get_step(src, dir) || loc)
		global.valid_coordinates["[x],[y]"] = TRUE


/obj/machinery/artillery/base/New()

	loaded = new/obj/item/artillery_ammo/none(src)

	for (var/v in TRUE to 20)
		var/obj/item/weapon/material/shard/shard = new/obj/item/weapon/material/shard/shrapnel(src)
		ejections.Add(shard)

	artillery_master.artillery_bases += src

/obj/machinery/artillery/base/proc/getNextOpeningClosingState()

	if (state == "CLOSED")
		return "opening"
	else
		if (loaded)
			return "closing_with_shell"
		else
			return "closing_without_shell"

/obj/machinery/artillery/base/Topic(href, href_list, hsrc)

	if (!user)
		return

	if (!user.lying)

		user.face_atom(src)

		if (!locate(src) in get_step(user, user.dir))
			user << "<span class = 'danger'>Get behind the artillery to use it.</span>"
			return FALSE

		if (!user.can_use_hands())
			user << "<span class = 'danger'>You have no hands to use this with.</span>"
			return FALSE

		if (!anchored)
			user << "<span class = 'danger'>The artillery piece must be anchored to use.</span>"
			return FALSE

		var/value = href_list["value"]

		switch (href_list["action"])
			//we can enter offsets directly
			if ("xocoord")
				offset_x = text2num(value)
			if ("yocoord")
				offset_y = text2num(value)
			//or enter the firing location directly and have them generated
			if ("xplusxocoord")
				var/val = text2num(value)
				offset_x = val - x
			if ("yplusyocoord")
				var/val = text2num(value)
				offset_y = val - y

		if (href_list["fire"])
			if ("fire")
				var/user_area = get_area(user)

				var/failure_msg = "<span class = 'danger'>You can't fire from here.</span>"

				if (istype(user_area, /area/prishtina/soviet/bunker))
					user << failure_msg
					return
				if (istype(user_area, /area/prishtina/soviet/bunker_entrance))
					user << failure_msg
					return
				if (istype(user_area, /area/prishtina/houses))
					user << failure_msg
					return

				if (state == "OPEN")
					user << "<span class='danger'>Close the shell loading slot first.</span>"
					return

				if (blind_fire_toggle)

					offset_x = FALSE
					offset_y = FALSE

					var/number_range = splittext(BLIND_FIRE_DISTANCES[blind_fire_range], ":")
					var/lowerbound = text2num(number_range[1])
					var/upperbound = text2num(number_range[2])
					var/add = rand(lowerbound, upperbound)

					switch (blind_fire_dir)
						if (NORTH)
							offset_y += add
						if (SOUTH)
							offset_y -= add
						if (EAST)
							offset_x += add
						if (WEST)
							offset_x -= add

					if (dir == NORTH || dir == SOUTH)
						switch (blind_fire_dir2)
							if (EAST)
								offset_x += add/2
							if (WEST)
								offset_x -= add/2


				var/target_x = offset_x + x
				var/target_y = offset_y + y

				target_x = min(max(target_x, TRUE), world.maxx)
				target_y = min(max(target_y, TRUE), world.maxy)

				var/valid_coords_check = FALSE

				if (!blind_fire_toggle)
					if (global.valid_coordinates.Find("[target_x],[target_y]"))
						valid_coords_check = TRUE
					else
						for (var/coords in global.valid_coordinates)
							var/splitcoords = splittext(coords, ",")
							var/coordx = text2num(splitcoords[1])
							var/coordy = text2num(splitcoords[2])
							if (abs(coordx - target_x) <= 15)
								if (abs(coordy - target_y) <= 15)
									valid_coords_check = TRUE
				else
					valid_coords_check = TRUE

				if (!valid_coords_check)
					user << "<span class='danger'>You have no knowledge of this location.</span>"
					return

				if (abs(offset_x) > FALSE || abs(offset_y) > FALSE)
					if (abs(offset_x) + abs(offset_y) < 20)
						user << "<span class='danger'>This location is too close to fire to.</span>"
						return
					else
						var/obj/item/artillery_ammo/shell = other.use_slot()
						if (shell)
							other.fire(target_x, target_y, shell)
						else
							user << "<span class='danger'>Load a shell in first.</span>"
							return
				else
					user << "<span class='danger>Set an offset x and offset y coordinate.</span>"
					return

		if (href_list["open"])
			if (state == "OPEN")
				return
			flick("opening", src)
			spawn (8)
				icon_state = "open"
				state = "OPEN"
			spawn (6)
				if (other.drop_casing)
					var/obj/o = new/obj/item/artillery_ammo/casing(get_step(src, dir))
					o.icon_state = casing_state
					user << "<span class='danger'>The casing falls out of the artillery.</span>"
					other.drop_casing = FALSE
					playsound(get_turf(src), 'sound/effects/Stamp.wav', 100, TRUE)

		if (href_list["close"])
			if (state == "CLOSED")
				return
			flick("closing", src)
			spawn (12)
				icon_state = ""
				state = "CLOSED"

		for (var/i in TRUE to 10)
			if (href_list["load_slot_[i]"])
				if (state == "CLOSED")
					user << "<span class = 'danger'>The shell loading slot must be open to add a shell.</span>"
					return
				var/obj/o = user.get_active_hand()
				var/cond_1 = o && istype(o, /obj/item/artillery_ammo) && !istype(o, /obj/item/artillery_ammo/casing)
				var/cond_2 = !o

				if (cond_1 || cond_2)

					if (!istype(loaded, /obj/item/artillery_ammo/none))
						loaded.loc = get_turf(user)

					if (o)
						user.drop_from_inventory(o)
						o.loc = src
						loaded = o
						icon_state = "open_with_shell"
						state = "OPEN"
					else
						icon_state = "open"
						state = "OPEN"



		//	flick("opening", src)


		// blind firing

		if (href_list["blind_fire_toggle"])
			blind_fire_toggle = !blind_fire_toggle


		if (href_list["blind_fire_dist"])
			switch (blind_fire_range)
				if ("SHORT")
					blind_fire_range = "MEDIUM"
				if ("MEDIUM")
					blind_fire_range = "LONG"
				if ("LONG")
					blind_fire_range = "SHORT"

		// no cardinal directions for now
		if (href_list["blind_fire_dir"])

			switch (blind_fire_dir)
				if (NORTH)
					blind_fire_dir = EAST
				if (EAST)
					blind_fire_dir = SOUTH
				if (SOUTH)
					blind_fire_dir = WEST
				if (WEST)
					blind_fire_dir = NORTH

			if (blind_fire_dir != SOUTH && blind_fire_dir != NORTH)
				blind_fire_dir2 = "NONE"

		if (href_list["blind_fire_dir2"])

			if (blind_fire_dir != SOUTH && blind_fire_dir != NORTH)
				blind_fire_dir2 = "NONE"
			else
				switch (blind_fire_dir2)
					if ("NONE")
						blind_fire_dir2 = EAST
					if (EAST)
						blind_fire_dir2 = WEST
					if (WEST)
						blind_fire_dir2 = "NONE"



		do_html(user)


/obj/machinery/artillery/base/attack_hand(var/mob/attacker)
	interact(attacker)

// todo: loading artillery. This will regenerate the shrapnel and affect our explosion
/obj/machinery/artillery/base/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		if (anchored)
			playsound(loc, 'sound/items/Ratchet.ogg', 100, TRUE)
			user << "<span class='notice'>Now unsecuring the artillery piece...</span>"
			if(do_after(user,20))
				if(!src) return
				user << "<span class='notice'>You unsecured the artillery piece.</span>"
				anchored = FALSE
		else if(!anchored)
			playsound(loc, 'sound/items/Ratchet.ogg', 100, TRUE)
			user << "<span class='notice'>Now securing the artillery piece...</span>"
			if(do_after(user, 20))
				if (!src) return
				user << "<span class='notice'>You secured the artillery piece.</span>"
				anchored = TRUE
	//second piece
/obj/machinery/artillery/tube
	var/obj/machinery/artillery/base/other = null
	icon_state = "tube"
	name = ""
	layer = FALSE
	var/drop_casing = FALSE

	proc/fire(var/x, var/y, shell)

		var/num_shrapnel = FALSE
		var/explosion = FALSE
		var/reagent_payload = null

		if (!istype(shell, /obj/item/artillery_ammo/gaseous))
			num_shrapnel = rand(15,20)
			explosion = TRUE
		else
			var/obj/item/artillery_ammo/gaseous/g = shell
			reagent_payload = g.reagent_payload

		if (istype(shell, /obj/item/artillery_ammo))
			var/obj/item/artillery_ammo/shell2 = shell
			other.casing_state = shell2.casing_state

		qdel(shell)

		z = other.z //mostly for testing, such as when you teleport the base

		drop_casing = TRUE

		var/list/shrapnel = list()

		for (var/v in TRUE to num_shrapnel)
			var/shrap = pick(other.ejections)
			if (shrap)
				shrapnel += shrap
				other.ejections -= shrap

		for (var/v in TRUE to num_shrapnel)
			other.ejections += new/obj/item/artillery_ammo()

		other.icon_state = "firing"

		for (var/mob/m in player_list)
			if (m.client)
				var/abs_dist = abs(m.x - other.x) + abs(m.y - other.y)
				if (abs_dist <= 75)
					shake_camera(m, 5, (5 - (abs_dist/20)))


		spawn (10)
			other.icon_state = initial(other.icon_state)

		var/dirX = "NONE"
		var/dirY = "NONE"
		var/direction = NORTH

		if (x > other.x)
			dirX = "EAST"
		else if (x < other.x)
			dirX = "WEST"

		if (y > other.y)
			dirY = "NORTH"
		else if (y < other.y)
			dirY = "SOUTH"

		switch (dirY)
			if ("SOUTH")
				switch (dirX)
					if ("EAST")
						direction = SOUTHEAST
					if ("WEST")
						direction = SOUTHWEST
					if ("NONE")
						direction = SOUTH
			if ("NORTH")
				switch (dirX)
					if ("EAST")
						direction = NORTHEAST
					if ("WEST")
						direction = NORTHEAST
					if ("NONE")
						direction = NORTH
			if ("NONE")
				switch (dirX)
					if ("EAST")
						direction = EAST
					if ("WEST")
						direction = WEST
					if ("NONE")
						direction = null

		if (direction != null) // how did this even happen
			spawn (rand(4,6))
				new/obj/effect/effect/smoke/chem(get_step(src, direction))
			spawn (rand(5,7))
				new/obj/effect/effect/smoke/chem(get_step(src, direction))
			spawn (rand(6,7))
				new/obj/effect/effect/smoke/chem(get_step(src, direction))
			spawn (5)
				new/obj/effect/effect/smoke/chem(get_step(src, pick(NORTH, EAST, SOUTH, WEST)))

		spawn (rand(1,2))
			var/turf/t1 = get_turf(src)
			var/list/heard = playsound(t1, "artillery_out", 100, TRUE)
			playsound(t1, "artillery_out_distant", 100, TRUE, excluded = heard)

		x = x + rand(1,-1)
		y = y + rand(1,-1)

		var/turf/t = locate(x, y, z)

		if (!t)
			return

		var/area/t_area = get_area(t)

		var/is_indoors = FALSE
		var/artillery_deflection_bonus = FALSE

		if (istype(t_area, /area/prishtina/void))
			return FALSE

		if (istype(t_area, /area/prishtina/admin))
			return FALSE

		if (istype(t_area, /area/prishtina/soviet/bunker))
			is_indoors = TRUE
			artillery_deflection_bonus = 55 // experimental

		if (istype(t_area, /area/prishtina/soviet/bunker_entrance))
			is_indoors = TRUE

		var/power_mult = TRUE //experimental. 2 is a bit high.

		var/travel_time = FALSE

		var/abs_dist = abs(t.x - other.x) + abs(t.y - other.y)

		travel_time = abs((round(abs_dist/50) * 10)) + 20 // must be at least 2 seconds for the incoming sound to
		// work right

		spawn (travel_time - 20) // the new artillery sound takes about 2 seconds to reach the explosion point, so start playing it now
			var/list/heard = playsound(t, "artillery_in", 100, TRUE)
			playsound(t, "artillery_in_distant", 100, TRUE, 100, excluded = heard)

		spawn (travel_time)

			// allows shells aimed at ladders to go down ladders - Kachnov

			if (locate(/obj/structure/multiz) in t)
				if (prob(50))
					visible_message("<span class = 'danger'>An artillery shell goes down the ladders!</span>")
					for (var/obj/structure/multiz/warp in t)
						if (warp.target)
							t = get_turf(warp.target)
							break

			if (istrueflooring(t) || iswall(t) || is_indoors)
				var/area/a = t.loc
				if (prob(a.artillery_integrity))
					for (var/mob/m in range(20, t))
						shake_camera(m, 5, 5)
						m << "<span class = 'danger'>You hear something violently smash into the ceiling!</span>"
					if (prob(100 - artillery_deflection_bonus))
						if (explosion) // HE master race
							a.artillery_integrity -= rand(25,30)
							a.update_snowfall_valid_turfs()
						else
							a.artillery_integrity -= rand(15,20)
							a.update_snowfall_valid_turfs()
					return
				else
					t.visible_message("<span class = 'danger'>The ceiling collapses!</span>")

			if (explosion)
				explosion(t, 2*power_mult, 4*power_mult, 6*power_mult, 9*power_mult)
				// extra effective against tonks
				for (var/obj/tank/T in range(1, t))
					T.ex_act(1.0, TRUE)
			else
				var/how_many = rand(20,30) // was 40, 50
				for (var/v in TRUE to how_many)
					switch (reagent_payload)
						if ("chlorine_gas")
							new/obj/effect/effect/smoke/chem/payload/chlorine_gas(t)
						if ("mustard_gas")
							new/obj/effect/effect/smoke/chem/payload/mustard_gas(t)
						if ("white_phosphorus_gas")
							new/obj/effect/effect/smoke/chem/payload/white_phosphorus_gas(t)
						if ("xylyl_bromide")
							new/obj/effect/effect/smoke/chem/payload/xylyl_bromide(t)

			var/list/atoms_in_range = list()

			for (var/turf/tt in range(12, t))
				atoms_in_range.Add(tt)

			for (var/obj/o in range(12, t))
				atoms_in_range.Add(o)

			var/list/mobs_in_range = list()

			for (var/mob/m in range(12, t))
				if (!m.lying)
					mobs_in_range.Add(m)

			if (shrapnel.len > FALSE)
				for (var/obj/item/weapon/material/shard/shrapnel/shrap in shrapnel)
					if (shrap)
						shrap.loc = t
						if (prob(33))
							if (mobs_in_range.len > FALSE)
								var/mob/m = pick(mobs_in_range)
								if (m)
									shrap.throw_at(m, 10)
						else
							if (atoms_in_range.len > FALSE)
								var/atom/a = pick(atoms_in_range)
								if (a)
									shrap.throw_at(a, 10)

/obj/machinery/artillery/tube/proc/use_slot()

	var/orig = null
	if (istype(other.loaded, /obj/item/artillery_ammo))
		orig = other.loaded
		if (!istype(other.loaded, /obj/item/artillery_ammo/none))
			if (!istype(other.loaded, /obj/item/artillery_ammo/casing))
				other.loaded = new/obj/item/artillery_ammo/none(src)
				return orig
	else
		return orig

/obj/machinery/artillery/tube/interact(var/mob/m)
	return

/obj/machinery/artillery/tube/New()
	return

/obj/machinery/artillery/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(10))
				qdel(src)
				return
		if(3.0)
			return