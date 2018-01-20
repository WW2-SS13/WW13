/datum/job/german
	faction = "Station"

/datum/job/german/give_random_name(var/mob/living/carbon/human/H)
	H.name = H.species.get_random_german_name(H.gender)
	H.real_name = H.name

/datum/job/german/commander
	title = "Oberleutnant"
	en_meaning = "Commander"
	total_positions = TRUE
	head_position = TRUE
	selection_color = "#2d2d63"
	spawn_location = "JoinLateHeerCO"
	additional_languages = list( "Russian" = 100, "Ukrainian" = 50 )
	is_officer = TRUE
	is_commander = TRUE
	absolute_limit = TRUE
	whitelisted = TRUE

/datum/job/german/commander/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni/gerofficer(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/gerofficercap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/weapon/attachment/scope/adjustable/binoculars(H), slot_l_hand)
	world << "<b><big>[H.client.prefs.german_name] is the [title] of the German forces!</big></b>"
	H << "<span class = 'notice'>You are the <b>[title]</b>, the highest ranking officer present. Your job is the organize the German forces and lead them to victory, while working alongside the <b>SS-Untersharffuhrer</b>. You take orders from the <b>German High Command</b>.</span>"
	H.give_radio()
	H.setStat("strength", STAT_MEDIUM_LOW)
	H.setStat("engineering", STAT_VERY_LOW)
	H.setStat("rifle", STAT_LOW)
	H.setStat("mg", STAT_MEDIUM_LOW)
	H.setStat("pistol", STAT_NORMAL)
	H.setStat("heavyweapon", STAT_NORMAL)
	H.setStat("medical", STAT_VERY_LOW)
	return TRUE

/datum/job/german/commander/update_character(var/mob/living/carbon/human/H)
	..()
	H.make_artillery_officer()

/datum/job/german/commander/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat, new/obj/item/weapon/key/german/medic, new/obj/item/weapon/key/german/engineer,
		new/obj/item/weapon/key/german/QM, new/obj/item/weapon/key/german/command_intermediate, new/obj/item/weapon/key/german/command_high, new/obj/item/weapon/key/german/train, new/obj/item/weapon/key/german/SS)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/german/staff_officer
	title = "Stabsoffizier"
	en_meaning = "Staff Officer"
	total_positions = 2
	head_position = FALSE
	selection_color = "#2d2d63"
	spawn_location = "JoinLateHeerSO"
	additional_languages = list( "Russian" = 100, "Ukrainian" = 50 )
	is_officer = TRUE
	absolute_limit = 3

/datum/job/german/staff_officer/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni/gerofficer(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/gerofficercap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/weapon/attachment/scope/adjustable/binoculars(H), slot_l_hand)
	H << "<span class = 'notice'>You are the <b>[title]</b>, one of the vice-commanders of the German forces. Your job is to take orders from the <b>Feldwebel</b> and coordinate with squad leaders.</span>"
	H.give_radio()
	H.setStat("strength", STAT_MEDIUM_LOW)
	H.setStat("engineering", STAT_VERY_LOW)
	H.setStat("rifle", STAT_LOW)
	H.setStat("mg", STAT_MEDIUM_LOW)
	H.setStat("pistol", STAT_NORMAL)
	H.setStat("heavyweapon", STAT_NORMAL)
	H.setStat("medical", STAT_VERY_LOW)
	return TRUE

/datum/job/german/staff_officer/update_character(var/mob/living/carbon/human/H)
	..()
	H.make_artillery_officer()

/datum/job/german/staff_officer/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat, new/obj/item/weapon/key/german/medic, new/obj/item/weapon/key/german/engineer,
		new/obj/item/weapon/key/german/QM, new/obj/item/weapon/key/german/command_intermediate, new/obj/item/weapon/key/german/command_high, new/obj/item/weapon/key/german/train)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/german/MP
	title = "Militärpolizei"
	en_meaning = "Military Police Officer"
	total_positions = 2
	selection_color = "#2d2d63"
	spawn_location = "JoinLateHeer"
	additional_languages = list( "Russian" = 100, "Ukrainian" = 33 )
	absolute_limit = 3
	is_officer = TRUE

