// used to be called "reset_view" before we realized it already existed, but its
// only purpose was to reset the eye and HUD overlays - what the fuck guys?
// you really need to get better at nomenclature, I guess
/mob/proc/reset_zoom()
	if (client)
		client.view = world.view
		client.pixel_x = 0
		client.pixel_y = 0
		return 1
	return 0
