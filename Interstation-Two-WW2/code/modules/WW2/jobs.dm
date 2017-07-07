/datum/fireteam
	var/name = null
	var/code = null
	var/list/members = list()
	var/list/required = list()
	var/side = CIVILIAN

	var/can_set_name = null
	var/name_set = 0
	var/fireteam_id = 1
	var/squad_type
	var/max_fireteams = -1

	var/list/fireteam_codes = list()
	var/list/fireteam_access = list()

/datum/fireteam/proc/add_member(var/mob/living/carbon/human/H, var/datum/job/job)
	if(!(job.type in required))
		return 0
	required -= job.type
	members += H
	greet_and_equip_member(H)
	if(required.len <= 0)
		trigger_full()
	if(job.type == can_set_name)
		name_set = 1
	//	var/new_name = input(H, "Enter new squad name. Leave empty to use default.", "Name", "") as text
		var/new_name = "Alpha" // fix to SLs spawning in the wrong spot and meme names - Kachnov
		new_name = sanitizeName(new_name)
		if(new_name && new_name != code)
			name = new_name
			for(var/member in members)
				member << "<b>Your fireteam [code] is now called \"[name]\".</b>"
	return 1

/datum/fireteam/proc/greet_and_equip_member(var/mob/living/carbon/human/H)
	if(!name)
		H << "You are now in the [squad_type] [code]"
	else
		H << "You are now in the [squad_type] [code] \"[name]\""
	var/obj/item/weapon/card/id/id = H.wear_id
	if(istype(id))
		if(fireteam_id > 0 & fireteam_access.len >= fireteam_id)
			id.access.Add(fireteam_access[fireteam_id])
		if(code)
			id.name = "[id.registered_name]'s ID Card ([code]'s [id.assignment])"
		else
			id.name = "[id.registered_name]'s ID Card ([id.assignment])"

/datum/fireteam/proc/init()
	for(var/type_name in required)
		for(var/datum/job/job in job_master.occupations)
			if(job.type == type_name)
				job.total_positions++
				break

	code = get_code()

/datum/fireteam/proc/trigger_full()
	job_master.not_full_fireteams -= src

	if(max_fireteams != -1 && fireteam_id >= max_fireteams)
		return 0

	var/datum/fireteam/new_fireteam = new src.type()
	new_fireteam.fireteam_id = fireteam_id + 1
	new_fireteam.init()

	job_master.fireteams += new_fireteam
	job_master.not_full_fireteams += new_fireteam
	return 1

/datum/fireteam/proc/is_full()
	return required.len <= 0

/datum/fireteam/proc/get_code()
	var/c = fireteam_codes[fireteam_id]
	if(!c)
		return ""
	return c

/datum/fireteam/american_squad
	required = list(/datum/job/german/squad_leader,
					/datum/job/german/medic,
					/datum/job/german/engineer,
					/datum/job/german/heavy_weapon
					)

	can_set_name = /datum/job/german/squad_leader
	squad_type = "fireteam"
	side = GEFORCE
	max_fireteams = 9

	fireteam_codes = list(
		1 = "Alpha",
		2 = "Bravo",
		3 = "Charlie",
		4 = "Delta"
		)

	fireteam_access = list(1, 2, 3, 4, 5, 6, 7, 8, 9)

/datum/fireteam/russian_squad
	required = list(/datum/job/russian/squad_leader,
					/datum/job/russian/medic,
					/datum/job/russian/engineer,
					/datum/job/russian/heavy_weapon,
					/datum/job/russian/heavy_weapon,
					/datum/job/russian/soldier,
					/datum/job/russian/soldier,
					/datum/job/russian/soldier,
					/datum/job/russian/soldier
					)

	can_set_name = /datum/job/russian/squad_leader
	squad_type = "otdeleniye"
	side = RUFORCE
	max_fireteams = 4

	fireteam_codes = list(
		1 = "Anna",
		2 = "Boris",
		3 = "Vasiliy",
		4 = "Grigoriy"
		)
/*
/datum/fireteam/russian_gru
	required = list(/datum/job/gru,
					/datum/job/gru,
					/datum/job/gru,
					/datum/job/gru
					)
	can_set_name = /datum/job/gru
	squad_type = "spec otryad"
	max_fireteams = 1
	side = RUFORCE

	fireteam_codes = list(
		1 = "Spetsnaz"
		)

/datum/fireteam/american_recon
	required = list(/datum/job/the75th_recon,
					/datum/job/the75th_recon
					)
	can_set_name = /datum/job/the75th_recon
	squad_type = "recon squad"
	max_fireteams = 1
	side = ENFORCE

	fireteam_codes = list(
		1 = "Recons"
		)

*/