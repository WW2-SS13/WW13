
/datum/job/german/give_random_name(var/mob/living/carbon/human/H)
	H.name = H.species.get_random_german_name(H.gender)
	H.real_name = H.name

/datum/job/german/commander
	title = "Feldwebel"
	en_meaning = "Commander"
	flag = GEROFF
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	head_position = 1
	selection_color = "#2d2d63"
	access = list(access_nato_soldier, access_nato_medic, access_nato_surgerist, access_nato_engineer, access_nato_heavy_weapon, access_nato_cook, access_nato_squad_leader, access_nato_commander)
	minimal_access = list(access_nato_soldier, access_nato_medic, access_nato_surgerist, access_nato_engineer, access_nato_heavy_weapon, access_nato_cook, access_nato_squad_leader, access_nato_commander)
	spawn_location = "JoinLateNATO"

/datum/job/german/commander/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/gercap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/luger(H), slot_r_hand)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars(H), slot_l_hand)
	world << "<b>[H.client.prefs.german_name] is the [title] of the German forces!</b>"
	H << "<span class = 'notice'>You are the <b>[title]</b>, the highest ranking officer present. Your job is the organize the German forces and lead them to victory, while working alongside the <b>SS-Untersharffuhrer</b>.</span>"
	return 1

/datum/job/german/commander/update_character(var/mob/living/carbon/human/H)
	H.add_language("German")
	H.add_language("Russian")
	H.default_language = all_languages["German"]

	H << "<b>You know the Russian language!</b>"

	H.make_artillery_officer()

	if (istype(H.languages[1], /datum/language/common))
		H.languages[1] = null

/datum/job/german/commander/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat, new/obj/item/weapon/key/german/medic, new/obj/item/weapon/key/german/engineer,
		new/obj/item/weapon/key/german/QM, new/obj/item/weapon/key/german/command_intermediate, new/obj/item/weapon/key/german/command_high, new/obj/item/weapon/key/german/train)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*/datum/job/german/pilot
	title = "Flugzeugführer"
	flag = GEROFF
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#2d2d63"
	access = list(access_nato_soldier, access_nato_squad_leader, access_nato_commander, access_nato_medic)
	minimal_access = list(access_nato_soldier, access_nato_squad_leader, access_nato_commander, access_nato_medic)
	spawn_location = "JoinLateNATO"

/datum/job/german/pilot/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/luger(H), slot_r_hand)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars(H), slot_l_hand)
	return 1

/datum/job/german/pilot/update_character(var/mob/living/carbon/human/H)
	H.add_language("German")
	H.add_language("Russian")
	H.default_language = all_languages["German"]

	H << "<b>You know the Russian language!</b>"

	if (istype(H.languages[1], /datum/language/common))
		H.languages[1] = null

// todo:(?) pilot probably wont exist by the time the key system is in

/datum/job/german/pilot/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat, new/obj/item/weapon/key/german/medic, new/obj/item/weapon/key/german/engineer,
		new/obj/item/weapon/key/german/QM, new/obj/item/weapon/key/german/command_intermediate, new/obj/item/weapon/key/german/command_high, new/obj/item/weapon/key/german/train)*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/german/squad_leader
	title = "Gruppenfuhrer"
	en_meaning = "Squad Leader"
	flag = GERSER
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	head_position = 1
	selection_color = "#4c4ca5"
	access = list(access_nato_soldier, access_nato_medic, access_nato_surgerist, access_nato_engineer, access_nato_cook, access_nato_squad_leader, access_nato_heavy_weapon)
	minimal_access = list(access_nato_soldier, access_nato_medic, access_nato_surgerist, access_nato_engineer, access_nato_cook, access_nato_squad_leader, access_nato_heavy_weapon)
	spawn_location = "JoinLateNATO"


