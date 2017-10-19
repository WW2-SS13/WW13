/proc/istankvalidtool(var/obj/item/weapon/W)
	if (istype(W, /obj/item/weapon/wrench))
		return 1
	if (istype(W, /obj/item/weapon/weldingtool))
		return 1
	if (istype(W, /obj/item/weapon/screwdriver))
		return 1
	if (istype(W, /obj/item/weapon/crowbar))
		return 1
	return 0
