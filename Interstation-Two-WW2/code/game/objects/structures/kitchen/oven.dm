/obj/structure/oven
	name = "Oven"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "oven"
	layer = 2.9
	density = TRUE
	anchored = TRUE
	flags = OPENCONTAINER | NOREACT
	var/base_state = "oven"
	var/on = FALSE

/obj/structure/oven/update_icon()
	if (on)
		icon_state = "[base_state]_on"
	else
		icon_state = base_state

/obj/structure/oven/attackby(var/obj/item/I, var/mob/living/carbon/human/H)
	if (!istype(H))
		return
	H.remove_from_mob(I)
	I.loc = src
	visible_message("<span class = 'info'>[H] puts [I] in the oven.</span>")

// todo: fix eggs not roasting & roasted meat sandwiches turning to burnt mess
/obj/structure/oven/attack_hand(var/mob/living/carbon/human/H)
	if (!on)
		visible_message("<span class = 'info'>[H] turns the oven on.</span>")
		on = TRUE
		update_icon()
		spawn (50)
			on = FALSE
			update_icon()
			visible_message("<span class = 'info'>The oven finishes cooking.</span>")
			process()

/obj/structure/oven/process()
	for (var/obj/item/I in contents)
		if (istype(I, /obj/item/weapon/reagent_containers/food/snacks/dough))
			contents += new /obj/item/weapon/reagent_containers/food/snacks/sliceable/bread(src)
			contents -= I
			qdel(I)
		else if (!istype(I, /obj/item/weapon/reagent_containers/food) || istype(I, /obj/item/weapon/reagent_containers/food/drinks) || I.name == "Stew" || findtext(I.name, "soup") || dd_hasprefix(I.name, "roasted"))
			if (!istype(I, /obj/item/organ))
				contents += new /obj/item/weapon/reagent_containers/food/snacks/badrecipe(src)
				contents -= I
				qdel(I)
			else
				var/obj/organ = new /obj/item/weapon/reagent_containers/food/snacks/organ(src)
				organ.name = "roasted [I.name]"
				organ.desc = I.desc
				organ.icon = I.icon
				organ.icon_state = I.icon_state
				organ.color = "#E59400"
				organ.reagents.multiply_reagent("nutriment", 5)
				organ.reagents.multiply_reagent("protein", 3)
				organ.reagents.del_reagent("toxin")
				contents -= I
				qdel(I)
		else
			I.name = "roasted [I.name]"
			I.color = "#E59400"
			I.reagents.multiply_reagent("nutriment", 5)
			I.reagents.multiply_reagent("protein", 3)
			I.reagents.del_reagent("toxin")

	for (var/obj/item/I in contents)
		I.loc = get_turf(src)