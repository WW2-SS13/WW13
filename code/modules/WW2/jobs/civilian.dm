/proc/civ_stat()
	return pick(ALL_STATS)

/datum/job/partisan/civilian
	title = "Civilian"
	selection_color = "#530909"
	spawn_location = "JoinLateCivilian"

	// AUTOBALANCE
	min_positions = 1
	max_positions = 10
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/flashlight(H), pick(slot_l_hand, slot_r_hand))
	equip_random_civilian_clothing(H)
	H.add_note("Role", "You are a <b>[title]</b>, a simple civilian trying to live his life in the warzone. Survive.")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))
	return TRUE

/datum/job/partisan/civilian/chef
	title = "Chef"
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianChef"

	// AUTOBALANCE
	min_positions = 1
	max_positions = 3
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/chef/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/flashlight(H), pick(slot_l_hand, slot_r_hand))
	equip_random_civilian_clothing(H)
	H.add_note("Role", "You are a <b>[title]</b>, one of the best in this city, serve the guests of this restruant with the best food in town!")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))
	return TRUE


/datum/job/partisan/civilian/det
	title = "Detective"
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianDetective"

	// AUTOBALANCE
	min_positions = 1
	max_positions = 2
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/det/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/revolver/detective(H), slot_l_store)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/c38(H), slot_r_store)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/det(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/det(H), slot_w_uniform)
	H.add_note("Role", "You are a <b>[title]</b>! It was cold. It was dark. Just another evening in this city. The police force was dismantaled by the occupiers here who's friends had a particular distaste for the boys in blue. Specially now, in 1942. You can get away with punching a cop no problem.")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_MEDIUM_LOW, STAT_MEDIUM_HIGH))
	H.setStat("mg", pick(STAT_MEDIUM_LOW, STAT_MEDIUM_HIGH))
	H.setStat("smg", pick(STAT_MEDIUM_LOW, STAT_MEDIUM_HIGH))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))
	return TRUE

/datum/job/partisan/civilian/cop
	title = "Cop"
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianCop"

	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/cop/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/collectable/police(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/assistantformal(H), slot_w_uniform)
	H.add_note("Role", "You are a <b>[title]</b>, well not so much anymore. The germans have dismantaled the police force and torched the building. Survive.")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_MEDIUM_LOW, STAT_MEDIUM_HIGH))
	H.setStat("smg", pick(STAT_MEDIUM_LOW, STAT_MEDIUM_HIGH))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))
	return TRUE

//CONSTRUCTION WORKER

/datum/job/partisan/civilian/worker
	title = "Construction Worker"
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianWorker"

	// AUTOBALANCE
	min_positions = 1
	max_positions = 10
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/worker/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/toolbox/mechanical(H), slot_l_hand)
	equip_random_civilian_clothing(H)
	H.add_note("Role", "You are a <b>[title]</b>, a simple man trying to live a simple life. Before the germans arrived we were working on a construction site down south. ")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", pick(STAT_HIGH, STAT_VERY_HIGH))
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))
	return TRUE

//RICH MAN

/datum/job/partisan/civilian/rich
	title = "Rich Banker"
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianRich"

	// AUTOBALANCE
	min_positions = 1
	max_positions = 2
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/rich/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/stack/money(H), pick(slot_l_hand, slot_r_hand))
	equip_random_civilian_clothing(H)
	H.add_note("Role", "You are a <b>[title]</b>, life has been easy on you due to your wealth. Hopefully that stays the same with the germans here.")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))
	return TRUE


/datum/job/partisan/civilian/sci
	title = "Scientist"
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianScientist"

	// AUTOBALANCE
	min_positions = 1
	max_positions = 10
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/sci/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/flashlight(H), pick(slot_l_hand, slot_r_hand))
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat(H), slot_wear_suit)
	equip_random_civilian_clothing(H)
	H.add_note("Role", "You are a <b>[title]</b>, when the germans came your lab was shelled! Survive with the equipment you have!")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))
	return TRUE

/datum/job/partisan/civilian/mayor
	title = "Mayor"
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianMayor"

	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/mayor/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/leather(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/charcoal(H), slot_w_uniform)
	equip_random_civilian_clothing(H)
	H.add_note("Role", "You are the <b>[title]</b>, you must work with the german occupiors to keep your citizens safe!")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))
	return TRUE

/datum/job/partisan/civilian/librarian
	title = "Librarian"
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianBook"

	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/librarian/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/flashlight(H), pick(slot_l_hand, slot_r_hand))
	equip_random_civilian_clothing(H)
	H.add_note("Role", "You are the <b>[title]</b>, keep your books safe!")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))
	return TRUE

