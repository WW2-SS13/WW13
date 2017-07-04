/mob/proc/use_object(o)
	if (!o)
		using_object = null
	else
		using_object = o
		if (istype(o, /obj/item/weapon/gun/projectile/minigun))
			var/obj/item/weapon/gun/projectile/minigun/mg = o
			mg.usedby(src, mg)
			mg.started_using(src)

/mob/Move()
	. = ..()
	if (using_object && !locate(using_object) in range(1, src))
		if (istype(using_object, /obj/item/weapon/gun/projectile/minigun))
			var/obj/item/weapon/gun/projectile/minigun/mg = using_object
			mg.stopped_using(src)
		use_object(null)