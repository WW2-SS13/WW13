/obj/structure/mortar
	name = "Mortar that shouldn't exist"
	icon = 'icons/WW2/mortar.dmi'
	layer = MOB_LAYER + 1 //just above mobs
	density = TRUE
	icon_state = null
	var/angle = 65
	var/travelled = 0
	var/max_distance = 0
	var/high_distance = 0
	var/high = TRUE
	var/mob/user = null
	var/obj/item/mortar_shell/loaded = null

/obj/structure/mortar/ex_act(severity)
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

/obj/structure/mortar/attack_hand(var/mob/attacker)
	interact(attacker)

// todo: loading artillery. This will regenerate the shrapnel and affect our explosion
/obj/structure/mortar/attackby(obj/item/W as obj, mob/M as mob)
	if (istype(W, /obj/item/mortar_shell))
		if (loaded)
			M << "<span class = 'warning'>There's already a shell loaded.</span>"
			return
		// load first and only slot
		M.remove_from_mob(W)
		W.loc = src
		loaded = W
		if (M == user)
			do_html(M)


/obj/structure/mortar/interact(var/mob/m)
	if (user)
		if (get_dist(src, user) > 1)
			user = null
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

/obj/structure/mortar/Topic(href, href_list, hsrc)

	var/mob/user = usr

	if (!user || user.lying)
		return

	user.face_atom(src)

	if (!locate(src) in get_step(user, user.dir))
		user << "<span class = 'danger'>Get behind the mortar to use it.</span>"
		return FALSE

	if (!user.can_use_hands())
		user << "<span class = 'danger'>You have no hands to use this with.</span>"
		return FALSE

	if (href_list["load"])
		var/obj/item/mortar_shell/M = user.get_active_hand()
		if (M && istype(M))
			user.remove_from_mob(M)
			M.loc = src
			loaded = M

	if (href_list["set_angle"])
		angle = input(user, "Set the angle to what? (From 45° to 80°)") as num
		angle = Clamp(angle, 45, 80)

	if (href_list["fire"])

		if (map && !map.soviets_can_cross_blocks())
			user << "<span class = 'danger'>You can't fire yet.</span>"
			return

		if (!loaded)
			user << "<span class = 'danger'>There's nothing in the mortar.</span>"
			return

		var/area/user_area = get_area(user)

		if (user_area.location == AREA_INSIDE)
			user << "<span class = 'danger'>You can't fire from inside.</span>"
		else if (do_mob(user, user, 20))

			// firing code

			// screen shake
			for (var/mob/m in player_list)
				if (m.client)
					var/abs_dist = abs(m.x - x) + abs(m.y - y)
					if (abs_dist <= 37)
						shake_camera(m, 3, (5 - (abs_dist/10)))

			// smoke
			spawn (rand(3,4))
				new/obj/effect/effect/smoke/chem(get_step(src, dir))
			spawn (rand(5,6))
				new/obj/effect/effect/smoke/chem(get_step(src, dir))

			// sound
			spawn (rand(1,2))
				var/turf/t1 = get_turf(src)
				var/list/heard = playsound(t1, "artillery_out", 50, TRUE)
				playsound(t1, "artillery_out_distant", 50, TRUE, excluded = heard)

			// actual hit somewhere (or not)
			var/turf/target = get_turf(src)
			var/odir = dir

			do_distance_calcs()
			travelled = 0
			high = TRUE
			qdel(loaded)
			loaded = null

			spawn (0)
				for (var/v in 1 to max_distance)

					if (v > high_distance)
						high = FALSE

					var/hit = FALSE

					switch (odir)
						if (EAST)
							target = locate(target.x+1, target.y + (prob(20) ? pick(1,-1) : 0), z)
						if (WEST)
							target = locate(target.x-1, target.y + (prob(20) ? pick(1,-1) : 0), z)
						if (NORTH)
							target = locate(target.x + (prob(20) ? pick(1,-1) : 0), target.y+1, z)
						if (SOUTH)
							target = locate(target.y + (prob(20) ? pick(1,-1) : 0), target.y-1, z)

					if (!target) // somehow
						break


					var/highcheck = high
					var/area/target_area = get_area(target)
					if (target_area.location == AREA_INSIDE)
						highcheck = FALSE

					if (v >= max_distance)
						hit = TRUE
					else if (target.density && !highcheck)
						hit = TRUE
					else if (!(target in range(1, get_turf(src))))
						if (!highcheck)
							for (var/atom/movable/AM in target)
								// go over sandbags
								if (AM.density && !(AM.flags & ON_BORDER))
									var/obj/structure/S = AM
									// go over some structures
									if (istype(S) && S.low)
										continue
									hit = TRUE
									break
					else if (target.x == 1 || target.x == world.maxx)
						hit = TRUE
					else if (target.y == 1 || target.y == world.maxy)
						hit = TRUE
					else if (istype(get_area(get_step(target, odir)), /area/prishtina/void))
						hit = TRUE

					if (hit)
						explosion(target, 1, 2, 3, 4)
						break

					sleep(0.5)

	do_html(user)

/obj/structure/mortar/proc/do_html(var/mob/m)

	if (m)

		do_distance_calcs()

		m << browse({"

		<br>
		<html>

		<head>
		<style>
		[common_browser_style]
		</style>
		</head>

		<body>

		<script language="javascript">

		function set(input) {
		  window.location="byond://?src=\ref[src];action="+input.name+"&value="+input.value;
		}

		</script>

		<center>
		<big><b>[name]</b></big><br><br>
		</center>
		Shell: <a href='?src=\ref[src];load=1'>[loaded ? loaded.name : "No shell loaded"]</a><br><br>
		Angle: <a href='?src=\ref[src];set_angle=1'>[angle]° (~[max_distance] meters)</a><br><br>
		<br>
		<center>
		<a href='?src=\ref[src];fire=1'><b><big>FIRE!</big></b></a>
		</center>

		</body>
		</html>
		<br>
		"},  "window=artillery_window;border=1;can_close=1;can_resize=1;can_minimize=0;titlebar=1;size=500x500")
	//		<A href = '?src=\ref[src];topic_type=[topic_custom_input];continue_num=1'>

/obj/structure/mortar/proc/do_distance_calcs()
	switch (angle)
		if (45 to 49)
			var/refangle = (49 - angle) + 45
			max_distance = round(refangle * 1.54) // 69 to 75
			high_distance = round(max_distance * 0.80)
		if (50 to 59)
			var/refangle = (59 - angle) + 50
			max_distance = round(refangle * 1.00) // 50 to 59
			high_distance = round(max_distance * 0.85)
		if (60 to 69)
			var/refangle = (69 - angle) + 60
			max_distance = round(refangle * 0.50) // 30 to 34
			high_distance = round(max_distance * 0.90)
		if (70 to 80)
			var/refangle = (80 - angle) + 70
			max_distance = round(refangle * 0.33) // 23 to 26
			high_distance = round(max_distance * 0.95)