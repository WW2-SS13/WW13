var/global/obj/map_metadata/map = null

/obj/map_metadata
	name = ""
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	anchored = 1
	simulated = 0
	invisibility = 101
	var/ID = null

/obj/map_metadata/New()
	..()
	map = src
	icon = null
	icon_state = null

/obj/map_metadata/forest
	ID = "Forest Map (200x529)"

/obj/map_metadata/minicity
	ID = "City Map (70x70)"