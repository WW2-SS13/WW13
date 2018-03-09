// APPAREL RACKS

/obj/structure/vending/sovietapparel
	name = "Soviet apparel rack"
	desc = "Basic wear for soviet soldiers."
	icon_state = "apparel_soviet"
	products = list(
		/obj/item/clothing/suit/storage/coat/soviet = 50,
		/obj/item/clothing/accessory/storage/webbing = 50,
		/obj/item/clothing/under/sovuni = 50,
		/obj/item/clothing/head/helmet/tactical/sovhelm = 50,
		/obj/item/clothing/shoes/swat/wrappedboots = 50,
		/obj/item/clothing/head/ushanka = 25,
		/obj/item/clothing/mask/gas/soviet = 25,
		/obj/item/clothing/under/sovuni/camo = 5,
	)
//	idle_power_usage = 0

/obj/structure/vending/germanapparel
	name = "German apparel rack"
	desc = "Basic wear for German soldiers."
	icon_state = "apparel_german"
	products = list(
		/obj/item/clothing/suit/storage/coat/german = 50,
		/obj/item/clothing/accessory/storage/webbing = 50,
		/obj/item/clothing/under/geruni = 50,
		/obj/item/clothing/head/helmet/tactical/gerhelm = 50,
		/obj/item/clothing/shoes/swat = 50,
		/obj/item/clothing/mask/gas/german = 25
	)
//	idle_power_usage = 0

// EQUIPMENT RACKS

/obj/structure/vending/germanequipment
	name = "German equipment rack"
	desc = "Basic equip for German soldiers."
	icon_state = "equipment_german"
	products = list(
		/obj/item/weapon/material/kitchen/utensil/knife/boot = 25,
		/obj/item/weapon/attachment/bayonet/german = 25,
		/obj/item/weapon/gauze_pack/gauze = 25,
		/obj/item/device/flashlight = 25,
		/obj/item/weapon/shovel/spade/russia = 25,
		/obj/item/weapon/gun/projectile/boltaction/kar98k = 25,
		/obj/item/ammo_magazine/kar98k = 50
	)
//	idle_power_usage = 0

/obj/structure/vending/SSequipment
	name = "SS equipment rack"
	desc = "Basic equip for SS soldiers."
	icon_state = "equipment_german"
	products = list(

		/obj/item/clothing/under/geruni/ssuni = 20,
		/obj/item/clothing/suit/sssmock = 20,
		/obj/item/clothing/accessory/storage/webbing = 20,

		/obj/item/clothing/head/helmet/tactical/gerhelm/sshelm = 10,
		/obj/item/clothing/mask/gas/german = 10,
		/obj/item/clothing/shoes/swat = 10,

		/obj/item/weapon/material/kitchen/utensil/knife/boot = 10,
		/obj/item/weapon/attachment/bayonet/german = 10,
		/obj/item/weapon/gauze_pack/gauze = 10,
		/obj/item/device/flashlight = 10,
		/obj/item/weapon/shovel/spade/russia = 10,
		/obj/item/ammo_magazine/a762/akm = 10,
		/obj/item/weapon/gun/projectile/boltaction/kar98k = 10,

		/obj/item/ammo_magazine/kar98k = 30,

		/obj/item/weapon/grenade/explosive/stgnade = 7,
		/obj/item/weapon/grenade/explosive/l2a2 = 7,
		/obj/item/weapon/grenade/smokebomb/german = 21,

		/obj/item/clothing/under/geruni/sscamo = 5
	)
//	idle_power_usage = 0

/obj/structure/vending/sovietequipment
	name = "Soviet equipment rack"
	desc = "Basic equip for Soviet soldiers."
	icon_state = "equipment_soviet"
	products = list(
		/obj/item/weapon/material/kitchen/utensil/knife/boot = 25,
		/obj/item/weapon/attachment/bayonet/soviet = 25,
		/obj/item/weapon/gauze_pack/bint = 25,
		/obj/item/device/flashlight = 25,
		/obj/item/weapon/shovel/spade/russia = 25,
		/obj/item/weapon/gun/projectile/boltaction/mosin = 25,
		/obj/item/ammo_magazine/mosin = 50
	)
//	idle_power_usage = 0