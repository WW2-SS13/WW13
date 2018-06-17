/obj/item/radio/intercom/loudspeaker
	name = "base loudspeaker"
	desc = "This is where your commandant shouts at you from."
	icon_state = "loudspeaker"
	canhear_range = 7
	listening = TRUE
	broadcasting = FALSE
	layer = MOB_LAYER + 1
	anchored = TRUE


/obj/item/radio/loudspeaker/german_real
	name = "german base loudspeaker"
	desc = "This is where your Kommandant shouts at you from."
	icon_state = "loudspeaker"
	canhear_range = 10
	listening = TRUE
	broadcasting = FALSE
	layer = MOB_LAYER + 1
	anchored = TRUE
	frequency = DE_BASE_FREQ
	is_supply_radio = FALSE
	faction = GERMAN
	//listening_on_channel[1004] = TRUE


/obj/item/radio/loudspeaker/soviet_real
	name = "soviet base loudspeaker"
	desc = "This is where your Kommandir shouts at you from."
	icon_state = "loudspeaker"
	canhear_range = 10
	listening = TRUE
	broadcasting = FALSE
	layer = MOB_LAYER + 1
	anchored = TRUE
	frequency = SO_BASE_FREQ
	is_supply_radio = FALSE
	faction = SOVIET
	//listening_on_channel[1001] = TRUE

/obj/item/radio/intercom/loudspeaker/german
	frequency = DE_BASE_FREQ

/obj/item/radio/intercom/loudspeaker/russian
	frequency = SO_BASE_FREQ

/obj/item/radio/intercom/loudspeaker/interact(mob/user)
	return //It's just a loudspeaker

/obj/item/radio/intercom/loudspeaker/process()
	return //to stop icon from changing
