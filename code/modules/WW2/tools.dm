/*****************************Shovel********************************/

/obj/item/weapon/shovel
	name = "shovel"
	desc = "A large tool for digging and moving dirt."
	icon = 'icons/obj/items.dmi'
	icon_state = "shovel"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 8.0
	throwforce = 4.0
	item_state = "shovel"
	w_class = 3.0
	matter = list(DEFAULT_WALL_MATERIAL = 50)
//	origin_tech = "materials=1;engineering=1"
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")
	sharp = FALSE
	edge = TRUE
	slot_flags = SLOT_BACK|SLOT_BELT
	var/dig_speed = 7

/obj/item/weapon/shovel/spade
	name = "spade"
	desc = "A small tool for digging and moving dirt."
	icon_state = "spade"
	item_state = "spade"
	force = 15.0
	throwforce = 20.0
	w_class = 2.0
	weight = 1.18
	dig_speed = 1

/obj/item/weapon/shovel/spade/russia
	name = "lopata"
	icon_state = "lopata"
	item_state = "lopata"
	dig_speed = 4

/obj/item/weapon/shovel/spade/german
	name = "feldspaten"
	icon_state = "german_shovel2"
	item_state = "lopata"
	dig_speed = 3

/obj/item/weapon/shovel/spade/japan
	name = "japanese field shovel"
	icon_state = "lopata"
	item_state = "lopata"
	dig_speed = 4

/obj/item/weapon/shovel/spade/usa
	name = "american field shovel"
	icon_state = "german_shovel2"
	item_state = "lopata"
	dig_speed = 3

/obj/item/weapon/shovel/spade/mortar
	name = "spade mortar"
	icon_state = "spade_mortar"
	item_state = "lopata"
	desc = "A 37mm mortar that also functions as a shovel. Very heavy."
	weight = 20
	heavy = TRUE
	dig_speed = 2

/obj/item/weapon/shovel/spade/mortar/New()
	..()
	mortar_spade_list += src

/obj/item/weapon/shovel/spade/mortar/Destroy()
	mortar_spade_list -= src
	..()
/obj/item/weapon/shovel/attack_self(var/mob/user as mob)
	var/mob/living/carbon/human/H = user
	var/turf/currentturf = get_turf(src)
	if ((istype(currentturf, /turf/floor/dirt) || istype(currentturf, /turf/floor/plating/dirt)) && istype(H) && !H.shoveling_dirt)
		if (currentturf.available_dirt >= 1)
			H.shoveling_dirt = TRUE
			visible_message("<span class = 'notice'>[H] starts to shovel dirt into a pile.</span>", "<span class = 'notice'>You start to shovel dirt into a pile.</span>")
			playsound(src,'sound/effects/shovelling.ogg',100,1)
			if (do_after(H, rand(45,60)))
				visible_message("<span class = 'notice'>[H] shovels dirt into a pile.</span>", "<span class = 'notice'>You shovel dirt into a pile.</span>")
				H.shoveling_dirt = FALSE
				currentturf.available_dirt -= 1
				new /obj/item/weapon/dirt_wall(currentturf)
			else
				H.shoveling_dirt = FALSE
		else
			H << "<span class='notice'>All the loose dirt has been shoveled out of this spot already.</span>"
			return
/obj/item/weapon/shovel/spade/mortar/attack_self(var/mob/user as mob)
	var/target = get_step(user, user.dir)
	if (target)
		visible_message("<span class = 'warning'>[user] starts to deploy a spade mortar.</span>")
		if (do_after(user, 50, get_turf(user)))
			visible_message("<span class = 'warning'>[user] deploys a spade mortar.</span>")
			user.remove_from_mob(src)
			qdel(src)
			var/atom/A = new/obj/structure/mortar/spade(get_turf(user))
			A.dir = user.dir

/obj/item/weapon/wirecutters/boltcutters
	name = "boltcutters"
	desc = "This cuts bolts and other things."
	icon_state = "boltcutters"

/obj/item/weapon/crowbar/prybar
	name = "prybar"
	icon_state = "prybar"

/obj/item/weapon/weldingtool/ww2
	name = "welding tool"
	icon_state = "ww2_welder_off"
	on_state = "ww2_welder_on"
	off_state = "ww2_welder_off"
/*
/obj/item/flashlight/ww2
	name = "flashlight"
	icon_state = "ww2_welder_off"
	on_state = "ww2_welder_on"
	off_state = "ww2_welder_off"*/


/obj/item/weapon/tool
	name = "tool"
	desc = "uh shit."
	icon = 'icons/obj/items.dmi'
	icon_state = "1"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 1.0
	throwforce = 1.0
	item_state = "1"
	w_class = 1.0
	matter = list(DEFAULT_WALL_MATERIAL = 50)
//	origin_tech = "materials=1;engineering=1"
	attack_verb = list("bashed","whacked")
	sharp = FALSE
	edge = FALSE

/obj/item/weapon/tool/repair
	name = "Repair Kit"
	icon_state = "1"
	item_state = "1"

/obj/item/weapon/tool/wire
	name = "Steel Wire"
	icon_state = "10"
	item_state = "10"

/obj/item/weapon/tool/string
	name = "String"
	icon_state = "6"
	item_state = "6"

/obj/item/weapon/tool/tape
	name = "Tape"
	icon_state = "7"
	item_state = "7"

/obj/item/weapon/tool/engine
	name = "Engine"
	icon_state = "engine"
	item_state = "engine"

/obj/item/weapon/tool/parts
	name = "Parts"
	icon_state = "12"
	item_state = "12"