/obj/structure/closet/engineering_welding_ww2
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
		new /obj/item/weapon/weldingtool(src)
	if(prob(70))
		new /obj/item/weapon/crowbar(src)
	if(prob(70))
		new /obj/item/weapon/wirecutters(src)
	if(prob(20))
		new /obj/item/weapon/storage/belt/utility(src)
	if(prob(30))
		new /obj/item/stack/cable_coil/random(src)
	if(prob(30))
		new /obj/item/stack/cable_coil/random(src)
	if(prob(30))
		new /obj/item/stack/cable_coil/random(src)
	if(prob(20))
		new /obj/item/device/multitool(src)
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