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
	stat = "heavy"
	var/recentpump = FALSE // to prevent spammage

	// pistol accuracy for now
	accuracy_list = list(

		// small body parts: head, hand, feet
		"small" = list(
			SHORT_RANGE_STILL = 80,
			SHORT_RANGE_MOVING = 40,

			MEDIUM_RANGE_STILL = 70,
			MEDIUM_RANGE_MOVING = 30,

			LONG_RANGE_STILL = 60,
			LONG_RANGE_MOVING = 40,

			VERY_LONG_RANGE_STILL = 50,
			VERY_LONG_RANGE_MOVING = 20),

		// medium body parts: limbs
		"medium" = list(
			SHORT_RANGE_STILL = 85,
			SHORT_RANGE_MOVING = 43,

			MEDIUM_RANGE_STILL = 75,
			MEDIUM_RANGE_MOVING = 38,

			LONG_RANGE_STILL = 65,
			LONG_RANGE_MOVING = 33,

			VERY_LONG_RANGE_STILL = 55,
			VERY_LONG_RANGE_MOVING = 28),

		// large body parts: chest, groin
		"large" = list(
			SHORT_RANGE_STILL = 90,
			SHORT_RANGE_MOVING = 45,

			MEDIUM_RANGE_STILL = 80,
			MEDIUM_RANGE_MOVING = 40,

			LONG_RANGE_STILL = 70,
			LONG_RANGE_MOVING = 35,

			VERY_LONG_RANGE_STILL = 60,
			VERY_LONG_RANGE_MOVING = 30),
	)

	accuracy_increase_per_point = 1.00
	accuracy_decrease_per_point = 1.00
	KD_chance = 20
	stat = "heavy"

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

