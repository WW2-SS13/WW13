/obj/tank
	var/admin = FALSE

/obj/tank/german
	icon_state = "ger"
	name = "German Panzer"

/obj/tank/german/New()
	..()
	radio = new/obj/item/radio/feldfu
	#ifdef MG_TANKS
	MG = new/obj/item/weapon/gun/projectile/automatic/stationary/kord/mg34(null)
	MG.invisibility = 101
	#endif

/obj/tank/german/admin
	movement_delay = 0.1
	slow_movement_delay = 0.1
	fast_movement_delay = 0.1
	fire_delay = 0.3
	admin = TRUE
	locked = FALSE

/obj/tank/soviet
	icon_state = "sov"
	name = "Soviet T-23 Tank"

/obj/tank/soviet/New()
	..()
	radio = new/obj/item/radio/rbs
	#ifdef MG_TANKS
	MG = new/obj/item/weapon/gun/projectile/automatic/stationary/kord/maxim(null)
	MG.invisibility = 101
	#endif

/obj/tank/soviet/admin
	movement_delay = 0.1
	slow_movement_delay = 0.1
	fast_movement_delay = 0.1
	fire_delay = 0.3
	admin = TRUE
	locked = FALSE