////////////////////////////////
////Survival Injector Define////
////////////////////////////////
/obj/item/weapon/reagent_containers/hypospray/autoinjector/survival
	name = "combat autoinjector"
	icon = 'icons/WW2/medical.dmi'
	icon_state = "injector2"
	amount_per_transfer_from_this = 10
	volume = 10

/obj/item/weapon/reagent_containers/hypospray/autoinjector/survival/inaprovaline
	name = "inaprovaline injector"

	New()
		..()
		reagents.add_reagent("inaprovaline", 10)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/survival/bicaridine
	name = "bicaridine injector"

	New()
		..()
		reagents.add_reagent("bicaridine", 10)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/survival/promedolum
	name = "promedolum injector"

	New()
		..()
		reagents.add_reagent("oxycodone", 5)
		reagents.add_reagent("methylphenidate", 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/survival/peridaxon
	name = "peridaxon injector"

	New()
		..()
		reagents.add_reagent("peridaxon", 10)

//////////////////////////////
////Combat Injector Define////
//////////////////////////////
/obj/item/weapon/reagent_containers/hypospray/autoinjector/combat
	name = "combat autoinjector"
	icon = 'icons/WW2/medical.dmi'
	icon_state = "injector_red"
	volume = 10

	var/cap_color = "red"
	var/obj/item/weapon/injector_cap/cap = null

/obj/item/weapon/reagent_containers/hypospray/autoinjector/combat/New()
	..()
	cap = new /obj/item/weapon/injector_cap (src, cap_color)
	update_icon()

/obj/item/weapon/reagent_containers/hypospray/autoinjector/combat/attack(mob/M as mob, mob/user as mob)
	if(cap)
		user << "<span class='warning'>Remove cap first!</span>"
	else
		..()

/obj/item/weapon/reagent_containers/hypospray/autoinjector/combat/attack_hand(mob/user as mob)
	if(cap && user.get_inactive_hand() == src)
		user << "<span class='notice'>You removed the cap.</span>"
		user.put_in_active_hand(cap)
		cap = null
		update_icon()
	else
		..()

/obj/item/weapon/reagent_containers/hypospray/autoinjector/combat/attack_self(mob/user as mob)
	if(cap)
		if(prob(50))
			user << "<span class='warning'>You tried to remove the cap by one hand but failed!</span>"
		else
			user << "<span class='notice'>You removed the cap.</spam>"
			cap.loc = user.loc
			cap = null
			update_icon()
	else
		..()

/obj/item/weapon/reagent_containers/hypospray/autoinjector/combat/update_icon()
	if(reagents.total_volume >= FALSE)
		if(cap)
			icon_state = "injector_[cap_color]"
		else
			icon_state = "injector_full"
	else
		icon_state = "injector_empty"

/obj/item/weapon/injector_cap
	name = "injector cap"
	icon = 'icons/WW2/medical.dmi'
	icon_state = "cap_red"

/obj/item/weapon/injector_cap/New(var/loc, var/color)
	..()
	icon_state = "cap_[color]"

/obj/item/weapon/reagent_containers/hypospray/autoinjector/combat/inaprovaline
	name = "inaprovaline injector"
	cap_color = "red"

	New()
		..()
		reagents.add_reagent("inaprovaline", 10)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/combat/bicaridine
	name = "bicaridine injector"
	cap_color = "blue"

	New()
		..()
		reagents.add_reagent("bicaridine", 10)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/combat/promedolum
	name = "promedolum injector"
	cap_color = "green"

	New()
		..()
		reagents.add_reagent("oxycodone", 5)
		reagents.add_reagent("methylphenidate", 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/combat/peridaxon
	name = "peridaxon injector"
	cap_color = "green"

	New()
		..()
		reagents.add_reagent("peridaxon", 10)


/////////////////////////////
////WW 2 injectors define////
/////////////////////////////


/obj/item/weapon/reagent_containers/hypospray/autoinjector/ww2
	name = "ww2 autoinjector"
	icon = 'icons/WW2/medical.dmi'
	icon_state = "ww2_injector"
	w_class = 2
	volume = 5


/obj/item/weapon/reagent_containers/hypospray/autoinjector/ww2/update_icon()
	if(reagents.total_volume >= FALSE)
		icon_state = "ww2_injector_full"
	else
		icon_state = "ww2_injector_empty"

/obj/item/weapon/reagent_containers/hypospray/autoinjector/ww2/morphine
	name = "Morphine injector"
	desc = "Injector containing 5 units of morphine. Administer two of these to make someone sleep."

	New()
		..()
		reagents.add_reagent("morphine", 5)
