//Food items that are eaten normally and don't leave anything behind.
/obj/item/weapon/reagent_containers/food/snacks/MRE
	name = "MRE"
	desc = "horrible food"
	nutriment_desc = list("horrible food" = 1)
	nutriment_amt = 5
	var/open = FALSE
	var/opens = TRUE
	var/base_state = ""
	trash = null

/obj/item/weapon/reagent_containers/food/snacks/MRE/attack(mob/M as mob, mob/user as mob, def_zone)
	if (!open && opens && M == user)
		user << "<span class = 'warning'>Open it first.</span>"
		return FALSE
	return ..(M, user, def_zone)

/obj/item/weapon/reagent_containers/food/snacks/MRE/attack_self(var/mob/living/carbon/human/H)
	if (!istype(H))
		return
	if (!open && opens)
		playsound(get_turf(src), 'sound/effects/rip_pack.ogg', 100)
		visible_message("<span class = 'info'>[H] opens [src].</span>")
		icon_state = "[base_state]_open"
		open = TRUE
	return

// generic MRE

/obj/item/weapon/reagent_containers/food/snacks/MRE/generic
	base_state = "mre_food"
	icon_state = "mre_food"
	opens = FALSE
	trash = /obj/item/weapon/generic_MRE_trash
	name = "Generic MRE"

/obj/item/weapon/generic_MRE_trash
	icon = 'icons/obj/food.dmi'
	icon_state = "mre_food_trash"
	name = "MRE trash"

/obj/item/weapon/reagent_containers/food/snacks/MRE/generic/german
	name = "German MRE: Sauerkraut"

/obj/item/weapon/reagent_containers/food/snacks/MRE/generic/soviet
	name = "Soviet MRE: Cabbage"

//

/obj/item/weapon/reagent_containers/food/snacks/MRE/schokakola
	base_state = "schokakola"
	icon_state = "schokakola"
	trash = /obj/item/weapon/schokakola_trash
	nutriment_desc = list("chocolate" = 1, "caffeine" = 1)
	name = "Schokakola"

/obj/item/weapon/reagent_containers/food/snacks/MRE/schokakola/New()
	..()
	reagents.reagent_list.Cut()
	reagents.add_reagent("nutriment", 3)
	reagents.add_reagent("sugar", 3)
	reagents.add_reagent("coco", 3)
	reagents.add_reagent("hyperzine", 3)

/obj/item/weapon/schokakola_trash
	icon = 'icons/obj/food.dmi'
	icon_state = "schokakola_trash"
	name = "Schokakola trash"