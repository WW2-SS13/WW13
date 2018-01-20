//*********************
//POD MACHINEGUNS
//*********************

/obj/item/weapon/gun/projectile/minigun/verb/eject_mag()
	set category = "Minigun"
	set name = "Eject magazine"
	set src in range(1, usr)
	try_remove_mag(usr)

/////////////////////////////
////Stationary Machinegun////
/////////////////////////////
/obj/item/weapon/gun/projectile/minigun
	name = "minigun"
	desc = "6-barreled highspeed machinegun."
	icon_state = "minigun"
	item_state = ""
	layer = FLY_LAYER
	anchored = TRUE
	density = TRUE
	w_class = 6
	load_method = SINGLE_CASING
	handle_casings = REMOVE_CASINGS
	max_shells = 6000
	caliber = "4mm"
	slot_flags = FALSE
	ammo_type = /obj/item/ammo_casing/c4mm
	accuracy = DEFAULT_MG_ACCURACY
	scoped_accuracy = DEFAULT_MG_SCOPED_ACCURACY

	firemodes = list(
		list(name="3000 rpm", burst=10, burst_delay=0.1, fire_delay=0.4, dispersion=list(1.0)),
		list(name="6000 rpm", burst=20, burst_delay=0.05, fire_delay=0.2, dispersion=list(1.5))
		)

	var/maximum_use_range = FALSE // user loc at minigun's current loc (used in use_object.dm)

	var/user_old_x = FALSE
	var/user_old_y = FALSE

	var/mob/last_user = null

	gun_type = GUN_TYPE_MG

/obj/item/weapon/gun/projectile/minigun/attack_hand(var/mob/user)

	if (last_user && last_user != user)
		user << "<span class = 'warning'>\the [src] is already in use.</span>"
		return

	if(user.using_object == src)
		if(firemodes.len > TRUE)
			switch_firemodes(user)
	else
		var/grip_dir = reverse_direction(dir)
		var/turf/T = get_step(loc, grip_dir)
		if(user.loc == T)
			if(user.has_empty_hand(both = TRUE) && !is_used_by(user))
				user.use_object(src)
			else
				user.show_message("\red You need both hands to use a minigun.")
		else
			user.show_message("<span class='warning'>You're too far from the handles.</span>")
/*
/obj/item/weapon/gun/projectile/minigun/proc/try_use_sights(mob/user)
	if (is_used_by(user))
		//toggle_scope(2.0)
	else
		user.visible_message("<span class='warning'>You aren't using \the [src].</span>")*/

// An ugly hack called a boolean proc, made it like this to allow special
// behaviour without too many overrides. So special snowflake weapons like the minigun
// can use zoom without overriding the original zoom proc.
//	user: user mob
//	devicename: name of what device you are peering through, set by zoom() in items.dm
//	silent: boolean controlling whether it should tell the user why they can't zoom in or not
// I am sorry for creating this abomination -- Irra
///obj/item/weapon/gun/projectile/minigun/can_zoom(mob/user, var/devicename, var/silent)
	//if(user.stat || !ishuman(user))
		//if (!silent) user.show_message("You are unable to focus through the [devicename]")
		//return FALSE
	//else if(!zoomed && global_hud.darkMask[1] in user.client.screen)
		//if (!silent) user.show_message("Your visor gets in the way of looking through the [devicename]")
		//return FALSE
	return TRUE

/obj/item/weapon/gun/projectile/minigun/proc/try_remove_mag(mob/user)
	if(!ishuman(user))
		return
	if (!is_used_by(user))
		if (user.has_empty_hand())
			unload_ammo(user)
		else
			user.show_message("<span class='warning'>You need an empty hand for this.</span>")
	else
		user.show_message("<span class='warning'>You can't do this while using \the [src].</span>")

/obj/item/weapon/gun/projectile/minigun/proc/usedby(mob/user, atom/A, params)
	if(A == src)
		switch_firemodes(user)

	if(check_direction(user, A))
		afterattack(A, user, FALSE, params)
	else
	//	rotate_to(user, A)
		update_layer()

/obj/item/weapon/gun/projectile/minigun/proc/check_direction(mob/user, atom/A)
	if(get_turf(A) == loc)
		return FALSE

	var/shot_dir = get_carginal_dir(src, A)

	if(shot_dir != dir)
		return FALSE

	return TRUE

/obj/item/weapon/gun/projectile/minigun/proc/rotate_to(mob/user, atom/A)
	user.show_message("<span class='warning'>You can't turn the [name] there.</span>")
	return FALSE

/obj/item/weapon/gun/projectile/minigun/proc/update_layer()
	if(dir == NORTH)
		layer = OBJ_LAYER+0.1 // above any casings we drop but below mobs
	else
		layer = FLY_LAYER

