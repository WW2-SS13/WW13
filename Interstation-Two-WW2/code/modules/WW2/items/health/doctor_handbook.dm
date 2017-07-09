// 2017-07-08: Created with essentials -- Irra

/obj/item/weapon/doctor_handbook
	name = "doctor's handbook"
	desc = "A book the size of your hand, containing a compact encyclopedia of the dark wonders of war - diseases, conditions, and documentation of all degrees of injury."
	icon = 'icons/obj/library.dmi'
	icon_state = "book1"
	item_state = "bible" // I couldn't find any better placeholder for now
	slot_flags = SLOT_BELT | SLOT_POCKET
	force = WEAPON_FORCE_NORMAL
	throwforce = WEAPON_FORCE_NORMAL
	w_class = 2.0
	throw_speed = 5
	throw_range = 10
	attack_verb = list("slapped", "whacked")

	var/list/severity_adj = list("minor", "moderate", "serious", "severe", "critical") // do not touch this
	var/sev_factor

/obj/item/weapon/doctor_handbook/attack(mob/living/victim as mob, mob/living/user as mob)
	if (user.a_intent == I_HURT)
		return ..()

	var/datum/gender/G = gender_datums[victim.gender]
	user.visible_message("<span class='notice'>[user] riffles through [src], inspecting [victim]'s [victim.stat == DEAD ? "corpse" : "body"].</span>")

	if (ishuman(victim))
		var/mob/living/carbon/human/H = victim

		var/severity_blood_loss = 0
		var/severity_poisoning = 0
		var/severity_malnourishment = 0

		// GENERAL BLOOD LOSS
		if (H.vessel) // look for any reference to "vessel"
			var/blood_percent = round((H.vessel.get_reagent_amount("blood") / H.species.blood_volume)*100)
			switch (blood_percent)
				if (91 to 100)	severity_blood_loss = 0
				if (81 to 90) 	severity_blood_loss = 1
				if (71 to 80)		severity_blood_loss = 2
				if (61 to 70) 	severity_blood_loss = 3
				if (51 to 60) 	severity_blood_loss = 4
				else						severity_blood_loss = 5

		// GENERAL TOXIN DAMAGE
		severity_poisoning = pick_severity(H.getToxLoss())

		// HUNGER
		switch (H.nutrition)
			if (41 to 50) severity_malnourishment = 1
			if (31 to 40) severity_malnourishment = 2
			if (21 to 30) severity_malnourishment = 3
			if (11 to 20) severity_malnourishment = 4
			if (0 to 10)  severity_malnourishment = 5
			else severity_malnourishment = 0

		// Begin displaying
		user.show_message("<b>----------</b>")
		user.show_message("Consulting [src], I've concluded that [victim] [victim.stat == DEAD ? "is dead. [G.He] " : "" ]has signs of:")

		var/is_bad = 0	// I hate myself
		if (severity_blood_loss)
			is_bad = 1
			user.show_message("<span style='warning'>* [severity_adj[severity_blood_loss]] blood loss.</span>")
		if (severity_poisoning)
			is_bad = 1
			user.show_message("<span style='warning'>* [severity_adj[severity_poisoning]] general poisoning.</span>")
		if (severity_malnourishment)
			is_bad = 1
			user.show_message("<span style='warning'>* [severity_adj[severity_malnourishment]] malnourishment.</span>")
		if (!is_bad)
			user.show_message("<span style='notice'>* No general health issues.</span>")

		var/count = 0
		var/list/unsplinted_limbs = list()
		user.show_message("[victim] has:")
		for (var/name in H.organs_by_name)
			var/obj/item/organ/external/e = H.organs_by_name[name]

			var/wounds = 0
			var/infected = 0
			var/broken = 0
			var/internal = 0
			var/open = 0
			var/bleeding = 0

			if (!e)
				continue
			if (e.status & ORGAN_DESTROYED && !e.is_stump())
				user.show_message("<span style='warning'>* [e.name] is gored at [e.amputation_point] and needs to be amputated properly.</span>")
				count++
				continue
			if (e.status & ORGAN_BROKEN)
				broken = 1
				if (e.limb_name == "l_arm" || e.limb_name == "r_arm" || e.limb_name == "l_leg" || e.limb_name == "r_leg" && !(e.status & ORGAN_SPLINTED))
					unsplinted_limbs.Add(e.name)
			if (e.has_infected_wound())
				infected = 1
			for (var/datum/wound/W in e.wounds)
				if (W.damage > 2)					wounds++
				if (W.internal)						internal = 1
				if (W.bleeding())					bleeding = 1
				if (W.can_be_infected()) 	open = 1 // returns 1 when it can be infected, then cosnidered as an open wound

			if (wounds || infected || broken || internal || open || bleeding)
				var/string = "<span class='warning'>* "
				if (wounds || infected || broken || internal || open || bleeding)
					string += "[wounds > 1 ? "multiple" : (open ? "an" : "a") ]"
					string += "[open ? " open" : ""]"
					string += "[bleeding ? " bleeding" : ""]"
					string += "[infected && e.germ_level > 175 ? " infected" : ""]"
					string += " wound[wounds > 1 ? "s" : ""]"
					string += " [broken || e.burn_dam > 2 || e.brute_dam > 2 ? "and" : "at"]"
				if (e.brute_dam > 2)
					var/sev = pick_severity(e.brute_dam)
					string += " [sev ? severity_adj[sev] : "dismissable"] bruises"
					string += " [broken || e.burn_dam > 2 ? "and" : "at"]"
				if (e.burn_dam > 2)
					var/sev = pick_severity(e.burn_dam)
					string += " [sev ? severity_adj[sev] : "dismissable"] burns"
					string += " [broken || e.burn_dam > 2 ? "and" : "at"]"
				if (broken)
					string += " broken bones"
					string += " in"
				string += " [G.his] [e.name].</span>"
				user.show_message(string)
				count++
		if(!count)
			user.show_message("<span style='notice'>* No local injuries.</span>")
		if(unsplinted_limbs.len >= 1)
			var/string = "[G.His] "
			var/Count = 1
			for (var/limb_name in unsplinted_limbs)
				string += limb_name
				if (Count < unsplinted_limbs.len)
				 string += ", "
				 if (Count + 1 == unsplinted_limbs.len)
				 	string += "and "
				Count++
			string += " need[count == 1 ? "s" : ""] splinting for safe transport."
		user.show_message("<b>----------</b>")


// Internal code for doctor_handbook
/obj/item/weapon/doctor_handbook/proc/pick_severity(var/damage, var/max_damage = 200)
	return pick_severity_by_percent(round((damage / max_damage)*100))

/obj/item/weapon/doctor_handbook/proc/pick_severity_by_percent(var/percent)
	return (percent - (percent % get_factor()))/(get_factor())

/obj/item/weapon/doctor_handbook/proc/get_factor()
	if (!sev_factor)
		sev_factor = 100/(severity_adj.len + 1)
	return sev_factor
