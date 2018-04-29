/datum/job
	var/default_language = "Common"
	var/list/additional_languages = list() // "Name" = probability between 1-100
	var/SL_check_independent = FALSE // we're important, so we can spawn even if SLs are needed

/datum/job/pillarman
	default_language = "German"
	additional_languages = list("Russian" = 100, "Ukrainian" = 100)

/datum/job/german
	default_language = "German"
	additional_languages = list("Russian" = 5, "Italian" = 10)

/datum/job/italian
	default_language = "Italian"
	additional_languages = list("German" = 100 )

/datum/job/soviet
	default_language = "Russian"
	additional_languages = list("German" = 5)

/datum/job/partisan
	default_language = "Ukrainian"
	additional_languages = list("German" = 50, "Russian" = 75)

/datum/job/partisan/civilian
	default_language = "Ukrainian"
	additional_languages = list("German" = 50, "Russian" = 75)

/datum/job/update_character(var/mob/living/carbon/human/H)
	. = ..()

	H.languages.Cut()
	if (istype(src, /datum/job/soviet))
		if (H.client && H.client.prefs)
			switch (H.client.prefs.soviet_ethnicity)
				if (RUSSIAN)
					H.add_language(RUSSIAN, TRUE)
				if (UKRAINIAN)
					H.add_language(UKRAINIAN, TRUE)
					if (H.client)
						spawn (20)
							H.real_name = H.client.prefs.ukrainian_name
					H.name = H.real_name
					H.show_message("<b>You know the Ukrainian language!</b>")
				if (POLISH)
					H.add_language(POLISH, TRUE)
					if (H.client)
						spawn (20)
							H.real_name = H.client.prefs.polish_name
					H.name = H.real_name
					H.show_message("<b>You know the Polish language!</b>")
	if (!H.languages.len || H.languages[1] != default_language)
		H.add_language(default_language, TRUE)
	H.default_language = H.languages[1]

	if (additional_languages && additional_languages.len > 0)
		for(var/language_name in additional_languages)
			var/probability = additional_languages[language_name]

			if (sprob(probability))
				H.add_language(language_name, FALSE)
				H.show_message("<b>You know the [language_name] language!</b>")

