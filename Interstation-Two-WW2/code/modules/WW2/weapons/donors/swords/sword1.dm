/obj/item/weapon/material/sword/Farcry11Sword
	name = "fancy sword"
	icon = 'icons/WW2/donor/sword1/sword/base.dmi'
	icon_state = "base"
	item_state = "base"

	item_icons = list(
		icon_l_hand = 'icons/WW2/donor/sword1/sword/lefthand.dmi',
		icon_r_hand = 'icons/WW2/donor/sword1/sword/righthand.dmi',
	//	icon_back = 'icons/WW2/donor/sword1_back.dmi'
		)

	New()
		..() // name is changed in parent proc

		name = "Fancy Sword"

/obj/item/weapon/storage/belt/Farcry11Sheath
	name = "fancy sword sheath"
	icon = 'icons/WW2/donor/sword1/sheath/base.dmi'
	icon_state = "base"
	item_state = "base"
	can_hold = list(/obj/item/weapon/material/sword/Farcry11Sword)

	item_icons = list(
		icon_l_hand = 'icons/WW2/donor/sword1/sheath/lefthand.dmi',
		icon_r_hand = 'icons/WW2/donor/sword1/sheath/righthand.dmi',
	//	icon_back = 'icons/WW2/donor/sword1_back.dmi'
		)

	New()
		..() // name is changed in parent proc
