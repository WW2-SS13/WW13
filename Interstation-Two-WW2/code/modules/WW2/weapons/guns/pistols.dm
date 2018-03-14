/obj/item/weapon/gun/projectile/pistol/attackby(obj/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/attachment/bayonet))
		user << "<span class = 'danger'>That won't fit on there.</span>"
		return FALSE
	else
		return ..()

/obj/item/weapon/gun/projectile/pistol/luger
	name = "Luger P08"
	desc = "German 9mm pistol, commonly used by officers and special assignment units."
	icon_state = "p08"
	item_state = "gun"
	w_class = 2
	caliber = "a9mm_para_luger"
	fire_sound = 'sound/weapons/Gunshot_light.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/luger
	accuracy = DEFAULT_PISTOL_ACCURACY
	scoped_accuracy = DEFAULT_PISTOL_SCOPED_ACCURACY

/obj/item/weapon/gun/projectile/pistol/luger/gibber
	crushes = TRUE

// new soviet officer gun
/obj/item/weapon/gun/projectile/pistol/_45
	name = "Colt M1911"
	desc = "a Colt M1911A1. Uses .45 rounds."
	icon_state = "colt"
	item_state = "gun"
	w_class = 2
	caliber = ".45"
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c45m
	accuracy = DEFAULT_PISTOL_ACCURACY
	scoped_accuracy = DEFAULT_PISTOL_SCOPED_ACCURACY

/obj/item/weapon/gun/projectile/pistol/_45/gibber
	crushes = TRUE


/obj/item/weapon/gun/projectile/pistol/tokarev
	name = "TT-30"
	desc = "Russian pistol chambered in 7.62mm rounds. Official name being Tula-Tokarev 30."
	icon_state = "tokarev"
	item_state = "gun"
	w_class = 2
	caliber = "7.62mm"
	fire_sound ='sound/weapons/guns/fire/pistol_fire.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c762mm_tokarev
	accuracy = DEFAULT_PISTOL_ACCURACY
	scoped_accuracy = DEFAULT_PISTOL_SCOPED_ACCURACY

/obj/item/weapon/gun/projectile/pistol/tokarev/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "tokarev"
		item_state = "gun"
	else
		icon_state = "tokarev0"
		item_state = "gun"
	return

/obj/item/weapon/gun/projectile/pistol/tokarev/gibber
	crushes = TRUE


/obj/item/weapon/gun/projectile/pistol/mauser
	name = "Mauser C96"
	desc = "German pistol, the C96 Mauser is chambered in 7.63x25mm Mauser."
	icon_state = "mauserc96"
	item_state = "gun"
	w_class = 2
	caliber = "7.63x25mm"
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	load_method = SINGLE_CASING|SPEEDLOADER
	max_shells = 10
	ammo_type = /obj/item/ammo_casing/c763x25mm_mauser
	magazine_type = /obj/item/ammo_casing/c763x25mm_mauser
	accuracy = DEFAULT_PISTOL_ACCURACY
	scoped_accuracy = DEFAULT_PISTOL_SCOPED_ACCURACY

/obj/item/weapon/gun/projectile/pistol/mauser/update_icon()
	..()
	if(loaded.len)
		icon_state = "mauserc96"
		item_state = "gun"
	else
		icon_state = "mauserc960"
		item_state = "gun"
	return

/obj/item/weapon/gun/projectile/pistol/mauser/gibber
	crushes = TRUE

/obj/item/weapon/gun/projectile/revolver/nagant_revolver
	name = "Nagant Revolver"
	desc = "Russian officer's revolver."
	icon_state = "nagant"
	item_state = "revolver"
	w_class = 2
	caliber = "7.62x38mmR"
	handle_casings = CYCLE_CASINGS
	max_shells = 7
	magazine_type = /obj/item/ammo_magazine/c762x38mmR

/obj/item/weapon/gun/projectile/revolver/nagant_revolver/gibber
	crushes = TRUE

/obj/item/weapon/gun/projectile/revolver/nagant_revolver/update_icon()
	..()
	if(loaded.len)
		icon_state = "nagant"
	else
		icon_state = "nagant"
	return


/////////////////////FLAREGUNS//////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

/obj/item/weapon/gun/projectile/pistol/luger/flaregun
	name = "Flare Gun"
	desc = "A gun which shoots flares, giving orders designated by an officer."
	icon_state = "flare"
	item_state = "gun"
	caliber = "flare"
	var/last_fired = -1

/obj/item/weapon/gun/projectile/pistol/luger/flaregun/New()
	..()
	ammo_magazine = new/obj/item/ammo_magazine/flare/red // prevents us from starting with a shitty generic mag

/obj/item/weapon/gun/projectile/pistol/luger/flaregun/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)

	if (last_fired != -1)
		if (world.time - last_fired < 150)
			user << "<span class = 'warning'>You can't fire again so soon!</span>"
			return

	last_fired = world.time

	..(target, user, clickparams, pointblank, reflex)

//called after successfully firing
/obj/item/weapon/gun/projectile/pistol/luger/flaregun/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0)

	if (!silenced)
		if(muzzle_flash)
			set_light(muzzle_flash)

	update_icon()

	var/local_message = ""
	var/self_message = ""
	var/other_message = ""

	if (istype(ammo_magazine, /obj/item/ammo_magazine/flare/red))
		local_message = "<span class = 'danger'>[user] fires a red flare into the sky!</span>"
		self_message = "<span class = 'warning'>You fire a red flare into the sky!</span>"
		other_message = "<span class = 'danger'>You see a red flare in the sky SUBSTITUTE_FOR_DIR of you!</span>"
	else if (istype(ammo_magazine, /obj/item/ammo_magazine/flare/green))
		local_message = "<span class = 'danger'>[user] fires a green flare into the sky!</span>"
		self_message = "<span class = 'warning'>You fire a green flare into the sky!</span>"
		other_message = "<span class = 'danger'>You see a green flare in the sky SUBSTITUTE_FOR_DIR of you!</span>"
	else if (istype(ammo_magazine, /obj/item/ammo_magazine/flare/yellow))
		local_message = "<span class = 'danger'>[user] fires a yellow flare into the sky!</span>"
		self_message = "<span class = 'warning'>You fire a yellow flare into the sky!</span>"
		other_message = "<span class = 'danger'>You see a yellow flare in the sky SUBSTITUTE_FOR_DIR of you!</span>"

	user.visible_message(local_message, self_message)

	for (var/mob/m in player_list)
		if (m.client && m != user)
			if (m.z == user.z && m.stat != UNCONSCIOUS && m.stat != DEAD) // everyone on the z level
				var/direction = m.dir2_text(user)
				var/message = replacetext(other_message, "SUBSTITUTE_FOR_DIR", lowertext(direction))
				m << message