/datum/job/german/squad_leader/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/mp40(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars(H), slot_l_hand)
	H << "<span class = 'notice'>You are the <b>[title]</b>. Your job is to lead offensive units of the German force according to the <b>Feldwebel</b>'s orders.</span>"
	return 1

/datum/job/german/squad_leader/update_character(var/mob/living/carbon/human/H)
	H.add_language("German")
	H.default_language = all_languages["German"]

	if(prob(10))
		H.add_language("Russian")
		H << "<b>You know the Russian language!</b>"

	H.make_artillery_officer()

	if (istype(H.languages[1], /datum/language/common))
		H.languages[1] = null

/datum/job/german/squad_leader/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat, new/obj/item/weapon/key/german/command_intermediate)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/german/medic
	title = "Feldarzt"
	en_meaning = "Medic"
	flag = GERMED
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	selection_color = "#4c4ca5"
	access = list(access_nato_soldier, access_nato_medic, access_nato_heavy_weapon)
	minimal_access = list(access_nato_soldier, access_nato_medic, access_nato_heavy_weapon)
	spawn_location = "JoinLateNATO"

/datum/job/german/medic/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/mp40(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/german(H), slot_l_hand)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a medic. Your job is to keep the army healthy and in good condition.</span>"
	return 1

/datum/job/german/medic/update_character(var/mob/living/carbon/human/H)
	H.add_language("German")
	H.default_language = all_languages["German"]
	if(prob(5))
		H.add_language("Russian")
		H << "<b>You know the Russian language!</b>"

	if (istype(H.languages[1], /datum/language/common))
		H.languages[1] = null

/datum/job/german/medic/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat, new/obj/item/weapon/key/german/medic)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/german/flamethrower_man
	title = "Flammenwerfersoldat"
	en_meaning = "Flamethrower Soldier"
	flag = GERQUAR
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	selection_color = "#4c4ca5"
	access = list(access_nato_soldier, access_nato_medic, access_nato_heavy_weapon)
	minimal_access = list(access_nato_soldier, access_nato_medic, access_nato_heavy_weapon)
	spawn_location = "JoinLateNATO"

/datum/job/german/flamethrower_man/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/flammenwerfer(H), slot_back)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a flamethrower unit. Your job is incinerate the enemy!</span>"
	return 1

/datum/job/german/flamethrower_man/update_character(var/mob/living/carbon/human/H)
	H.add_language("German")
	H.default_language = all_languages["German"]
	if(prob(5))
		H.add_language("Russian")
		H << "<b>You know the Russian language!</b>"

	if (istype(H.languages[1], /datum/language/common))
		H.languages[1] = null

/datum/job/german/flamethrower_man/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/german/sniper
	title = "Sharfshutze"
	en_meaning = "Sniper"
	flag = GERSNI
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	selection_color = "#4c4ca5"
	access = list(access_nato_soldier, access_nato_heavy_weapon)
	minimal_access = list(access_nato_soldier, access_nato_heavy_weapon)
	spawn_location = "JoinLateNATO"

