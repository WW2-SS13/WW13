//////////////////ROCKET LAUNCHER///////////////////

/obj/item/weapon/gun/projectile/rocket
	name = "rocket launcher"
	desc = "MAGGOT."
	icon_state = "rocket"
	item_state = "rocket"
	w_class = 4.0
	throw_speed = 2
	throw_range = 10
	force = 5.0
	flags = CONDUCT | USEDELAY
	slot_flags = FALSE
//	origin_tech = "combat=8;materials=5"
	fire_sound = 'sound/effects/bang.ogg'

	recoil = 4


/obj/item/weapon/gun/projectile/rocket/examine(mob/user)
	if(!..(user, 2))
		return

/obj/item/weapon/gun/projectile/rocket/attackby(obj/item/I as obj, mob/user as mob)
	if (..()) // handle attachments
		return TRUE

	if(istype(I, /obj/item/ammo_casing/rocket))
		load_ammo(I, user)
	else
		..()

/obj/item/weapon/gun/projectile/rocket/handle_post_fire(mob/user, atom/target)
	..()
	message_admins("[key_name_admin(user)] fired a rocket from a rocket launcher ([name]) at [target].")
	log_game("[key_name_admin(user)] used a rocket launcher ([name]) at [target].")

//////////////////////////////////////////////
/obj/item/weapon/gun/projectile/rocket/one_use
	name = "one use rocket launcher"
	max_shells = TRUE
	ammo_type = /obj/item/ammo_casing/rocket_he
	load_method = SINGLE_CASING
	handle_casings = REMOVE_CASINGS

	recoil = 4
	can_wield = TRUE
	must_wield = TRUE

/obj/item/weapon/gun/projectile/rocket/one_use/attackby(obj/item/I as obj, mob/user as mob)
	if (..()) // handle attachments
		return TRUE

	return

/obj/item/weapon/gun/projectile/rocket/one_use/attack_self(mob/user as mob)
	if(!wielded)
		wield(user)
	else
		unwield(user)

/obj/item/weapon/gun/projectile/rocket/one_use/update_icon()
	if(wielded)
		item_state = "rpg26_wielded"
	else
		item_state = "rpg26"
	update_held_icon()

/obj/item/weapon/gun/projectile/rocket/one_use/handle_post_fire()
	..()
	name += " (Used)"

/obj/item/weapon/gun/projectile/rocket/one_use/examine(mob/user)
	if(!..(user, 2))
		return
	if(loaded.len > FALSE)
		var/obj/item/ammo_casing/rocket_he/rocket = loaded[1]
		user << "\blue Rocket fuse is set to [rocket.BB.kill_count]."
	else
		user << "\red It's empty."


/obj/item/weapon/gun/projectile/rocket/one_use/rpg26
	name = "RPG-26"
	slot_flags = SLOT_BACK
	icon_state = "rpg26"
	item_state = "rpg26"

/obj/item/weapon/gun/projectile/rocket/one_use/at4
	name = "AT-4"
	slot_flags = SLOT_BACK
	icon_state = "at4"
	item_state = "rpg26"

/////////////Grenade Launcher///////////


/obj/item/weapon/gun/projectile/grenade
	name = "m32"
	desc = "A bulky pump-action grenade launcher. Holds up to 6 grenades in a revolving magazine."
	icon_state = "m32_ready"
	item_state = "m32"
	w_class = 4
	force = 10

	handle_casings = REMOVE_CASINGS
	load_method = SINGLE_CASING
	max_shells = 6

	caliber = "grenade"

	fire_sound = 'sound/weapons/m32_grenshoot.ogg'
	load_shell_sound = 'sound/weapons/m32_grenload.ogg'
	fire_sound_text = "a metallic thunk"
	recoil = FALSE

	slot_flags = SLOT_BACK
	var/opened = FALSE
	matter = list(DEFAULT_WALL_MATERIAL = 2000)

	can_wield = TRUE
	must_wield = TRUE

//revolves the magazine, allowing players to choose between multiple grenade types
/obj/item/weapon/gun/projectile/grenade/proc/pump(mob/M as mob)
	playsound(M, 'sound/weapons/shotgunpump.ogg', 60, TRUE)
	var/obj/item/weapon/grenade/next
	if(loaded.len)
		next = loaded[1] //get this first, so that the chambered grenade can still be removed if the grenades list is empty
	if(chambered)
		loaded += chambered //rotate the revolving magazine
		chambered = null
	if(next)
		loaded -= next //Remove grenade from loaded list.
		chambered = next
		M.visible_message("[M] pumped \a [src].", "<span class='notice'>You pump [src], loading \a [next] into the chamber.</span>")
	else
		M.visible_message("[M] pumped \a [src].", "<span class='notice'>You pump [src], but the magazine is empty.</span>")
	update_icon()

/obj/item/weapon/gun/projectile/grenade/examine(mob/user)
	if(..(user, 2))
		var/grenade_count = loaded.len + (chambered ? TRUE : FALSE)
		user << "Has [grenade_count] grenade\s remaining."
		if(chambered)
			user << "\A [chambered] is chambered. Grenade fuse is set to [chambered.BB.kill_count]."
