
/obj/item/weapon/storage/bag/medical_bag_soviet
	name = "medical bag"
	icon_state = "combat_aid_bag_sov"
	desc = "Medical bag specially designed to carry a lot of medical stuff."
	w_class = 3
	storage_slots = 14
	max_storage_space = 20
	max_w_class = 2

/obj/item/weapon/storage/bag/medical_bag_soviet/full/New()
	..()

	new/obj/item/weapon/doctor_handbook(src)

	for(var/i = 1 to 5)
		new /obj/item/weapon/gauze_pack/gauze(src)

	for(var/i = 1 to 1)
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/combat/bicaridine(src)

	for(var/i = 1 to 2)
		new /obj/item/weapon/pill_pack/tramadol(src)

	for(var/i = 1 to 1)
		new /obj/item/weapon/pill_pack/dexalin(src)

	for(var/i = 1 to 2)
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/combat/inaprovaline(src)

	for(var/i = 1 to 3)
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/combat/peridaxon(src)

/obj/item/weapon/storage/bag/medical_bag_nato
	name = "medical bag"
	icon_state = "combat_aid_bag_nato"
	desc = "Medical bag specially designed to carry a lot of medical stuff."
	w_class = 3
	storage_slots = 14
	max_storage_space = 20
	max_w_class = 2

/obj/item/weapon/storage/bag/medical_bag_nato/full/New()
	..()

	new/obj/item/weapon/doctor_handbook(src)

	for(var/i = TRUE to 5)
		new /obj/item/weapon/gauze_pack/gauze(src)

	for(var/i = TRUE to TRUE)
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/combat/bicaridine(src)

	for(var/i = TRUE to 2)
		new /obj/item/weapon/pill_pack/tramadol(src)

	for(var/i = TRUE to TRUE)
		new /obj/item/weapon/pill_pack/dexalin(src)

	for(var/i = TRUE to 2)
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/combat/inaprovaline(src)

	for(var/i = TRUE to 3)
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/combat/peridaxon(src)