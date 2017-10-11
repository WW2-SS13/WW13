/datum/job/german

/datum/job/german/give_random_name(var/mob/living/carbon/human/H)
	H.name = H.species.get_random_german_name(H.gender)
	H.real_name = H.name

/datum/job/german/commander
	title = "Oberleutnant"
	en_meaning = "Commander"
	faction = "Station"
	total_positions = 1
	head_position = 1
	selection_color = "#2d2d63"
	spawn_location = "JoinLateHeerCO"
	additional_languages = list( "Russian" = 100, "Ukrainian" = 50 )
	is_officer = 1
	is_commander = 1
	absolute_limit = 1

/datum/job/german/commander/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni/gerofficer(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/gerofficercap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/attachment/scope/adjustable/binoculars(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(H), slot_r_hand)
	H.give_radio()
	world << "<b>[H.client.prefs.german_name] is the [title] of the German forces!</b>"
	H << "<span class = 'notice'>You are the <b>[title]</b>, the highest ranking officer present. Your job is the organize the German forces and lead them to victory, while working alongside the <b>SS-Untersharffuhrer</b>. You take orders from the <b>German High Command</b>.</span>"
	return 1

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
	faction = "Station"
	total_positions = 2
	head_position = 0
	selection_color = "#2d2d63"
	spawn_location = "JoinLateHeerSO"
	additional_languages = list( "Russian" = 100, "Ukrainian" = 50 )
	is_officer = 1
	absolute_limit = 3

/datum/job/german/staff_officer/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni/gerofficer(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/gerofficercap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/attachment/scope/adjustable/binoculars(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(H), slot_r_hand)
	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>, one of the vice-commanders of the German forces. Your job is to take orders from the <b>Feldwebel</b> and coordinate with squad leaders.</span>"
	return 1

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
/datum/job/german/squad_leader
	title = "Gruppenfuhrer"
	en_meaning = "Squad Leader"
	faction = "Station"
	total_positions = 4
	head_position = 0
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeerSL"
	additional_languages = list( "Russian" = 33 )
	is_officer = 1
	is_squad_leader = 1

/datum/job/german/squad_leader/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni/gerofficer(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/gerofficercap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/mp40(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/attachment/scope/adjustable/binoculars(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(H), slot_r_hand)
	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>. Your job is to lead offensive units of the German force according to the <b>Feldwebel</b>'s and <b>Stabsoffizier</b>en's orders.</span>"
	return 1

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
	faction = "Station"
	total_positions = 5
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"

/datum/job/german/medic/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/mp40(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/german(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/doctor_handbook(H), slot_l_store)

	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>, a medic. Your job is to keep the army healthy and in good condition.</span>"
	return 1

/datum/job/german/medic/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat, new/obj/item/weapon/key/german/medic)

/datum/job/german/doctor
	title = "Medizinier"
	en_meaning = "Doctor"
	faction = "Station"
	total_positions = 2
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeerDr"
	is_nonmilitary = 1

/datum/job/german/doctor/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/color/white(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/doctor(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_med(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/medical(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/adv(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/doctor_handbook(H), slot_l_store)

	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>, a doctor. Your job is to stay back at base and treat wounded that come in from the front, as well as treat prisoners and base personnel.</span>"
	return 1

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
	faction = "Station"
	total_positions = 3
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"
	is_primary = 0
	is_secondary = 1

/datum/job/german/flamethrower_man/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/flammenwerfer(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger(H), slot_belt)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a flamethrower unit. Your job is incinerate the enemy!</span>"
	return 1

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
	faction = "Station"
	total_positions = 3
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"
	is_primary = 0
	is_secondary = 1

/datum/job/german/sniper/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/attachment/scope/adjustable/sniper_scope(H), slot_r_store)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a sniper. Your job is to assist normal <b>Soldat</b> from behind defenses.</span>"
	return 1

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
	faction = "Station"
	total_positions = 3
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"

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
	faction = "Station"
	total_positions = 2
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"
	is_primary = 0
	is_secondary = 1

/datum/job/german/heavy_weapon/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/l6_saw(H), slot_r_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/german(H), slot_l_hand)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a heavy weapons unit. Your job is to assist normal <b>Soldat</b>en in front line combat.</span>"
	return 1

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
	faction = "Station"
	total_positions = 50 // this was causing an error with latejoin spawning
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"
	allow_spies = 1

/datum/job/german/soldier/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/shovel/spade/russia(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)

	H << "<span class = 'notice'>You are the <b>[title]</b>, a normal infantry unit. Your job is to participate in front line combat.</span>"
	return 1

/datum/job/german/soldier/get_keys()
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
	faction = "Station"
	total_positions = 4
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"
	is_primary = 0
	is_secondary = 1
	absolute_limit = 4
	is_tankuser = 1

/datum/job/german/tankcrew/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni/gertankeruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/gertankerhat(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/shovel/spade/russia(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/mp40(H), slot_back)

	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>, a tank crewman. Your job is to work with another crewman to operate a tank.</span>"
	return 1

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
	faction = "Station"
	total_positions = 4
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"
	is_primary = 0
	is_secondary = 1
	absolute_limit = 4

/datum/job/german/anti_tank_crew/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/heavysniper/ptrd(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/german/anti_tank_crew, slot_belt)
	H << "<span class = 'notice'>You are the <b>[title]</b>, an anti-tank infantry unit. Your job is to destroy enemy tanks.</span>"
	return 1

/datum/job/german/anti_tank_crew/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat)

var/first_fallschirm = 1

/datum/job/german/paratrooper
	title = "Fallschirmjager"
	en_meaning = "Paratrooper"
	faction = "Station"
	total_positions = 7
	selection_color = "#4c4ca5"
	spawn_location = "Fallschirm"
	additional_languages = list( "Russian" = 100 )
	spawn_delay = 4000 // a bit more than 6.5 minutes should give russians some time to prepare - kachnov
	delayed_spawn_message = "<span class = 'danger'><big>You are parachuting behind Russian lines. You won't spawn until 6-7 minutes.</big></span>"
	is_paratrooper = 1
	var/fallschirm_spawnzone = null
	var/list/fallschirm_spawnpoints = list()

/datum/job/german/paratrooper/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni/falluni(H), slot_w_uniform)

	var/obj/item/clothing/accessory/storage/webbing/webbing = new/obj/item/clothing/accessory/storage/webbing(get_turf(H))
	var/obj/item/clothing/under/uniform = H.w_uniform
	uniform.attackby(webbing, H)

	H.equip_to_slot_or_del(new /obj/item/clothing/suit/fallsparka(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/german/paratrooper(H), slot_r_hand)
	H.give_radio()

	if(first_fallschirm)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/mp40(H), slot_back)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)

	if(first_fallschirm)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/german/fallofficer(H), slot_belt)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/german/fallsoldier(H), slot_belt)

	first_fallschirm = 0

	if(!fallschirm_spawnzone)
		fallschirm_spawnzone = pick(fallschirm_landmarks)
		fallschirm_landmarks = null
		for(var/turf/T in range(3, fallschirm_spawnzone))
			fallschirm_spawnpoints += T

		H.loc = get_turf(fallschirm_spawnzone)
	else
		H.loc = pick(fallschirm_spawnpoints)

	H << "<span class = 'notice'>You are the <b>[title]</b>, a paratrooper. Your job is to help any other units that need assistance.</span>"
	return 1

/datum/job/german/paratrooper/get_keys()
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
	faction = "Station"
	total_positions = 1
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeerQM"

	additional_languages = list( "Russian" = 100 )
	is_officer = 1
	absolute_limit = 1

/datum/job/german/stabsgefreiter/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/gercap/fieldcap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/mp40(H), slot_back)
	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>, a Quartermaster. Your job is to keep the army well armed and supplied. Use a pen to sign supply requisition sheets.</span>"
	return 1

/datum/job/german/stabsgefreiter/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat, new/obj/item/weapon/key/german/QM, new/obj/item/weapon/key/german/command_intermediate)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/german/artyman
	title = "Kanonier"
	en_meaning = "Artillery Officer"
	faction = "Station"
	total_positions = 2
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeerSO"
	is_officer = 1
	absolute_limit = 2

