/*
Should be used for all zoom mechanics
Parts of code courtesy of Super3222
*/

/obj/item/attachment/scope
	name = "generic scope"
	icon = 'icons/obj/device.dmi'
	icon_state = "binoculars"
	zoomdevicename = null
	var/zoom_amt = 3
	var/zoomed = 0
	var/datum/action/toggle_scope/azoom
	attachment_type = ATTACH_SCOPE
	slot_flags = SLOT_POCKET

/obj/item/attachment/scope/New()
	..()
	build_zooming()

/obj/item/attachment/scope/adjustable
	name = "generic adjustable scope"
	var/min_zoom = 3
	var/max_zoom = 3

/obj/item/attachment/scope/adjustable/New()
	..()
	zoom_amt = max_zoom // this really makes more sense IMO, 95% of people will just set it to the max - Kachnov

/obj/item/attachment/scope/adjustable/sniper_scope/zoom()
	..()
	if(A_attached)
		var/obj/item/weapon/gun/L = loc //loc is the gun this is attached to
		var/zoom_offset = round(world.view * zoom_amt)
		if(zoomed)
			if(L.accuracy)
				L.accuracy = L.scoped_accuracy + zoom_offset
			if(L.recoil)
				L.recoil = round(L.recoil*(zoom_amt/5)+1)//recoil is worse when looking through a scope
		else
			L.accuracy = initial(L.accuracy)
			L.recoil = initial(L.recoil)

//Not actually an attachment
/obj/item/attachment/scope/adjustable/binoculars
	name = "binoculars"
	desc = "A pair of binoculars."
	max_zoom = 25
	attachable = FALSE

/obj/item/attachment/scope/adjustable/verb/adjust_scope_verb()
	set name = "Adjust Zoom"
	set category = "Weapons"
	var/mob/living/carbon/human/user = usr
	if(istype(src, /obj/item/weapon/gun))
		var/obj/item/weapon/gun/G = src
		for(var/obj/item/attachment/scope/adjustable/A in G.attachments)
			src = A
	adjust_scope(user)

/obj/item/attachment/scope/adjustable/proc/adjust_scope(mob/living/carbon/human/user)

	if(!Adjacent(user))
		return
	if(zoomed)
		zoom(user, FALSE)

	var/input = input(user, "Set the zoom amount.", "Zoom" , "") as num
	if(input == zoom_amt)
		return

	var/dial_check = 0

	if(input > max_zoom)
		if(zoom_amt == max_zoom)
			user << "<span class='warning'>You can't adjust it any further.</span>"
			return
		else
			zoom_amt = max_zoom
			dial_check = 1
	else if(input < min_zoom)
		if(zoom_amt == min_zoom)
			user << "<span class='warning'>You can't adjust it any further.</span>"
			return
		else
			zoom_amt = min_zoom
	else
		if(input > zoom_amt)
			dial_check = 1
		zoom_amt = input

	user << "<span class='notice'>You twist the dial on [src] [dial_check ? "clockwise, increasing" : "counterclockwise, decreasing"] the zoom range to [zoom_amt].</span>"

// An ugly hack called a boolean proc, made it like this to allow special
// behaviour without big overrides. So special snowflake weapons like the minigun
// can use zoom without overriding the original zoom proc.
//	user: user mob
//	devicename: name of what device you are peering through, set by zoom()
//	silent: boolean controlling whether it should tell the user why they can't zoom in or not
// I am sorry for creating this abomination -- Irra
/obj/item/attachment/scope/proc/can_zoom(mob/living/user, var/silent = 0)
	if(user.stat || !ishuman(user))
		if(!silent) user << "You are unable to focus through \the [src]."
		return 0
	if (istype(user.loc, /obj/tank))
		return 0
	else if(global_hud.darkMask[1] in user.client.screen)
		if(!silent) user << "Your visor gets in the way of looking through \the [src]."
		return 0
	else if(!A_attached)
		if(user.client.pixel_x | user.client.pixel_y) //Keep people from looking through two scopes at once
			if(!silent) user << "You are too distracted to look through \the [src]."
			return 0
		if(user.get_active_hand() != src)
			if(!silent) user << "You are too distracted to look through \the [src]."
			return 0
	else if(user.get_active_hand() != loc)
		if(!silent) user << "You are too distracted to look through \the [src]."
		return 0
	return 1

