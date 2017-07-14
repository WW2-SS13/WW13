/*#####SHIT AND PISS#####
##Ok there's a lot of stupid shit here. Literally, but let me explain a bit why I put this here.
##I feel like poo and pee add a degree of autistic realism that you wouldn't otherwise get. And I'm autistic about that kind of thing.
##This file contains all the reagents, decals, objects and life procs. These procs are used in human/life.dm and human/emote.dm
##Have some shitty fun. - Matt
*/

//#####DECALS#####
/obj/effect/decal/cleanable/poo
	name = "poo stain"
	desc = "Well that sinks."
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/pooeffect.dmi'
	icon_state = "floor1"
	random_icon_states = list("floor1", "floor2", "floor3", "floor4", "floor5", "floor6", "floor7", "floor8")
	var/dried = 0


/obj/effect/decal/cleanable/poo/New()
	icon = 'icons/effects/pooeffect.dmi'
	icon_state = pick(src.random_icon_states)
	for(var/obj/effect/decal/cleanable/poo/shit in src.loc)
		if(shit != src)
			qdel(shit)
	spawn(6000)
		dried = 1
		name = "dried poo stain"
		desc = "It's a dried poo stain..."


/obj/effect/decal/cleanable/poo/tracks
	icon_state = "tracks"
	random_icon_states = null

/obj/effect/decal/cleanable/poo/drip
	name = "drips of poo"
	desc = "It's brown."
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/pooeffect.dmi'
	icon_state = "drip1"
	random_icon_states = list("drip1", "drip2", "drip3", "drip4", "drip5")

//This proc is really deprecated.
/*/obj/effect/decal/cleanable/poo/proc/streak(var/list/directions)
	spawn (0)
		var/direction = pick(directions)
		for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
			sleep(3)
			if (i > 0)
				new /obj/effect/decal/cleanable/poo(src.loc)
			if (step_to(src, get_step(src, direction), 0))
				break
*/

/obj/effect/decal/cleanable/poo/Crossed(AM as mob|obj, var/forceslip = 0)
	if (istype(AM, /mob/living/carbon) && src.dried == 0)
		var/mob/living/carbon/M = AM
		if (M.m_intent == "walk")
			return

		if(prob(5))
			M.slip("poo")

//These aren't needed for now.
///obj/effect/decal/cleanable/poo/tracks/Crossed(AM as mob|obj)
//	return

//obj/effect/decal/cleanable/poo/drip/Crossed(AM as mob|obj)
//	return

/obj/effect/decal/cleanable/urine
	name = "urine stain"
	desc = "Someone couldn't hold it.."
	density = 0
	anchored = 1
	layer = 2
	icon = 'icons/effects/pooeffect.dmi'
	icon_state = "pee1"
	random_icon_states = list("pee1", "pee2", "pee3")
	var/dried

/obj/effect/decal/cleanable/urine/Crossed(AM as mob|obj)
	if (istype(AM, /mob/living/carbon))
		var/mob/living/carbon/M =	AM
		if ((istype(M, /mob/living/carbon/human) && istype(M:shoes, /obj/item/clothing/shoes/galoshes)) || M.m_intent == "walk")
			return

		if((!dried) && prob(5))
			M.slip("urine")

/obj/effect/decal/cleanable/urine/New()
	icon_state = pick(random_icon_states)
	spawn(10) src.reagents.add_reagent("urine",5)
//	..()
	spawn(800)
		dried = 1
		name = "dried urine stain"
		desc = "That's a dried crusty urine stain. Fucking janitors."

//#####REAGENTS#####

//SHIT
/datum/reagent/poo
	name = "poo"
	id = "poo"
	description = "It's poo."
	reagent_state = LIQUID
	color = "#643200"


/datum/reagent/poo/on_mob_life(var/mob/living/M)
	if(!M)
		M = holder.my_atom

	M.adjustToxLoss(1)
	holder.remove_reagent(src.id, 0.2)
	..()
	return

//TO MAKE add_poo() PROC
/*			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
		src = null
		if(istype(M, /mob/living/carbon/human) && method==TOUCH)
			if(M:wear_suit) M:wear_suit.add_poo()
			if(M:w_uniform) M:w_uniform.add_poo()
			if(M:shoes) M:shoes.add_poo()
			if(M:gloves) M:gloves.add_poo()
			if(M:head) M:head.add_poo()
		//if(method==INGEST)
		//	if(prob(20))
			//	M.contract_disease(new /datum/disease/gastric_ejections)
			//	holder.add_reagent("gastricejections", 1)
			//	M:toxloss += 0.1
			//	holder.remove_reagent(src.id, 0.2)
*/

/datum/reagent/poo/touch_turf(var/turf/T)
	src = null
	if(!istype(T, /turf/space))
		new /obj/effect/decal/cleanable/poo(T)

/datum/reagent/urine
	name = "urine"
	id = "urine"
	description = "It's pee."
	reagent_state = LIQUID
	color = COLOR_YELLOW
	var/dried = 0

/datum/reagent/urine/touch_turf(var/turf/T)
	src = null
	if(!istype(T, /turf/space))
		new /obj/effect/decal/cleanable/urine(T)


