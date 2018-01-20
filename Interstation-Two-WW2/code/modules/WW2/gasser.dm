/obj/gasser
	icon = null
	icon_state = null
	anchored = 1.0
	name = ""

/obj/gasser/proc/function()

	var/list/chemsmokes = list()
	var/list/target_turfs = list()
	var/area/target_area = locate(/area/prishtina/void/german/ss_train/gas_chamber/gas_room)

	if (istype(get_area(src), /area/prishtina/german))
		target_area = locate(/area/prishtina/german/gas_chamber)

	for (var/turf/t in target_area.contents)
		target_turfs += t

	for (var/v in TRUE to rand(2,3))
		spawn ((v*2) - 2)
			var/obj/effect/effect/smoke/chem/smoke = new/obj/effect/effect/smoke/chem/payload/zyklon_b(get_turf(src), _spread = TRUE, _destination = get_step(src, EAST))
			smoke.dontmove = TRUE
			chemsmokes += smoke

	// make the smoke randomly move around
	for (var/v in TRUE to 10)
		spawn (v * 20)
			for (var/obj/effect/effect/smoke/chem/smoke in chemsmokes)
				walk_to(smoke, pick(target_turfs),0,rand(2,3),0)

/obj/gas_lever // same icon as the train lever for now
	anchored = 1.0
	density = TRUE
	icon = 'icons/WW2/train_lever.dmi'
	icon_state = "lever_none"
	var/none_state = "lever_none"
	var/pushed_state = "lever_pushed"
	var/orientation = "NONE"
	name = "gassing lever"
	var/next_use = -1

/obj/gas_lever/attack_hand(var/mob/user as mob)
	if (world.time < next_use && next_use != -1)
		return

	next_use = world.time + 25

	if (user && istype(user, /mob/living/carbon/human))
		if (orientation == "NONE")
			icon_state = pushed_state
			orientation = "PUSHED"
			visible_message("<span class = 'danger'>[user] pushes the lever forwards!</span>", "<span class = 'notice'>You push the lever forwards.</span>")
			for (var/obj/gasser/gasser in range(10, src))
				gasser.function()
		else if (orientation == "PUSHED")
			icon_state = none_state
			orientation = "NONE"
			visible_message("<span class = 'danger'>[user] pulls the lever back.</span>", "<span class = 'notice'>You pull the lever back.</span>")
