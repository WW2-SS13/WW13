/proc/civ_stat()
	return pick(ALL_STATS)

/datum/job/partisan/proc/create_partisan(var/mob/living/carbon/human/H)
	if(!map.agents || map.agents_in_game >= 4)
		return

	if(prob(80))
		return

	var/obj/item/letter/L = new /obj/item/letter()
	H.put_in_any_hand_if_possible(L)

	if(!(L in H.contents))
		L.loc = get_turf(H)

	map.agents_in_game++
	H << "<B><span class='danger'>You are partisan!!!</span>"
	H.mind.store_memory("You are partisan!!!")

/datum/job/partisan/civilian
	title = "Civilian"
	selection_color = "#530909"
	spawn_location = "JoinLateCivilian"

	// AUTOBALANCE
	min_positions = 1
	max_positions = 10
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/equip(var/mob/living/carbon/human/H, var/create_partisans = 0)
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

	create_partisan(H)

	return TRUE

//CHEF
/datum/job/partisan/civilian/chef
	title = "Chef"
	is_occupation = TRUE
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianChef"
	additional_languages = list( "Russian" = 10, "German" = 70)
	// AUTOBALANCE
	min_positions = 1
	max_positions = 3
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/chef/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/chef/classic(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chef(H), slot_w_uniform)
	H.add_note("Role", "You are a <b>[title]</b>, one of the best in this city, serve the guests of this restruant with the best food in town!")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))

	create_partisan(H)

	return TRUE

//DETECTIVE
/datum/job/partisan/civilian/det
	title = "Detective"
	is_occupation = TRUE
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianDetective"
	additional_languages = list( "Russian" = 10, "German" = 80)
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
	H.equip_to_slot_or_del(new 	/obj/item/clothing/suit/storage/det_trench(H), slot_wear_suit)
	H.add_note("Role", "You are a <b>[title]</b>! It was cold. It was dark. Just another evening in this city. The police force was dismantaled by the occupiers here who's friends had a particular distaste for the boys in blue. Specially now, in 1942. You can get away with punching a cop no problem.")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_MEDIUM_LOW, STAT_MEDIUM_HIGH))
	H.setStat("mg", pick(STAT_MEDIUM_LOW, STAT_MEDIUM_HIGH))
	H.setStat("smg", pick(STAT_MEDIUM_LOW, STAT_MEDIUM_HIGH))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))

	create_partisan(H)

	return TRUE

//COP
/datum/job/partisan/civilian/cop
	title = "Cop"
	is_occupation = TRUE
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianCop"
	additional_languages = list( "Russian" = 10, "German" = 80)
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
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/_45(H), slot_l_store)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/c45m(H), slot_r_store)
	H.add_note("Role", "You are a <b>[title]</b>, well not so much anymore. The germans have dismantaled the police force and torched the building. Survive.")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_MEDIUM_LOW, STAT_MEDIUM_HIGH))
	H.setStat("smg", pick(STAT_MEDIUM_LOW, STAT_MEDIUM_HIGH))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))

	create_partisan(H)

	return TRUE

//CONSTRUCTION WORKER

/datum/job/partisan/civilian/worker
	title = "Construction Worker"
	is_occupation = TRUE
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianWorker"
	additional_languages = list( "Russian" = 10, "German" = 70)
	// AUTOBALANCE
	min_positions = 1
	max_positions = 10
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/worker/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/engineer(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/toolbox/mechanical(H), slot_l_hand)

	H.add_note("Role", "You are a <b>[title]</b>, a simple man trying to live a simple life. Before the germans arrived we were working on a construction site down south. ")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", pick(STAT_HIGH, STAT_VERY_HIGH))
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))

	create_partisan(H)

	return TRUE

//RICH MAN

/datum/job/partisan/civilian/rich
	title = "Rich Banker"
	is_occupation = TRUE
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianRich"
	additional_languages = list( "Russian" = 10, "German" = 70)
	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
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

	create_partisan(H)

	return TRUE

