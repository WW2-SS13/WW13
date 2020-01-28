/datum/job/partisan/give_random_name(var/mob/living/carbon/human/H)
	H.name = H.species.get_random_ukrainian_name(H.gender)
	H.real_name = H.name

/datum/job/german/uia/soldier
	title = "UIA Soldier"
	selection_color = "#530909"
	spawn_location = "JoinLateHeer"
	is_uia = TRUE

	// AUTOBALANCE
	min_positions = 1
	max_positions = 10
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/german/uia/soldier/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni/uia(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/pilotka(H), slot_head)
	if (prob(40))
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger(H), slot_belt)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/material/knife/combat(H), slot_r_hand)
	H.equip_to_slot_or_del(new /obj/item/flashlight(H), slot_l_hand)
	H.give_radio()
	H.add_note("Role", "You are a <b>[title]</b>, a UIA soldier. You take orders from the <b>UIA Leader</b> alone.")
	if (partisan_stockpile)
		H << "<br><span class = 'warning'>You have a stockpile of weapons at [partisan_stockpile.name]. Also, there are some stockpiles of medical items and tools around the town.</span>"
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_MEDIUM_LOW, STAT_NORMAL, STAT_MEDIUM_HIGH))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_MEDIUM_LOW, STAT_NORMAL, STAT_MEDIUM_HIGH))
	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH, STAT_VERY_HIGH))

	H.setStat("shotgun", pick(STAT_MEDIUM_HIGH, STAT_HIGH, STAT_VERY_HIGH))
	return TRUE

/datum/job/german/uia/commander
	title = "UIA Commander"
	is_officer = TRUE
	is_commander = TRUE
	head_position = TRUE
	selection_color = "#2d2d63"
	spawn_location = "JoinLateHeer"
	additional_languages = list( "Russian" = 100, "German" = 100)
	is_uia = TRUE
	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
	player_threshold = PLAYER_THRESHOLD_HIGHEST

/datum/job/german/uia/commander/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/uia_cap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni/uiaoff(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/weapon/attachment/scope/adjustable/binoculars(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/flashlight(H), slot_r_hand)
	if (map && map.ID == "FOREST")
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/heavy/ptrd(H), slot_back)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/submachinegun/stenmk2(H), slot_back)
		// equipping the luger second means we get ammo for the PPSH instead
		// this works because the PPSH is added to our contents list first
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/tokarev(H), slot_belt)

	H.give_radio()

	H.add_note("Role", "You are a <b>[title]</b>, the leader of the UIA forces in the town. Protect your men and the civilians!")
	if (partisan_stockpile)
		H << "<br><span class = 'warning'>You have a stockpile of weapons at [partisan_stockpile.name]. Also, there are some stockpiles of medical items and tools around the town.</span>"
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_MEDIUM_LOW, STAT_NORMAL, STAT_MEDIUM_HIGH))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_MEDIUM_LOW, STAT_NORMAL, STAT_MEDIUM_HIGH))
	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH, STAT_VERY_HIGH))

	H.setStat("shotgun", pick(STAT_MEDIUM_HIGH, STAT_HIGH, STAT_VERY_HIGH))
	return TRUE

/datum/job/german/honey/rittmeister
	is_terek = TRUE

/datum/job/german/honey/rittmeister
	title = "Terek Rittmeister"
	en_meaning = "Terek Squad Lead"
	rank_abbreviation = "schtz"
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"
	allow_spies = TRUE
	SL_check_independent = TRUE
	is_officer = TRUE

	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
	scale_to_players = PLAYER_THRESHOLD_HIGHEST

