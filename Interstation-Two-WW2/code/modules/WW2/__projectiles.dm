#define DAMAGE_LOW 33
#define DAMAGE_MEDIUM 46
#define DAMAGE_HIGH 69
#define DAMAGE_VERY_HIGH 92

/obj/item/projectile/bullet/rifle
	speed = 2.5
	armor_penetration = 50

/obj/item/projectile/bullet/rifle/a792x33
	damage = DAMAGE_LOW
	penetrating = TRUE

// MOSIN
/obj/item/projectile/bullet/rifle/a762x54
	damage = DAMAGE_HIGH
	penetrating = 2
	armor_penetration = 100

// KARS
/obj/item/projectile/bullet/rifle/a792x57
	damage = DAMAGE_MEDIUM
	penetrating = 2
	armor_penetration = 100

/obj/item/projectile/bullet/rifle/a762x25
	damage = DAMAGE_LOW
	penetrating = FALSE

/obj/item/projectile/bullet/rifle/a9_parabellum
	damage = DAMAGE_LOW
	penetrating = FALSE

/obj/item/projectile/bullet/rifle/a9_parabellum_luger
	damage = DAMAGE_MEDIUM
	penetrating = FALSE

/obj/item/projectile/bullet/rifle/a762
	damage = DAMAGE_MEDIUM
	penetrating = TRUE

/obj/item/projectile/bullet/rifle/a145
	damage = DAMAGE_VERY_HIGH
	stun = 3
	weaken = 3
	penetrating = 5
	armor_penetration = 150
	hitscan = TRUE //so the PTRD isn't useless as a sniper weapon

/obj/item/projectile/bullet/rifle/a556
	damage = DAMAGE_MEDIUM
	penetrating = TRUE

/obj/item/projectile/bullet/rifle/a9x39
	damage = DAMAGE_LOW
	penetrating = 3
	step_delay = 2

/obj/item/projectile/bullet/rifle/a762x39
	damage = DAMAGE_LOW
	penetrating = 2

/obj/item/projectile/bullet/rifle/a762x51
	damage = DAMAGE_LOW
	penetrating = 3

/obj/item/projectile/bullet/rifle/c4mm
	damage = DAMAGE_LOW
	penetrating = 0

/obj/item/projectile/bullet/rifle/a127x108
	damage = DAMAGE_LOW
	penetrating = 3

/obj/item/projectile/bullet/rifle/a556x45
	damage = DAMAGE_VERY_HIGH
	penetrating = 3
	hitscan = TRUE

#undef DAMAGE_LOW
#undef DAMAGE_MEDIUM
#undef DAMAGE_HIGH
#undef DAMAGE_VERY_HIGH

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

// Pillar men

/obj/burning_blood
	name = "burning giblets"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "gibshot"
	layer = MOB_LAYER + 0.1
	density = 1

/obj/burning_blood/New()
	..()
	playsound(get_turf(src), 'sound/effects/gore/severed.ogg', 100)

/obj/burning_blood/throw_impact(var/atom/movable/obstacle)
	if (isliving(obstacle))
		var/mob/living/L = obstacle
		L.adjustFireLoss(rand(30,40))
		L.Weaken(rand(2,3))
		visible_message("<span class = 'warning'>[L] is scalded by burning blood!</span>")
		if (ishuman(L))
			L.emote("scream")
		playsound(get_turf(L), 'sound/effects/gore/fallsmash.ogg', 100)
		. = TRUE
	. = FALSE
	qdel(src)
	return .