/obj/item/weapon/gun/projectile/minigun/proc/started_using(mob/living/carbon/human/user)
	..()

	for(var/datum/action/A in actions)
		if(istype(A, /datum/action/toggle_scope))
			if(user.client.pixel_x | user.client.pixel_y)
				for(var/datum/action/toggle_scope/T in user.actions)
					if(T.scope.zoomed)
						T.scope.zoom(user, FALSE)
			var/datum/action/toggle_scope/S = A
			S.scope.zoom(user, TRUE, TRUE)
			last_user = user

	user.forceMove(loc)
	user.dir = dir

/obj/item/weapon/gun/projectile/minigun/proc/stopped_using(mob/user as mob)
	..()

	for(var/datum/action/A in actions)
		if(istype(A, /datum/action/toggle_scope))
			var/datum/action/toggle_scope/S = A
			S.scope.zoom(user, FALSE)

/obj/item/weapon/gun/projectile/minigun/proc/is_used_by(mob/user)
	return user.using_object == src && user.loc == loc

/obj/item/weapon/gun/projectile/minigun/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return TRUE
	if(istype(mover, /obj/item/projectile))
		return TRUE
	return FALSE

///////////////////////
////Stationary KORD////
///////////////////////
/obj/item/weapon/gun/projectile/minigun/kord
	name = "KORD"
	desc = "Heavy machinegun"
	icon_state = "kord"
	load_method = MAGAZINE
	handle_casings = EJECT_CASINGS
	caliber = "a127x108"
	magazine_type = /obj/item/ammo_magazine/a127x108
	max_shells = FALSE

	fire_sound = 'sound/weapons/WW2/kord1.ogg'

	firemodes = list(
		list(name="default", burst=3, burst_delay=0.5, fire_delay=1.5, dispersion=list(0), accuracy=list(2))
		)

/obj/item/weapon/gun/projectile/minigun/kord/rotate_to(mob/user, atom/A)
	var/shot_dir = get_carginal_dir(src, A)
	dir = shot_dir

	//if(zoomed)
		//zoom(user, FALSE) //Stop Zoom

	user.forceMove(loc)
	user.dir = dir


/obj/item/weapon/gun/projectile/minigun/kord/maxim
	name = "Maxim M1910"
	desc = "Heavy Maxim machinegun on cart mount. You can see 'Batya Makhno' scribed on it's water cooler."
	icon_state = "maxim"
	load_method = MAGAZINE
	handle_casings = EJECT_CASINGS
	caliber = "a762x54"
	magazine_type = /obj/item/ammo_magazine/maxim
	max_shells = FALSE
	anchored = FALSE
	auto_eject = TRUE
	fire_sound = 'sound/weapons/maxim_shot.ogg'
	firemodes = list(
		list(name="default", burst=3, burst_delay=2.5, fire_delay=1.0, dispersion=list(0.4), accuracy=list(2))
		)


/obj/item/weapon/gun/projectile/minigun/kord/maxim/update_icon()
	if(ammo_magazine)
		icon_state = "maxim"
		if(wielded)
			item_state = "maxim"
		else
			item_state = "maxim"
	else
		icon_state = "maxim0"
		if(wielded)
			item_state = "maxim0"
		else
			item_state = "maxom0"
	update_held_icon()
	return


/obj/item/weapon/gun/projectile/minigun/maximstat
	name = "Statioanry maxim machinegun"
	desc = "Maxim machinegun established on special wooden pod."
	icon_state = "maximstat"
	item_state = "maximstat"
	layer = FLY_LAYER
	anchored = TRUE
	density = TRUE
	w_class = 6
	magazine_type = /obj/item/ammo_magazine/maxim
	auto_eject = TRUE
	load_method = MAGAZINE
	handle_casings = EJECT_CASINGS
	max_shells = FALSE
	caliber = "a762x54"
	fire_sound = 'sound/weapons/maxim_shot.ogg'
	slot_flags = FALSE
	ammo_type = /obj/item/ammo_casing/a762x54

	firemodes = list(	// changed burst from 3 to 6, burst_delay from 2.5 to 0.1 to make this more mg-ish - Kachnov
		list(name="default", burst=9, burst_delay=0.1, fire_delay=0.75, dispersion=list(0.3), accuracy=list(2))
		)


/obj/item/weapon/gun/projectile/minigun/maximstat/update_icon()
	if(ammo_magazine)
		icon_state = "maximstat"
		if(wielded)
			item_state = "maximstat"
		else
			item_state = "maximstat"
	else
		icon_state = "maximstat0"
		if(wielded)
			item_state = "maximstat0"
		else
			item_state = "maxomstat0"
	update_held_icon()
	return
