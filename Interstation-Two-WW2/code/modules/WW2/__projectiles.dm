/* WW2 */

/obj/item/projectile/bullet/rifle
	speed = 2.5

/obj/item/projectile/bullet/rifle/a792x33
	damage = 30
	penetrating = TRUE

/obj/item/projectile/bullet/rifle/a762x54
	damage = 33
	penetrating = 2

/obj/item/projectile/bullet/rifle/a792x57
	damage = 35
	penetrating = 2

/obj/item/projectile/bullet/rifle/a762x25
	damage = 25
	penetrating = FALSE

/obj/item/projectile/bullet/rifle/a9_parabellum
	damage = 23
	penetrating = FALSE


/* "Rifle" rounds */

/obj/item/projectile/bullet/rifle/a762
	damage = 30
	penetrating = TRUE

/obj/item/projectile/bullet/rifle/a145
	damage = 80
	stun = 3
	weaken = 3
	penetrating = 5
	armor_penetration = 80
	hitscan = TRUE //so the PTR isn't useless as a sniper weapon

/obj/item/projectile/bullet/rifle/a556
	damage = 30
	penetrating = TRUE

/obj/item/projectile/bullet/rifle/a9x39
	damage = 45
	penetrating = 3
	step_delay = 2

/obj/item/projectile/bullet/rifle/a762x39
	damage = 20
	penetrating = 2

/obj/item/projectile/bullet/rifle/a762x51
	damage = 15
	penetrating = 3

/obj/item/projectile/bullet/rifle/c4mm
	damage = 5
	penetrating = FALSE

/obj/item/projectile/bullet/rifle/a127x108
	damage = 25
	penetrating = 3

/obj/item/projectile/bullet/rifle/a556x45
	damage = 30
	penetrating = 3
	hitscan = TRUE

/obj/item/projectile/bullet/chameleon
	damage = TRUE // stop trying to murderbone with a fake gun dumbass!!!
	embed = FALSE // nope

// missiles

/obj/item/projectile/bullet/rifle/missile/yuge
	name = "huge HE missle"
	explosion_ranges = list(1,2,3,4)

/obj/item/projectile/bullet/rifle/missile/tank
	name = "tank missle"
	explosion_ranges = list(1,3,4,5)

/obj/item/projectile/bullet/rifle/missile/he
	name = "HE missle"
	explosion_ranges = list(1,2,3,4)

/obj/item/projectile/grenade/he
	name = "he grenade"

	kill_count = 10

	on_hit(atom/hit_atom)
		explosion(hit_atom, FALSE, FALSE, 2, 6)
		qdel(src)

	on_impact(atom/hit_atom)
		on_hit(hit_atom)

/obj/item/projectile/grenade/smoke
	name = "smoke grenade"

	kill_count = 10

	var/datum/effect/effect/system/smoke_spread/bad/smoke

	New()
		..()
		smoke = PoolOrNew(/datum/effect/effect/system/smoke_spread/bad)
		smoke.attach(src)

	on_hit(atom/hit_atom)
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

	on_impact(atom/hit_atom)
		on_hit(hit_atom)


/////////////////////FLAREGUNS//////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

/obj/item/projectile/flare
	name = "flare projectile"
	icon_state = ""
	damage = FALSE
	penetrating = FALSE
	density = FALSE