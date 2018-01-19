/obj/machinery/vending/sovietapparel
	name = "Soviet apparel rack"
	desc = "Basic wear for soviet soldiers."
	icon_state = "sovarmsvend2.0"
	product_ads = "Kill fascist!;The best stuff for you!;Only the finest tools!;This stuff saves your life!;Don't you want some?;Slava Sovetskomu Soyuzu!"
	products = list(
		/obj/item/clothing/suit/coat/soviet = 20,
		/obj/item/clothing/accessory/storage/webbing = 20,
		/obj/item/clothing/under/sovuni = 20,
		/obj/item/clothing/head/helmet/tactical/sovhelm = 20,
		/obj/item/clothing/shoes/swat/wrappedboots = 20,
		/obj/item/clothing/head/ushanka = 10,
		/obj/item/weapon/material/kitchen/utensil/knife/boot = 10,
		/obj/item/weapon/attachment/bayonet = 10,
		/obj/item/weapon/gauze_pack/bint = 10
	)
	idle_power_usage = 0 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/machinery/vending/germanapparel
	name = "German apparel rack"
	desc = "Basic wear for German soldiers."
	icon_state = "gearmsvend2.0"
	product_ads = "Kill soviet pigs!;The best stuff for you!;Only the finest tools!;This stuff saves your life!;Don't you want some?;Heil Hitler!"
	products = list(
		/obj/item/clothing/suit/coat/german = 20,
		/obj/item/clothing/accessory/storage/webbing = 20,
		/obj/item/clothing/under/geruni = 20,
		/obj/item/clothing/head/helmet/tactical/gerhelm = 20,
		/obj/item/clothing/shoes/swat = 20,
		/obj/item/weapon/material/kitchen/utensil/knife/boot = 10,
		/obj/item/weapon/attachment/bayonet = 10,
		/obj/item/weapon/gauze_pack/gauze = 10
	)
	idle_power_usage = 0 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

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
