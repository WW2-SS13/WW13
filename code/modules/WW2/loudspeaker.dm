/obj/item/radio/intercom/loudspeaker
	name = "base loudspeaker"
	desc = "This is where your commandant shouts at you from."
	icon_state = "loudspeaker"
	canhear_range = 7
	listening = TRUE
	broadcasting = FALSE
	layer = MOB_LAYER + 1
	anchored = TRUE

/obj/item/radio/intercom/loudspeaker/german
	frequency = DE_BASE_FREQ

/obj/item/radio/intercom/loudspeaker/russian
	frequency = SO_BASE_FREQ

/obj/item/radio/intercom/loudspeaker/interact(mob/user)
	return //It's just a loudspeaker

/obj/item/radio/intercom/loudspeaker/process()
	return //to stop icon from changing
