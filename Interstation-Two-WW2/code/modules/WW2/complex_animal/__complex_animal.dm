/* complex_animals are based off of simple_animals. They have more complex
  AI, require food, and have stamina. */

/mob/living/simple_animal/complex_animal
	var/base_type = /mob/living/simple_animal/complex_animal
	var/stamina = 100
	var/nutrition = 500

	// from how far away can we detect others: must be below or = 30.
	// sight is more accurate than hearing, and hearing more than smelling.
	var/sightrange = 7
	var/hearrange = 10
	var/smellrange = 12
	var/list/knows_about_mobs = list()

	// who are we going to kill or not kill: by default we do NOT kill anyone
	var/friendly_to_base_type = 1
	var/list/unfriendly_types = list()

	// if a mob is in unfriendly_types() but friendly_factions(), faction wins
	// for example, guard dogs are unfriendly to humans, except those in their
	// faction
	var/list/friendly_factions = list()

	// any specific people we like or dislike: overrides everything else
	var/list/friends = list()
	var/list/enemies = list()

	// icons
	icon = null
	icon_state = null
	var/resting_state = null

// things we do every life tick: by default, wander every few seconds,
// rest every ~10 minutes. Deplete nutrition over ~30 minutes
/mob/living/simple_animal/complex_animal/proc/onEveryLifeTick()
	if (prob(50))
		wander()
	else if (prob(1) && prob(33) && !resting)
		nap()
	else
		stop_napping()

	var/nutrition_loss = initial(nutrition)/900
	if (resting)
		nutrition_loss /= 2

	nutrition -= nutrition_loss

	// todo: starvation


// things we do when someone touches us
/mob/living/simple_animal/complex_animal/proc/onTouchedBy(var/mob/living/human/H, var/intent = I_HELP)
	return

// things we do when someone attacks us
/mob/living/simple_animal/complex_animal/proc/onAttackedBy(var/mob/living/human/H, var/obj/item/weapon/W)
	return

/* things we do whenever a nearby human moves:
called after H added to knows_about_mobs() */
/mob/living/simple_animal/complex_animal/proc/onHumanMovement(var/mob/living/human/H)
	return

// things we do whenever a mob with our base_type moves
/mob/living/simple_animal/complex_animal/proc/onEveryBaseTypeMovement(var/mob/living/simple_animal/complex_animal/C)
	return

// things we do whenever a mob with type 'X' moves
/mob/living/simple_animal/complex_animal/proc/onEveryXMovement(var/mob/X)
	return