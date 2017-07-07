/datum/category_item/player_setup_item/general/german

/datum/category_item/player_setup_item/general/basic/german
	name = "Basic"
	sort_order = 1

/datum/category_item/player_setup_item/general/basic/german/load_character(var/savefile/S)
	// real names
	S["real_name"]				>> pref.real_name_german
	S["name_is_always_random"]	>> pref.be_random_name_german

	S["gender"]					>> pref.gender_german
	S["body_build"]				>> pref.body_build_german
	S["age"]					>> pref.age_german
	S["spawnpoint"]				>> pref.spawnpoint_german
	S["OOC_Notes"]				>> pref.metadata_german

/datum/category_item/player_setup_item/general/basic/german/save_character(var/savefile/S)
	// real names
	S["real_name"]				<< pref.real_name_german
	S["name_is_always_random"]	<< pref.be_random_name_german

	S["gender"]					<< pref.gender_german
	S["body_build"]				<< pref.body_build_german
	S["age"]					<< pref.age_german
	S["spawnpoint"]				<< pref.spawnpoint_german
	S["OOC_Notes"]				<< pref.metadata_german

/datum/category_item/player_setup_item/general/basic/german/sanitize_character()

	var/datum/species/S = all_species[pref.species ? pref.species : "Human"]
	pref.age_german			= sanitize_integer(pref.age, S.min_age, S.max_age, initial(pref.age))
	pref.gender_german 		= sanitize_inlist(pref.gender, valid_player_genders, pick(valid_player_genders))
	pref.body_build_german 	= sanitize_inlist(pref.body_build, list("Slim", "Default", "Fat"), "Default")
	pref.identifying_gender_german = (pref.identifying_gender in all_genders_define_list) ? pref.identifying_gender : pref.gender
	pref.real_name_german		= sanitize_name(pref.real_name, pref.species)

	if(!pref.real_name_german)
		pref.real_name_german	= random_name(pref.gender_german, pref.species_german)

	pref.spawnpoint		= sanitize_inlist(pref.spawnpoint, spawntypes, initial(pref.spawnpoint))
	pref.be_random_name	= sanitize_integer(pref.be_random_name, 0, 1, initial(pref.be_random_name))

/datum/category_item/player_setup_item/general/basic/german/content()
	//name
	. = "<b>Name:</b> "
	. += "<a href='?src=\ref[src];rename=1'><b>[pref.real_name]</b></a><br>"
	. += "(<a href='?src=\ref[src];random_name=1'>Random Name</A>) "
	. += "(<a href='?src=\ref[src];always_random_name=1'>Always Random Name: [pref.be_random_name ? "Yes" : "No"]</a>)"
	. += "<br><br>"
	//gender
	. += "<b>Gender:</b> <a href='?src=\ref[src];gender=1'><b>[capitalize(lowertext(pref.gender))]</b></a><br>"
	//. += "<b>Body Shape:</b> <a href='?src=\ref[src];body_build=1'><b>[pref.body_build]</b></a><br>" No. No no no no no no.
	. += "<b>Age:</b> <a href='?src=\ref[src];age=1'>[pref.age]</a><br>"
	if(config.allow_Metadata)
		. += "<b>OOC Notes:</b> <a href='?src=\ref[src];metadata=1'> Edit </a><br>"

/datum/category_item/player_setup_item/general/basic/german/OnTopic(var/href,var/list/href_list, var/mob/user)

	//real names
	if(href_list["rename"])
		var/raw_name = input(user, "Choose your character's name:", "Character Name")  as text|null
		if (!isnull(raw_name) && CanUseTopic(user))
			var/new_name = sanitize_name(raw_name, pref.species)
			if(new_name)
				pref.real_name = new_name
				return TOPIC_REFRESH
			else
				user << "<span class='warning'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</span>"
				return TOPIC_NOACTION

	else if(href_list["random_name"])
		pref.real_name = random_name(pref.gender, pref.species)
		return TOPIC_REFRESH

	else if(href_list["always_random_name"])
		pref.be_random_name = !pref.be_random_name
		return TOPIC_REFRESH

	//german names
	if(href_list["rename_german"])
		var/raw_name = input(user, "Choose your character's GERMAN name:", "Character Name")  as text|null
		if (!isnull(raw_name) && CanUseTopic(user))
			var/new_name = sanitize_name(raw_name, pref.species)
			if(new_name)
				pref.german_name = new_name
				return TOPIC_REFRESH
			else
				user << "<span class='warning'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</span>"
				return TOPIC_NOACTION

	else if(href_list["random_name_german"])
		pref.german_name = random_german_name(pref.gender, pref.species)
		return TOPIC_REFRESH

	else if(href_list["always_random_name_german"])
		pref.be_random_name_german = !pref.be_random_name_german
		return TOPIC_REFRESH

	//russian names
	if(href_list["rename_russian"])
		var/raw_name = input(user, "Choose your character's RUSSIAN name:", "Character Name")  as text|null
		if (!isnull(raw_name) && CanUseTopic(user))
			var/new_name = sanitize_name(raw_name, pref.species)
			if(new_name)
				pref.russian_name = new_name
				return TOPIC_REFRESH
			else
				user << "<span class='warning'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</span>"
				return TOPIC_NOACTION

	else if(href_list["random_name_russian"])
		pref.russian_name = random_russian_name(pref.gender, pref.species)
		return TOPIC_REFRESH

	else if(href_list["always_random_name_russian"])
		pref.be_random_name_russian = !pref.be_random_name_russian
		return TOPIC_REFRESH

	else if(href_list["gender"])
		pref.gender = next_in_list(pref.gender, valid_player_genders)
		return TOPIC_REFRESH

	else if(href_list["body_build"])
		pref.body_build = input("Body Shape", "Body") in list("Default", "Slim", "Fat")
		return TOPIC_REFRESH

	else if(href_list["age"])
		var/datum/species/S = all_species[pref.species]
		var/new_age = input(user, "Choose your character's age:\n([S.min_age]-[S.max_age])", "Character Preference", pref.age) as num|null
		if(new_age && CanUseTopic(user))
			pref.age = max(min(round(text2num(new_age)), S.max_age), S.min_age)
			return TOPIC_REFRESH

	else if(href_list["metadata"])
		var/new_metadata = sanitize(input(user, "Enter any information you'd like others to see, such as Roleplay-preferences:", "Game Preference" , pref.metadata)) as message|null
		if(new_metadata && CanUseTopic(user))
			pref.metadata = sanitize(new_metadata)
			return TOPIC_REFRESH

	return ..()
