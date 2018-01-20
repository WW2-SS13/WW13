/mob/proc/use_object(o)
	if (!o)
		using_object = null
	else
		using_object = o
		if (istype(o, /obj/item/weapon/gun/projectile/minigun))
			var/obj/item/weapon/gun/projectile/minigun/mg = o
			mg.usedby(src, mg)
			mg.started_using(src)

/mob/proc/handle_object_operation(var/stop_using = FALSE)
	if (using_object)
		if (istype(using_object, /obj/item/weapon/gun/projectile/minigun))
			var/obj/item/weapon/gun/projectile/minigun/mg = using_object
			if (!(locate(src) in range(mg.maximum_use_range, mg)) || stop_using)
				use_object(null)
				mg.stopped_using(src)
		else if (!locate(using_object) in range(1, src) || stop_using)
			use_object(null)

/mob/Move()
	. = ..()
	handle_object_operation()

/mob/update_canmove()
	. = ..()
	if (lying || stat)
		handle_object_operation(stop_using = TRUE)
