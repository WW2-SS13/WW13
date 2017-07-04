/proc/scream_sound(var/dying = 0)
	return 0

/*

var/global/list/scream_sounds_german_l1 = list()
var/global/list/scream_sounds_german_l2 = list()
var/global/list/scream_sounds_german_l3 = list()
var/global/list/scream_sounds_german_l4 = list()
var/global/list/scream_sounds_german_l5 = list()
var/global/list/scream_sounds_german_dying = list()

var/global/list/scream_sounds_russian = list()

/mob/living/carbon/human/proc/scream_sound(var/dying = 0)
	var/health_percentage = (health/maxhealth) * 100
	if (istype(default_language, /datum/language/german))
		if (!dying)
			switch (health_percentage)
				if (0 to 20)
					playsound(get_turf(src), pick(scream_sounds_german_l5), 100)
				if (21 to 40)
					playsound(get_turf(src), pick(scream_sounds_german_l4), 100)
				if (41 to 60)
					playsound(get_turf(src), pick(scream_sounds_german_l3), 100)
				if (61 to 80)
					playsound(get_turf(src), pick(scream_sounds_german_l2), 100)
				if (81 to 100)
					playsound(get_turf(src), pick(scream_sounds_german_l2), 100)
		else
			playsound(get_turf(src), pick(scream_sounds_german_dying), 100)
	else
		if (!dying)
			switch (health_percentage)
				if (0 to 20)
					playsound(get_turf(src), pick(scream_sounds_russian_l5), 100)
				if (21 to 40)
					playsound(get_turf(src), pick(scream_sounds_russian_l4), 100)
				if (41 to 60)
					playsound(get_turf(src), pick(scream_sounds_russian_l3), 100)
				if (61 to 80)
					playsound(get_turf(src), pick(scream_sounds_russian_l2), 100)
				if (81 to 100)
					playsound(get_turf(src), pick(scream_sounds_russian_l1), 100)
		else
			playsound(get_turf(src), pick(scream_sounds_russian_dying), 100)

			*/