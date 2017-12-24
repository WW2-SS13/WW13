/var/obj/effect/lobby_image = new/obj/effect/lobby_image()

/obj/effect/lobby_image
	name = "Baystation12"
	desc = ""
	icon = 'icons/_LOBBY.dmi'
	icon_state = "1"
	screen_loc = "WEST,SOUTH"

/obj/effect/lobby_image/initialize()
	var/list/known_icon_states = icon_states(icon)
	for(var/lobby_screen in config.lobby_screens)
		if(!(lobby_screen in known_icon_states))
			error("Lobby screen '[lobby_screen]' did not exist in the icon set [icon].")
			config.lobby_screens -= lobby_screen

	if(config.lobby_screens.len)
		icon_state = pick(config.lobby_screens)
	else
		icon_state = known_icon_states[1]
