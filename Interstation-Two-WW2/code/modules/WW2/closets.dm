/obj/structure/closet/welding
	name = "welding supplies"
	icon_state = "secureengweld1"
	icon_closed = "secureengweld"
	icon_opened = "toolclosetopen"

	New()
		..()
		new /obj/item/clothing/head/welding(src)
		new /obj/item/clothing/head/welding(src)
		new /obj/item/clothing/head/welding(src)
		new /obj/item/weapon/weldingtool/largetank(src)
		new /obj/item/weapon/weldingtool/largetank(src)
		new /obj/item/weapon/weldingtool/largetank(src)
		new /obj/item/weapon/weldpack(src)
		new /obj/item/weapon/weldpack(src)
		new /obj/item/weapon/weldpack(src)
		return

/obj/structure/closet/toolcloset
	name = "tool closet"
	desc = "It's a storage unit for tools."
	icon_state = "toolcloset"
	icon_closed = "toolcloset"
	icon_opened = "toolclosetopen"

/obj/structure/closet/toolcloset/New()
	..()
	if(prob(40))
		new /obj/item/clothing/suit/storage/hazardvest(src)
	if(prob(70))
		new /obj/item/device/flashlight(src)
	if(prob(70))
		new /obj/item/weapon/screwdriver(src)
	if(prob(70))
		new /obj/item/weapon/wrench(src)
	if(prob(70))
		new /obj/item/weapon/weldingtool/ww2(src)
	if(prob(70))
		new /obj/item/weapon/crowbar/prybar(src)
	if(prob(70))
		new /obj/item/weapon/wirecutters/boltcutters(src)
	if(prob(20))
		new /obj/item/weapon/storage/belt/utility(src)
	if(prob(30))
		new /obj/item/stack/cable_coil/random(src)
	if(prob(30))
		new /obj/item/stack/cable_coil/random(src)
	if(prob(30))
		new /obj/item/stack/cable_coil/random(src)
/*	if(prob(20))
		new /obj/item/device/multitool(src)*/
	if(prob(5))
		new /obj/item/clothing/gloves/insulated(src)
	if(prob(40))
		new /obj/item/clothing/head/hardhat(src)

/obj/structure/closet/cabinet
	name = "cabinet"
	desc = "Old will forever be in fashion."
	icon_state = "cabinet_closed"
	icon_closed = "cabinet_closed"
	icon_opened = "cabinet_open"

/obj/structure/closet/cabinet/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened

/obj/structure/closet/chemical
	name = "chemical closet"
	desc = "Store dangerous chemicals in here."
	icon_state = "medical1"
	icon_closed = "medical"
	icon_opened = "medicalopen"

	New()
		..()
		new /obj/item/weapon/storage/box/pillbottles(src)
		new /obj/item/weapon/storage/box/pillbottles(src)

/obj/structure/closet/freezer

/obj/structure/closet/freezer/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened

/obj/structure/closet/freezer/kitchen
	name = "kitchen cabinet"

	New()
		..()
		for(var/i = FALSE, i < 6, i++)
			new /obj/item/weapon/reagent_containers/food/condiment/flour(src)
		new /obj/item/weapon/reagent_containers/food/condiment/sugar(src)
		for(var/i = FALSE, i < 3, i++)
			new /obj/item/weapon/reagent_containers/food/snacks/meat/monkey(src)
		return


/obj/structure/closet/freezer/meat
	name = "meat fridge"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_opened = "fridgeopen"

	New()
		..()
		for(var/i = FALSE, i < 4, i++)
			new /obj/item/weapon/reagent_containers/food/snacks/meat/monkey(src)
		return



/obj/structure/closet/freezer/fridge
	name = "refrigerator"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_opened = "fridgeopen"


	New()
		..()
		for(var/i = FALSE, i < 5, i++)
			new /obj/item/weapon/reagent_containers/food/drinks/milk(src)
		for(var/i = FALSE, i < 3, i++)
			new /obj/item/weapon/reagent_containers/food/drinks/soymilk(src)
		for(var/i = FALSE, i < 2, i++)
			new /obj/item/weapon/storage/fancy/egg_box(src)
		return