/datum/job/german/MP/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni/MP(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm/MP(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/german/MP(H), slot_belt)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a military police officer. Keep the <b>Soldat</b>en in line.</span>"
	H.give_radio()
	H.setStat("strength", STAT_VERY_HIGH)
	H.setStat("engineering", STAT_VERY_LOW)
	H.setStat("rifle", STAT_LOW)
	H.setStat("mg", STAT_LOW)
	H.setStat("pistol", STAT_NORMAL)
	H.setStat("heavyweapon", STAT_NORMAL)
	H.setStat("medical", STAT_VERY_LOW)
	return TRUE

/datum/job/german/MP/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat, new/obj/item/weapon/key/german/medic, new/obj/item/weapon/key/german/engineer,
		new/obj/item/weapon/key/german/QM, new/obj/item/weapon/key/german/command_intermediate, new/obj/item/weapon/key/german/train)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/german/squad_leader
	title = "Gruppenfuhrer"
	en_meaning = "Squad Leader"
	total_positions = 4
	head_position = FALSE
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeerSL"
	additional_languages = list( "Russian" = 33 )
	is_officer = TRUE
	is_squad_leader = TRUE

/datum/job/german/squad_leader/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni/gerofficer(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/gerofficercap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/mp40(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/attachment/scope/adjustable/binoculars(H), slot_l_hand)
	H << "<span class = 'notice'>You are the <b>[title]</b>. Your job is to lead offensive units of the German force according to the <b>Feldwebel</b>'s and <b>Stabsoffizier</b>en's orders.</span>"
	H.give_radio()
	H.setStat("strength", STAT_NORMAL)
	H.setStat("engineering", STAT_LOW)
	H.setStat("rifle", STAT_MEDIUM_LOW)
	H.setStat("mg", STAT_MEDIUM_HIGH)
	H.setStat("pistol", STAT_MEDIUM_LOW)
	H.setStat("heavyweapon", STAT_NORMAL)
	H.setStat("medical", STAT_LOW)
	return TRUE

/datum/job/german/squad_leader/update_character(var/mob/living/carbon/human/H)
	..()
	H.make_artillery_officer()

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
	total_positions = 5
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"

/datum/job/german/medic/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm/medic(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/mp40(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/german(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/doctor_handbook(H), slot_l_store)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a medic. Your job is to keep the army healthy and in good condition.</span>"
	H.give_radio()
	H.setStat("strength", STAT_MEDIUM_LOW)
	H.setStat("engineering", STAT_LOW)
	H.setStat("rifle", STAT_MEDIUM_LOW)
	H.setStat("mg", STAT_NORMAL)
	H.setStat("pistol", STAT_NORMAL)
	H.setStat("heavyweapon", STAT_MEDIUM_LOW)
	H.setStat("medical", STAT_MEDIUM_HIGH)
	return TRUE

/datum/job/german/medic/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat, new/obj/item/weapon/key/german/medic)

/datum/job/german/doctor
	title = "Medizinier"
	en_meaning = "Doctor"
	total_positions = 3
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeerDr"
	is_nonmilitary = TRUE
	additional_languages = list( "Russian" = 100, "Ukrainian" = 50 )

/datum/job/german/doctor/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/color/white(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/doctor(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_med(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/medical(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/adv(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/doctor_handbook(H), slot_l_store)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a doctor. Your job is to stay back at base and treat wounded that come in from the front, as well as treat prisoners and base personnel.</span>"
	H.give_radio()
	H.setStat("strength", STAT_LOW)
	H.setStat("engineering", STAT_VERY_LOW)
	H.setStat("rifle", STAT_LOW)
	H.setStat("mg", STAT_VERY_LOW)
	H.setStat("pistol", STAT_MEDIUM_LOW)
	H.setStat("heavyweapon", STAT_VERY_LOW)
	H.setStat("medical", STAT_VERY_HIGH)
	return TRUE

/datum/job/german/doctor/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/medic, new/obj/item/weapon/key/german/command_intermediate)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/german/flamethrower_man
	title = "Flammenwerfersoldat"
	en_meaning = "Flamethrower Soldier"
	total_positions = 3
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"
	is_primary = FALSE
	is_secondary = TRUE

/datum/job/german/flamethrower_man/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/flammenwerfer(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger(H), slot_belt)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a flamethrower unit. Your job is incinerate the enemy!</span>"
	H.give_radio()
	H.setStat("strength", STAT_NORMAL)
	H.setStat("engineering", STAT_NORMAL)
	H.setStat("rifle", STAT_NORMAL)
	H.setStat("mg", STAT_NORMAL)
	H.setStat("pistol", STAT_NORMAL)
	H.setStat("heavyweapon", STAT_MEDIUM_LOW)
	H.setStat("medical", STAT_LOW)
	return TRUE

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
	total_positions = 3
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"
	is_primary = FALSE
	is_secondary = TRUE

/datum/job/german/sniper/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/attachment/scope/adjustable/sniper_scope(H), slot_r_store)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a sniper. Your job is to assist normal <b>Soldat</b> from behind defenses.</span>"
	H.give_radio()
	H.setStat("strength", STAT_NORMAL)
	H.setStat("engineering", STAT_NORMAL)
	H.setStat("rifle", STAT_VERY_HIGH)
	H.setStat("mg", STAT_NORMAL)
	H.setStat("pistol", STAT_NORMAL)
	H.setStat("heavyweapon", STAT_MEDIUM_LOW)
	H.setStat("medical", STAT_VERY_LOW)
	return TRUE

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
	total_positions = 3
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"

/datum/job/german/engineer/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/mp40(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/material/knife/combat(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/german(H), slot_r_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/shovel/spade/russia(H), slot_belt)
	H << "<span class = 'notice'>You are the <b>[title]</b>, an engineer. Your job is to build forward defenses.</span>"
	H.give_radio()
	H.setStat("strength", STAT_MEDIUM_HIGH)
	H.setStat("engineering", STAT_VERY_HIGH)
	H.setStat("rifle", STAT_MEDIUM_LOW)
	H.setStat("mg", STAT_MEDIUM_HIGH)
	H.setStat("pistol", STAT_NORMAL)
	H.setStat("heavyweapon", STAT_MEDIUM_LOW)
	H.setStat("medical", STAT_VERY_LOW)
	return TRUE

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
	total_positions = 2
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"
	is_primary = FALSE
	is_secondary = TRUE

/datum/job/german/heavy_weapon/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/l6_saw(H), slot_r_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/german(H), slot_l_hand)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a heavy weapons unit. Your job is to assist normal <b>Soldat</b>en in front line combat.</span>"
	H.give_radio()
	H.setStat("strength", STAT_VERY_HIGH)
	H.setStat("engineering", STAT_NORMAL)
	H.setStat("rifle", STAT_MEDIUM_LOW)
	H.setStat("mg", STAT_VERY_HIGH)
	H.setStat("pistol", STAT_NORMAL)
	H.setStat("heavyweapon", STAT_NORMAL) // misleading statname, heavyweapons soldiers are best with MGs
	H.setStat("medical", STAT_LOW)
	return TRUE

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
	total_positions = 200 // this was causing an error with latejoin spawning
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"
	allow_spies = TRUE

/datum/job/german/soldier/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/shovel/spade/russia(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a normal infantry unit. Your job is to participate in front line combat.</span>"
	H.give_radio()
	H.setStat("strength", STAT_NORMAL)
	H.setStat("engineering", STAT_NORMAL)
	H.setStat("rifle", STAT_NORMAL)
	H.setStat("mg", STAT_NORMAL)
	H.setStat("pistol", STAT_NORMAL)
	H.setStat("heavyweapon", STAT_NORMAL)
	H.setStat("medical", STAT_NORMAL)
	return TRUE

/datum/job/german/soldier/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/german/dogmaster
	title = "Hunden Trainer"
	en_meaning = "Dog Trainer"
	total_positions = 50
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"
	allow_spies = TRUE

/datum/job/german/dogmaster/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)
	H << "<span class = 'notice'>You are the <b>[title]</b>, the master of the dogs.</span>"
	H << "<span class = 'warning'>See your notes for dog commands.</span>"

	H.add_memory("As a Hunden Trainer, you have access to a number of dog commands. To use them, simply shout! them near a dog which belongs to your faction. These are listed below:")
	H.add_memory("")
	H.add_memory("attack! - attack armed enemies.")
	H.add_memory("kill! - kill armed or unarmed enemies.")
	H.add_memory("guard! - attack enemies who come near us.")
	H.add_memory("patrol! - start patrolling.")
	H.add_memory("stop patrolling! - stop patrolling.")
	H.add_memory("be passive! - only attack in self defense.")
	H.add_memory("stop everything! - stop patrolling and be passive.")
	H.add_memory("follow! - follow me.")
	H.add_memory("stop following! - stop following whoever you're following.")
	H.add_memory("prioritize {following/attacking}! - tells the dog if it should stop following you when it finds a target to attack.")
	H.add_memory("")
	H.add_memory("Some commands overlap. There are three categories of commands: attack modes, patrol modes, and follow modes. Each type of command can be used in tandem with commands of the other types.")
	H.add_memory("")
	H.give_radio()
	H.setStat("strength", STAT_MEDIUM_LOW)
	H.setStat("engineering", STAT_MEDIUM_LOW)
	H.setStat("rifle", STAT_MEDIUM_LOW)
	H.setStat("mg", STAT_MEDIUM_LOW)
	H.setStat("pistol", STAT_NORMAL)
	H.setStat("heavyweapon", STAT_MEDIUM_LOW)
	H.setStat("medical", STAT_MEDIUM_LOW)
	return TRUE

/datum/job/german/dogmaster/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/german/tankcrew
	title = "Panzerbesatzung"
	en_meaning = "Tank Crewman"
	total_positions = 4
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"
	is_primary = FALSE
	is_secondary = TRUE
	absolute_limit = 4
	is_tankuser = TRUE

/datum/job/german/tankcrew/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni/gertankeruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/gertankerhat(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/mp40(H), slot_back)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a tank crewman. Your job is to work with another crewman to operate a tank.</span>"
	H.give_radio()
	H.setStat("strength", STAT_VERY_HIGH)
	H.setStat("engineering", STAT_MEDIUM_HIGH)
	H.setStat("rifle", STAT_MEDIUM_LOW)
	H.setStat("mg", STAT_MEDIUM_HIGH)
	H.setStat("pistol", STAT_NORMAL)
	H.setStat("heavyweapon", STAT_MEDIUM_LOW)
	H.setStat("medical", STAT_MEDIUM_LOW)
	return TRUE

/datum/job/german/tankcrew/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat, new/obj/item/weapon/key/german/command_intermediate)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/german/anti_tank_crew
	title = "Panzer-Soldat"
	en_meaning = "Anti Tank Soldier"
	total_positions = 4
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"
	is_primary = FALSE
	is_secondary = TRUE
	absolute_limit = 4

/datum/job/german/anti_tank_crew/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/heavysniper/ptrd(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/german/anti_tank_crew, slot_belt)
	H << "<span class = 'notice'>You are the <b>[title]</b>, an anti-tank infantry unit. Your job is to destroy enemy tanks.</span>"
	H.give_radio()
	H.setStat("strength", STAT_NORMAL)
	H.setStat("engineering", STAT_NORMAL)
	H.setStat("rifle", STAT_NORMAL)
	H.setStat("mg", STAT_NORMAL)
	H.setStat("pistol", STAT_NORMAL)
	H.setStat("heavyweapon", STAT_VERY_HIGH)
	H.setStat("medical", STAT_NORMAL)
	return TRUE

/datum/job/german/anti_tank_crew/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat)

var/first_fallschirm = TRUE

/datum/job/german/paratrooper
	title = "Fallschirmjager"
	en_meaning = "Paratrooper"
	total_positions = 7
	selection_color = "#4c4ca5"
	spawn_location = "Fallschirm"
	additional_languages = list( "Russian" = 100, "Ukrainian" = 100 )
	spawn_delay = 3000
	delayed_spawn_message = "<span class = 'danger'><big>You are parachuting behind Russian lines. You won't spawn until 5 minutes.</big></span>"
	is_paratrooper = TRUE
	var/fallschirm_spawnzone = null
	var/list/fallschirm_spawnpoints = list()

/datum/job/german/paratrooper/equip(var/mob/living/carbon/human/H)
	spawn_delay = config.paratrooper_drop_time

	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni/falluni(H), slot_w_uniform)

	var/obj/item/clothing/accessory/storage/webbing/webbing = new/obj/item/clothing/accessory/storage/webbing(get_turf(H))
	var/obj/item/clothing/under/uniform = H.w_uniform
	uniform.attackby(webbing, H)

	H.equip_to_slot_or_del(new /obj/item/clothing/suit/fallsparka(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/german/paratrooper(H), slot_r_hand)

	if(first_fallschirm)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/mp40(H), slot_back)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)

	if(first_fallschirm)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/german/fallofficer(H), slot_belt)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/german/fallsoldier(H), slot_belt)

	first_fallschirm = FALSE

	if(!fallschirm_spawnzone)
		fallschirm_spawnzone = pick(fallschirm_landmarks)
		fallschirm_landmarks = null
		for(var/turf/T in range(3, fallschirm_spawnzone))
			fallschirm_spawnpoints += T

		H.loc = get_turf(fallschirm_spawnzone)
	else
		H.loc = pick(fallschirm_spawnpoints)

	H << "<span class = 'notice'>You are the <b>[title]</b>, a paratrooper. Your job is to help any other units that need assistance.</span>"
	H.give_radio()
	// Paratroopers are elite so they have very nicu stats - Kachnov
	H.setStat("strength", STAT_MEDIUM_HIGH)
	H.setStat("engineering", STAT_MEDIUM_HIGH)
	H.setStat("rifle", STAT_VERY_HIGH)
	H.setStat("mg", STAT_VERY_HIGH)
	H.setStat("pistol", STAT_MEDIUM_HIGH)
	H.setStat("heavyweapon", STAT_NORMAL)
	H.setStat("medical", STAT_MEDIUM_HIGH)
	return TRUE

