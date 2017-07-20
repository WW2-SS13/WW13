// the parent for this is in swords_axes_etc.dm

/obj/item/weapon/melee/classic_baton/ss_baton
	name = "SS police baton"
	desc = "A wooden police baton perfect for subduing Untermensch."

/obj/item/weapon/melee/classic_baton/ss_baton/attack(mob/M as mob, mob/living/user as mob)

	switch (user.a_intent) // harm intent lets us murder people, others not so much - Kachnov
		if (I_HURT)
			force*=2
		if (I_HELP, I_GRAB, I_DISARM)
			force/=2

	..()

	M.Weaken(pick(4,5)) // now SS can actually subdue people - Kachnov

	force = initial(force)