/*
/obj/item/weapon/gun/projectile/grenade/load_ammo(obj/item/ammo_casing/grenade/G, mob/user)
	if(grenades.len >= max_grenades)
		user << "<span class='warning'>[src] is full.</span>"
		return
	playsound(user, 'sound/weapons/m32_grenload.ogg', 60, TRUE)
	user.remove_from_mob(G)
	G.loc = src
	grenades.Insert(1, G) //add to the head of the list, so that it is loaded on the next pump
	user.visible_message("[user] inserts \a [G] into [src].", "<span class='notice'>You insert \a [G] into [src].</span>")
*/
/*
/obj/item/weapon/gun/projectile/grenade/proc/unload(mob/user)
	if(grenades.len)
		var/obj/item/ammo_casing/grenade/G = grenades[grenades.len]
		grenades.len--
		user.put_in_hands(G)
		user.visible_message("[user] removes \a [G] from [src].", "<span class='notice'>You remove \a [G] from [src].</span>")
	else
		user << "<span class='warning'>[src] is empty.</span>"
*/
/obj/item/weapon/gun/projectile/grenade/attack_self(mob/user)
	if(opened)
		user << "\red You closed the [name]'s loading chamber."
		opened = FALSE
		update_icon()
		return
	if(wielded)
		pump(user)
	else
		wield(user)
	return

/obj/item/weapon/gun/projectile/grenade/attackby(obj/item/I, mob/user)
	if (..()) // handle attachments
		return TRUE

	if(istype(I, /obj/item/ammo_casing/grenade))
		if(opened)
			load_ammo(I, user)
		else
			user << "\red Open the chamber first."
	else
		..()

/obj/item/weapon/gun/projectile/grenade/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		if(opened)
			unload_ammo(user)
		else
			user << "\red You opened the [name]'s loading chamber."
			opened = TRUE
			update_icon()
	else
		..()
/*
/obj/item/weapon/gun/projectile/grenade/consume_next_projectile()
	if(chambered)
		var/obj/item/gl_grenade/grenade = new chambered.projectile_type(src)
		grenade.primed = TRUE
		return grenade
	return null
*/
/obj/item/weapon/gun/projectile/grenade/update_icon()
	if(opened)
		icon_state = "m32_opened"
		item_state = "m32"
	else
		icon_state = "m32_ready"
		if(wielded)
			item_state = "m32_wielded"
		else
			item_state = "m32"
	update_held_icon()

/obj/item/weapon/gun/projectile/grenade/handle_post_fire(mob/user)
	message_admins("[key_name_admin(user)] fired a grenade from a grenade launcher ([name]).")
	log_game("[key_name_admin(user)] used a grenade.")
	chambered = null
	if(loaded.len)
		chambered = loaded[1]
		loaded -= loaded[1]
/*
//Underslung grenade launcher to be used with the Z8
/obj/item/weapon/gun/launcher/grenade/underslung
	name = "underslung grenade launcher"
	desc = "Not much more than a tube and a firing mechanism, this grenade launcher is designed to be fitted to a rifle."
	w_class = 3
	force = 5
	max_grenades = FALSE

/obj/item/weapon/gun/launcher/grenade/underslung/attack_self()
	return

//load and unload directly into chambered
/obj/item/weapon/gun/launcher/grenade/underslung/load(obj/item/weapon/grenade/G, mob/user)
	if(chambered)
		user << "<span class='warning'>[src] is already loaded.</span>"
		return
	user.remove_from_mob(G)
	G.loc = src
	chambered = G
	user.visible_message("[user] load \a [G] into [src].", "<span class='notice'>You load \a [G] into [src].</span>")

/obj/item/weapon/gun/launcher/grenade/underslung/unload(mob/user)
	if(chambered)
		user.put_in_hands(chambered)
		user.visible_message("[user] removes \a [chambered] from [src].", "<span class='notice'>You remove \a [chambered] from [src].</span>")
		chambered = null
	else
		user << "<span class='warning'>[src] is empty.</span>"
*/
/*
/obj/item/gl_grenade
	name = "grenade"

	var/primed = FALSE

/obj/item/gl_grenade/he
	name = "he grenade"

	throw_impact(atom/hit_atom)
		if(primed)
			explosion(hit_atom, FALSE, FALSE, 2, 6)
			qdel(src)
		else
			..()
		return

/obj/item/gl_grenade/smoke
	name = "smoke grenade"
	var/datum/effect/effect/system/smoke_spread/bad/smoke

	New()
		..()
		smoke = PoolOrNew(/datum/effect/effect/system/smoke_spread/bad)
		smoke.attach(src)

	throw_impact(atom/hit_atom)
		if(primed)
			name += " (Used)"
			playsound(loc, 'sound/effects/smoke.ogg', 50, TRUE, -3)
			smoke.set_up(5, FALSE, usr.loc)
			spawn(0)
				smoke.start()
				sleep(10)
				smoke.start()
				sleep(10)
				smoke.start()
				sleep(10)
				smoke.start()
		else
			..()
		return

/obj/item/gl_grenade/tear
	name = "tear grenade"
	var/datum/effect/effect/system/smoke_spread/tear/smoke

	New()
		..()
		smoke = PoolOrNew(/datum/effect/effect/system/smoke_spread/tear)
		smoke.attach(src)

	throw_impact(atom/hit_atom)
		if(primed)
			name += " (Used)"
			playsound(loc, 'sound/effects/smoke.ogg', 50, TRUE, -3)
			smoke.set_up(5, FALSE, usr.loc)
			spawn(0)
				smoke.start()
				sleep(10)
				smoke.start()
				sleep(10)
				smoke.start()
				sleep(10)
				smoke.start()
		else
			..()
		return
*/