
/mob/verb/on_press_spacebar()

	set category = null

	if (!ishuman(src))
		return FALSE

	if (!istype(loc, /obj/tank))
		if (istype(src, /mob/living/carbon/human/pillarman))
			var/mob/living/carbon/human/pillarman/P = src
			if (P.next_shoot_burning_blood > world.time)
				P << "<span class = 'warning'>You can't shoot burning blood again yet.</span>"
				return
			P.shoot_burning_blood()
	else
		var/obj/tank/tank = loc
		tank.receive_command_from(src, "FIRE")
		return TRUE
	return FALSE