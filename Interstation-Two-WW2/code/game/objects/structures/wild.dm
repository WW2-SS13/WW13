/obj/structure/wild
	icon = 'icons/obj/wild.dmi'
	anchored = 1

/obj/structure/wild/bullet_act(var/obj/item/projectile/proj)
	if (prob(proj.damage))
		visible_message("<span class = 'danger'>[src] collapses!</span>")
		qdel(src)

/obj/structure/wild/tree
	name = "tree"
	icon_state = "tree"
	opacity = 1
	density = 1

/obj/structure/wild/bush
	name = "bush"
	icon_state = "small_bush"
	opacity = 0
	density = 0

/obj/structure/wild/bush/big
	name = "large bush"
	icon_state = "big_bush"

/obj/structure/wild/bush/New()
	..()
	if (prob(50))
		icon_state = "grassybush_[rand(1,4)]"
	else if (prob(20))
		if (prob(50))
			icon_state = "leafybush_[rand(1,3)]"
		else
			icon_state = "palebush_[rand(1,4)]"
	else
		icon_state = "stalkybush_[rand(1,3)]"