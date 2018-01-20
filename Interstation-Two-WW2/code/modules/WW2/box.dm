/obj/item/weapon/storage/box/med_kit_ruforce
	name = "medkit"
	icon_state = "medkit"
	w_class = 2
	storage_slots = 7
	max_storage_space = 7
	max_w_class = TRUE

/obj/item/weapon/storage/box/med_kit_ruforce/full/New()
	..()
	for(var/i = TRUE to 3)
		new /obj/item/weapon/gauze_pack/bint(src)
	new /obj/item/weapon/pill_pack/tramadol(src)
	new /obj/item/weapon/pill_pack/bicaridine(src)
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector/survival/inaprovaline(src)
	new /obj/item/weapon/reagent_containers/hypospray/autoinjector/survival/promedolum(src)