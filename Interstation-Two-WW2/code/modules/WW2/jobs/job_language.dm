/datum/job
	var/default_language = "Common"
	var/list/additional_languages = list() // "Name" = probability between TRUE-100

/datum/job/german
	default_language = "German"
	additional_languages = list("Russian" = 5)

/datum/job/soviet
	default_language = "Russian"
	additional_languages = list("German" = 5)

/datum/job/partisan
	default_language = "Ukrainian"
	additional_languages = list("German" = 50, "Russian" = 50)

/datum/job/update_character(var/mob/living/carbon/human/H)
	. = ..()

	H.add_language(default_language, TRUE)
	H.default_language = all_languages[default_language]

	if (additional_languages && additional_languages.len > FALSE)
		for(var/language_name in additional_languages)
			var/probability = additional_languages[language_name]

			if (prob(probability))
				H.add_language(language_name, FALSE)
				H.show_message("<b>You know the [language_name] language!</b>")

	if (istype(H.languages[1], /datum/language/common))
		H.languages[1] = null
