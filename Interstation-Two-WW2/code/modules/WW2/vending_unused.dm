
/obj/machinery/vending/sovietarms
	name = "Soviet arms rack"
	desc = "Basic equipment for soviet soldiers"
	icon_state = "sovarmsvend2.0"
	product_ads = "Kill fascist!;The best stuff for you!;Only the finest tools!;This stuff saves your life!;Don't you want some?;Slava Sovetskomu Soyuzu!"
	products = list(
		/obj/item/weapon/gun/projectile/automatic/m4 = 10,
		/obj/item/ammo_magazine/a556/m4 = 30,
		/obj/item/weapon/gun/projectile/colt = 5,
		/obj/item/ammo_magazine/c45m = 15,
		/obj/item/weapon/gun/projectile/boltaction/mosin = 20,
		/obj/item/ammo_magazine/mosin = 40,
		/obj/item/ammo_magazine/mosinbox = 10,
		/obj/item/weapon/shovel/spade/russia = 5,
		/obj/item/weapon/grenade/explosive/rgd = 10,
		/obj/item/weapon/gauze_pack/bint = 10

	)
	idle_power_usage = FALSE //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/machinery/vending/sovietharms
	name = "Soviet heavy arms rack"
	desc = "Heavy equipment for soviet soldiers"
	icon_state = "sovarmsvend2.0"
	product_ads = "Kill fascist!;The best stuff for you!;Only the finest tools!;This stuff saves your life!;Don't you want some?;Slava Sovetskomu Soyuzu!"
	products = list(
		/obj/item/weapon/gun/projectile/automatic/pkm = 2,
		/obj/item/ammo_magazine/a762/pkm = 20,
		/obj/item/weapon/gun/projectile/colt = 5,
		/obj/item/ammo_magazine/c45m = 15,
		//obj/item/weapon/gun/launcher/rocket/one_use/pzfaust = TRUE,
		/obj/item/weapon/storage/backpack = 2


	)
	idle_power_usage = FALSE //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/machinery/vending/sovietsapp
	name = "Soviet sapper rack"
	desc = "Basic equipment for soviet sapper soldiers"
	icon_state = "sovarmsvend2.0"
	product_ads = "Kill fascist!;The best stuff for you!;Only the finest tools!;This stuff saves your life!;Don't you want some?;Slava Sovetskomu Soyuzu!"
	products = list(
		/obj/item/weapon/gun/projectile/boltaction/mosin = 5,
		/obj/item/ammo_magazine/mosin = 20,
		/obj/item/ammo_magazine/mosinbox = 5,
		/obj/item/weapon/shovel/spade/russia = 5,
		/obj/item/weapon/material/knife = 5,
		/obj/item/device/mine/betty = 20,
		/obj/item/weapon/storage/backpack/industrial = 5

	)
	idle_power_usage = FALSE //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.


/obj/machinery/vending/germanarms
	name = "German arms rack"
	desc = "Basic equipment for German soldiers."
	icon_state = "gearmsvend2.0"
	product_ads = "Kill soviet pigs!;The best stuff for you!;Only the finest tools!;This stuff saves your life!;Don't you want some?;Heil Hitler!"
	products = list(
		/obj/item/weapon/gun/projectile/automatic/akm = 5,
		/obj/item/ammo_magazine/a762/akm = 30,
		/obj/item/weapon/gun/projectile/pistol = 8,
		/obj/item/ammo_magazine/mc9mm = 20,
		/obj/item/weapon/gun/projectile/boltaction/kar98k = 20,
		/obj/item/ammo_magazine/kar98k = 40,
		/obj/item/ammo_magazine/kar98kbox = 10,
		/obj/item/weapon/shovel/spade/russia = 5,
		/obj/item/weapon/grenade/explosive/stgnade = 20,
		/obj/item/weapon/gauze_pack/gauze = 20,
		/obj/item/weapon/reagent_containers/food/snacks/pervitinchocolatebar = 10


	)
	idle_power_usage = FALSE //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/machinery/vending/germansapp
	name = "German pioneer arms rack"
	desc = "Heavy equipment for German pioneer soldiers."
	icon_state = "gearmsvend2.0"
	product_ads = "Kill soviet pigs!;The best stuff for you!;Only the finest tools!;This stuff saves your life!;Don't you want some?;Heil Hitler!"
	products = list(
		/obj/item/weapon/gun/projectile/automatic/mp40 = 5,
		/obj/item/ammo_magazine/mp40 = 25,
		/obj/item/weapon/shovel/spade/russia = 5,
		/obj/item/weapon/material/knife = 5,
		/obj/item/device/mine/betty = 20,
		/obj/item/weapon/storage/backpack/industrial = 5


	)
	idle_power_usage = FALSE //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/machinery/vending/germanharms
	name = "German heavy arms rack"
	desc = "Heavy equipment for German soldiers."
	icon_state = "gearmsvend2.0"
	product_ads = "Kill soviet pigs!;The best stuff for you!;Only the finest tools!;This stuff saves your life!;Don't you want some?;Heil Hitler!"
	products = list(
		/obj/item/weapon/gun/projectile/pistol/luger = 8,
		/obj/item/ammo_magazine/mc9mm = 20,
		/obj/item/weapon/gun/projectile/automatic/l6_saw = 2,
		/obj/item/ammo_magazine/a762 = 10,
		//obj/item/weapon/gun/launcher/rocket/one_use/pzfaust = 3,
		/obj/item/weapon/storage/backpack = 2


	)
	idle_power_usage = FALSE //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.


/obj/machinery/vending/wallmed1
	name = "NanoMed"
	desc = "Wall-mounted Medical Equipment dispenser."
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?"
	icon_state = "wallmed"
	light_color = "#e6fff2"
	icon_deny = "wallmed-deny"
	density = FALSE //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(/obj/item/stack/medical/bruise_pack = 2,/obj/item/stack/medical/ointment = 2,/obj/item/weapon/reagent_containers/hypospray/autoinjector = 4)
	contraband = list(/obj/item/weapon/reagent_containers/syringe/antitoxin = 4,/obj/item/weapon/reagent_containers/syringe/antiviral = 4,/obj/item/weapon/reagent_containers/pill/tox = TRUE)

/obj/machinery/vending/wallmed2
	name = "NanoMed"
	desc = "Wall-mounted Medical Equipment dispenser."
	icon_state = "wallmed"
	light_color = "#e6fff2"
	icon_deny = "wallmed-deny"
	density = FALSE //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(/obj/item/weapon/reagent_containers/hypospray/autoinjector = 5,/obj/item/weapon/reagent_containers/syringe/antitoxin = 3,/obj/item/stack/medical/bruise_pack = 3,
					/obj/item/stack/medical/ointment =3)
	contraband = list(/obj/item/weapon/reagent_containers/pill/tox = 3)
