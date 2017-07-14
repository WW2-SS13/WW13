// An ugly hack called a boolean proc, made it like this to allow special
// behaviour without big overrides. So special snowflake weapons like the minigun
// can use zoom without overriding the original zoom proc.
//	user: user mob
//	devicename: name of what device you are peering through, set by zoom()
//	silent: boolean controlling whether it should tell the user why they can't zoom in or not
// I am sorry for creating this abomination -- Irra
/obj/item/weapon/gun/proc/can_zoom(mob/living/user, var/devicename = src.name, var/silent = 0)
	if(user.stat || !ishuman(user))
		if (!silent) user.visible_message("You are unable to focus through the [devicename].")
		return 0
	else if(global_hud.darkMask[1] in user.client.screen)
		if (!silent) user.visible_message("Your visor gets in the way of looking through the [devicename].")
		return 0
	else if(user.get_active_hand() != src)
		if (!silent) user.visible_message("You are too distracted to look through the [devicename].")
		return 0
	return 1

/obj/item/weapon/gun/proc/zoom(mob/living/user, forced_zoom)
  if(!user || !user.client)
    return

  var/zoom_offset = round(world.view * zoom_amt)

  switch(forced_zoom)
    if(FALSE)
      zoomed = FALSE
    if(TRUE)
      zoomed = TRUE
    else
      zoomed = !zoomed

  if(zoomed)
    if(!can_zoom(user, src))//Zoom checks
      return
    else
      if(do_after(user, 5, src, 1))//Scope delay
        if(accuracy)
          accuracy = scoped_accuracy + zoom_offset
        if(recoil)
          recoil = round(recoil*zoom_amt+1)//recoil is worse when looking through a scope
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
        else // Otherwise just slide the camera
          animate(user.client, pixel_x = world.icon_size*_x, pixel_y = world.icon_size*_y, 4, 1)
        user.visible_message("[user] peers through the [zoomdevicename ? "[zoomdevicename] of the [src.name]" : "[src.name]"].")
  else //Resets everything
    user.client.pixel_x = 0
    user.client.pixel_y = 0
    user.client.view = world.view
    user.visible_message("[zoomdevicename ? "[user] looks up from the [src.name]" : "[user] lowers the [src.name]"].")
    accuracy = initial(accuracy)
		recoil = initial(recoil)

/datum/action/toggle_scope
	name = "Toggle Sights"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_RESTRAINED|AB_CHECK_STUNNED|AB_CHECK_LYING
	button_icon_state = "sniper_zoom"
	var/obj/item/weapon/gun/gun = null

/datum/action/toggle_scope/IsAvailable()
	. = ..()
	if(gun.zoomed)
		return 0

/datum/action/toggle_scope/Trigger()
  ..()
  gun.zoom(owner)

/datum/action/toggle_scope/Remove(mob/living/L)
	if(gun.zoomed)
		gun.zoom(L, FALSE)
	..()

//Proc, so that gun accessories/scopes/etc. can easily add zooming.
/obj/item/weapon/gun/proc/build_zooming()
	if(azoom)
		return

	if(zoomable)
		azoom = new()
		azoom.gun = src

/obj/item/weapon/gun/pickup(mob/user)
	..()
	if(azoom)
		azoom.Grant(user)

//For some rasin, this is called during inventorty events like grabbing an item from your pocket/back/holster
/obj/item/weapon/gun/dropped(mob/user)
	if(loc != user)//To stop inventory events from deleting your buttons (for now)
		..()
		if(azoom)
			azoom.Remove(user)

/mob/living/carbon/human/Move()//Resets zoom on movement
  ..()
  if(client && actions)
    if(client.pixel_x | client.pixel_y) //Cancle currently scoped weapons
      for(var/datum/action/toggle_scope/T in actions)
        T.gun.zoom(src, FALSE)
