/datum/job/russian

/datum/job/russian/give_random_name(var/mob/living/carbon/human/H)
	H.name = H.species.get_random_russian_name(H.gender)
	H.real_name = H.name

/datum/job/russian/commander
	title = "Comandir Batalyona"
	en_meaning = "Commander"
	faction = "Station"
	total_positions = 1
	head_position = 1
	selection_color = "#530909"
	spawn_location = "JoinLateRACO"
	additional_languages = list( "German" = 100, "Ukrainian" = 50 )
	is_officer = 1
	is_commander = 1
	absolute_limit = 1

/datum/job/russian/commander/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/sovuni/officer(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/sovofficercap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger/colt(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/attachment/scope/adjustable/binoculars(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(H), slot_r_hand)
	H.give_radio()
	world << "<b>[H.client.prefs.russian_name] is the [title] of the Soviet forces!</b>"
	H << "<span class = 'notice'>You are the <b>[title]</b>, the highest ranking officer present. Your job is the organize the Russian forces and lead them to victory. You take orders from the <b>Soviet High Command</b>.</span>"
	return 1

/datum/job/russian/commander/get_keys()
	return list(new/obj/item/weapon/key/russian, new/obj/item/weapon/key/russian/soldat, new/obj/item/weapon/key/russian/medic, new/obj/item/weapon/key/russian/engineer,
		new/obj/item/weapon/key/russian/QM, new/obj/item/weapon/key/russian/command_intermediate, new/obj/item/weapon/key/russian/command_high, new/obj/item/weapon/key/russian/bunker_doors)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/russian/staff_officer
	title = "Ofitser"
	en_meaning = "Staff Officer"
	faction = "Station"
	total_positions = 2
	head_position = 0
	selection_color = "#530909"
	spawn_location = "JoinLateRASO"
	additional_languages = list( "German" = 100, "Ukrainian" = 50 )
	is_officer = 1
	absolute_limit = 3

/datum/job/russian/staff_officer/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/sovuni/officer(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/sovofficercap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/luger/colt(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/attachment/scope/adjustable/binoculars(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(H), slot_r_hand)
	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>, one of the vice-commanders of the Russian forces. Your job is to take orders from the <b>Commandir</b> and coordinate with squad leaders.</span>"
	return 1

/datum/job/russian/staff_officer/get_keys()
	return list(new/obj/item/weapon/key/russian, new/obj/item/weapon/key/russian/soldat, new/obj/item/weapon/key/russian/medic, new/obj/item/weapon/key/russian/engineer,
		new/obj/item/weapon/key/russian/QM, new/obj/item/weapon/key/russian/command_intermediate, new/obj/item/weapon/key/russian/command_high, new/obj/item/weapon/key/russian/bunker_doors)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

/datum/job/russian/squad_leader
	title = "Sergant"
	en_meaning = "Squad Leader"
	faction = "Station"
	total_positions = 4
	head_position = 0
	selection_color = "#770e0e"
	spawn_location = "JoinLateRASL"
	additional_languages = list( "German" = 33 )
	is_officer = 1
	is_squad_leader = 1

/datum/job/russian/squad_leader/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/sovofficercap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/sovuni/officer(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/m4(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/attachment/scope/adjustable/binoculars(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(H), slot_r_hand)
	H.give_radio()
	H.visible_message("<span class = 'notice'>You are the <b>[title]</b>. Your job is to lead offensive units of the Russian force according to the <b>Commandir</b>'s and the <b>Ofitser</b>'s orders.</span>")
	return 1

/datum/job/russian/squad_leader/get_keys()
	return list(new/obj/item/weapon/key/russian, new/obj/item/weapon/key/russian/soldat,
		new/obj/item/weapon/key/russian/command_intermediate, new/obj/item/weapon/key/russian/bunker_doors)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/russian/medic
	title = "Sanitar"
	en_meaning = "Medic"
	faction = "Station"
	total_positions = 5
	selection_color = "#770e0e"
	spawn_location = "JoinLateRA"

/datum/job/russian/medic/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/sovhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/sovuni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/mosin(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/russian(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/doctor_handbook(H), slot_l_store)

	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>, a medic. Your job is to keep the army healthy and in good condition.</span>"
	return 1

/datum/job/russian/medic/get_keys()
	return list(new/obj/item/weapon/key/russian, new/obj/item/weapon/key/russian/soldat,
		new/obj/item/weapon/key/russian/medic)

/datum/job/russian/doctor
	title = "Doktor"
	en_meaning = "Doctor"
	faction = "Station"
	total_positions = 2
	selection_color = "#770e0e"
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
	faction = "Station"
	total_positions = 2
	selection_color = "#770e0e"
	spawn_location = "JoinLateRA"
	is_primary = 0
	is_secondary = 1

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
	faction = "Station"
	total_positions = 3
	selection_color = "#770e0e"
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
	faction = "Station"
	total_positions = 3
	selection_color = "#770e0e"
	spawn_location = "JoinLateRA"
	is_primary = 0
	is_secondary = 1

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
	faction = "Station"
	total_positions = 50
	selection_color = "#770e0e"
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
	faction = "Station"
	total_positions = 4
	selection_color = "#770e0e"
	spawn_location = "JoinLateRA"
	is_primary = 0
	is_secondary = 1
	absolute_limit = 4
	is_tankuser = 1

/datum/job/russian/tankcrew/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/sovtankerhat(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/sovuni/sovtankeruni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/m4(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/shovel/spade/russia(H), slot_belt)
	H.give_radio()
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
/datum/job/russian/anti_tank_crew
	title = "Protivotankovyy Soldat"
	en_meaning = "Anti-Tank Soldier"
	faction = "Station"
	total_positions = 4
	selection_color = "#770e0e"
	spawn_location = "JoinLateRA"
	is_primary = 0
	is_secondary = 1
	absolute_limit = 4

/datum/job/russian/anti_tank_crew/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/sovuni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/sovhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/heavysniper/ptrd(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/soviet/anti_tank_crew(H), slot_belt)

	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>, an anti-tank infantry unit. Your job is to destroy enemy tanks.</span>"
	return 1

/datum/job/russian/anti_tank_crew/get_keys()
	return list(new/obj/item/weapon/key/russian, new/obj/item/weapon/key/russian/soldat)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/russian/guard
	title = "Gvardeyec"
	en_meaning = "Guard"
	faction = "Station"
	total_positions = 3
	selection_color = "#a8b800"
	spawn_location = "JoinLateRA"
	additional_languages = list( "German" = 100 )
	is_guard = 1

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
	return list(new/obj/item/weapon/key/russian, new/obj/item/weapon/key/russian/soldat, new/obj/item/weapon/key/russian/bunker_doors)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/russian/zavhoz
	title = "Zavhoz"
	en_meaning = "Quartermaster"
	faction = "Station"
	total_positions = 1
	selection_color = "#a8b800"
	spawn_location = "JoinLateRAQM"
	additional_languages = list( "German" = 100 )
	is_officer = 1
	absolute_limit = 1

/datum/job/russian/zavhoz/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/under/sovuni/officer(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/mosin(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat/sovcap/fieldcap(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/device/flashlight/lantern(H), slot_r_hand)
	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>, a Quartermaster. Your job is to keep the army well armed and supplied.</span>"
	return 1

/datum/job/russian/zavhoz/get_keys()
	return list(new/obj/item/weapon/key/russian, new/obj/item/weapon/key/russian/soldat,  new/obj/item/weapon/key/russian/QM, new/obj/item/weapon/key/russian/bunker_doors, new/obj/item/weapon/key/russian/command_intermediate)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/russian/sturmovik
	title = "Sturmovik"
	en_meaning = "Elite Infantry Soldier"
	faction = "Station"
	total_positions = 3
	selection_color = "#770e0e"
	spawn_location = "JoinLateRA"
	is_sturmovik = 1

/datum/job/russian/sturmovik/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/sovhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/sovuni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/m4(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/bulletproof/cn42(H), slot_wear_suit)
	H.give_radio()
	H << "<span class = 'notice'>You are the <b>[title]</b>, an elite infantry soldier. Your job is assist normal <b>Soldat</b>i in front line combat.</span>"
	return 1

/datum/job/russian/sturmovik/get_keys()
	return list(new/obj/item/weapon/key/russian, new/obj/item/weapon/key/russian/soldat)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/job/russian/chef
	title = "Povar"
	en_meaning = "Chef"
	faction = "Station"
	total_positions = 1
	selection_color = "#770e0e"
	spawn_location = "JoinLateRAChef"
	allow_spies = 1
	is_nonmilitary = 1
	is_primary = 0
	is_secondary = 1
	absolute_limit = 1

/datum/job/russian/chef/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/wrappedboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/tactical/sovhelm(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/sovuni(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/chef/classic(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/boltaction/mosin(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/shovel/spade/russia(H), slot_belt)
	H << "<span class = 'notice'>You are the <b>[title]</b>, a front chef. Your job is to keep the Red Army well fed.</span>"
	return 1

/datum/job/russian/chef/get_keys()
	return list(new/obj/item/weapon/key/russian, new/obj/item/weapon/key/russian/soldat)
