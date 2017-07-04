/obj/gasser
	icon = null
	icon_state = null
	anchored = 1.0
	name = ""

/obj/gasser/proc/function()

	var/list/chemsmokes = list()

	for (var/v in 1 to 5)
		spawn ((v*5) - 5)
			var/obj/effect/effect/smoke/chem/smoke = new/obj/effect/effect/smoke/chem/payload/zyklon_b(get_turf(src), _spread = 1)
			chemsmokes += smoke
	// shitty solution since I can't get the chems to spread on to people - Kachnov

	for (var/s in 1 to chemsmokes.len)
		var/obj/effect/effect/smoke/chem/smoke = chemsmokes[s]
		for (var/v in 1 to 20)
			spawn (v * 10)
				if (istype(get_area(smoke), /area/prishtina/void/german/ss_train/gas_chamber/gas_room))
					for(var/datum/reagent/R in smoke.reagents.reagent_list)
						for (var/mob/m in get_turf(smoke))
							R.touch_mob(m, 20)
				else
					qdel(smoke) // we're too far away now anyway


/obj/gas_lever // same icon as the train lever for now
	anchored = 1.0
	density = 1
	icon = 'icons/WW2/train_lever.dmi'
	icon_state = "lever_none"
	var/none_state = "lever_none"
	var/pushed_state = "lever_pushed"
	var/orientation = "NONE"
	name = "gassing lever"

/obj/gas_lever/attack_hand(var/mob/user as mob)
	if (user && istype(user, /mob/living/carbon/human))
		if (orientation == "NONE")
			icon_state = pushed_state
			orientation = "PUSHED"
			visible_message("<span class = 'danger'>[user] pushes the lever forwards!</span>")
			for (var/obj/gasser/gasser in range(10, src))
				gasser.function()
		else if (orientation == "PUSHED")
			icon_state = none_state
			orientation = "NONE"
			visible_message("<span class = 'danger'>[user] pulls the lever back.</span>")
