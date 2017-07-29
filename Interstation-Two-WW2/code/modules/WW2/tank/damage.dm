/obj/tank/var/did_critical_damage = 0

/obj/tank/bullet_act(var/obj/item/projectile/P, var/def_zone)
	def_zone = check_zone(def_zone)
	damage += (P.damage/3 + (P.armor_penetration*20))/25
	if (P.armor_penetration < 50)
		damage /= 4

	damage += 1 // minimum damage

	update_damage_status()
	if (prob(critical_damage_chance()))
		critical_damage()
	tank_message("<span class = 'danger'>The tank is hit by [P]!</span>")

/obj/tank/ex_act(severity)
	if (damage < (max_damage/10))
		return 0

	// reproportion severity - most dangerous to biggest number
	switch (severity)
		if (3.0)
			severity = 1.0
		if (2.0)
			severity = 2.0
		if (1.0)
			severity = 3.0

	damage += (rand(15,20) * severity)

	if (prob(critical_damage_chance()))
		critical_damage()

	return 1


/obj/tank/proc/health_percentage() // text!
	return "[100 - ((damage/max_damage) * 100)]%"


/obj/tank/proc/health_percentage_num()
	return 100 - ((damage/max_damage) * 100)

/obj/tank/proc/health_coeff_num()
	return health_percentage_num()/100

/obj/tank/proc/critical_damage_chance()
	var/damage_coeff = damage/max_damage
	if (damage_coeff < 0.7)
		return 0
	else
		if (damage_coeff >= 0.7 && damage_coeff <= 0.9)
			return 5
		else
			return 25

/obj/tank/proc/critical_damage()

	if (did_critical_damage)
		return

	did_critical_damage = 1
	tank_message("<span class = 'danger'><big>[src] starts to shake and fall apart!</big></span>")
	spawn (rand(100,200))
		tank_message("<span class = 'danger'>You can smell burning from inside [src].</danger>")
		for (var/mob/living/m in src)
			m.on_fire = 1
			m.fire_stacks += rand(5,15)
			m << "<span class = 'danger'><big>You're on fire.</big></danger>"
			if (prob(30))
				spawn (25) // smell needs to travel or something
					tank_message("<span class = 'danger'>You can smell burning flesh from inside [src].</danger>")

	spawn (rand(250, 350))
		tank_message("<span class = 'danger'>[src] is falling apart[pick("!", "!!")]</span>")
		for (var/v in 1 to 10)
			spawn (v * 5)
				for (var/mob/living/m in src)
					m.apply_damage(rand(1,2), BRUTE)
	spawn (rand(420, 600))
		tank_message("<span class = 'danger'><big>[src] explodes.</big></span>")
		for (var/mob/m in src)
			m.gib()
		explosion(get_turf(src), 1, 3, 5, 6)
		spawn (20)
			qdel(src)