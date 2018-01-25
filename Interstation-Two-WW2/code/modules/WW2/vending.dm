// APPAREL RACKS

/obj/machinery/vending/sovietapparel
	name = "Soviet apparel rack"
	desc = "Basic wear for soviet soldiers."
	icon_state = "apparel_soviet"
	products = list(
		/obj/item/clothing/suit/coat/soviet = 20,
		/obj/item/clothing/accessory/storage/webbing = 20,
		/obj/item/clothing/under/sovuni = 20,
		/obj/item/clothing/head/helmet/tactical/sovhelm = 20,
		/obj/item/clothing/shoes/swat/wrappedboots = 20,
		/obj/item/clothing/head/ushanka = 10
	)
	idle_power_usage = 0

/obj/machinery/vending/germanapparel
	name = "German apparel rack"
	desc = "Basic wear for German soldiers."
	icon_state = "apparel_german"
	products = list(
		/obj/item/clothing/suit/coat/german = 20,
		/obj/item/clothing/accessory/storage/webbing = 20,
		/obj/item/clothing/under/geruni = 20,
		/obj/item/clothing/head/helmet/tactical/gerhelm = 20,
		/obj/item/clothing/shoes/swat = 20
	)
	idle_power_usage = 0

// EQUIPMENT RACKS

/obj/machinery/vending/germanequipment
	name = "German equipment rack"
	desc = "Basic equip for German soldiers."
	icon_state = "equipment_german"
	products = list(
		/obj/item/weapon/material/kitchen/utensil/knife/boot = 10,
		/obj/item/weapon/attachment/bayonet = 10,
		/obj/item/weapon/gauze_pack/gauze = 10,
		/obj/item/device/flashlight = 10,
		/obj/item/clothing/mask/gas/german = 10,
		/obj/item/weapon/shovel/spade/russia = 10,
		/obj/item/weapon/gun/projectile/boltaction/kar98k = 10,
		/obj/item/ammo_magazine/kar98k = 20,
	)
	idle_power_usage = 0

/obj/machinery/vending/sovietequipment
	name = "Soviet equipment rack"
	desc = "Basic equip for Soviet soldiers."
	icon_state = "equipment_soviet"
	products = list(
		/obj/item/weapon/material/kitchen/utensil/knife/boot = 10,
		/obj/item/weapon/attachment/bayonet = 10,
		/obj/item/weapon/gauze_pack/bint = 10,
		/obj/item/device/flashlight = 10,
		/obj/item/clothing/mask/gas/soviet = 10,
		/obj/item/weapon/shovel/spade/russia = 10,
		/obj/item/weapon/gun/projectile/boltaction/mosin = 10,
		/obj/item/ammo_magazine/mosin = 20,
	)
	idle_power_usage = 0