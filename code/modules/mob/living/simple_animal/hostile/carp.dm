

/mob/living/simple_animal/hostile/trainingbot
	name = "training bot"
	desc = "."
	icon = "robots.dmi"
	icon_state = "robot_old"
	icon_living = "robot_old"
	icon_dead = "gib1"
	icon_gib = "gib1"
	speak_chance = FALSE
	turns_per_move = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/carpmeat
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speed = 4
	maxHealth = 25
	health = 25

	harm_intent_damage = 8
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	//Space carp aren't affected by atmos.
	min_oxy = FALSE
	max_oxy = FALSE
	min_tox = FALSE
	max_tox = FALSE
	min_co2 = FALSE
	max_co2 = FALSE
	min_n2 = FALSE
	max_n2 = FALSE
	minbodytemp = FALSE

	break_stuff_probability = 15

	faction = "trainingbot"

/mob/living/simple_animal/hostile/trainingbot/FindTarget()
	. = ..()
	if (.)
		custom_emote(1,"nashes at [.]")

/mob/living/simple_animal/hostile/trainingbot/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if (istype(L))
		if (prob(15))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")