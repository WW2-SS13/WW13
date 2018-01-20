// 2017-07-04: Fixed rifles spitting out all casings on ground when opening bolt after first shot -- Irra

/obj/item/weapon/gun/projectile/boltaction/
	name = "bolt-action rifle"
	desc = "A bolt-action rifle of true ww2 (You shouldn't be seeing this)"
	icon_state = "mosin"
	item_state = "mosin" //placeholder
	w_class = 4
	force = 10
	max_shells = 5
	slot_flags = SLOT_BACK
//	origin_tech = "combat=4;materials=2;syndicate=8"
	caliber = "a792x54"
	recoil = TRUE //extra kickback
	//fire_sound = 'sound/weapons/sniper.ogg'
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING | SPEEDLOADER
	ammo_type = /obj/item/ammo_casing/a762x54
	magazine_type = /obj/item/ammo_magazine/mosin
	load_shell_sound = 'sound/weapons/clip_reload.ogg'
	//+2 accuracy over the LWAP because only one shot
	accuracy = TRUE
	scoped_accuracy = 2
	var/bolt_open = FALSE
	var/check_bolt = FALSE //Keeps the bolt from being interfered with
	var/check_bolt_lock = FALSE //For locking the bolt. Didn't put this in with check_bolt to avoid issues
	var/bolt_safety = FALSE //If true, locks the bolt when gun is empty

/obj/item/weapon/gun/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/attachment))
		var/obj/item/weapon/attachment/A = I
		if(A.attachable)
			try_attach(A, user)
	..()

/obj/item/weapon/gun/projectile/boltaction/attack_self(mob/user)
	if(!check_bolt)//Keeps people from spamming the bolt
		check_bolt++
		if(!do_after(user, 2, src, FALSE, TRUE,INCAPACITATION_DEFAULT, TRUE))//Delays the bolt
			check_bolt--
			return
	else return
	if(check_bolt_lock)
		user << "<span class='notice'>The bolt won't move, the gun is empty!</span>"
		check_bolt--
		return
	bolt_open = !bolt_open
	if(bolt_open)
		if(chambered)
			playsound(loc, 'sound/weapons/bolt_open.ogg', 50, TRUE)
			user << "<span class='notice'>You work the bolt open, ejecting [chambered]!</span>"
			chambered.loc = get_turf(src)
			loaded -= chambered
			chambered = null
			if(bolt_safety)
				if(!loaded.len)
					check_bolt_lock++
					user << "<span class='notice'>The bolt is locked!</span>"
		else
			playsound(loc, 'sound/weapons/bolt_open.ogg', 50, TRUE)
			user << "<span class='notice'>You work the bolt open.</span>"
	else
		playsound(loc, 'sound/weapons/bolt_close.ogg', 50, TRUE)
		user << "<span class='notice'>You work the bolt closed.</span>"
		bolt_open = FALSE
	add_fingerprint(user)
	update_icon()
	check_bolt--

/obj/item/weapon/gun/projectile/boltaction/special_check(mob/user)
	if(bolt_open)
		user << "<span class='warning'>You can't fire [src] while the bolt is open!</span>"
		return FALSE
	return ..()

/obj/item/weapon/gun/projectile/boltaction/load_ammo(var/obj/item/A, mob/user)
	if(!bolt_open)
		return
	if(check_bolt_lock)
		--check_bolt_lock // preincrement is superior
	..()

/obj/item/weapon/gun/projectile/boltaction/unload_ammo(mob/user, var/allow_dump=1)
	if(!bolt_open)
		return
	..()
