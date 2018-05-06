/mob/living/maim()
	Weaken(5)
	adjustBruteLoss(50)

	var/appendages = 0
	var/list/arms = list()
	var/list/legs = list()

	for (var/obj/item/organ/external/arm/arm in contents)
		++appendages
		arms += arm
	for (var/obj/item/organ/external/leg/leg in contents)
		++appendages
		legs += leg

	for (var/obj/item/organ/external/E in arms)
		if (prob(round(50/arms.len)))
			E.droplimb()
			--appendages

	for (var/obj/item/organ/external/E in legs)
		if (prob(round(50/legs.len)))
			E.droplimb()
			--appendages

	if (!appendages)
		crush()