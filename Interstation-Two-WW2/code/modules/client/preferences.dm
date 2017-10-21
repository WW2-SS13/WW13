//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

var/list/preferences_datums = list()

datum/preferences
	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/savefile_version = 0

	//non-preference stuff
	var/warns = 0
	var/muted = 0
	var/last_ip
	var/last_id

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change
	var/ooccolor = "#010000"			//Whatever this is set to acts as 'reset' color and is thus unusable as an actual custom color
	var/list/be_special_role = list()		//Special role selection
	var/UI_style = "ErisStyleHolo"
	var/UI_useborder = 0
	var/UI_style_color = "#92CE81"
	var/UI_style_alpha = 255

	//character preferences
	var/real_name						//our character's name
	var/german_name
	var/russian_name
	var/ukrainian_name
	var/be_random_name = 0				//whether we are a random name every round
	var/be_random_name_german = 0
	var/be_random_name_russian = 0
	var/be_random_name_ukrainian = 0
	var/gender = MALE					//gender of character (well duh)
	var/german_gender = MALE
	var/russian_gender = MALE
	var/ukrainian_gender = MALE // civs
	var/body_build = "Default"			//character body build name
	var/age = 30						//age of character
	var/spawnpoint = "Cryogenic Storage"//where this character will spawn (0-2).
	var/b_type = "A+"					//blood type (not-chooseable)
	var/backbag = 2						//backpack type
	var/h_style = "Bald"				//Hair type
	var/r_hair = 0						//Hair color
	var/g_hair = 0						//Hair color
	var/b_hair = 0						//Hair color
	var/f_style = "Shaved"				//Face hair type
	var/r_facial = 0					//Face hair color
	var/g_facial = 0					//Face hair color
	var/b_facial = 0					//Face hair color
	var/s_tone = 0						//Skin tone

	var/r_skin = 0						//Skin color
	var/g_skin = 0						//Skin color
	var/b_skin = 0						//Skin color

	var/german_r_skin = 0						//Skin color
	var/german_g_skin = 0						//Skin color
	var/german_b_skin = 0						//Skin color

	var/russian_r_skin = 0						//Skin color
	var/russian_g_skin = 0						//Skin color
	var/russian_b_skin = 0						//Skin color

	var/r_eyes = 0						//Eye color
	var/g_eyes = 0						//Eye color
	var/b_eyes = 0						//Eye color
	var/species = "Human"               //Species datum to use.
	var/species_preview                 //Used for the species selection window.
	var/list/alternate_languages = list() //Secondary language(s)
	var/list/language_prefixes = list() //Kanguage prefix keys
	var/list/gear						//Custom/fluff item loadout.


		//Some faction information.
	var/religion = "None"               //Religious association.

	var/be_spy = 0
	var/be_jew = 0

 // TODO?
/*
// preferences refactor: 1 preference per faction: german/russian right now
	var/real_name_german						//our character's name
	var/be_random_name_german = 0				//whether we are a random name every round
	var/gender_german = MALE					//gender of character (well duh)
	var/body_build_german = "Default"			//character body build name
	var/age_german = 30						//age of character
	var/spawnpoint_german = "Cryogenic Storage"//where this character will spawn (0-2).
	var/b_type_german = "A+"					//blood type (not-chooseable)
	var/backbag_german = 2						//backpack type
	var/h_style_german = "Bald"				//Hair type
	var/r_hair_german = 0						//Hair color
	var/g_hair_german = 0						//Hair color
	var/b_hair_german = 0						//Hair color
	var/f_style_german = "Shaved"				//Face hair type
	var/r_facial_german = 0					//Face hair color
	var/g_facial_german = 0					//Face hair color
	var/b_facial_german = 0					//Face hair color
	var/s_tone_german = 0						//Skin tone
	var/r_skin_german = 0						//Skin color
	var/g_skin_german = 0						//Skin color
	var/b_skin_german = 0						//Skin color
	var/r_eyes_german = 0						//Eye color
	var/g_eyes_german = 0						//Eye color
	var/b_eyes_german = 0						//Eye color
	var/species_german = "Human"               //Species datum to use.
	var/species_preview_german                 //Used for the species selection window.
	var/list/alternate_languages_german = list() //Secondary language(s)
	var/list/language_prefixes_german = list() //Kanguage prefix keys
	var/list/gear_german						//Custom/fluff item loadout.
	var/religion_german = "None"               //Religious association.

	var/real_name_russian						//our character's name
	var/be_random_name_russian = 0				//whether we are a random name every round
	var/gender_russian = MALE					//gender of character (well duh)
	var/body_build_russian = "Default"			//character body build name
	var/age_russian = 30						//age of character
	var/spawnpoint_russian = "Cryogenic Storage"//where this character will spawn (0-2).
	var/b_type_russian = "A+"					//blood type (not-chooseable)
	var/backbag_russian = 2						//backpack type
	var/h_style_russian = "Bald"				//Hair type
	var/r_hair_russian = 0						//Hair color
	var/g_hair_russian = 0						//Hair color
	var/b_hair_russian = 0						//Hair color
	var/f_style_russian = "Shaved"				//Face hair type
	var/r_facial_russian = 0					//Face hair color
	var/g_facial_russian = 0					//Face hair color
	var/b_facial_russian = 0					//Face hair color
	var/s_tone_russian = 0						//Skin tone
	var/r_skin_russian = 0						//Skin color
	var/g_skin_russian = 0						//Skin color
	var/b_skin_russian = 0						//Skin color
	var/r_eyes_russian = 0						//Eye color
	var/g_eyes_russian = 0						//Eye color
	var/b_eyes_russian = 0						//Eye color
	var/species_russian = "Human"               //Species datum to use.
	var/species_preview_russian                 //Used for the species selection window.
	var/list/alternate_languages_russian = list() //Secondary language(s)
	var/list/language_prefixes_russian = list() //Kanguage prefix keys
	var/list/gear_russian						//Custom/fluff item loadout.
	var/religion_russian = "None"               //Religious association.
*/
		//Mob preview
	var/icon/preview_icon = null
	var/icon/preview_icon_front = null
	var/icon/preview_icon_side = null

	var/high_job_title = ""

		//Jobs, uses bitflags
	var/job_civilian_high = 0
	var/job_civilian_med = 0
	var/job_civilian_low = 0

	var/job_medsci_high = 0
	var/job_medsci_med = 0
	var/job_medsci_low = 0

	var/job_engsec_high = 0
	var/job_engsec_med = 0
	var/job_engsec_low = 0

	//Keeps track of preferrence for not getting any wanted jobs
	var/alternate_option = 0

	// maps each organ to either null(intact), "cyborg" or "amputated"
	// will probably not be able to do this for head and torso ;)
	var/list/organ_data = list()
	var/list/rlimb_data = list()
	var/list/player_alt_titles = new()		// the default name of a job like "Medical Doctor"

	var/flavor_text = ""
	var/list/flavour_texts_robot = list()

	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/exploit_record = ""
	var/disabilities = 0

	var/uplinklocation = "PDA"

	// OOC Metadata:
	var/metadata = ""

	var/client/client = null
	var/client_ckey = null

	var/savefile/loaded_preferences
	var/savefile/loaded_character
	var/datum/category_collection/player_setup_collection/player_setup

	var/current_character_type = "N/A"


