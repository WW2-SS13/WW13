// the parent for this is in swords_axes_etc.dm

/obj/item/weapon/melee/classic_baton/mp_baton
	name = "police baton"
	desc = ""
	var/weakens = 2

/obj/item/weapon/melee/classic_baton/mp_baton/attack(mob/M as mob, mob/living/user as mob)

	switch (user.a_intent) // harm intent lets us murder people, others not so much - Kachnov
		if (I_HURT)
			force*=2
		if (I_HELP, I_GRAB, I_DISARM)
			force/=2

	var/user_last_intent = user.a_intent
	user.a_intent = I_HURT // so we actually hit people right

	..(M, user)

	M.Weaken(weakens) // decent

	user.a_intent = user_last_intent

	force = initial(force)


/obj/item/weapon/melee/classic_baton/mp_baton/ss_baton
	name = "SS police baton"
	desc = "A wooden police baton perfect for subduing Untermensch."
	weakens = 5

/obj/item/weapon/melee/classic_baton/mp_baton/russian_baton
	name = "Soviet police baton"
	desc = "A wooden police baton perfect for subduing fascists."
	weakens = 3

/obj/item/weapon/melee/classic_baton/mp_baton/russian_baton/old
	name = "Old Soviet police baton"
	weakens = 2

/obj/item/weapon/melee/classic_baton/mp_baton/german_baton
	name = "Wehrmacht police baton"
	desc = "A wooden police baton perfect for subduing commies."
	weakens = 4



