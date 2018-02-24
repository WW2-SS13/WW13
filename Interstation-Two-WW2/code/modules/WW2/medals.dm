/obj/item/clothing/accessory/medal/WW2
	icon = 'icons/WW2/medals.dmi'
	var/visual = "gold"

/obj/item/clothing/accessory/medal/WW2/get_inv_overlay()
	if (!inv_overlay)
		inv_overlay = image(icon = 'icons/WW2/medals.dmi', icon_state = "suit_[visual]", dir = SOUTH)
	return inv_overlay

/obj/item/clothing/accessory/medal/WW2/get_mob_overlay()
	return get_inv_overlay()


// German

/obj/item/clothing/accessory/medal/WW2/iron_cross_oak_leaves
	name = "Iron Cross with Oak Leaves medal"
	icon_state = "iron_cross_oak_leaves"
	visual = "bronze"
	// desc: todo

/obj/item/clothing/accessory/medal/WW2/iron_cross_second_class
	name = "Iron Cross second class medal"
	icon_state = "iron_cross_second_class"
	visual = "bronze"
	// desc: todo

/obj/item/clothing/accessory/medal/WW2/wehrmacht_long_service_medal
	name = "Wehrmacht Long Service medal"
	icon_state = "wehrmacht_long_service_medal"
	visual = "silver"
	// desc: todo

/obj/item/clothing/accessory/medal/WW2/eastern_front_medal
	name = "Eastern Front medal"
	icon_state = "eastern_front_medal"
	visual = "silver"
	// desc: todo

/obj/item/clothing/accessory/medal/WW2/iron_cross_first_class
	name = "Iron Cross first class medal"
	icon_state = "iron_cross_first_class"
	visual = "bronze"
	// desc: todo

/obj/item/clothing/accessory/medal/WW2/general_assault_badge
	name = "General Assault Badge"
	icon_state = "iron_cross_first_class"
	visual = "silver"
	// desc: todo

/obj/item/clothing/accessory/medal/WW2/tank_destruction_badge_silver
	name = "Silver Tank Destruction Badge"
	icon_state = "tank_destruction_badge_silver"
	visual = "silver"
	// desc: todo

/obj/item/clothing/accessory/medal/WW2/tank_destruction_badge_gold
	name = "Gold Tank Destruction Badge"
	icon_state = "tank_destruction_badge_gold"
	visual = "gold"
	// desc: todo

/obj/item/clothing/accessory/medal/WW2/wound_badge_silver
	name = "Silver Wound Badge"
	icon_state = "wound_badge_silver"
	visual = "silver"
	// desc: todo

/obj/item/clothing/accessory/medal/WW2/wound_badge_black
	name = "Black Wound Badge"
	icon_state = "wound_badge_black"
	visual = "black"
	// desc: todo

/obj/item/clothing/accessory/medal/WW2/wound_badge_gold
	name = "Gold Wound Badge"
	icon_state = "wound_badge_gold"
	visual = "gold"
	// desc: todo

// Soviet

/obj/item/clothing/accessory/medal/WW2/hero_soviet_union
	name = "Hero of the Soviet Union medal"
	icon_state = "hero_soviet_union"
	visual = "gold"
	// desc: todo

/obj/item/clothing/accessory/medal/WW2/order_of_red_star
	name = "Order of the Red Star medal"
	icon_state = "order_of_red_star"
	visual = "bronze"
	// desc: todo

/obj/item/clothing/accessory/medal/WW2/guards_badge
	name = "Guards' Badge"
	icon_state = "guards_badge"
	visual = "gold"
	// desc: todo

/obj/item/clothing/accessory/medal/WW2/order_of_great_patriotic_war_silver
	name = "Silver Order of Great Patriotic War medal"
	icon_state = "order_of_great_patriotic_war_silver"
	visual = "silver"
	// desc: todo

/obj/item/clothing/accessory/medal/WW2/order_of_great_patriotic_war_gold
	name = "gold Order of Great Patriotic War medal"
	icon_state = "order_of_great_patriotic_war_gold"
	visual = "gold"
	// desc: todo