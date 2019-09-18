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
		visible_message("<span class = 'notice'>[H] opens [src].</span>")
		icon_state = "[base_state]_open"
		open = TRUE
	return

// generic MRE

/obj/item/weapon/reagent_containers/food/snacks/MRE/generic
	base_state = "mre_box"
	icon_state = "mre_box"
	name = "Generic MRE"
	opens = FALSE
	trash = /obj/item/weapon/generic_MRE_trash

/obj/item/weapon/generic_MRE_trash
	icon = 'icons/obj/food.dmi'
	icon_state = "mre_box_open"
	name = "MRE trash"
	desc = "The remains of some MRE."
	w_class = 1

/obj/item/weapon/generic_MRE_trash/german
	icon_state = "mre_box2_open"
	name = "MRE trash"
	desc = "The remains of some MRE."
	w_class = 1

/obj/item/weapon/generic_MRE_trash/japanese
	icon_state = "jap_can_open"
	name = "opened can"
	desc = "The remains of some canned MRE."
	w_class = 1

/obj/item/weapon/generic_MRE_trash/american
	icon_state = "spam_food0"
	name = "Empty Can"
	desc = "The remains of some Canned Mystery Meat."
	w_class = 1

/obj/item/weapon/generic_MRE_trash/soviet
	icon_state = "wut_empty"
	name = "Empty Can"
	desc = "The remains of some Canned Mystery Meat."
	w_class = 1

/obj/item/weapon/reagent_containers/food/snacks/MRE/generic/german
	name = "German MRE: Sauerkraut"
	desc = "A pickled cabbage MRE."
	icon_state = "mre_box2"
	base_state = "mre_box2"
	nutriment_desc = list("pickled cabbage" = 1)
	trash = /obj/item/weapon/generic_MRE_trash/german

/obj/item/weapon/reagent_containers/food/snacks/MRE/generic/soviet
	name = "Soviet MRE: Mystery Meat"
	desc = "A Mystery Meat MRE."
	icon_state = "wut"
	base_state = "wut"
	nutriment_desc = list("overcooked dog food like meat" = 1)
	trash = /obj/item/weapon/generic_MRE_trash/soviet

/obj/item/weapon/reagent_containers/food/snacks/MRE/generic/italian
	name = "Italian MRE: Spaghetti"
	desc = "Mama mia!"
	nutriment_desc = list("spaghett" = 1, "tomat" = 1, "spicia meatball")

/obj/item/weapon/reagent_containers/food/snacks/MRE/generic/american
	name = "American MRE: Canned Meat"
	base_state = "spam_food"
	icon_state = "spam_food"
	desc = "A package of canned meat and vegetables."
	nutriment_desc = list("canned meat" = 1, "canned vegetables" = 1)
	trash = /obj/item/weapon/generic_MRE_trash/american

/obj/item/weapon/reagent_containers/food/snacks/MRE/generic/japanese
	name = "Japanese MRE: Noodles"
	base_state = "jap_can"
	icon_state = "jap_can"
	desc = "A package of precooked noodles and dry meat."
	nutriment_desc = list("noodles" = 1, "vegetables" = 1, "dried meat")
	trash = /obj/item/weapon/generic_MRE_trash/japanese

// scho ka kola

/obj/item/weapon/reagent_containers/food/snacks/MRE/schokakola
	base_state = "schokakola"
	icon_state = "schokakola"
	name = "Scho-Ka-Kola"
	desc = "A delicious chocolate treat with lots of caffeine."
	trash = /obj/item/weapon/schokakola_trash
	nutriment_desc = list("chocolate" = 1, "caffeine" = 1)

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
	desc = "The remains of a delicious Scho-Ka-Kola."
	w_class = 1