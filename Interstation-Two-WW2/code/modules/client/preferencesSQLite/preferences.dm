//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

var/list/preferences_datums = list()

/datum/preferences

	//non-preference stuff
	var/warns = 0
	var/muted = 0
	var/last_ip
	var/last_id

	//game-preferences
	var/ooccolor = "#010000"			//Whatever this is set to acts as 'reset' color and is thus unusable as an actual custom color
	var/list/be_special_role = list()		//Special role selection
	var/UI_style = "ErisStyleHolo"
	var/UI_useborder = 0
	var/UI_style_color = "#92CE81"
	var/UI_style_alpha = 255

	//character preferences
	var/real_name = "John Doe"						//our character's name
	var/german_name = "Hans Schneider"
	var/russian_name = "Boris Borisov"
	var/ukrainian_name = "Boris Borisov"
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
//	var/spawnpoint = "Cryogenic Storage"//where this character will spawn (0-2).
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

		//Some faction information.
//	var/religion = "None"               //Religious association.

//	var/be_spy = 0
//	var/be_jew = 0

	//Mob preview
	var/list/preview_icons = list()
	var/list/preview_icons_front = list()
	var/list/preview_icons_back = list()
	var/list/preview_icons_east = list()
	var/list/preview_icons_west = list()

//	var/high_job_title = ""

	//Keeps track of preferrence for not getting any wanted jobs
	var/alternate_option = 0

	// maps each organ to either null(intact), "cyborg" or "amputated"
	// will probably not be able to do this for head and torso ;)
	var/list/organ_data = list()
	var/list/rlimb_data = list()
	var/list/player_alt_titles = new()		// the default name of a job like "Medical Doctor"

//	var/flavor_text = ""
//	var/list/flavour_texts_robot = list()
/*
	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/exploit_record = ""*/
	var/disabilities = 0

//	var/uplinklocation = "PDA"

	// OOC Metadata:
//	var/metadata = ""
	var/client/client = null
	var/client_ckey = null
	var/client_isguest = 0

	// for debugging purposes
	var/list/internal_table = list()

//	var/savefile/loaded_preferences
//	var/savefile/loaded_character
	var/datum/category_collection/player_setup_collection/player_setup

	var/current_character_type = "N/A"

	var/current_slot = 1

	var/list/preferences_enabled = list("SOUND_MIDI", "SOUND_LOBBY", "SOUND_AMBIENCE",
		"CHAT_GHOSTEARS", "CHAT_GHOSTSIGHT", "CHAT_GHOSTRADIO", "CHAT_SHOWICONS",
		"SHOW_TYPING", "CHAT_OOC", "CHAT_LOOC", "CHAT_DEAD", "SHOW_PROGRESS",
		"CHAT_ATTACKLOGS", "CHAT_DEBUGLOGS", "CHAT_PRAYER", "SOUND_ADMINHELP")
	var/list/preferences_disabled = list()

/datum/preferences/New(client/C)

	player_setup = new(src)

    /* don't change any of our preferences from the default anymore:
     * its counter-intuitive to how the new saving system works: the
     * preference saving thing assumes that the only things that change
     * are those which are changed by the user, so if we randomize these
     * values we will end up loading the default anyway */
	/*

	gender = pick(MALE, FEMALE)
	german_gender = pick(MALE, FEMALE)
	russian_gender = pick(MALE, FEMALE)
	ukrainian_gender = pick(MALE, FEMALE)
	real_name = random_name(gender,species)

	/* changing names from the default is neccessary, however, and it occurs
	 * below. */


	b_type = pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")
   */

	if(istype(C))
		client = C
		client_ckey = C.ckey
		if (IsGuestKey(client_ckey))
			client_isguest = 1

		// load our first slot, if we have one
		if (preferences_exist(1))
			load_preferences(1)
		else
			real_name = random_name(gender, species)
			german_name = random_german_name(gender, species)
			russian_name = random_russian_name(gender, species)
			ukrainian_name = random_ukrainian_name(gender, species)

		// otherwise, keep using our default values

/datum/preferences/Del()
	save_preferences(current_slot)
	..()

/datum/preferences/proc/update_setup()
	player_setup.update_setup()

/datum/preferences/proc/ShowChoices(mob/user)
	if(!user || !user.client)	return

	if(!get_mob_by_key(client_ckey))
		user << "<span class='danger'>No mob exists for the given client!</span>"
		close_load_dialog(user)
		return

	var/dat = "<html><body><center>"

	if(!IsGuestKey(user.key))
		dat += "<big><b>"
		dat += "<a href='?src=\ref[src];load=1'>Load Slot</a> - "
		dat += "<a href='?src=\ref[src];save=1'>Save to Slot</a> - "
		dat += "<a href='?src=\ref[src];del=1'>Delete Slot</a>"
		dat += "</big></b>"
	else
		dat += "Please create an account to save your preferences."

	dat += "<br><br>"
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
		open_save_dialog(usr)

	else if(href_list["savetoslot"])
		current_slot = text2num(href_list["savetoslot"])
		if (current_slot != 0 && save_preferences(current_slot))
			usr << "<span class = 'good'>Successfully saved current preferences to slot #[current_slot].</span>"
		else
			usr << "<span class = 'bad'>FAILED to save current preferences to slot #[current_slot].</span>"
		close_save_dialog(usr)

	else if(href_list["load"])
		if(!IsGuestKey(usr.key))
			open_load_dialog(usr)
			return 1

	else if(href_list["loadfromslot"])
		current_slot = text2num(href_list["loadfromslot"])
		if (current_slot != 0)
			if (load_preferences(current_slot))
				usr << "<span class = 'good'>Successfully loaded current preferences (slot #[current_slot]).</span>"
			else
				usr << "<span class = 'bad'>FAILED to load preferences (slot #[current_slot]).</span>"
		close_load_dialog(usr)

	else if (href_list["del"])
		open_del_dialog(usr)

	else if (href_list["delslot"])
		current_slot = text2num(href_list["delslot"])
		if (current_slot != 0)
			if (del_preferences(current_slot))
				usr << "<span class = 'good'>Successfully DELETED preferences (slot #[current_slot]).</span>"
			else
				usr << "<span class = 'good'>failed to DELETE preferences (slot #[current_slot]).</span>"
		close_del_dialog(usr)
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

