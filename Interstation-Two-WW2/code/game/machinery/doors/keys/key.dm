/obj/item/weapon/key
	var/code = -1
	icon = 'icons/obj/key.dmi'
	icon_state = "key_EAST"
	name = "random fucking key that should NOT exist"
	w_class = 1

/obj/item/weapon/key/New()
	if (istype(src, /obj/item/weapon/key/german))
		name = "German [name]"
	else if (istype(src, /obj/item/weapon/key/russian))
		name = "Russian [name]"
	..()