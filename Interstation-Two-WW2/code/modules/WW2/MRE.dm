//Food items that are eaten normally and don't leave anything behind.
/obj/item/weapon/reagent_containers/food/snacks/MRE
	name = "MRE"
	desc = "horrible food"
	nutriment_desc = list("horrible food" = 1)
	nutriment_amt = 5
	var/open = FALSE
	var/base_state = ""

/obj/item/weapon/reagent_containers/food/snacks/MRE/attack(mob/M as mob, mob/user as mob, def_zone)
	if (!open && M == user)
		user << "<span class = 'warning'>Open it first.</span>"
		return FALSE
	return ..(M, user, def_zone)

/obj/item/weapon/reagent_containers/food/snacks/MRE/attack_self(var/mob/living/carbon/human/H)
	if (!istype(H))
		return
	if (!open)
		playsound(get_turf(src), 'sound/effects/rip_pack.ogg', 100)
		visible_message("<span class = 'info'>[H] opens [src].</span>")
		icon_state = "[base_state]_open"
		open = TRUE
	return


/obj/item/weapon/reagent_containers/food/snacks/MRE/generic
	base_state = "mre_food"
	icon_state = "mre_food"

/obj/item/weapon/reagent_containers/food/snacks/MRE/generic/german
	name = "German MRE"

/obj/item/weapon/reagent_containers/food/snacks/MRE/generic/soviet
	name = "Soviet MRE"