//SCIENTIST
//TODO: Update clothing for scientist and give random chemcials in pockets.
/datum/job/partisan/civilian/sci
	title = "Scientist"
	is_occupation = TRUE
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianScientist"
	additional_languages = list( "Russian" = 10, "German" = 70, "English" = 50)
	// AUTOBALANCE
	min_positions = 1
	max_positions = 10
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/sci/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/flashlight(H), pick(slot_l_hand, slot_r_hand))
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat(H), slot_wear_suit)
	H.add_note("Role", "You are a <b>[title]</b>, when the germans came your lab was shelled! Survive with the equipment you have!")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))

	create_partisan(H)

	return TRUE

//MAYOR
//Give mayor clothing and german radio
/datum/job/partisan/civilian/mayor
	title = "Mayor"
	is_occupation = TRUE
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianMayor"
	additional_languages = list( "Russian" = 100, "German" = 100, "English" = 100)
	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/mayor/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/leather(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/mayor(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/radio/feldfu/SS(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/coat/civilian(H), slot_wear_suit)
	H.add_note("Role", "You are the <b>[title]</b>, you must work with the german occupiors to keep your citizens safe!")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))

	create_partisan(H)

	return TRUE


//LIBRARIAN
//TODO: Better clothing
/datum/job/partisan/civilian/librarian
	title = "Librarian"
	is_occupation = TRUE
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianBook"
	additional_languages = list( "Russian" = 70, "German" = 70)
	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/librarian/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/flashlight(H), pick(slot_l_hand, slot_r_hand))
	H.equip_to_slot_or_del(new /obj/item/clothing/under/common2(H), slot_w_uniform)
	H.add_note("Role", "You are the <b>[title]</b>, keep your books safe!")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))

	create_partisan(H)

	return TRUE

//PREIST
//TODO: Better clothing
/datum/job/partisan/civilian/priest
	title = "Priest"
	is_occupation = TRUE
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianGod"
	additional_languages = list( "Russian" = 70, "German" = 70)
	// AUTOBALANCE
	min_positions = 1
	max_positions = 2
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/preist/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/flashlight(H), pick(slot_l_hand, slot_r_hand))
	H.equip_to_slot_or_del(new /obj/item/clothing/under/common1(H), slot_w_uniform)
	H.add_note("Role", "You are a <b>[title]</b>, keep your flock safe!")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", pick(STAT_MEDIUM_HIGH, STAT_HIGH))

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))

	create_partisan(H)

	return TRUE

//GEM
//Todo: More MONEY
/datum/job/partisan/civilian/jewl
	title = "Jewler"
	is_occupation = TRUE
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianJewl"
	additional_languages = list( "Russian" = 10, "German" = 70)
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

	create_partisan(H)

	return TRUE


//WAR JOURNALIST
//TODO: Fix camera and give war journalist more features and shit.
/datum/job/partisan/civilian/journalist
	title = "War Journalist"
	is_occupation = TRUE
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianWar"
	additional_languages = list( "Russian" = 100, "German" = 100, "English" = 100)
	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/journalist/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	//H.equip_to_slot_or_del(new /obj/item/camera(H), slot_l_hand)
	//H.equip_to_slot_or_del(new /obj/item/camera_film(H), slot_l_store)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/work2(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/press(H), slot_wear_suit)

	H.add_note("Role", "You are a <b>[title]</b>, you are here working on a piece for TIME magazine!")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))

	create_partisan(H)

	return TRUE

//WRITER
//TODO: Book writing?
/datum/job/partisan/civilian/writer
	title = "Writer"
	is_occupation = TRUE
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianWrite"
	additional_languages = list( "Russian" = 10, "German" = 70)
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
	H.equip_to_slot_or_del(new /obj/item/clothing/under/work1(H), slot_w_uniform)
	H.add_note("Role", "You are a <b>[title]</b>, its a good time to write a book!")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))

	create_partisan(H)

	return TRUE

//HUNTER
//TODO: better clothes
/datum/job/partisan/civilian/hunter
	title = "Hunter"
	is_occupation = TRUE
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianHunt"
	additional_languages = list( "Russian" = 10, "German" = 70)
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
	H.equip_to_slot_or_del(new /obj/item/clothing/under/hunter(H), slot_w_uniform)
	H.add_note("Role", "You are a <b>[title]</b>, there are always more bear to hunt in the woods!")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", civ_stat())

	H.setStat("rifle", pick(STAT_VERY_HIGH, STAT_HIGH))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))

	create_partisan(H)

	return TRUE

