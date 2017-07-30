/datum/job/russian/give_random_name(var/mob/living/carbon/human/H)
	H.name = H.species.get_random_russian_name(H.gender)
	H.real_name = H.name

/datum/job/russian/commander
	title = "Comandir Batalyona"
	en_meaning = "Commander"
	flag = HOS
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	head_position = 1
	selection_color = "#530909"
	access = list(access_ru_soldier, access_nato_squad_leader, access_ru_medic, access_ru_surgerist, access_ru_engineer, access_ru_heavy_weapon, access_ru_squad_leader, access_ru_cook, access_ru_commander)
	minimal_access = list(access_ru_soldier, access_nato_squad_leader, access_ru_medic, access_ru_surgerist, access_ru_engineer, access_ru_heavy_weapon, access_ru_squad_leader, access_ru_cook, access_ru_commander)
	spawn_location = "JoinLateRACO"
	additional_languages = list( "German" = 100 )
	is_officer = 1
	is_commander = 1

/datum/job/russian/commander/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/sovuni/officer(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/sovcap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/colt(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/c45m(H), slot_r_hand)
	H.equip_to_slot_or_del(new /obj/item/attachment/scope/adjustable/binoculars(H), slot_l_hand)
	H.give_radio()
	world << "<b>[H.client.prefs.russian_name] is the [title] of the Soviet forces!</b>"
	H << "<span class = 'notice'>You are the <b>[title]</b>, the highest ranking officer present. Your job is the organize the Russian forces and lead them to victory.</span>"
	return 1

/datum/job/russian/commander/get_keys()
	return list(new/obj/item/weapon/key/russian, new/obj/item/weapon/key/russian/soldat, new/obj/item/weapon/key/russian/medic, new/obj/item/weapon/key/russian/engineer,
		new/obj/item/weapon/key/russian/QM, new/obj/item/weapon/key/russian/command_intermediate, new/obj/item/weapon/key/russian/command_high)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/russian/staff_officer
	title = "Ofitser"
	en_meaning = "Staff Officer"
	flag = HOS
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	head_position = 0
	selection_color = "#530909"
	access = list(access_ru_soldier, access_nato_squad_leader, access_ru_medic, access_ru_surgerist, access_ru_engineer, access_ru_heavy_weapon, access_ru_squad_leader, access_ru_cook, access_ru_commander)
	minimal_access = list(access_ru_soldier, access_nato_squad_leader, access_ru_medic, access_ru_surgerist, access_ru_engineer, access_ru_heavy_weapon, access_ru_squad_leader, access_ru_cook, access_ru_commander)
	spawn_location = "JoinLateRASO"
	additional_languages = list( "German" = 100 )
	is_officer = 1

/datum/job/russian/staff_officer/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/sovuni/officer(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/sovcap/fieldcap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/colt(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/ammo_magazine/c45m(H), slot_r_hand)
	H.equip_to_slot_or_del(new /obj/item/attachment/scope/adjustable/binoculars(H), slot_l_hand)
	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>, one of the vice-commanders of the Russian forces. Your job is to take orders from the <b>Commandir</b> and coordinate with squad leaders.</span>"
	return 1

/datum/job/russian/staff_officer/get_keys()
	return list(new/obj/item/weapon/key/russian, new/obj/item/weapon/key/russian/soldat, new/obj/item/weapon/key/russian/medic, new/obj/item/weapon/key/russian/engineer,
		new/obj/item/weapon/key/russian/QM, new/obj/item/weapon/key/russian/command_intermediate, new/obj/item/weapon/key/russian/command_high)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

/datum/job/russian/squad_leader
	title = "Sergant"
	en_meaning = "Squad Leader"
	flag = WARDEN
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	head_position = 0
	selection_color = "#770e0e"
	access = list(access_ru_soldier, access_nato_squad_leader, access_ru_medic, access_ru_surgerist, access_ru_engineer, access_ru_squad_leader, access_ru_cook)
	minimal_access = list(access_ru_soldier, access_nato_squad_leader, access_ru_medic, access_ru_surgerist, access_ru_engineer, access_ru_squad_leader, access_ru_cook)
	spawn_location = "JoinLateRASL"
	fallback_spawn_location = "JoinLateRussia-Fallback"
	additional_languages = list( "German" = 33 )
	is_officer = 1
	is_squad_leader = 1

/datum/job/russian/squad_leader/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/sovcap/fieldcap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/sovuni/officer(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/m4(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/attachment/scope/adjustable/binoculars(H), slot_l_hand)
	H.give_radio()
	H.visible_message("<span class = 'notice'>You are the <b>[title]</b>. Your job is to lead offensive units of the Russian force according to the <b>Commandir</b>'s and the <b>Ofitser</b>'s orders.</span>")
	return 1

/datum/job/russian/squad_leader/get_keys()
	return list(new/obj/item/weapon/key/russian, new/obj/item/weapon/key/russian/soldat,
		new/obj/item/weapon/key/russian/command_intermediate)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/russian/medic
	title = "Sanitar"
	en_meaning = "Medic"
	flag = ENGINEER
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	selection_color = "#770e0e"
	access = list(access_ru_soldier, access_ru_medic)
	minimal_access = list(access_ru_soldier, access_ru_medic)
	spawn_location = "JoinLateRADr"

/datum/job/russian/medic/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/sovhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/sovuni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/mosin(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/russian(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/doctor_handbook(H), slot_l_store)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a medic. Your job is to keep the army healthy and in good condition.</span>"
	return 1

/datum/job/russian/medic/get_keys()
	return list(new/obj/item/weapon/key/russian, new/obj/item/weapon/key/russian/soldat,
		new/obj/item/weapon/key/russian/medic)

/datum/job/russian/doctor
	title = "Doktor"
	en_meaning = "Doctor"
	flag = ENGINEER
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	selection_color = "#770e0e"
	access = list(access_ru_soldier, access_ru_medic)
	minimal_access = list(access_ru_soldier, access_ru_medic)
	spawn_location = "JoinLateRADr"
	is_nonmilitary = 1

/datum/job/russian/doctor/equip(var/mob/living/carbon/human/H)
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

/datum/job/russian/doctor/get_keys()
	return list(new/obj/item/weapon/key/russian, new/obj/item/weapon/key/russian/medic, new/obj/item/weapon/key/russian/command_intermediate)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/russian/sniper
	title = "Snaiper"
	en_meaning = "Sniper"
	flag = CYBORG
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	selection_color = "#770e0e"
	access = list(access_ru_soldier)
	minimal_access = list(access_ru_soldier)
	spawn_location = "JoinLateRA"

/datum/job/russian/sniper/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/sovhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/sovuni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/mosin(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/attachment/scope/adjustable/sniper_scope(H), slot_r_store)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a sniper. Your job is to assist normal <b>Soldat</b> from behind defenses.</span>"
	return 1

/datum/job/russian/sniper/get_keys()
	return list(new/obj/item/weapon/key/russian, new/obj/item/weapon/key/russian/soldat)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/russian/engineer
	title = "Boyevoy saper"
	en_meaning = "Engineer"
	flag = CHIEF
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	selection_color = "#770e0e"
	access = list(access_ru_soldier, access_ru_engineer)
	minimal_access = list(access_ru_soldier, access_ru_engineer)
	spawn_location = "JoinLateRA"

/datum/job/russian/engineer/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/sovhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/sovuni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/mosin(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/material/knife/combat(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/industrial(H), slot_r_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/shovel/spade/russia(H), slot_belt)
	H << "<span class = 'notice'>You are the <b>[title]</b>, an engineer. Your job is to build forward defenses.</span>"
	return 1

/datum/job/russian/engineer/get_keys()
	return list(new/obj/item/weapon/key/russian, new/obj/item/weapon/key/russian/soldat, new/obj/item/weapon/key/russian/engineer)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/russian/heavy_weapon
	title = "Pulemetchik"
	en_meaning = "Heavy Weapons Soldier"
	flag = OFFICER
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	selection_color = "#770e0e"
	access = list(access_ru_soldier)
	minimal_access = list(access_ru_soldier)
	spawn_location = "JoinLateRA"

/datum/job/russian/heavy_weapon/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/sovhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/sovuni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/pkm(H), slot_r_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/russian(H), slot_l_hand)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a heavy weapons unit. Your job is to assist normal <b>Soldat</b>i in front line combat.</span>"
	return 1

/datum/job/russian/heavy_weapon/get_keys()
	return list(new/obj/item/weapon/key/russian, new/obj/item/weapon/key/russian/soldat)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/russian/soldier
	title = "Sovietsky Soldat"
	en_meaning = "Infantry Soldier"
	flag = ATMOSTECH
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1000
	spawn_positions = -1
	selection_color = "#770e0e"
	access = list(access_ru_soldier)
	minimal_access = list(access_ru_soldier)
	spawn_location = "JoinLateRA"
	allow_spies = 1

/datum/job/russian/soldier/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/sovhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/sovuni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/mosin(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/shovel/spade/russia(H), slot_belt)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a normal infantry unit. Your job is to participate in front line combat.</span>"
	return 1

/datum/job/russian/soldier/get_keys()
	return list(new/obj/item/weapon/key/russian, new/obj/item/weapon/key/russian/soldat)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/russian/tankcrew
	title = "Tank-ekipazh"
	en_meaning = "Tank Crewman"
	flag = ATMOSTECH
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	selection_color = "#770e0e"
	access = list(access_ru_soldier)
	minimal_access = list(access_ru_soldier)
	spawn_location = "JoinLateRA"

/datum/job/russian/tankcrew/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/sovtankerhat(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/sovuni/sovtankeruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/m4(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/shovel/spade/russia(H), slot_belt)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a tank crewman. Your job is to work with another crewman to operate a tank.</span>"
	return 1

/datum/job/russian/tankcrew/get_keys()
	return list(new/obj/item/weapon/key/russian, new/obj/item/weapon/key/russian/soldat, new/obj/item/weapon/key/russian/command_intermediate)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/russian/guard
	title = "Gvardeyec"
	en_meaning = "Guard"
	flag = DETECTIVE
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	selection_color = "#a8b800"
	access = list(access_ru_soldier)
	minimal_access = list(access_ru_soldier)
	spawn_location = "JoinLateRA"

	additional_languages = list( "German" = 100 )

var/first_guard = 0
/datum/job/russian/guard/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/ushanka(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/sovuni(H), slot_w_uniform)
	if(first_guard)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/heavysniper/ptrd(H), slot_back)
		var/obj/item/weapon/storage/belt/security/tactical/belt = new(H)
		new /obj/item/ammo_casing/a145(belt)
		new /obj/item/ammo_casing/a145(belt)
		new /obj/item/ammo_casing/a145(belt)
		new /obj/item/ammo_casing/a145(belt)
		new /obj/item/ammo_casing/a145(belt)
		new /obj/item/ammo_casing/a145(belt)
		H.equip_to_slot_or_del(belt, slot_belt)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/svt(H), slot_back)
		var/obj/item/weapon/storage/belt/security/tactical/belt = new(H)
		new /obj/item/ammo_magazine/svt(belt)
		new /obj/item/ammo_magazine/svt(belt)
		new /obj/item/ammo_magazine/svt(belt)
		new /obj/item/ammo_magazine/svt(belt)
		new /obj/item/ammo_magazine/svt(belt)
		new /obj/item/ammo_magazine/svt(belt)
		H.equip_to_slot_or_del(belt, slot_belt)
	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>, a guard. Your job is to operate the minigun.</span>"
	return 1

/datum/job/russian/guard/get_keys()
	return list(new/obj/item/weapon/key/russian, new/obj/item/weapon/key/russian/soldat)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/russian/zavhoz
	title = "Zavhoz"
	en_meaning = "Quartermaster"
	flag = SOVQUAR
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#a8b800"
	access = list(access_ru_soldier, access_ru_heavy_weapon)
	minimal_access = list(access_ru_soldier, access_ru_heavy_weapon)
	spawn_location = "JoinLateRAQM"
	additional_languages = list( "German" = 100 )
	is_officer = 1

/datum/job/russian/zavhoz/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/under/sovuni/officer(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/mosin(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/sovcap/fieldcap(H), slot_head)
	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>, a Quartermaster. Your job is to keep the army well armed and supplied.</span>"
	return 1

/datum/job/russian/zavhoz/get_keys()
	return list(new/obj/item/weapon/key/russian, new/obj/item/weapon/key/russian/soldat,  new/obj/item/weapon/key/russian/QM)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/russian/sturmovik
	title = "Sturmovik"
	en_meaning = "Elite Infantry Soldier"
	flag = ATMOSTECH
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	selection_color = "#770e0e"
	access = list(access_ru_soldier)
	minimal_access = list(access_ru_soldier)
	spawn_location = "JoinLateRA"

/datum/job/russian/sturmovik/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/sovhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/sovuni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/m4(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/bulletproof/cn42(H), slot_l_hand)
	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>, an elite infantry soldier. Your job is assist normal <b>Soldat</b>i in front line combat.</span>"
	return 1

/datum/job/russian/sturmovik/get_keys()
	return list(new/obj/item/weapon/key/russian, new/obj/item/weapon/key/russian/soldat)
