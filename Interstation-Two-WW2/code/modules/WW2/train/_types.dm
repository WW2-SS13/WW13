// factional train controllers

/datum/train_controller/german_train_controller

/datum/train_controller/german_train_controller/New()
	..(GERMAN)

/datum/train_controller/german_supplytrain_controller
	var/supply_points = 200
	var/supply_points_per_second_min = 0.4
	var/supply_points_per_second_max = 0.5
	var/obj/item/device/radio/intercom/fu2/announcer = null
	var/mob/living/carbon/human/mob = null
	var/here = TRUE

/datum/train_controller/german_supplytrain_controller/New()
	..("GERMAN-SUPPLY")
	direction = "BACKWARDS"

	// our personal radio
	announcer = new
	announcer.broadcasting = TRUE

	// hackish code because radios need a mob, with a language, to announce
	mob = new
	mob.default_language = new/datum/language/german
	mob.real_name = "Supply Announcement System"
	mob.name = mob.real_name
	mob.original_job = new/datum/job/german/trainsystem
	mob.sayverb = "announces"

/datum/train_controller/german_supplytrain_controller/proc/announce(msg)
	if (!announcer)
		return
	announcer.broadcast(msg, mob)

/datum/train_controller/russian_train_controller/New()
	..(SOVIET)