/datum/job/german/honey/rittmeister/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/terek(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/terek(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/coat/terek(H), slot_wear_suit)
	H.add_note("Role", "You are a <b>[title]</b>, a normal infantry unit. Your job is to participate in front line combat.")
	H.setStat("strength", STAT_VERY_HIGH)
	H.setStat("engineering", STAT_NORMAL)
	H.setStat("rifle", STAT_MEDIUM_HIGH)
	H.setStat("mg", STAT_MEDIUM_HIGH)
	H.setStat("smg", STAT_MEDIUM_HIGH)
	H.setStat("pistol", STAT_MEDIUM_HIGH)
	H.setStat("heavyweapon", STAT_MEDIUM_HIGH)
	H.setStat("medical", STAT_MEDIUM_HIGH)
	H.setStat("shotgun", STAT_MEDIUM_HIGH)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/waltherp38(H), slot_belt)
	if (prob(8))
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/semiautomatic/g41(H), slot_back)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)
	return TRUE

/datum/job/german/honey/rittmeister/get_keys()
	return list(new/obj/item/weapon/key/german)

/datum/job/german/honey/reconlead
	title = "Terek Oberluetnant"
	en_meaning = "Terek Recon Lead"
	rank_abbreviation = "schtz"
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"
	allow_spies = TRUE
	SL_check_independent = TRUE
	is_officer = TRUE

	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
	scale_to_players = PLAYER_THRESHOLD_HIGHEST

/datum/job/german/honey/reconlead/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/terek(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/terek(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/coat/terek(H), slot_wear_suit)
	H.add_note("Role", "You are a <b>[title]</b>, a normal infantry unit. Your job is to participate in front line combat.")
	H.setStat("strength", STAT_VERY_HIGH)
	H.setStat("engineering", STAT_NORMAL)
	H.setStat("rifle", STAT_MEDIUM_HIGH)
	H.setStat("mg", STAT_MEDIUM_LOW)
	H.setStat("smg", STAT_MEDIUM_HIGH)
	H.setStat("pistol", STAT_MEDIUM_HIGH)
	H.setStat("heavyweapon", STAT_MEDIUM_HIGH)
	H.setStat("medical", STAT_MEDIUM_HIGH)
	H.setStat("shotgun", STAT_MEDIUM_HIGH)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/waltherp38(H), slot_belt)
	if (prob(8))
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/semiautomatic/g41(H), slot_back)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)
	return TRUE

/datum/job/german/honey/reconlead/get_keys()
	return list(new/obj/item/weapon/key/german)

/datum/job/german/honey/reconassist
	title = "Terek Gefreiter"
	en_meaning = "Terek Recon Lead Assistant"
	rank_abbreviation = "schtz"
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"
	allow_spies = TRUE
	SL_check_independent = TRUE
	is_officer = TRUE

	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
	scale_to_players = PLAYER_THRESHOLD_HIGHEST

/datum/job/german/honey/reconassist/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/terek(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/terek(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/waltherp38(H), slot_belt)
	H.add_note("Role", "You are a <b>[title]</b>, a normal infantry unit. Your job is to participate in front line combat.")
	H.setStat("strength", STAT_VERY_HIGH)
	H.setStat("engineering", STAT_NORMAL)
	H.setStat("rifle", STAT_MEDIUM_HIGH)
	H.setStat("mg", STAT_MEDIUM_HIGH)
	H.setStat("smg", STAT_MEDIUM_HIGH)
	H.setStat("pistol", STAT_MEDIUM_HIGH)
	H.setStat("heavyweapon", STAT_MEDIUM_HIGH)
	H.setStat("medical", STAT_MEDIUM_HIGH)
	H.setStat("shotgun", STAT_MEDIUM_HIGH)
	if (prob(8))
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/semiautomatic/g41(H), slot_back)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)
	return TRUE

/datum/job/german/honey/reconassist/get_keys()
	return list(new/obj/item/weapon/key/german)


/datum/job/german/honey/machinegunner
	title = "Terek MG Gefreiter"
	en_meaning = "Terek Machinegunner"
	rank_abbreviation = "schtz"
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"
	allow_spies = TRUE
	SL_check_independent = TRUE
	is_officer = TRUE

	// AUTOBALANCE
	min_positions = 2
	max_positions = 2
	scale_to_players = PLAYER_THRESHOLD_HIGHEST