/datum/job/german/sniper/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k_scope(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a sniper. Your job is to assist normal <b>Soldat</b> from behind defenses.</span>"
	return 1

/datum/job/german/sniper/update_character(var/mob/living/carbon/human/H)
	H.add_language("German")
	H.default_language = all_languages["German"]
	if(prob(5))
		H.add_language("Russian")
		H << "<b>You know the Russian language!</b>"

	if (istype(H.languages[1], /datum/language/common))
		H.languages[1] = null

/datum/job/german/sniper/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/german/engineer
	title = "Pionier"
	en_meaning = "Engineer"
	flag = GERENG
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	selection_color = "#4c4ca5"
	access = list(access_nato_soldier, access_nato_engineer, access_nato_heavy_weapon)
	minimal_access = list(access_nato_soldier, access_nato_engineer, access_nato_heavy_weapon)
	spawn_location = "JoinLateNATO"


/datum/job/german/engineer/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/mp40(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/material/knife/combat(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/german(H), slot_r_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/shovel/spade/russia(H), slot_belt)
	H << "<span class = 'notice'>You are the <b>[title]</b>, an engineer. Your job is to build forward defenses.</span>"
	return 1

/datum/job/german/engineer/update_character(var/mob/living/carbon/human/H)
	H.add_language("German")
	H.default_language = all_languages["German"]
	if(prob(5))
		H.add_language("Russian")
		H << "<b>You know the Russian language!</b>"

	if (istype(H.languages[1], /datum/language/common))
		H.languages[1] = null

/datum/job/german/engineer/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat, new/obj/item/weapon/key/german/engineer)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/german/heavy_weapon
	title = "Machinegewehrschutze"
	en_meaning = "Heavy Weapons Soldier"
	flag = GERSOND
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	selection_color = "#4c4ca5"
	access = list(access_nato_soldier, access_nato_heavy_weapon)
	minimal_access = list(access_nato_soldier, access_nato_heavy_weapon)
	spawn_location = "JoinLateNATO"

/datum/job/german/heavy_weapon/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/l6_saw(H), slot_r_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/german(H), slot_l_hand)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a heavy weapons unit. Your job is to assist normal <b>Soldat</b>en in front line combat.</span>"
	return 1

/datum/job/german/heavy_weapon/update_character(var/mob/living/carbon/human/H)
	H.add_language("German")
	H.default_language = all_languages["German"]
	if(prob(5))
		H.add_language("Russian")
		H << "<b>You know the Russian language!</b>"

	if (istype(H.languages[1], /datum/language/common))
		H.languages[1] = null

/datum/job/german/heavy_weapon/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/german/soldier
	title = "Soldat"
	en_meaning = "Infantry Soldier"
	flag = GERSOL
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1000 // this was causing an error with latejoin spawning
	spawn_positions = 3
	selection_color = "#4c4ca5"
	access = list(access_nato_soldier, access_nato_heavy_weapon)
	minimal_access = list(access_nato_soldier, access_nato_heavy_weapon)
	spawn_location = "JoinLateNATO"
	fallback_spawn_location = "JoinLateNATO-Fallback"

/datum/job/german/soldier/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/shovel/spade/russia(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)
	if (!check_for_german_train_conductors())
		for (var/obj/item/weapon/storage/belt/keychain/keychain in H)
			keychain.keys += new/obj/item/weapon/key/german/train()
			H << "<i>You have a key with train access.</i>"
			break

	H << "<span class = 'notice'>You are the <b>[title]</b>, a normal infantry unit. Your job is to participate in front line combat.</span>"
	return 1


/datum/job/german/soldier/update_character(var/mob/living/carbon/human/H)
	H.add_language("German")
	H.default_language = all_languages["German"]
	if(prob(5))
		H.add_language("Russian")
		H << "<b>You know the Russian language!</b>"

	if (istype(H.languages[1], /datum/language/common))
		H.languages[1] = null

/datum/job/german/soldier/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
var/first_fallschirm = 1

/datum/job/german/fallschirm
	title = "Fallschirmjager"
	en_meaning = "Paratrooper"
	flag = GERFALL
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	selection_color = "#4c4ca5"
	access = list(access_nato_soldier, access_nato_heavy_weapon)
	minimal_access = list(access_nato_soldier, access_nato_heavy_weapon)
//	spawn_location = "Fallschirm"
	spawn_location = "JoinLateNATO"


/datum/job/german/fallschirm/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/under/falluni(H), slot_w_uniform)
	//H.equip_to_slot_or_del(new /obj/item/clothing/suit/fallsparka(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	if(first_fallschirm)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/mp40(H), slot_back)
		world << "<b>You can see a Ju 57 in the sky...</b>"
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)

	if(first_fallschirm)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/german/fallofficer(H), slot_belt)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/german/fallsoldier(H), slot_belt)

	first_fallschirm = 0

	H << "<span class = 'notice'>You are the <b>[title]</b>, a paratrooper. Your job is to help any other units that need assistance.</span>"
	return 1