/datum/job/german/paratrooper/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/german/QM
	title = "Stabsgefreiter"
	en_meaning = "Quartermaster"
	total_positions = TRUE
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeerQM"

	additional_languages = list( "Russian" = 100 )
	is_officer = TRUE
	absolute_limit = TRUE

/datum/job/german/QM/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/gercap/fieldcap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/mp40(H), slot_back)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a Quartermaster. Your job is to keep the army well armed and supplied. Use a pen to sign supply requisition sheets.</span>"
	H.give_radio()
	H.setStat("strength", STAT_MEDIUM_HIGH)
	H.setStat("engineering", STAT_LOW)
	H.setStat("rifle", STAT_MEDIUM_LOW)
	H.setStat("mg", STAT_NORMAL)
	H.setStat("pistol", STAT_NORMAL)
	H.setStat("heavyweapon", STAT_VERY_LOW)
	H.setStat("medical", STAT_VERY_LOW)
	return TRUE

/datum/job/german/QM/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat, new/obj/item/weapon/key/german/QM, new/obj/item/weapon/key/german/command_intermediate, new/obj/item/weapon/key/german/engineer)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/german/artyman
	title = "Kanonier"
	en_meaning = "Artillery Officer"
	total_positions = 2
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeerSO"
	is_officer = TRUE
	absolute_limit = 2