/datum/job/german/honey/machinegunner/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/terek(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/ukihelm(H), slot_head)
	H.add_note("Role", "You are a <b>[title]</b>, a normal infantry unit. Your job is to participate in front line combat.")
	H.setStat("strength", STAT_VERY_HIGH)
	H.setStat("engineering", STAT_NORMAL)
	H.setStat("rifle", STAT_MEDIUM_HIGH)
	H.setStat("mg", STAT_VERY_HIGH)
	H.setStat("smg", STAT_MEDIUM_HIGH)
	H.setStat("pistol", STAT_MEDIUM_HIGH)
	H.setStat("heavyweapon", STAT_MEDIUM_HIGH)
	H.setStat("medical", STAT_MEDIUM_HIGH)
	H.setStat("shotgun", STAT_MEDIUM_HIGH)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/dp(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/waltherp38(H), slot_belt)
	return TRUE

/datum/job/german/honey/machinegunner/get_keys()
	return list(new/obj/item/weapon/key/german)

/datum/job/german/honey/sapper
	title = "Terek Pionier"
	en_meaning = "Terek Engineer"
	rank_abbreviation = "schtz"
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"
	allow_spies = TRUE
	is_officer = TRUE
	SL_check_independent = TRUE

	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
	scale_to_players = PLAYER_THRESHOLD_HIGHEST

/datum/job/german/honey/sapper/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/terek(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/ukihelm(H), slot_head)
	H.add_note("Role", "You are a <b>[title]</b>, a normal infantry unit. Your job is to participate in front line combat.")
	H.setStat("strength", STAT_VERY_HIGH)
	H.setStat("engineering", STAT_VERY_HIGH)
	H.setStat("rifle", STAT_MEDIUM_HIGH)
	H.setStat("mg", STAT_MEDIUM_HIGH)
	H.setStat("smg", STAT_MEDIUM_HIGH)
	H.setStat("pistol", STAT_MEDIUM_HIGH)
	H.setStat("heavyweapon", STAT_MEDIUM_HIGH)
	H.setStat("medical", STAT_MEDIUM_HIGH)
	H.setStat("shotgun", STAT_MEDIUM_HIGH)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/waltherp38(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/submachinegun/mp40(H), slot_r_hand)
	return TRUE

/datum/job/german/honey/sapper/get_keys()
	return list(new/obj/item/weapon/key/german)


/datum/job/german/honey/schutze
	title = "Terek Gefreiter Schutze"
	en_meaning = "Terek Rifleman"
	rank_abbreviation = "schtz"
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"
	allow_spies = TRUE
	is_officer = TRUE
	SL_check_independent = TRUE

	// AUTOBALANCE
	min_positions = 2
	max_positions = 2
	scale_to_players = PLAYER_THRESHOLD_HIGHEST

/datum/job/german/honey/schutze/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/terek(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/ukihelm(H), slot_head)
	H.add_note("Role", "You are a <b>[title]</b>, a normal infantry unit. Your job is to participate in front line combat.")
	H.setStat("strength", STAT_VERY_HIGH)
	H.setStat("engineering", STAT_NORMAL)
	H.setStat("rifle", STAT_MEDIUM_HIGH)
	H.setStat("mg", STAT_MEDIUM_HIGH)
	H.setStat("smg", STAT_MEDIUM_HIGH)
	H.setStat("pistol", STAT_MEDIUM_HIGH)
	H.setStat("heavyweapon", STAT_MEDIUM_HIGH)
	H.setStat("medical", STAT_MEDIUM_HIGH)
	H.setStat("shotgun", STAT_MEDIUM_HIGH)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/waltherp38(H), slot_belt)
	if (prob(8))
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/semiautomatic/g41(H), slot_back)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)
	return TRUE

/datum/job/german/honey/schutze/get_keys()
	return list(new/obj/item/weapon/key/german)