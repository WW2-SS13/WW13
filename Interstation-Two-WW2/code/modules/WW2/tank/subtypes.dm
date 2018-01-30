/obj/tank/german
	icon_state = "ger"
	name = "German Panzer"

/obj/tank/german/New()
	..()
	radio = new/obj/item/device/radio/feldfu()

/obj/tank/soviet
	icon_state = "sov"
	name = "Soviet T-23 Tank"

/obj/tank/soviet/New()
	..()
	radio = new/obj/item/device/radio/rbs()