/datum/job/german/artyman/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/gercap/fieldcap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/wrench(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/attachment/scope/adjustable/binoculars(H), slot_r_hand)
	H << "<span class = 'notice'>You are the <b>[title]</b>, an artillery officer. Your job is to bomb the shit out of the enemy.</span>"
	H.give_radio()
	H.setStat("strength", STAT_MEDIUM_HIGH)
	H.setStat("engineering", STAT_MEDIUM_LOW)
	H.setStat("rifle", STAT_MEDIUM_HIGH)
	H.setStat("mg", STAT_NORMAL)
	H.setStat("pistol", STAT_NORMAL)
	H.setStat("heavyweapon", STAT_VERY_LOW)
	H.setStat("medical", STAT_VERY_LOW)
	return TRUE

/datum/job/german/artyman/update_character(var/mob/living/carbon/human/H)
	..()

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
	total_positions = 2
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"

/datum/job/german/scout/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/attachment/scope/adjustable/binoculars(H), slot_l_hand)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a scout. Your job is to assist the <b>Kanonier</b> by getting coordinates.</span>"
	H.give_radio()
	H.setStat("strength", STAT_NORMAL)
	H.setStat("engineering", STAT_NORMAL)
	H.setStat("rifle", STAT_NORMAL)
	H.setStat("mg", STAT_MEDIUM_LOW)
	H.setStat("pistol", STAT_NORMAL)
	H.setStat("heavyweapon", STAT_MEDIUM_LOW)
	H.setStat("medical", STAT_NORMAL)
	return TRUE

