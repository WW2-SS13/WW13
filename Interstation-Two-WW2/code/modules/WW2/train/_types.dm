// factional train controllers

/datum/train_controller/german_train_controller

/datum/train_controller/german_train_controller/New()
	..(GERMAN)

/datum/train_controller/german_supplytrain_controller
	var/supply_points = 200
	var/supply_points_per_second_min = 0.1
	var/supply_points_per_second_max = 0.3
	var/obj/item/device/radio/intercom/fu2/announcer = null
	var/mob/living/carbon/human/mob = null

/datum/train_controller/german_supplytrain_controller/New()
	..("GERMAN-SUPPLY")
	direction = "BACKWARDS"

	// our personal radio
	announcer = new
	announcer.broadcasting = 1

	// hackish code because radios need a mob, with a language, to announce
	mob = new
	mob.default_language = new/datum/language/german
	mob.real_name = "Supply System"
	mob.name = mob.real_name
	mob.original_job = new/datum/job/german/trainsystem

/datum/train_controller/german_supplytrain_controller/proc/announce(msg)
	if (!announcer)
		return
	announcer.broadcast(msg, mob)

/datum/train_controller/russian_train_controller/New()
	..(RUSSIAN)
