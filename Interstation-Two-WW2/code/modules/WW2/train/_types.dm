// factional train controllers

/datum/train_controller/german_train_controller

/datum/train_controller/german_train_controller/New()
	..(GERMAN)

/datum/train_controller/german_supplytrain_controller
	var/supply_points = 200
	var/supply_points_per_second_min = 0.1
	var/supply_points_per_second_max = 0.3

/datum/train_controller/german_supplytrain_controller/New()
	..("GERMAN-SUPPLY")
	direction = "BACKWARDS"

/datum/train_controller/russian_train_controller

/datum/train_controller/russian_train_controller/New()
	..(RUSSIAN)
