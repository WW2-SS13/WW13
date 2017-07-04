/obj/train_track
	name = "train track"
	icon = 'icons/obj/structures.dmi'
	icon_state = "traintrack"
	density = 0
	anchored = 1.0
	w_class = 3
	layer = 2.01 //just above floors
	//	flags = CONDUCT

/obj/train_track/New()
	..()
	#ifdef USE_TRAIN_LIGHTS
	set_light(2, 3, "#a0a080") // range, power, color
	#endif