//DOCTOR
//TODO: not much maybe more supplies
/datum/job/partisan/civilian/doctor
	title = "Doctor"
	is_occupation = TRUE
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianDoc"
	additional_languages = list( "Russian" = 20, "German" = 80)
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

	create_partisan(H)

	return TRUE

//FIRE
/datum/job/partisan/civilian/fire
	title = "Fire Fighter"
	is_occupation = TRUE
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianDoc"
	additional_languages = list( "Russian" = 20, "German" = 80)
	// AUTOBALANCE
	min_positions = 1
	max_positions = 3
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/fire/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/under/firefighter(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/german(H), slot_back)
	H.add_note("Role", "You are a <b>[title]</b>, in the chaos the fire department was destroyed! Maybe you could get the engineers to rebuild it!")
	H.setStat("strength", civ_stat())
	H.setStat("engineering", civ_stat())
	H.setStat("shotgun", civ_stat())
	H.setStat("medical", pick(STAT_VERY_HIGH, STAT_HIGH))

	H.setStat("rifle", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("mg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))
	H.setStat("smg", pick(STAT_VERY_LOW, STAT_LOW, STAT_MEDIUM_LOW))

	H.setStat("survival", pick(STAT_MEDIUM_HIGH, STAT_HIGH))

	create_partisan(H)

	return TRUE

//violinist
//TODO: manuscript and clothign
/datum/job/partisan/civilian/vio
	title = "Violinist"
	is_occupation = TRUE
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianVio"
	additional_languages = list( "Russian" = 10, "German" = 70)
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

	create_partisan(H)

	return TRUE

//spy

/datum/job/partisan/civilian/americanspy
	title = "Construction Worker"
	is_occupation = TRUE
	selection_color = "#530909"
	spawn_location = "JoinLateCivilianSpy"
	additional_languages = list( "Russian" = 100, "German" = 100, "English" = 100)
	// AUTOBALANCE
	min_positions = 1
	max_positions = 1
	player_threshold = PLAYER_THRESHOLD_HIGHEST - 10
	scale_to_players = PLAYER_THRESHOLD_HIGHEST + 10

/datum/job/partisan/civilian/americanspy/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/_45(H), slot_l_store)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/c45m(H), slot_r_store)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/work2(H), slot_w_uniform)
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
	is_occupation = TRUE
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

	create_partisan(H)

	return TRUE
/////////////////////////////////////////////////////////////
/datum/job/partisan/civilian/prisoner
	title = "Zaklyucheny GULAG"
	en_meaning = "GULAG Prisoner"
	rank_abbreviation = "Zak"
	selection_color = "#770e0e"
	spawn_location = "JoinLatePOW"
	additional_languages = list( "Russian" = 100 )
	allow_spies = TRUE
	is_prisoner = TRUE
	SL_check_independent = TRUE

	// AUTOBALANCE
	min_positions = 0
	max_positions = 0

/datum/job/partisan/civilian/prisoner/equip(var/mob/living/carbon/human/H)
	if (!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/under/gulag(H), slot_w_uniform)
	H.add_note("Role", "You are a <b>[title]</b>, a disgraced Soviet citizen thrown into the GULAG system in Siberia. Try to survive!")
	H.add_note("Rules", "ATTENTION! This is a <b>HIGH-ROLEPLAY</b> map! <b>DO NOT</b> start attacking the guards without a reason, and act reallisticaly. If you do not want to play in a HIGH RP gamemode, please leave. Your objective is to escape and reach one of the corners of the map. Dig tunnels, destroy the fence, and do anything to escape, but be realistic.")
	H.setStat("strength", STAT_LOW)
	H.setStat("engineering", STAT_LOW)
	H.setStat("rifle", STAT_LOW)
	H.setStat("mg", STAT_LOW)
	H.setStat("smg", STAT_LOW)
	H.setStat("pistol", STAT_LOW)
	H.setStat("heavyweapon", STAT_LOW)
	H.setStat("medical", STAT_LOW)
	H.setStat("shotgun", STAT_LOW)
	return TRUE