/datum/job/partisan/civilian/jewl
	title = "Jewler"
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianJewl"

	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/jewl/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/monocle(H), slot_l_store)
	equip_random_civilian_clothing(H)
	H.add_note("Role", "You are the <b>[title]</b>, you run a shop selling precious gems!")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))
	return TRUE

/datum/job/partisan/civilian/journalist
	title = "War Journalist"
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianWar"

	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/journalist/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/camera(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/camera_film(H), slot_l_store)
	equip_random_civilian_clothing(H)
	H.add_note("Role", "You are a <b>[title]</b>, you are here working on a piece for TIME magazine!")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))
	return TRUE

//WRITER

/datum/job/partisan/civilian/writer
	title = "Writer"
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianWrite"

	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/writer/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/book(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/pen/blue(H), slot_r_hand)
	equip_random_civilian_clothing(H)
	H.add_note("Role", "You are a <b>[title]</b>, its a good time to write a book!")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))
	return TRUE

//HUNTER

/datum/job/partisan/civilian/hunter
	title = "Hunter"
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianHunt"

	// AUTOBALANCE
	min_positions = 1
	max_positions = 3
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/hunter/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/shotgunshells(H), pick(slot_l_hand, slot_r_hand))
	H.equip_to_slot_or_del(new /obj/item/stack/money(H), slot_r_store)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/shotgun/pump/combat/winchester1897 (H), slot_back)
	equip_random_civilian_clothing(H)
	H.add_note("Role", "You are a <b>[title]</b>, there are always more bear to hunt in the woods!")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_HIGH, STAT_HIGH))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))
	return TRUE

//DOCTOR

/datum/job/partisan/civilian/doctor
	title = "Doctor"
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianDoc"

	// AUTOBALANCE
	min_positions = 1
	max_positions = 2
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/doctor/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/under/doctor(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/color/white(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_med(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/stack/money(H), slot_r_store)
	H.add_note("Role", "You are a <b>[title]</b>, you were in practice for many years till you retired recently!")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", pick(STAT_VERY_HIGH, STAT_HIGH))

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))
	return TRUE

//violinist

/datum/job/partisan/civilian/vio
	title = "Violinist"
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianVio"

	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/vio/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/violin(H), pick(slot_l_hand, slot_r_hand))
	equip_random_civilian_clothing(H)
	H.add_note("Role", "You are a <b>[title]</b>, you have always had your trusty violin by your side!")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))
	return TRUE

//spy

/datum/job/partisan/civilian/americanspy
	title = "Civilian"
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianSpy"

	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/americanspy/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/_45(H), slot_l_store)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/c45m(H), slot_r_store)
	equip_random_civilian_clothing(H)
	H.add_note("Role", "You are a <b>[title]</b>, you have infiltrated this occupied town and are here to blend in and record information. In your closet is a weapon for self defense and a german radio for listening in. DO NOT BLOW YOUR COVER.")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_HIGH, STAT_NORMAL))
	H.setStat("mg", pick(STAT_HIGH, STAT_NORMAL))
	H.setStat("smg", pick(STAT_HIGH, STAT_NORMAL))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))
	return TRUE



////////////////////////////////////////////////////////////////////////////
/datum/job/partisan/civilian/redcross
	title = "Red Cross"
	selection_color = "#530909"
	spawn_location = "JoinLateRC"
	is_redcross = TRUE
	additional_languages = list( "Russian" = 100, "German" = 100, "Italian" = 100, "Polish" = 100)

	// AUTOBALANCE
	min_positions = 1
	max_positions = 3
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 20
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 20

/datum/job/partisan/civilian/redcross/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/redcross(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_med(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/medical(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/adv(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/doctor_handbook(H), slot_l_store)
	H.equip_to_slot_or_del(new 	/obj/item/clothing/head/caphat/gercap/fieldcap2(H), slot_head)
	var/obj/item/clothing/accessory/armband/redcross_a = new /obj/item/clothing/accessory/armband/redcross(null)
	var/obj/item/clothing/under/uniform = H.w_uniform
	uniform.attackby(redcross_a, H)
	H.add_note("Role", "You are a member of the Red Cross, a civilian organization whose mission is to provide medical and humanitarian help to anyone who needs it, regarding of the side in the war.")
	H.setStat("strength", STAT_NORMAL)
	H.setStat("engineering", STAT_NORMAL)
	H.setStat("shotgun", STAT_MEDIUM_LOW)
	H.setStat("medical", STAT_VERY_HIGH)

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))
	return TRUE