
/obj/item/weapon/storage/backpack/german
	name = "german backpack"
	desc = "You wear this on your back and put items into it."
	icon_state = "germanpack"
	item_state_slots = null

//portable rations

/obj/item/weapon/storage/backpack/german/rations

/obj/item/weapon/storage/backpack/german/rations/New()
	..()
	for (var/v in 1 to 3)
		contents += new_ration(GERMAN, "solid")

/obj/item/weapon/storage/backpack/german/paratrooper

/obj/item/weapon/storage/backpack/german/paratrooper/New()
	..()
	for (var/v in 1 to 3)
		contents += new_ration(GERMAN, "solid")
	contents += new/obj/item/device/flashlight/lantern()

// todo: needs a new icon

/obj/item/weapon/storage/backpack/russian
	name = "russian backpack"
	desc = "You wear this on your back and put items into it."
	icon_state = "russianpack"
	item_state_slots = null
