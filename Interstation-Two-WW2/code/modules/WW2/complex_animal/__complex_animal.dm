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
	icon = 'icons/mob/animal.dmi'
	icon_state = null
	var/resting_state = null
	var/dead_state = null

	// can we move outside of the area we started in, or an area we were moved to
	var/allow_moving_outside_home = 0

	// how likely are we to try and wander each lifetick
	var/wander_probability = 20

	// simple_animal overrides
	response_help   = "pets"
	response_disarm = "pushes"
	response_harm   = "punches"


// things we do every life tick: by default, wander every few seconds,
// rest every ~20 minutes. Deplete nutrition over ~30 minutes
/mob/living/simple_animal/complex_animal/proc/onEveryLifeTick()

	if (stat == DEAD)
		return 0

	if (prob(1) && prob(15) && !resting)
		nap()
	else if (resting && prob(1))
		stop_napping()

	// todo: dehydration

	var/nutrition_loss = initial(nutrition)/900
	if (resting)
		nutrition_loss /= 2

	nutrition -= nutrition_loss

	if (stat == UNCONSCIOUS)
		return -1

	if (prob(wander_probability) && !resting && can_wander_specialcheck())
		for (var/turf/T in range(1, src))
			if (get_area(T) == get_area(src) || allow_moving_outside_home)
				if (!T.density)
					for (var/atom/movable/AM in T.contents)
						if (AM.density)
							goto nextturf
					Move(T, get_dir(loc, T))
					goto endturfsearch
			nextturf
		endturfsearch

	return 1

	// todo: starvation

/mob/living/simple_animal/complex_animal/proc/can_wander_specialcheck()
	return 1

// things we do when someone touches us
/mob/living/simple_animal/complex_animal/proc/onTouchedBy(var/mob/living/human/H, var/intent = I_HELP)
	if (stat == DEAD || stat == UNCONSCIOUS)
		return 0
	return 1

// things we do when someone attacks us
/mob/living/simple_animal/complex_animal/proc/onAttackedBy(var/mob/living/human/H, var/obj/item/weapon/W)
	if (stat == DEAD || stat == UNCONSCIOUS)
		return 0
	return 1

/* things we do whenever a nearby human moves:
called after H added to knows_about_mobs() */
/mob/living/simple_animal/complex_animal/proc/onHumanMovement(var/mob/living/human/H)
	if (stat == DEAD || stat == UNCONSCIOUS)
		return 0
	return 1

// things we do whenever a mob with our base_type moves
/mob/living/simple_animal/complex_animal/proc/onEveryBaseTypeMovement(var/mob/living/simple_animal/complex_animal/C)
	if (stat == DEAD || stat == UNCONSCIOUS)
		return 0
	return 1

// things we do whenever a mob with type 'X' moves
/mob/living/simple_animal/complex_animal/proc/onEveryXMovement(var/mob/X)
	if (stat == DEAD || stat == UNCONSCIOUS)
		return 0
	return 1


/mob/living/simple_animal/complex_animal/bullet_act(var/obj/item/projectile/P, var/def_zone)
	apply_damage(P.damage)
	if (P.firer)
		enemies |= P.firer
		onHumanMovement(P.firer)