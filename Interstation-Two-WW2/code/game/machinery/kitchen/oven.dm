/obj/machinery/microwave/oven
	name = "Oven"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "oven"
	layer = 2.9
	density = TRUE
	anchored = TRUE
	use_power = TRUE
	idle_power_usage = 5
	active_power_usage = 100
	flags = OPENCONTAINER | NOREACT

	base_state = "oven"
	on_state = "oven_on"
	open_state = "oven"
	off_state = "oven_off"
	broken_state = "oven"
	bloody_state = "oven"
	bloody_off_state = "oven"
	bloody_open_state = "oven"
	bloody_on_state = "oven_on"