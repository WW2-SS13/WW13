/obj/item/weapon/gun/projectile/automatic/dp
	name = "DP-28"
	desc = "Soviet light machine gun with a odd disk-shaped magazine on top. Chambered in 7.62x54mmR, in 41 round magazines."
	icon_state = "dp"
	item_state = "dp"
	load_method = MAGAZINE
	w_class = 5
	accuracy = DEFAULT_MG_ACCURACY
	scoped_accuracy = DEFAULT_MG_SCOPED_ACCURACY
	caliber = "a762x39"
	magazine_type = /obj/item/ammo_magazine/a762/dp
	can_wield = FALSE
	must_wield = FALSE
	slot_flags = SLOT_BACK

	firemodes = list(
		list(name="short bursts",	burst=4, burst_delay=0.8, move_delay=8, dispersion = list(0.7, 1.1, 1.1, 1.1, 1.3), recoil = 1.0),
		list(name="long bursts",	burst=8, burst_delay=1.5, move_delay=11, dispersion = list(0.9, 1.3, 1.3, 1.3, 1.5), recoil = 1.5)
		)

	sel_mode = 2
	force = 20
	throwforce = 30

/obj/item/weapon/gun/projectile/automatic/dp/update_icon()
	if(ammo_magazine)
		icon_state = "dp"
		if(wielded)
			item_state = "dp-w"
		else
			item_state = "dp"
	else
		icon_state = "dp0"
		if(wielded)
			item_state = "dp-w"
		else
			item_state = "dp0"
	update_held_icon()
	return

/obj/item/weapon/gun/projectile/automatic/mg34
	name = "MG-34"
	desc = "German light machinegun chambered in 7.92x57mm Mauser. An utterly devastating support weapon."
	icon_state = "l6closed100"
	item_state = "l6closedmag"
	w_class = 5
	max_shells = 50
	caliber = "a792x57"
	slot_flags = SLOT_BACK
	ammo_type = /obj/item/ammo_casing/a792x57_weaker
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a762
	unload_sound 	= 'sound/weapons/guns/interact/lmg_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/lmg_magin.ogg'
	cocked_sound 	= 'sound/weapons/guns/interact/lmg_cock.ogg'
	fire_sound = 'sound/weapons/guns/fire/mg34_firing.ogg'
	requires_two_hands = FALSE
	wielded_icon = "assault-wielded"
	accuracy = DEFAULT_MG_ACCURACY-2 //Prevents shitters from going CQC as they will begin to "miss" more unless they go into scope sight. Shindes- FUCK MGS ACCURACY NERF - ShinDes
	scoped_accuracy = DEFAULT_MG_SCOPED_ACCURACY

	firemodes = list(
		list(name="short bursts", burst=8, move_delay=10, dispersion = list(0.8, 1.2, 1.2, 1.2, 1.4), burst_delay = 1.0, recoil = 1.4),
		list(name="long bursts", burst=16, move_delay=12, dispersion = list(1.0, 1.4, 1.4, 1.4, 1.6), burst_delay = 1.4, recoil = 2.8)
		)

	fire_delay = 3
	force = 20
	throwforce = 30
	var/cover_open = FALSE

/obj/item/weapon/gun/projectile/automatic/mg34/special_check(mob/user)
	if(cover_open)
		user << "<span class='warning'>[src]'s cover is open! Close it before firing!</span>"
		return FALSE
	return ..()

/obj/item/weapon/gun/projectile/automatic/mg34/proc/toggle_cover(mob/user)
	cover_open = !cover_open
	user << "<span class='notice'>You [cover_open ? "open" : "close"] [src]'s cover.</span>"
	update_icon()

/obj/item/weapon/gun/projectile/automatic/mg34/attack_self(mob/user as mob)
	if(cover_open)
		toggle_cover(user) //close the cover
		playsound(loc, 'sound/weapons/guns/interact/lmg_close.ogg', 100, TRUE)
	else
		return ..() //once closed, behave like normal

/obj/item/weapon/gun/projectile/automatic/mg34/attack_hand(mob/user as mob)
	if(!cover_open && user.get_inactive_hand() == src)
		toggle_cover(user) //open the cover
		playsound(loc, 'sound/weapons/guns/interact/lmg_open.ogg', 100, TRUE)
	else
		return ..() //once open, behave like normal

/obj/item/weapon/gun/projectile/automatic/mg34/update_icon()
	icon_state = "l6[cover_open ? "open" : "closed"][ammo_magazine ? round(ammo_magazine.stored_ammo.len, 25) : "-empty"]"

/obj/item/weapon/gun/projectile/automatic/mg34/load_ammo(var/obj/item/A, mob/user)
	if(!cover_open)
		user << "<span class='warning'>You need to open the cover to load [src].</span>"
		return
	..()

/obj/item/weapon/gun/projectile/automatic/mg34/unload_ammo(mob/user, var/allow_dump=1)
	if(!cover_open)
		user << "<span class='warning'>You need to open the cover to unload [src].</span>"
		return
	..()
