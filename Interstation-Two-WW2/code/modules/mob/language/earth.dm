/datum/language/russian
	name = "Russian"
	desc = "SLAVA SOVETSKOMU SOYUZU!"
	speech_verb = "says"
	whisper_verb = "whispers"
	key = "r"
	colour = "russian"
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

/datum/language/english
	name = "English"
	desc = "Blah blah."
	speech_verb = "says"
	whisper_verb = "whispers"
	key = "e"
	colour = "english"
	flags = RESTRICTED | COMMON_VERBS
	//syllables = list("democracy", "hu", "freedom", "usa", "fuck", "shit", "dick", "I")
	syllables = list("al", "an", "ar", "as", "at", "ea", "ed", "en", "er", "es", "ha", "he", "hi", "in", "is", "it", "le", "me", "nd", "ne", "ng", "nt", "on", "or", "ou", "re", "se", "st", "te", "th", "ti", "to", "ve", "wa", "all", "and", "are", "but", "ent", "era", "ere", "eve", "for", "had", "hat", "hen", "her", "hin", "his", "ing", "ion", "ith", "not", "ome", "oul", "our", "sho", "ted", "ter", "tha", "the", "thi", "tio", "uld", "ver", "was", "wit", "you")

/datum/language/english/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return pick("exclaims", "shouts", "yells") //TODO: make the basic proc handle lists of verbs.
		if("?")
			return ask_verb
	return speech_verb

/datum/language/local
	name = "Local"
	desc = "Blah blah."
	speech_verb = "says"
	whisper_verb = "whispers"
	key = "l"
	colour = "local"
	flags = RESTRICTED | COMMON_VERBS
	//syllables = list("democracy", "hu", "freedom", "usa", "fuck", "shit", "dick", "I")
	syllables = list("al", "by", "ch", "do", "en", "ho", "je", "ko", "la", "le", "na", "ne", "ni", "od", "ou", "ov", "po", "pr", "ra", "ro", "se", "st", "te", "to", "ach", "ako", "ale", "byl", "chi", "del", "ech", "edn", "eho", "eni", "hod", "jak", "jeh", "jen", "kdy", "kte", "mel", "neb", "nos", "ost", "ova", "pod", "pro", "pre", "pri", "sem", "sta", "ste", "sti", "tak", "ter", "val", "ylo")

/datum/language/local/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return pick("exclaims", "shouts", "yells") //TODO: make the basic proc handle lists of verbs.
		if("?")
			return ask_verb
	return speech_verb