/datum/job/german/scout/update_character(var/mob/living/carbon/human/H)
	..()

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
	total_positions = 2
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeerSO"
	is_officer = TRUE
	absolute_limit = TRUE

/datum/job/german/conductor/train_check() // if there's no train, don't let people be conductors!
	return WW2_train_check()

/datum/job/german/conductor/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/gercap/fieldcap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger(H), slot_belt)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a train conductor. Your job is take men to and from the front.</span>"
	H.give_radio()
	H.setStat("strength", STAT_MEDIUM_HIGH)
	H.setStat("engineering", STAT_MEDIUM_HIGH)
	H.setStat("rifle", STAT_MEDIUM_LOW)
	H.setStat("mg", STAT_MEDIUM_LOW)
	H.setStat("pistol", STAT_NORMAL)
	H.setStat("heavyweapon", STAT_VERY_LOW)
	H.setStat("medical", STAT_LOW)
	return TRUE

/datum/job/german/conductor/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat, new/obj/item/weapon/key/german/train,
		new/obj/item/weapon/key/german/command_intermediate)

////////////////////////////////
/datum/job/german/squad_leader_ss
	title = "SS-Untersharffuhrer"
	en_meaning = "SS Squad Leader"
	total_positions = TRUE
	head_position = TRUE
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateSS-Officer"
	is_SS = TRUE
	additional_languages = list( "Russian" = 10 )
	is_officer = TRUE
	is_commander = TRUE // not a squad leader despite the title
	is_petty_commander = TRUE

