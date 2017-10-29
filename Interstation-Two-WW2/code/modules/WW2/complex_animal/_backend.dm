// backend member functions for complex_animals, which call frontend hooks
/mob/living/simple_animal/complex_animal/New()
	..()
	resting_state = "[icon_state]_rest"
	dead_state = "[icon_state]_dead"

/mob/living/simple_animal/complex_animal/Life()
	..()
	onEveryLifeTick()

/mob/living/simple_animal/complex_animal/death(gibbed, deathmessage = "dies!")
	..(gibbed,deathmessage)
	icon_state = dead_state

/mob/living/simple_animal/complex_animal/attack_hand(var/mob/living/carbon/human/H as mob)
	..(H)
	onTouchedBy(H)

/mob/living/simple_animal/complex_animal/attackby(var/obj/item/weapon/W as obj, var/mob/living/carbon/human/H as mob)
	..(W, H)
	onAttackedBy(W, H)

// movement detection
/mob/living/Move()
	..()
	for (var/mob/living/simple_animal/complex_animal/C in range(30, src))
		if (prob(90) && C in range(C.sightrange, src))
			C.knows_about_mobs += src
		else if (prob(45) && C in range(C.hearrange, src))
			C.knows_about_mobs += src
		else if (prob(22) && C in range(C.smellrange, src))
			C.knows_about_mobs += src
		if (ishuman(src))
			C.onHumanMovement(src)
		else if (vars.Find("base_type") && src:base_type == C.base_type)
			C.onEveryBaseTypeMovement(src)
		else
			C.onEveryXMovement(type)