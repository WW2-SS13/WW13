#define STATE_EMPTY "empty"
#define STATE_WATER "water"
#define STATE_BOILING "boiling"
#define STATE_STEWING "stew"

/obj/structure/pot
	name = "Pot"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "empty_pot"
	layer = 2.9
	density = TRUE
	anchored = TRUE
	flags = OPENCONTAINER | NOREACT
	var/base_state = "_pot"
	var/state = STATE_EMPTY
	var/bowls = 0

/obj/structure/pot/New()
	..()
	processing_objects += src

/obj/structure/pot/Del()
	processing_objects -= src
	..()

/obj/structure/pot/update_icon()
	icon_state = "[state][base_state]"

/obj/structure/pot/attackby(var/obj/item/I, var/mob/living/carbon/human/H)
	if (!istype(H))
		return
	if (state != STATE_STEWING || state != STATE_EMPTY)
		return
	if (istype(I, /obj/item/weapon/reagent_containers/glass))
		if (!I.reagents)
			return
		var/datum/reagent/R = I.reagents.get_master_reagent()
		if (!istype(R, /datum/reagent/water))
			H << "<span class = 'warning'>You need to fill the pot with water.</span>"
			return
		if (R.volume < 50)
			H << "<span class = 'warning'>You need at least 50 units of water.</span>"
			return
		I.reagents.remove_reagent(R.id, 50)
		state = STATE_WATER
		update_icon()
		H << "<span class = 'info'>[H] fills the pot with water.</span>"
		return
	if (!istype(I, /obj/item/trash/snack_bowl))
		H.remove_from_mob(I)
		I.loc = src
		visible_message("<span class = 'info'>[H] puts [I] in the pot.</span>")
	else
		if (H.l_hand == I)
			H.remove_from_mob(I)
			H.equip_to_slot(new /obj/item/weapon/reagent_containers/food/snacks/stew, slot_l_hand)
		else if (H.r_hand == I)
			H.remove_from_mob(I)
			H.equip_to_slot(new /obj/item/weapon/reagent_containers/food/snacks/stew, slot_r_hand)
		qdel(I)
		--bowls
		if (bowls <= 0)
			state = STATE_EMPTY
			update_icon()

/obj/structure/pot/attack_hand(var/mob/living/carbon/human/H)
	if (!istype(H))
		return
	if (state != STATE_BOILING)
		return
	for (var/obj/item/I in contents)
		H.put_in_any_hand_if_possible(I)
		visible_message("<span class = 'info'>[H] takes [I.name] from the pot of boiling water.</span>")
		break

/obj/structure/pot/process()

	if (state == STATE_BOILING)
		var/boiling = 0
		for (var/obj/item/weapon/reagent_containers/food/F in contents)
			if (!F.boiled && prob(10))
				F.name = "boiled [F.name]"
				F.color = "#f0f0f0"
				F.reagents.multiply_reagent("nutriment", 4)
				F.reagents.multiply_reagent("protein", 2)
				F.reagents.del_reagent("toxin")
				visible_message("<span class = 'info'>[F] finishes boiling.</span>")
			else
				++boiling
		if (boiling > 0 && prob(5))
			state = STATE_STEWING
			bowls = 10

	update_icon()