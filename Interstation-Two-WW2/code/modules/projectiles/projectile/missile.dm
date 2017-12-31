/obj/item/projectile/bullet/rifle/missile
	muzzle_type = /obj/effect/projectile/bullet/muzzle
	var/explosive = 1
	var/explosion_ranges = list(1,2,4,5)
	icon = 'icons/obj/grenade.dmi'
	icon_state = "missile"
	throwforce = 5
	damage = 0
	nodamage = 1
	embed = 0
	name = "missile"

/obj/item/projectile/bullet/rifle/missile/throw_impact(atom/hit_atom)
	missile_effect(hit_atom)

/obj/item/projectile/bullet/rifle/missile/proc/missile_effect(atom/hit_atom)
	if (explosive)
		var/e = explosion_ranges
		explosion(get_turf(hit_atom), e[1], e[2], e[3], e[4])
		if (src)
			spawn (1)
				qdel(src)