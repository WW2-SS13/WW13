/obj/item/weapon/gun/launcher/rocket/panzerfaust
	name = "Panzerfaust"
	icon_state = "panzerfaust"
	item_state = "panzerfaust"

/obj/item/weapon/gun/launcher/rocket/panzerfaust/New()
	..()
	rockets += new/obj/item/ammo_casing/rocket/yuge()

/obj/item/weapon/gun/launcher/rocket/handle_post_fire()
	..()
	qdel(src)
