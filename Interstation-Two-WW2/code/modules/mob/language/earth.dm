/datum/language/russian
	name = "Russian"
	desc = "slava sovyetskomu soyuzu!"
	key = "r"
	colour = "Russian"
	flags = RESTRICTED | COMMON_VERBS
	syllables = list("al", "an", "bi", "vye", "vo", "go", "dye", "yel", "?n", "yer", "yet", "ka", "ko", "la", "ly", "lo", "l", "na", "nye", "ny", "no", "ov", "ol", "on", "or", "slog", "ot", "po", "pr", "ra", "rye", "ro", "st", "ta", "tye", "to", "t", "at", "bil", "vyer", "yego", "yeny", "yenn", "yest", "kak", "ln", "ova", "ogo", "?l", "oro", "ost", "oto", "pry", "pro", "sta", "stv", "tor", "chto", "eto")
	mutual_intelligibility = list(/datum/language/ukrainian = 66,
		/datum/language/polish = 45)

/datum/language/ukrainian
	name = "Ukrainian"
	desc = "Smert' do radyans'koho soyuzu!"
	key = "u"
	colour = "Russian"
	flags = RESTRICTED | COMMON_VERBS
	syllables = list("al", "an", "bi", "vye", "vo", "go", "dye", "yel", "?n", "yer", "yet", "ka", "ko", "la", "ly", "lo", "l", "na", "nye", "ny", "no", "ov", "ol", "on", "or", "slog", "ot", "po", "pr", "ra", "rye", "ro", "st", "ta", "tye", "to", "t", "at", "bil", "vyer", "yego", "yeny", "yenn", "yest", "kak", "ln", "ova", "ogo", "?l", "oro", "ost", "oto", "pry", "pro", "sta", "stv", "tor", "chto", "eto")
	mutual_intelligibility = list(/datum/language/polish = 75,
		/datum/language/russian = 70)

/datum/language/polish
	name = "Polish"
	desc = "Smierc dla ciemiezców!"
	key = "u"
	colour = "Russian"
	flags = RESTRICTED | COMMON_VERBS
	syllables = list("al", "an", "bi", "vye", "vo", "go", "dye", "yel", "?n", "yer", "yet", "ka", "ko", "la", "ly", "lo", "l", "na", "nye", "ny", "no", "ov", "ol", "on", "or", "slog", "ot", "po", "pr", "ra", "rye", "ro", "st", "ta", "tye", "to", "t", "at", "bil", "vyer", "yego", "yeny", "yenn", "yest", "kak", "ln", "ova", "ogo", "?l", "oro", "ost", "oto", "pry", "pro", "sta", "stv", "tor", "chto", "eto")
	mutual_intelligibility = list(/datum/language/ukrainian = 75,
		/datum/language/russian = 45)

/datum/language/german
	name = "German"
	desc = "Sieg heil!"
	key = "g"
	colour = "english"
	flags = RESTRICTED | COMMON_VERBS
	syllables = list("al", "an", "ar", "as", "at", "ea", "ed", "en", "er", "es", "ha", "he", "hi", "in", "is", "it", "le", "me", "nd", "ne", "ng", "nt", "on", "or", "ou", "re", "se", "st", "te", "th", "ti", "to", "ve", "wa", "all", "and", "are", "but", "ent", "era", "ere", "eve", "for", "had", "hat", "hen", "her", "hin", "his", "ing", "ion", "ith", "not", "ome", "oul", "our", "sho", "ted", "ter", "tha", "the", "thi", "tio", "uld", "ver", "was", "wit", "you")

/datum/language/italian
	name = "Italian"
	desc = "Mama mia!"
	key = "i"
	colour = "english"
	flags = RESTRICTED | COMMON_VERBS
	syllables = list("pi", "za", "pe", "pp", "er", "on", "i", "ma", "mia", "na", "va", "gi")
	mutual_intelligibility = list(/datum/language/romanian = 50)

/datum/language/romanian
	name = "Romanian"
	desc = "Mama mea!"
	key = "r"
	colour = "english"
	flags = RESTRICTED | COMMON_VERBS
	syllables = list("za", "pe", "pp", "er", "on", "i", "ma", "mia", "na", "va", "gi", "vye", "vo", "go", "dye")
	mutual_intelligibility = list(/datum/language/italian = 50)