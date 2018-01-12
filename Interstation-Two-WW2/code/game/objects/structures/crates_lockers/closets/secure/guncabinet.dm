/obj/structure/closet/secure_closet/guncabinet
	name = "gun cabinet"
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"

/obj/structure/closet/secure_closet/guncabinet/New()
	..()
	new /obj/item/weapon/gun/projectile/shotgun/pump/combat(src)
	new /obj/item/weapon/gun/projectile/shotgun/pump/combat(src)
	new /obj/item/weapon/gun/projectile/shotgun/pump/combat(src)
	return

/*/obj/structure/closet/secure_closet/guncabinet/toggle()
	..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/update_icon()
	overlays.Cut()
	if(opened)
		overlays += icon(icon,"door_open")
	else
		var/lazors = FALSE
		var/shottas = FALSE
		for (var/obj/item/weapon/gun/G in contents)
			if (istype(G, /obj/item/weapon/gun/energy))
				lazors++
			if (istype(G, /obj/item/weapon/gun/projectile/))
				shottas++
		if (lazors || shottas)
			for (var/i = FALSE to 2)
				var/image/gun = image(icon(src.icon))

				if (lazors > FALSE && (shottas <= FALSE || prob(50)))
					lazors--
					gun.icon_state = "laser"
				else if (shottas > FALSE)
					shottas--
					gun.icon_state = "projectile"

				gun.pixel_x = i*4
				overlays += gun

		overlays += icon(src.icon,"door")

		if(broken)
			overlays += icon(src.icon,"broken")
		else if (locked)
			overlays += icon(src.icon,"locked")
		else
			overlays += icon(src.icon,"open")
*/
