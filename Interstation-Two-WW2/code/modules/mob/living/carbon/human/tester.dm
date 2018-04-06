/mob/living/carbon/human/proc/selfheal()
	set category = "Tester"
	set name = "Heal Self"
	src << "<span class = 'good'>Please wait...</span>"
	if (do_after(src, 50, get_turf(src)))
		src << "<span class = 'good'>You've been fully healed.</span>"
		revive()