/datum/preferences/New(client/C)

	player_setup = new(src)
	gender = pick(MALE, FEMALE)
	german_gender = pick(MALE, FEMALE)
	russian_gender = pick(MALE, FEMALE)
	ukrainian_gender = pick(MALE, FEMALE)
	real_name = random_name(gender,species)

	b_type = pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")

	gear = list()

	if(istype(C))
		client = C
		client_ckey = C.ckey
		if(!IsGuestKey(C.key))
			load_path(C.ckey)
			load_preferences()
			load_and_update_character()

/datum/preferences/proc/load_and_update_character(var/slot)
	load_character(slot)
	if(update_setup(loaded_preferences, loaded_character))
		save_preferences()
		save_character()

/datum/preferences/proc/ShowChoices(mob/user)
	if(!user || !user.client)	return

	if(!get_mob_by_key(client_ckey))
		user << "<span class='danger'>No mob exists for the given client!</span>"
		close_load_dialog(user)
		return

	var/dat = "<html><body><center>"

	if(path)
		dat += "Slot - "
		dat += "<a href='?src=\ref[src];load=1'>Load slot</a> - "
		dat += "<a href='?src=\ref[src];save=1'>Save slot</a> - "
		dat += "<a href='?src=\ref[src];reload=1'>Reload slot</a>"

	else
		dat += "Please create an account to save your preferences."

	dat += "<br>"
	dat += player_setup.header()
	dat += "<br><HR></center>"
	dat += player_setup.content(user)

	dat += "</html></body>"
	user << browse(dat, "window=preferences;size=635x736")

/datum/preferences/proc/process_link(mob/user, list/href_list)
	if(!user)	return

	if(!istype(user, /mob/new_player))	return

	if(href_list["preference"] == "open_whitelist_forum")
		if(config.forumurl)
			user << link(config.forumurl)
		else
			user << "<span class='danger'>The forum URL is not set in the server configuration.</span>"
			return
	ShowChoices(usr)
	return 1

/datum/preferences/Topic(href, list/href_list)
	if(..())
		return 1

	if(href_list["save"])
		save_preferences()
		save_character()
	else if(href_list["reload"])
		load_preferences()
		load_character()
	else if(href_list["load"])
		if(!IsGuestKey(usr.key))
			open_load_dialog(usr)
			return 1
	else if(href_list["changeslot"])
		load_character(text2num(href_list["changeslot"]))
		close_load_dialog(usr)
	else
		return 0

	ShowChoices(usr)
	return 1

