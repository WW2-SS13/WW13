/obj/item/projectile/bullet/rifle/missile
	muzzle_type = /obj/effect/projectile/bullet/muzzle
	var/explosion_ranges = list(1,1,1,1)
	icon = 'icons/obj/grenade.dmi'
	icon_state = "missile"
	throwforce = 5

/obj/item/projectile/bullet/rifle/missile/Bumped(atom/into)
	on_hit(into)

/obj/item/projectile/bullet/rifle/missile/on_impact(atom/hit_atom)
	on_hit(hit_atom)

/obj/item/projectile/bullet/rifle/missile/on_hit(atom/hit_atom)
	var/e = explosion_ranges
	explosion(get_turf(hit_atom), e[1], e[2], e[3], e[4])
	spawn (5)
		qdel(src)