/datum/job/german/fallschirm/update_character(var/mob/living/carbon/human/H)
	H.add_language("German")
	H.add_language("Russian")
	H.default_language = all_languages["German"]
	H << "<b>You know the Russian language!</b>"

	if (istype(H.languages[1], /datum/language/common))
		H.languages[1] = null

/datum/job/german/fallschirm/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/german/stabsgefreiter
	title = "Stabsgefreiter"
	en_meaning = "Quartermaster"
	flag = GERQUAR
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#4c4ca5"
	access = list(access_nato_soldier, access_nato_heavy_weapon)
	minimal_access = list(access_nato_soldier, access_nato_heavy_weapon)
//	spawn_location = "Fallschirm"
	spawn_location = "JoinLateNATO"

/datum/job/german/stabsgefreiter/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/mp40(H), slot_back)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a Quartermaster. Your job is to keep the army well armed and supplied.</span>"
	return 1

/datum/job/german/stabsgefreiter/update_character(var/mob/living/carbon/human/H)
	H.add_language("German")
	H.add_language("Russian")
	H.default_language = all_languages["German"]
	H << "<b>You know the Russian language!</b>"

	if (istype(H.languages[1], /datum/language/common))
		H.languages[1] = null

/datum/job/german/stabsgefreiter/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat, new/obj/item/weapon/key/german/QM)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/german/artyman
	title = "Kanonier"
	en_meaning = "Artillery Officer"
	flag = GERQUAR
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	selection_color = "#4c4ca5"
	access = list(access_nato_soldier, access_nato_engineer, access_nato_heavy_weapon)
	minimal_access = list(access_nato_soldier, access_nato_engineer, access_nato_heavy_weapon)
	spawn_location = "JoinLateNATO"

/datum/job/german/artyman/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/gercap/fieldcap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/wrench(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars(H), slot_r_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/shovel/spade/russia(H), slot_belt)
	H << "<span class = 'notice'>You are the <b>[title]</b>, an artillery officer. Your job is to bomb the shit out of the enemy.</span>"
	return 1

/datum/job/german/artyman/update_character(var/mob/living/carbon/human/H)
	H.add_language("German")
	H.default_language = all_languages["German"]
	if(prob(5))
		H.add_language("Russian")
		H << "<b>You know the Russian language!</b>"

	H.make_artillery_officer()


	if (istype(H.languages[1], /datum/language/common))
		H.languages[1] = null

/datum/job/german/artyman/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat, new/obj/item/weapon/key/german/command_intermediate)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/german/scout
	title = "Aufklartrupp"
	en_meaning = "Scout"
	flag = GERQUAR
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	selection_color = "#4c4ca5"
	access = list(access_nato_soldier, access_nato_engineer, access_nato_heavy_weapon)
	minimal_access = list(access_nato_soldier, access_nato_engineer, access_nato_heavy_weapon)
	spawn_location = "JoinLateNATO"

/datum/job/german/scout/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/shovel/spade/russia(H), slot_belt)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a scout. Your job is to assist the <b>Kanonier</b> by getting coordinates.</span>"
	return 1

/datum/job/german/scout/update_character(var/mob/living/carbon/human/H)
	H.add_language("German")
	H.default_language = all_languages["German"]
	if(prob(5))
		H.add_language("Russian")
		H << "<b>You know the Russian language!</b>"

	H.make_artillery_scout()

	if (istype(H.languages[1], /datum/language/common))
		H.languages[1] = null

/datum/job/german/scout/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/german/conductor
	title = "Dirigent"
	en_meaning = "Train Conductor"
	flag = GERQUAR
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	selection_color = "#4c4ca5"
	access = list(access_nato_soldier, access_nato_engineer, access_nato_heavy_weapon)
	minimal_access = list(access_nato_soldier, access_nato_engineer, access_nato_heavy_weapon)
	spawn_location = "JoinLateNATO"