/datum/job/german/artyman/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/gercap/fieldcap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/wrench(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/attachment/scope/adjustable/binoculars(H), slot_r_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/shovel/spade/russia(H), slot_belt)
	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>, an artillery officer. Your job is to bomb the shit out of the enemy.</span>"
	return 1

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
	faction = "Station"
	total_positions = 2
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeer"

/datum/job/german/scout/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/attachment/scope/adjustable/binoculars(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/shovel/spade/russia(H), slot_belt)
	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>, a scout. Your job is to assist the <b>Kanonier</b> by getting coordinates.</span>"
	return 1

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
	faction = "Station"
	total_positions = 2
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeerSO"
	is_officer = 1
	absolute_limit = 1

/datum/job/german/conductor/train_check() // if there's no train, don't let people be conductors!
	return WW2_train_check()

/datum/job/german/conductor/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/gercap/fieldcap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger(H), slot_belt)
	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>, a train conductor. Your job is take men to and from the front.</span>"
	return 1

/datum/job/german/conductor/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat, new/obj/item/weapon/key/german/train,
		new/obj/item/weapon/key/german/command_intermediate)

////////////////////////////////
/datum/job/german/squad_leader_ss
	title = "SS-Untersharffuhrer"
	en_meaning = "SS Squad Leader"
	faction = "Station"
	total_positions = 1
	head_position = 1
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateSS-Officer"
	is_SS = 1
	additional_languages = list( "Russian" = 10 )
	is_officer = 1
	is_commander = 1 // not a squad leader despite the title

/datum/job/german/squad_leader_ss/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni/ssuni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/gercap/fieldcap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/akm(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/attachment/scope/adjustable/binoculars(H), slot_l_hand)
	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>, a squad leader for an elite SS unit. Your job is to work alongside normal <b>Gruppenfuhrer</b>s and the <b>Feldwebel</b>, while setting your own goals. Also, kill any jews you find on sight. They usually have long hair and beards.</span>"
	if (secret_ladder_message)
		H << "<br>[secret_ladder_message]"

	H.stamina = 150
	H.max_stamina = 150

	return 1

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
	faction = "Station"
	total_positions = 5 // this was causing an error with latejoin spawning
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateSS"
	is_SS = 1

/datum/job/german/soldier_ss/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni/ssuni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/sssmock(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm/sshelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/shovel/spade/russia(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)
	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>, a soldier for an elite SS unit. Your job is to follow the orders of the <b>SS-Untersharffuhrer</b>. Also, kill any jews you find on sight. They usually have long hair and beards.</span>"

	H.stamina = 150
	H.max_stamina = 150

	return 1

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
	faction = "Station"
	total_positions = 1
	selection_color = "#4c4ca5"
	spawn_location = "JoinLateHeerChef"
	is_nonmilitary = 1
	is_primary = 0
	is_secondary = 1
	absolute_limit = 1

/datum/job/german/chef/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/geruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/chef/classic(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/gerhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/shovel/spade/russia(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/kar98k(H), slot_back)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a front chef. Your job is to keep the Wehrmacht well fed.</span>"
	return 1

/datum/job/german/chef/get_keys()
	return list(new/obj/item/weapon/key/german, new/obj/item/weapon/key/german/soldat)
