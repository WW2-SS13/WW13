/obj/item/clothing/head/helmet
	name = "helmet"
	desc = "What the fuck is this"
	icon_state = "helmet"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet",
		)
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor = list(melee = 62, bullet = 50, laser = 50,energy = 35, bomb = 10, bio = 2, rad = FALSE)
	flags_inv = HIDEEARS
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	w_class = 3

/obj/item/clothing/head/helmet/proc/block_check(var/obj/item/projectile/proj)
	if (!proj || !proj.nodamage || !proj.is_shrapnel)
		return TRUE
	return FALSE