/obj/item/device/mpwhistle
	name = "whistle"
	desc = "Used by officers to gather the troops."
	icon_state = "voice0"
	item_state = "flashbang"	//looks exactly like a flash (and nothing like a flashbang)
	w_class = 1.0
	flags = CONDUCT

	var/use_message = "Halt!"
	var/spamcheck = 0

obj/item/device/mpwhistle/attack_self(mob/living/carbon/user as mob)
	if (spamcheck)
		return

	for (var/mob/living/carbon/human/H in range(5, H))
		if (!H.takes_less_damage)
			H.SpinAnimation(7,1)
			H.Weaken(rand(4,5))

	spamcheck = 1
	spawn(20)
		spamcheck = 0