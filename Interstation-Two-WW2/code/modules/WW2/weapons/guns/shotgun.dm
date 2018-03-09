/obj/item/projectile/bullet/shotgun
	speed = 3.0

/obj/item/projectile/bullet/shotgun/murder
	speed = 10.0
	armor_penetration = 500
	damage = 300
	accuracy = 5000
	penetrating = 1

/obj/item/weapon/gun/projectile/shotgun
	gun_type = GUN_TYPE_SHOTGUN
	accuracy = DEFAULT_SHOTGUN_ACCURACY
	scoped_accuracy = DEFAULT_SHOTGUN_SCOPED_ACCURACY
	fire_sound = 'sound/weapons/guns/fire/shotgunp_fire.ogg'

/obj/item/weapon/gun/projectile/shotgun/pump
	name = "shotgun"
	desc = "Useful for sweeping alleys."
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 4
	w_class = 4.0
	force = 10
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	caliber = "shotgun"
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	handle_casings = HOLD_CASINGS
	var/recentpump = FALSE // to prevent spammage

/obj/item/weapon/gun/projectile/shotgun/pump/consume_next_projectile()
	if(chambered)
		return chambered.BB
	return null

/obj/item/weapon/gun/projectile/shotgun/pump/attack_self(mob/living/user as mob)
	if(world.time >= recentpump + 10)
		pump(user)
		recentpump = world.time

/obj/item/weapon/gun/projectile/shotgun/pump/proc/pump(mob/M as mob)
	playsound(M, 'sound/weapons/shotgunpump.ogg', 60, TRUE)

	if(chambered)//We have a shell in the chamber
		chambered.loc = get_turf(src)//Eject casing
		chambered = null

	if(loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC

	update_icon()

/obj/item/weapon/gun/projectile/shotgun/pump/combat
	name = "combat shotgun"
	icon_state = "cshotgun"
	item_state = "cshotgun"
//	origin_tech = "combat=5;materials=2"
	max_shells = 7 //match the ammo box capacity, also it can hold a round in the chamber anyways, for a total of 8.
	ammo_type = /obj/item/ammo_casing/shotgun
	force = 15
	throwforce = 30

/obj/item/weapon/gun/projectile/shotgun/pump/combat/ithaca37
	icon_state = "ithaca37"
	name = "Ithaca 37"

/obj/item/weapon/gun/projectile/shotgun/pump/combat/winchester1897
	icon_state = "winchester1897"
	name = "Winchester 1897"

/obj/item/weapon/gun/projectile/shotgun/pump/combat/coachgun
	icon_state = "coachgun"
	name = "Coachgun"