/datum/job/german/conductor/train_check() // if there's no train, don't let people be conductors!
	return WW2_train_check()

/datum/job/german/conductor/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/gercap/fieldcap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/luger(H), slot_r_hand)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a train conductor. Your job is take men to and from the front.</span>"
	return 1

/datum/job/german/conductor/update_character(var/mob/living/carbon/human/H)
	H.add_language("German")
	H.default_language = all_languages["German"]
	if(prob(5))
		H.add_language("Russian")
		H << "<b>You know the Russian language!</b>"

	if (istype(H.languages[1], /datum/language/common))
		H.languages[1] = null

/datum/job/german/conductor/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat, new/obj/item/weapon/key/german/train,
		new/obj/item/weapon/key/german/command_intermediate)

////////////////////////////////
/datum/job/german/squad_leader_ss
	title = "SS-Untersharffuhrer"
	en_meaning = "S.S. Squad Leader"
	flag = GERSER
	department_flag = GUNSERG // so we get our own job category
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	head_position = 1
	selection_color = "#4c4ca5"
	access = list(access_nato_soldier, access_nato_medic, access_nato_surgerist, access_nato_engineer, access_nato_cook, access_nato_squad_leader, access_nato_heavy_weapon)
	minimal_access = list(access_nato_soldier, access_nato_medic, access_nato_surgerist, access_nato_engineer, access_nato_cook, access_nato_squad_leader, access_nato_heavy_weapon)
	spawn_location = "JoinLateSS-Officer"
	is_SS = 1

/datum/job/german/squad_leader_ss/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/ssuni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/sssmock(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/sshelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/akm(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/device/binoculars(H), slot_l_hand)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a squad leader for an elite S.S. unit. Your job is to work alongside normal <b>Gruppenfuhrer</b>s and the <b>Feldwebel</b>, while setting your own goals.</span>"
	return 1

/datum/job/german/squad_leader_ss/update_character(var/mob/living/carbon/human/H)
	H.add_language("German")
	H.default_language = all_languages["German"]
	if(prob(10))
		H.add_language("Russian")
		H << "<b>You know the Russian language!</b>"

	H.make_artillery_officer()

	if (istype(H.languages[1], /datum/language/common))
		H.languages[1] = null

/datum/job/german/squad_leader_ss/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat,
		new/obj/item/weapon/key/german/command_intermediate, new/obj/item/weapon/key/german/SS)
////////////////////////////////

/datum/job/german/soldier_ss
	title = "SS-Schutze"
	en_meaning = "S.S. Infantry Soldier"
	flag = GERSOL
	department_flag = GUNSERG // so we get our own job category
	faction = "Station"
	total_positions = 5 // this was causing an error with latejoin spawning
	spawn_positions = 5
	selection_color = "#4c4ca5"
	access = list(access_nato_soldier, access_nato_heavy_weapon)
	minimal_access = list(access_nato_soldier, access_nato_heavy_weapon)
	spawn_location = "JoinLateSS"
	is_SS = 1

/datum/job/german/soldier_ss/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/ssuni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/sssmock(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/sshelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/shovel/spade/russia(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a soldier for an elite S.S. unit. Your job is to follow the orders of the <b>SS-Untersharffuhrer</b>.</span>"
	return 1

/datum/job/german/soldier_ss/update_character(var/mob/living/carbon/human/H)
	H.add_language("German")
	H.default_language = all_languages["German"]
	if(prob(5))
		H.add_language("Russian")
		H << "<b>You know the Russian language!</b>"

	if (istype(H.languages[1], /datum/language/common))
		H.languages[1] = null

/datum/job/german/soldier_ss/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat, new/obj/item/weapon/key/german/SS)