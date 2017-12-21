/obj/item/projectile/bullet/rifle/missile
	muzzle_type = /obj/effect/projectile/bullet/muzzle
	var/explosive = 1
	var/explosion_ranges = list(1,2,4,5)
	icon = 'icons/obj/grenade.dmi'
	icon_state = "missile"
	throwforce = 5
	damage = 0
	nodamage = 1

/obj/item/projectile/bullet/rifle/missile/on_impact(atom/into)
	if (..(into))
		missile_effect(into)

/obj/item/projectile/bullet/rifle/missile/proc/missile_effect(atom/hit_atom)
	if (explosive)
		var/e = explosion_ranges
		explosion(get_turf(hit_atom), e[1], e[2], e[3], e[4])
		if (src)
			spawn (15)
				qdel(src)