/obj/item/attachment/scope/proc/zoom(mob/living/user, forced_zoom, var/bypass_can_zoom = 0)

	if(!user || !user.client)
		return

	switch(forced_zoom)
		if(FALSE)
			zoomed = FALSE
		if(TRUE)
			zoomed = TRUE
		else
			zoomed = !zoomed

	if(zoomed)
		if(!can_zoom(user) && !bypass_can_zoom)//Zoom checks
			zoomed = FALSE
			return
		else
			if(do_after(user, 5, user, 1))//Scope delay
				var/_x = 0
				var/_y = 0
				switch(user.dir)
					if(NORTH)
						_y = zoom_amt
					if(EAST)
						_x = zoom_amt
					if(SOUTH)
						_y = -zoom_amt
					if(WEST)
						_x = -zoom_amt
				if(zoom_amt > world.view)//So we can still see the player at the edge of the screen if the zoom amount is greater than the world view
					var/view_offset = round((zoom_amt - world.view)/2, 1)
					user.client.view += view_offset
					switch(user.dir)
						if(NORTH)
							_y -= view_offset
						if(EAST)
							_x -= view_offset
						if(SOUTH)
							_y += view_offset
						if(WEST)
							_x += view_offset
					animate(user.client, pixel_x = world.icon_size*_x, pixel_y = world.icon_size*_y, 4, 1)
					animate(user.client, pixel_x = 0, pixel_y = 0)
					user.client.pixel_x = world.icon_size*_x
					user.client.pixel_y = world.icon_size*_y
				else // Otherwise just slide the camera
					animate(user.client, pixel_x = world.icon_size*_x, pixel_y = world.icon_size*_y, 4, 1)
					animate(user.client, pixel_x = 0, pixel_y = 0)
					user.client.pixel_x = world.icon_size*_x
					user.client.pixel_y = world.icon_size*_y
				user.visible_message("[user] peers through the [zoomdevicename ? "[zoomdevicename] of \the [src.name]" : "[src.name]"].")
			else
				zoomed = FALSE
	else //Resets everything
		user.client.pixel_x = 0
		user.client.pixel_y = 0
		user.client.view = world.view
		user.visible_message("[zoomdevicename ? "[user] looks up from \the [src.name]" : "[user] lowers \the [src.name]"].")

	if (zoomed)
		for (var/obj/o in user.client.screen)
			if (!istype(o, /obj/screen/movable/action_button))
				/* 100 invisibility is better than 101 so we can still
				   work with objects (like radios) */
				o.invisibility = 100
	else
		for (var/obj/o in user.client.screen)
			if (!istype(o, /obj/screen/movable/action_button))
				o.invisibility = initial(o.invisibility)

/datum/action/toggle_scope
	name = "Toggle Sights"
	check_flags = AB_CHECK_ALIVE|AB_CHECK_RESTRAINED|AB_CHECK_STUNNED|AB_CHECK_LYING
	button_icon_state = "sniper_zoom"
	var/obj/item/attachment/scope/scope = null

/datum/action/toggle_scope/IsAvailable()
	. = ..()
	if(scope.zoomed)
		return 0

/datum/action/toggle_scope/Trigger()
	..()
	scope.zoom(owner)

/datum/action/toggle_scope/Remove(mob/living/L)
	if(scope.zoomed)
		scope.zoom(L, FALSE)
	..()

//Proc, so that gun accessories/scopes/etc. can easily add zooming.
/obj/item/attachment/scope/proc/build_zooming()
	azoom = new()
	azoom.scope = src
	actions += azoom

/obj/item/attachment/scope/pickup(mob/user)
	..()
	if(azoom)
		azoom.Grant(user)

/obj/item/attachment/scope/dropped(mob/user)
	..()
	if(azoom)
		azoom.Remove(user)

/mob/living/carbon/human/Move()//Resets zoom on movement
	..()
	if(client && actions.len)
		if(client.pixel_x || client.pixel_y) //Cancel currently scoped weapons
			for(var/datum/action/toggle_scope/T in actions)
				if(T.scope.zoomed && src.m_intent=="run")
					shake_camera(src, 2, rand(2,3))
				//	T.scope.zoom(src, FALSE)

// called from Life()
/mob/living/carbon/human/proc/handle_zoom_stuff(var/ghosting = FALSE)
	if (stat == UNCONSCIOUS || stat == DEAD || ghosting)
		if(client && actions.len)
			if(client.pixel_x || client.pixel_y) //Cancel currently scoped weapons
				for(var/datum/action/toggle_scope/T in actions)
					if(T.scope.zoomed)
						T.scope.zoom(src, FALSE)

/mob/living/carbon/human/proc/using_zoom()
	if (stat == CONSCIOUS)
		if(client && actions.len)
			if(client.pixel_x || client.pixel_y) //Cancel currently scoped weapons
				for(var/datum/action/toggle_scope/T in actions)
					if(T.scope.zoomed)
						return 1
	return 0