/datum/preferences/proc/copy_to(mob/living/carbon/human/character, safety = 0)
	// Sanitizing rather than saving as someone might still be editing when copy_to occurs.
	player_setup.sanitize_setup()
	if(be_random_name)
		real_name = random_name(gender,species)

	if(config.humans_need_surnames)
		var/firstspace = findtext(real_name, " ")
		var/name_length = length(real_name)
		if(!firstspace)	//we need a surname
			real_name += " [pick(last_names)]"
		else if(firstspace == name_length)
			real_name += "[pick(last_names)]"

	character.real_name = real_name

	if(character.dna)
		character.dna.real_name = character.real_name

	character.flavor_text = flavor_text

	character.body_build = get_body_build(gender, body_build)

	character.med_record = med_record
	character.sec_record = sec_record
	character.gen_record = gen_record
	character.exploit_record = exploit_record

	character.gender = gender
	character.age = age
	character.b_type = b_type

	character.r_eyes = r_eyes
	character.g_eyes = g_eyes
	character.b_eyes = b_eyes

	character.r_hair = r_hair
	character.g_hair = g_hair
	character.b_hair = b_hair

	character.r_facial = r_facial
	character.g_facial = g_facial
	character.b_facial = b_facial

	character.r_skin = r_skin
	character.g_skin = g_skin
	character.b_skin = b_skin

	character.s_tone = s_tone

	character.h_style = h_style
	character.f_style = f_style

	character.religion = religion

/*
	// german
	character.gender_german = gender_german
	character.age_german = age_german
	character.b_type_german = b_type_german

	character.r_eyes_german = r_eyes_german
	character.g_eyes_german = g_eyes_german
	character.b_eyes_german = b_eyes_german

	character.r_hair_german = r_hair_german
	character.g_hair_german = g_hair_german
	character.b_hair_german = b_hair_german

	character.r_facial_german = r_facial_german
	character.g_facial_german = g_facial_german
	character.b_facial_german = b_facial_german

	character.r_skin_german = r_skin_german
	character.g_skin_german = g_skin_german
	character.b_skin_german = b_skin_german

	character.s_tone_german = s_tone_german

	character.h_style_german = h_style_german
	character.f_style_german = f_style_german

	character.religion_german = religion_german

	// russian
	character.gender_russian = gender_russian
	character.age_russian = age_russian
	character.b_type_russian = b_type_russian

	character.r_eyes_russian = r_eyes_russian
	character.g_eyes_russian = g_eyes_russian
	character.b_eyes_russian = b_eyes_russian

	character.r_hair_russian = r_hair_russian
	character.g_hair_russian = g_hair_russian
	character.b_hair_russian = b_hair_russian

	character.r_facial_russian = r_facial_russian
	character.g_facial_russian = g_facial_russian
	character.b_facial_russian = b_facial_russian

	character.r_skin_russian = r_skin_russian
	character.g_skin_russian = g_skin_russian
	character.b_skin_russian = b_skin_russian

	character.s_tone_russian = s_tone_russian

	character.h_style_russian = h_style_russian
	character.f_style_russian = f_style_russian

	character.religion_russian = religion_russian
*/
	// Destroy/cyborgize organs

	for(var/name in organ_data)

		var/status = organ_data[name]
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if(O)
			O.status = 0
			if(status == "amputated")
				character.organs_by_name[O.limb_name] = null
				character.organs -= O
				if(O.children) // This might need to become recursive.
					for(var/obj/item/organ/external/child in O.children)
						character.organs_by_name[child.limb_name] = null
						character.organs -= child

			else if(status == "cyborg")
				if(rlimb_data[name])
					O.robotize(rlimb_data[name])
				else
					O.robotize()
		else
			var/obj/item/organ/I = character.internal_organs_by_name[name]
			if(I)
				if(status == "assisted")
					I.mechassist()
				else if(status == "mechanical")
					I.robotize()

	character.all_underwear.Cut()

	for(var/underwear_category_name in all_underwear)
		var/datum/category_group/underwear/underwear_category = global_underwear.categories_by_name[underwear_category_name]
		if(underwear_category)
			var/underwear_item_name = all_underwear[underwear_category_name]
			character.all_underwear[underwear_category_name] = underwear_category.items_by_name[underwear_item_name]
		else
			all_underwear -= underwear_category_name

	if(backbag > 4 || backbag < 1)
		backbag = 1 //Same as above
	character.backbag = backbag

	//Debugging report to track down a bug, which randomly assigned the plural gender to people.
	if(character.gender in list(PLURAL, NEUTER))
		if(isliving(src)) //Ghosts get neuter by default
			message_admins("[character] ([character.ckey]) has spawned with their gender as plural or neuter. Please notify coders.")
			character.gender = MALE

/datum/preferences/proc/open_load_dialog(mob/user)
	var/dat = "<body>"
	dat += "<tt><center>"

	var/savefile/S = new /savefile(path)
	if(S)
		dat += "<b>Select a character slot to load</b><hr>"
		var/name
		for(var/i=1, i<= config.character_slots, i++)
			S.cd = "/character[i]"
			S["real_name"] >> name
			if(!name)	name = "Character[i]"
			if(i==default_slot)
				name = "<b>[name]</b>"
			dat += "<a href='?src=\ref[src];changeslot=[i]'>[name]</a><br>"

	dat += "<hr>"
	dat += "</center></tt>"
	user << browse(dat, "window=saves;size=300x390")

/datum/preferences/proc/close_load_dialog(mob/user)
	user << browse(null, "window=saves")
