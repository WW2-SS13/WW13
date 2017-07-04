/* WW2 */

/obj/item/projectile/bullet/rifle
	speed = 2.5

/obj/item/projectile/bullet/rifle/a792x33
	damage = 30
	penetrating = 1

/obj/item/projectile/bullet/rifle/a762x54
	damage = 33
	penetrating = 2

/obj/item/projectile/bullet/rifle/a792x57
	damage = 35
	penetrating = 2

/obj/item/projectile/bullet/rifle/a762x25
	damage = 25
	penetrating = 0

/obj/item/projectile/bullet/rifle/a9_parabellum
	damage = 23
	penetrating = 0


/* "Rifle" rounds */

/obj/item/projectile/bullet/rifle/a762
	damage = 30
	penetrating = 1

/obj/item/projectile/bullet/rifle/a145
	damage = 80
	stun = 3
	weaken = 3
	penetrating = 5
	hitscan = 1 //so the PTR isn't useless as a sniper weapon

/obj/item/projectile/bullet/rifle/a556
	damage = 30
	penetrating = 1

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
	penetrating = 0

/obj/item/projectile/bullet/rifle/a127x108
	damage = 25
	penetrating = 3

/obj/item/projectile/bullet/rifle/a556x45
	damage = 30
	penetrating = 3
	hitscan = 1


/obj/item/projectile/bullet/chameleon
	damage = 1 // stop trying to murderbone with a fake gun dumbass!!!
	embed = 0 // nope

/obj/item/projectile/missile/yuge
	name = "he missle"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "missile"
	throwforce = 5
	muzzle_type = /obj/effect/projectile/bullet/muzzle

	kill_count = 10

	on_hit(atom/hit_atom)
		explosion(hit_atom, 1, 3, 4, 8)
		qdel(src)

	on_impact(atom/hit_atom)
		on_hit(hit_atom)

/obj/item/projectile/missile/he
	name = "he missle"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "missile"
	throwforce = 5
	muzzle_type = /obj/effect/projectile/bullet/muzzle

	kill_count = 10

	on_hit(atom/hit_atom)
		explosion(hit_atom, 1, 1, 4, 8)
		qdel(src)

	on_impact(atom/hit_atom)
		on_hit(hit_atom)

/obj/item/projectile/grenade/he
	name = "he grenade"

	kill_count = 10

	on_hit(atom/hit_atom)
		explosion(hit_atom, 0, 0, 2, 6)
		qdel(src)

	on_impact(atom/hit_atom)
		on_hit(hit_atom)



/obj/item/projectile/grenade/smoke
	name = "smoke grenade"

	kill_count = 10

	var/datum/effect/effect/system/smoke_spread/bad/smoke

	New()
		..()
		src.smoke = PoolOrNew(/datum/effect/effect/system/smoke_spread/bad)
		src.smoke.attach(src)

	on_hit(atom/hit_atom)
		name += " (Used)"
		playsound(src.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
		src.smoke.set_up(5, 0, usr.loc)
		spawn(0)
			src.smoke.start()
			sleep(10)
			src.smoke.start()
			sleep(10)
			src.smoke.start()
			sleep(10)
			src.smoke.start()

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
	damage = 0
	penetrating = 0
	density = 0