/obj/item/projectile/energy
	name = "energy"
	icon_state = "spark"
	damage = FALSE
	damage_type = BURN
	check_armour = "energy"


//releases a burst of light on impact or after travelling a distance
/obj/item/projectile/energy/flash
	name = "chemical shell"
	icon_state = "bullet"
	damage = 5
	agony = 10
	kill_count = 15 //if the shell hasn't hit anything after travelling this far it just explodes.
	var/flash_range = FALSE
	var/brightness = 7
	var/light_duration = 5

/obj/item/projectile/energy/flash/on_impact(var/atom/A)
	var/turf/T = flash_range? loc : get_turf(A)
	if(!istype(T)) return

	//blind adjacent people
	for (var/mob/living/carbon/M in viewers(T, flash_range))
		if(M.eyecheck() < FLASH_PROTECTION_MODERATE)
			if (M.HUDtech.Find("flash"))
				flick("e_flash", M.HUDtech["flash"])

	//snap pop
	playsound(src, 'sound/effects/snap.ogg', 50, TRUE)
	visible_message("<span class='warning'>\The [src] explodes in a bright flash!</span>")

	new /obj/effect/decal/cleanable/ash(loc) //always use loc so that ash doesn't end up inside windows
	new /obj/effect/sparks(T)
	new /obj/effect/effect/smoke/illumination(T, brightness=max(flash_range*2, brightness), lifetime=light_duration)

//blinds people like the flash round, but can also be used for temporary illumination
/obj/item/projectile/energy/flash/flare
	damage = 10
	flash_range = TRUE
	brightness = 9 //similar to a flare
	light_duration = 200

/obj/item/projectile/energy/electrode
	name = "electrode"
	icon_state = "spark"
	nodamage = TRUE
	taser_effect = TRUE
	agony = 40
	damage_type = HALLOSS
	//Damage will be handled on the MOB side, to prevent window shattering.

/obj/item/projectile/energy/electrode/stunshot
	name = "stunshot"
	damage = 5
	taser_effect = TRUE
	agony = 80

/obj/item/projectile/energy/declone
	name = "declone"
	icon_state = "declone"
	nodamage = TRUE
	damage_type = CLONE
	irradiate = 40


/obj/item/projectile/energy/dart
	name = "dart"
	icon_state = "toxin"
	damage = 5
	damage_type = TOX
	weaken = 5


/obj/item/projectile/energy/bolt
	name = "bolt"
	icon_state = "cbbolt"
	damage = 10
	damage_type = TOX
	nodamage = FALSE
	agony = 40
	stutter = 10


/obj/item/projectile/energy/bolt/large
	name = "largebolt"
	damage = 20


/obj/item/projectile/energy/neurotoxin
	name = "neuro"
	icon_state = "neurotoxin"
	damage = 5
	damage_type = TOX
	weaken = 5

/obj/item/projectile/energy/plasma
	name = "plasma bolt"
	icon_state = "energy"
	damage = 20
	damage_type = TOX
	irradiate = 20
