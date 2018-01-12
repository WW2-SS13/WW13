/obj/snow_maker // lets the map know where they can spawn snow

/obj/snow
	icon = 'icons/turf/snow.dmi'
	icon_state = ""
	layer = 2.03 // above grass_edge plant decals
	alpha = 200
	name = "snow"
	anchored = TRUE
	special_id = "seasons"
	var/amount = 0.05 // "meters" of snow
	var/area/my_area = null

/obj/snow/New()
	..()
	amount = pick(0.04, 0.05, 0.06) // around 2 inchesi
	var/spawntime = FALSE
	if (!obj_process)
		spawntime = 300
	spawn (spawntime)
		obj_process.add_nonvital_object(src)

/obj/snow/Destroy()
	var/spawntime = FALSE
	if (!obj_process)
		spawntime = 300
	spawn (spawntime)
		obj_process.remove_nonvital_object(src)
	..()

/obj/snow/process()
	if (!my_area)
		my_area = get_area(src)
	if (my_area.weather == WEATHER_SNOW)
		// accumulate about 0.05 meters of snow/40 seconds (+ randomness)
		amount += 0.05 * my_area.weather_intensity
		if (prob(25)) // and some more
			amount *= 0.05 * my_area.weather_intensity
	else if (weather == WEATHER_SNOW && my_area.artillery_integrity <= 20)
		// or, if we're inside, aboout 0.02 meters/40 seconds
		amount += 0.02 * 1.0
		if (prob(25)) // and some more
			amount += 0.02 * 1.0

/obj/snow/proc/descriptor()
	switch (amount)
		if (0 to 0.08) // up to ~1/4 feet
			return "light snow"
		if (0.08 to 0.16) // up to ~1/2 feet
			return "moderately deep snow"
		if (0.16 to 0.30) // up to a ~1 foot
			return "deep snow"
		if (0.30 to 0.75) // ~ 2 to 2.5 feet
			return "very deep snow"
		if (0.75 to 1.22) // up to 4 feet!
			return "extremely deep snow"
		if (1.22 to INFINITY) // no way we can go through this easily
			return "incredibly deep snow"

/obj/snow/get_description_info()
	return "It's about [amount] meters deep. That's [descriptor()]."

/obj/snow/attackby(obj/item/C as obj, mob/user as mob)
	var/turf/floor/F = get_turf(src)
	if (istype(F))
		return F.attackby(C, user)

/obj/snow/bullet_act(var/obj/item/projectile/P, var/def_zone)
	return