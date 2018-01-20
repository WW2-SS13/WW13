/datum/language/russian
	name = "Russian"
	desc = "SLAVA SOVETSKOMU SOYUZU!"
	speech_verb = "says"
	whisper_verb = "whispers"
	key = "r"
	colour = "Russian"
	flags = RESTRICTED | COMMON_VERBS
	syllables = list("ал", "ан", "бы", "ве", "во", "го", "де", "ел", "ен", "ер", "ет", "ка", "ко", "ла", "ли", "ло", "ль", "на", "не", "ни", "но", "ов", "ол", "он", "ор", "слог", "от", "по", "пр", "ра", "ре", "ро", "ст", "та", "те", "то", "ть", "ать", "был", "вер", "его", "ени", "енн", "ест", "как", "льн", "ова", "ого", "оль", "оро", "ост", "ото", "при", "про", "ста", "ств", "тор", "что", "это")

/datum/language/ukrainian
	name = "Ukrainian"
	desc = "SMERT' DO RADYANS'KOHO SOYUZU"
	speech_verb = "says"
	whisper_verb = "whispers"
	key = "u"
	colour = "Russian"
	flags = RESTRICTED | COMMON_VERBS
	syllables = list("ал", "ан", "бы", "ве", "во", "го", "де", "ел", "ен", "ер", "ет", "ка", "ко", "ла", "ли", "ло", "ль", "на", "не", "ни", "но", "ов", "ол", "он", "ор", "слог", "от", "по", "пр", "ра", "ре", "ро", "ст", "та", "те", "то", "ть", "ать", "был", "вер", "его", "ени", "енн", "ест", "как", "льн", "ова", "ого", "оль", "оро", "ост", "ото", "при", "про", "ста", "ств", "тор", "что", "это")

/datum/language/russian/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return pick("exclaims", "shouts", "yells") //TODO: make the basic proc handle lists of verbs.
		if("?")
			return ask_verb
	return speech_verb

/datum/language/german
	name = "German"
	desc = "ZIEG HEIL!"
	speech_verb = "says"
	whisper_verb = "whispers"
	key = "g"
	colour = "english"
	flags = RESTRICTED | COMMON_VERBS
	syllables = list("al", "an", "ar", "as", "at", "ea", "ed", "en", "er", "es", "ha", "he", "hi", "in", "is", "it", "le", "me", "nd", "ne", "ng", "nt", "on", "or", "ou", "re", "se", "st", "te", "th", "ti", "to", "ve", "wa", "all", "and", "are", "but", "ent", "era", "ere", "eve", "for", "had", "hat", "hen", "her", "hin", "his", "ing", "ion", "ith", "not", "ome", "oul", "our", "sho", "ted", "ter", "tha", "the", "thi", "tio", "uld", "ver", "was", "wit", "you")

/datum/language/german/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return pick("exclaims", "shouts", "yells") //TODO: make the basic proc handle lists of verbs.
		if("?")
			return ask_verb
	return speech_verb

// 'basic' language; spoken by default.
/datum/language/common
	name = "Galactic Common"
	desc = "The common galactic tongue."
	speech_verb = "says"
	whisper_verb = "whispers"
	key = "0"
	flags = RESTRICTED
	syllables = list("blah","blah","blah","bleh","meh","neh","nah","wah")

//TODO flag certain languages to use the mob-type specific say_quote and then get rid of these.
/datum/language/common/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return pick("exclaims","shouts","yells") //TODO: make the basic proc handle lists of verbs.
		if("?")
			return ask_verb
	return speech_verb