/obj/item/weapon/reagent_containers/food/snacks/poo
	name = "poo"
	desc = "A chocolately surprise!"
	icon = 'icons/obj/poop.dmi'
	icon_state = "poop2"
	item_state = "poop"
	New()
		..()
		icon_state = pick("poop1", "poop2", "poop3", "poop4", "poop5", "poop6", "poop7")
		reagents.add_reagent("poo", 10)
		bitesize = 3

	throw_impact(atom/hit_atom)
		..()
		if(reagents.total_volume)
			src.reagents.handle_reactions()
		playsound(src.loc, "sound/effects/squishy.ogg", 40, 1)
		var/turf/T = src.loc
		if(!istype(T, /turf/space))
			new /obj/effect/decal/cleanable/poo(T)
		qdel(src)

//#####BOTTLES#####

//PISS
/obj/item/weapon/reagent_containers/glass/bottle/urine
	name = "urine bottle"
	desc = "A small bottle. Contains urine."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle15"

	New()
		..()
		reagents.add_reagent("urine", 30)


//#####LIFE PROCS#####

//poo and pee counters. This is called in human/handle_stomach.
/mob/living/carbon/human/proc/handle_excrement()
	if(bowels <= 0)
		bowels = 0
	if(bladder <= 0)
		bladder = 0

	if(bowels >= 250)
		switch(bowels)
			if(250 to 400)
				if(prob(5))
					src << "<b>You need to use the bathroom.</b>"
			if(400 to 450)
				if(prob(5))
					src << "<span class='danger'>You really need to use the restroom!</span>"
			if(450 to 500)
				if(prob(2))
					handle_shit()
				else if(prob(10))
					src << "<span class='danger'>You're about to shit yourself!</span>"
			if(500 to INFINITY)
				if(prob(15))
					handle_shit()
				else if(prob(30))
					src << "<span class='danger'>OH MY GOD YOU HAVE TO SHIT!</span>"

	if(bladder >= 100)//Your bladder is smaller than your colon
		switch(bladder)
			if(100 to 250)
				if(prob(5))
					src << "<b>You need to use the bathroom.</b>"
			if(250 to 400)
				if(prob(5))
					src << "<span class='danger'>You really need to use the restroom!</span>"
			if(400 to 500)
				if(prob(2))
					handle_piss()
				else if(prob(10))
					src << "<span class='danger'>You're about to piss yourself!</span>"
			if(500 to INFINITY)
				if(prob(15))
					handle_piss()
				else if(prob(30))
					src << "<span class='danger'>OH MY GOD YOU HAVE TO PEE!</span>"


//Shitting
/mob/living/carbon/human/proc/handle_shit()
	var/message = null
	if (src.bowels >= 30)

		//Poo in the loo.
		var/obj/structure/toilet/T = locate() in src.loc
		var/mob/living/M = locate() in src.loc
		if(T && T.open)
			message = "<B>[src]</B> defecates into the [T]."


		//Poo on the face.
		else if(M != src && M.lying)//Can only shit on them if they're lying down.
			message = "<span class='danger'><b>[src]</b> shits right on <b>[M]</b>'s face!</span>"
			M.reagents.add_reagent("poo", 10)

		//Poo on the floor.
		else
			message = "<B>[src]</B> [pick("shits", "craps", "poops")]."
			var/turf/location = src.loc
			//var/obj/effect/decal/cleanable/poo/D = new/obj/effect/decal/cleanable/poo(location)
			//if(src.reagents)//No need to spawn the snack poo and the decal.
			//	src.reagents.trans_to(D, rand(1,5))


			var/obj/item/weapon/reagent_containers/food/snacks/poo/V = new/obj/item/weapon/reagent_containers/food/snacks/poo(location)
			if(src.reagents)
				src.reagents.trans_to(V, rand(1,5))

		playsound(src.loc, 'sound/effects/poo2.ogg', 60, 1)
		src.bowels -= rand(60,80)

	else
		if (stat != UNCONSCIOUS && stat != DEAD)
			src << "You don't have to."
			return

	visible_message("[message]")

//Peeing
/mob/living/carbon/human/proc/handle_piss()
	var/message = null
	if (src.bladder < 30)
		src << "You don't have to."
		return

	var/obj/structure/urinal/U = locate() in src.loc
	var/obj/structure/toilet/T = locate() in src.loc
	var/obj/structure/sink/S = locate() in src.loc
	if((U || S) && gender != FEMALE)//In the urinal or sink.
		message = "<B>[src]</B> urinates into the [U ? U : S]."
		src.reagents.remove_any(rand(1,8))
		src.bladder -= 50
	else if(T)//In the toilet.
		message = "<B>[src]</B> urinates into the [T]."
		src.reagents.remove_any(rand(1,8))
		src.bladder -= 50
	else
		var/turf/TT = src.loc
		var/obj/effect/decal/cleanable/urine/D = new/obj/effect/decal/cleanable/urine(src.loc)
		if(src.reagents)
			src.reagents.trans_to(D, rand(1,8))
		message = "<B>[src]</B> pisses on the [TT.name]."
		src.bladder -= 50
	visible_message("[message]")