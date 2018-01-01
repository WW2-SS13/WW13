/mob/living/var/traumatic_shock = 0
/mob/living/carbon/var/shock_stage = 0

// proc to find out in how much pain the mob is at the moment
/mob/living/carbon/proc/updateshock()
	if (species && (species.flags & NO_PAIN))
		traumatic_shock = 0
		return 0

	src.traumatic_shock = 			\
	1	* src.getOxyLoss() + 		\
	0.7	* src.getToxLoss() + 		\
	1.5	* src.getFireLoss() + 		\
	1.2	* src.getBruteLoss() + 		\
	1.7	* src.getCloneLoss() + 		\
	2	* src.halloss + 			\
	-1	* src.analgesic

	if(slurring)
		traumatic_shock -= 20

	// broken or ripped off organs will add quite a bit of pain
	if(istype(src,/mob/living/carbon/human))
		var/mob/living/carbon/human/M = src
		for(var/obj/item/organ/external/organ in M.organs)
			if(organ && (organ.is_broken() || organ.open))
				traumatic_shock += 30

	if (bloodstr)
		for (var/datum/reagent/ethanol/E in bloodstr.reagent_list)
			traumatic_shock -= E.volume

	if(traumatic_shock < 0)
		traumatic_shock = 0

	return traumatic_shock


/mob/living/carbon/proc/handle_shock()
	updateshock()