//	character.flavor_text = flavor_text

	character.body_build = get_body_build(gender, body_build)
/*
	character.med_record = med_record
	character.sec_record = sec_record
	character.gen_record = gen_record
	character.exploit_record = exploit_record
*/
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

//	character.religion = religion

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
/*
	for(var/underwear_category_name in all_underwear)
		var/datum/category_group/underwear/underwear_category = global_underwear.categories_by_name[underwear_category_name]
		if(underwear_category)
			var/underwear_item_name = all_underwear[underwear_category_name]
			character.all_underwear[underwear_category_name] = underwear_category.items_by_name[underwear_item_name]
		else
			all_underwear -= underwear_category_name*/

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

	dat += "<b>Select a character slot to load from</b><hr>"
	for (var/i in 1 to config.character_slots)
		if (preferences_exist(i))
			dat += "<a href='?src=\ref[src];loadfromslot=[i]'>[i]. [get_DB_preference_value("real_name", i)]</a><br>"
		else
			dat += "[i]. Empty Slot<br>"

	dat += "<hr>"
	dat += "</center></tt>"
	user << browse(dat, "window=load_dialog;size=300x390")

/datum/preferences/proc/close_load_dialog(mob/user)
	user << browse(null, "window=load_dialog")

// save

/datum/preferences/proc/open_save_dialog(mob/user)
	var/dat = "<body>"
	dat += "<tt><center>"

	dat += "<b>Select a character slot to save to</b><hr>"
	for (var/i in 1 to config.character_slots)
		if (preferences_exist(i))
			dat += "<a href='?src=\ref[src];savetoslot=[i]'>[i]. [get_DB_preference_value("real_name", i)]</a><br>"
		else
			dat += "<a href='?src=\ref[src];savetoslot=[i]'>[i]. Empty Slot</a><br>"

	dat += "<hr>"
	dat += "</center></tt>"
	user << browse(dat, "window=save_dialog;size=300x390")

/datum/preferences/proc/close_save_dialog(mob/user)
	user << browse(null, "window=save_dialog")

// del

/datum/preferences/proc/open_del_dialog(mob/user)
	var/dat = "<body>"
	dat += "<tt><center>"

	dat += "<b>Select a character save to delete</b><hr>"
	for (var/i in 1 to config.character_slots)
		if (preferences_exist(i))
			dat += "<a href='?src=\ref[src];delslot=[i]'>[i]. [get_DB_preference_value("real_name", i)]</a><br>"
		else
			dat += "<i>[i]. Empty Slot</i><br>"

	dat += "<hr>"
	dat += "</center></tt>"
	user << browse(dat, "window=del_dialog;size=300x390")

/datum/preferences/proc/close_del_dialog(mob/user)
	user << browse(null, "window=del_dialog")

/client/proc/is_preference_enabled(var/preference)

	if(ispath(preference))
		var/datum/client_preference/cp = get_client_preference_by_type(preference)
		preference = cp.key

	return (preference in prefs.preferences_enabled)

/client/proc/set_preference(var/preference, var/set_preference)
	var/datum/client_preference/cp
	if(ispath(preference))
		cp = get_client_preference_by_type(preference)
	else
		cp = get_client_preference_by_key(preference)

	if(!cp)
		return FALSE

	var/enabled
	if(set_preference && !(preference in prefs.preferences_enabled))
		prefs.preferences_enabled  += preference
		prefs.preferences_disabled -= preference
		enabled = TRUE
		. = TRUE
	else if(!set_preference && (preference in prefs.preferences_enabled))
		prefs.preferences_enabled  -= preference
		prefs.preferences_disabled |= preference
		enabled = FALSE
		. = TRUE
	if(.)
		cp.toggled(mob, enabled)

/mob/proc/is_preference_enabled(var/preference)
	if(!client)
		return FALSE
	return client.is_preference_enabled(preference)

/mob/proc/set_preference(var/preference, var/set_preference)
	if(!client)
		return FALSE
	if(!client.prefs)
		log_debug("Client prefs found to be null for mob [src] and client [ckey], this should be investigated.")
		return FALSE

	return client.set_preference(preference, set_preference)

/client/proc/onload_preferences()
	var/datum/client_preference/cp = get_client_preference_by_type(/datum/client_preference/play_lobby_music)
	if (isnewplayer(mob))
		if (is_preference_enabled(cp.key))
			mob << sound(ticker.login_music, repeat = 1, wait = 0, volume = 85, channel = 1)
		else
			mob << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1)
