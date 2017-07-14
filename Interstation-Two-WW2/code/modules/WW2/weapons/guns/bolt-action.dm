/obj/item/weapon/gun/projectile/boltaction
	recoil = 2

/obj/item/weapon/gun/projectile/boltaction/mosin
	name = "Mosin-Nagant rifle"
	desc = "A bolt-action rifle of true LIBERATORS."
	force = 12
	origin_tech = "combat=4;materials=2;syndicate=8"
	fire_sound = 'sound/weapons/mosin_shot.ogg'
	//+2 accuracy over the LWAP because only one shot
	accuracy = 2
	zoomable = TRUE
	zoom_amt = 3

/obj/item/weapon/gun/projectile/boltaction/mosin/update_icon()
	if(bolt_open)
		icon_state = "mosin_open" //open
	else
		icon_state = "mosin" //closed



/obj/item/weapon/gun/projectile/boltaction/mosin/scoped
	name = "Mosin-Nagant scoped rifle"
	icon_state = "mosin_scope"
	item_state = "mosin_scope" //placeholder
	scoped_accuracy = 4 //If this is really meant to be worse than the kar, yell at me -Alexshreds
	zoomable = TRUE
	zoom_amt = 8
	zoomdevicename = "scope"



/obj/item/weapon/gun/projectile/boltaction/mosin/scoped/update_icon()
	if(bolt_open)
		icon_state = "mosin_scope_open" //open
	else
		icon_state = "mosin_scope" //closed

/obj/item/weapon/gun/projectile/boltaction/kar98k
	name = "Kar98k rifle"
	desc = "A bolt-action rifle of true ARYAN."
	icon_state = "kar98k"
	item_state = "kar98k" //placeholder
	caliber = "a792x57"
	fire_sound = 'sound/weapons/kar_shot.ogg'
	ammo_type = /obj/item/ammo_casing/a792x57
	magazine_type = /obj/item/ammo_magazine/kar98k
	//+2 accuracy over the LWAP because only one shot
	accuracy = 2
	scoped_accuracy = 4
	zoomable = TRUE
	zoom_amt = 3
	bolt_safety = 1

/obj/item/weapon/gun/projectile/boltaction/kar98k/update_icon()

	if(bolt_open)
		icon_state = "kar98k_open" //open
	else
		icon_state = "kar98k" //closed



/obj/item/weapon/gun/projectile/boltaction/kar98k/scoped
	name = "Kar98k scoped rifle"
	icon_state = "kar98k_scope"
	item_state = "kar98k_scope" //placeholder
	scoped_accuracy = 5
	zoom_amt = 8
	zoomdevicename = "scope"

/obj/item/weapon/gun/projectile/boltaction/kar98k/scoped/update_icon()
	if(bolt_open)
		icon_state = "kar98k_scope_open" //open
	else
		icon_state = "kar98k_scope" //closed