/datum/job/german/squad_leader_ss/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni/ssuni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/gercap/fieldcap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/akm(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/attachment/scope/adjustable/binoculars(H), slot_l_hand)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a squad leader for an elite SS unit. Your job is to work alongside normal <b>Gruppenfuhrer</b>s and the <b>Feldwebel</b>, while setting your own goals. Also, kill any jews you find on sight. They usually have long hair and beards.</span>"
	H.give_radio()
	if (secret_ladder_message)
		H << "<br>[secret_ladder_message]"

	H.stamina *= 1.5
	H.max_stamina *= 1.5
	// glorious SS stats
	H.setStat("strength", STAT_VERY_HIGH)
	H.setStat("engineering", STAT_MEDIUM_HIGH)
	H.setStat("rifle", STAT_VERY_HIGH)
	H.setStat("mg", STAT_VERY_HIGH)
	H.setStat("pistol", STAT_VERY_HIGH)
	H.setStat("heavyweapon", STAT_MEDIUM_HIGH)
	H.setStat("medical", STAT_LOW)
	return TRUE

/datum/job/german/squad_leader_ss/update_character(var/mob/living/carbon/human/H)
	..()

	H.make_artillery_officer()

	if (istype(H.languages[1], /datum/language/common))
		H.languages[1] = null

/datum/job/german/squad_leader_ss/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat,
		new/obj/item/weapon/key/german/command_intermediate, new/obj/item/weapon/key/german/SS)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/german/soldier_ss
	title = "SS-Schutze"
	en_meaning = "SS Infantry Soldier"
	total_positions = 5 // this was causing an error with latejoin spawning
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateSS"
	is_SS = TRUE

/datum/job/german/soldier_ss/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni/ssuni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/sssmock(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm/sshelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a soldier for an elite SS unit. Your job is to follow the orders of the <b>SS-Untersharffuhrer</b>. Also, kill any jews you find on sight. They usually have long hair and beards.</span>"
	H.give_radio()

	H.stamina *= 1.5
	H.max_stamina *= 1.5
	// glorious SS stats
	H.setStat("strength", STAT_VERY_HIGH)
	H.setStat("engineering", STAT_MEDIUM_HIGH)
	H.setStat("rifle", STAT_VERY_HIGH)
	H.setStat("mg", STAT_MEDIUM_HIGH)
	H.setStat("pistol", STAT_VERY_HIGH)
	H.setStat("heavyweapon", STAT_MEDIUM_HIGH)
	H.setStat("medical", STAT_LOW)
	return TRUE

/datum/job/german/soldier_ss/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat, new/obj/item/weapon/key/german/SS)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/job/german/chef
	title = "Kuchenchef" // note: SS13 does not like ü in job titles
	en_meaning = "Chef"
	total_positions = TRUE
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeerChef"
	is_nonmilitary = TRUE
	is_primary = FALSE
	is_secondary = TRUE
	absolute_limit = TRUE

/datum/job/german/chef/equip(var/mob/living/carbon/human/H)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/chef/classic(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a front chef. Your job is to keep the Wehrmacht well fed.</span>"
	H.give_radio()
	H.setStat("strength", STAT_MEDIUM_LOW)
	H.setStat("engineering", STAT_MEDIUM_LOW)
	H.setStat("rifle", STAT_MEDIUM_LOW)
	H.setStat("mg", STAT_MEDIUM_LOW)
	H.setStat("pistol", STAT_NORMAL)
	H.setStat("heavyweapon", STAT_VERY_LOW)
	H.setStat("medical", STAT_MEDIUM_LOW)
	return TRUE

/datum/job/german/chef/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat)

// this is a horrible hack.
/datum/job/german/trainsystem
	title = "N/A"
	en_meaning = "N/A"
	total_positions = FALSE
	head_position = FALSE
	is_officer = FALSE
	is_commander = FALSE
	absolute_limit = FALSE
	faction = "trainsystem"