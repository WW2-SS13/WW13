//////////////////////////////
//Contents: Ladders, Stairs.//
//////////////////////////////

/hook/startup/proc/assign_ladder_ids()

	var/list/top_ladders = list()
	var/list/bottom_ladders = list()

	for (var/obj/structure/multiz/ladder/ww2/ladder in world) // todo: remove
		if (ladder.istop)
			++top_ladders[ladder.area_id]
			ladder.ladder_id = "ww2-l-[ladder.area_id]-[top_ladders[ladder.area_id]]"
		else
			++bottom_ladders[ladder.area_id]
			ladder.ladder_id = "ww2-l-[ladder.area_id]-[bottom_ladders[ladder.area_id]]"

	for (var/obj/structure/multiz/ladder/ww2/ladder in world)
		ladder.target = ladder.find_target()

/obj/structure/multiz
	name = "ladder"
	density = 0
	opacity = 0
	anchored = 1
	icon = 'icons/obj/stairs.dmi'
	var/istop = 1
	var/obj/structure/multiz/target

	New()
		. = ..()
		for(var/obj/structure/multiz/M in loc)
			if(M != src)
				spawn(1)
					world.log << "##MAP_ERROR: Multiple [initial(name)] at ([x],[y],[z])"
					qdel(src)
				return .

	CanPass(obj/mover, turf/source, height, airflow)
		return airflow || !density

	proc/find_target()
		return

	initialize()
		find_target()

	attack_tk(mob/user)
		return

	attack_ghost(mob/user)
		. = ..()
		user.Move(get_turf(target))

	attack_ai(mob/living/silicon/ai/user)
		var/turf/T = get_turf(target)
		T.move_camera_by_click()

	attackby(obj/item/C, mob/user)
		. = ..()
		attack_hand(user)
		return



////LADDER////

/obj/structure/multiz/ladder
	name = "ladder"
	desc = "A ladder.  You can climb it up and down."
	icon_state = "ladderdown"

/obj/structure/multiz/ladder/find_target()
	var/turf/targetTurf = istop ? GetBelow(src) : GetAbove(src)
	target = locate(/obj/structure/multiz/ladder) in targetTurf

/obj/structure/multiz/ladder/up
	icon_state = "ladderup"
	istop = 0

/obj/structure/multiz/ladder/Destroy()
	if(target && istop)
		qdel(target)
	return ..()

/obj/structure/multiz/ladder/attack_hand(var/mob/M)

	if(!target || !istype(target.loc, /turf))
		M << "<span class='notice'>\The [src] is incomplete and can't be climbed.</span>"
		return

	var/turf/T = target.loc
	for(var/atom/A in T)
		if(A.density)
			M << "<span class='notice'>\A [A] is blocking \the [src].</span>"
			return

	M.visible_message(
		"<span class='notice'>\A [M] climbs [istop ? "down" : "up"] \a [src]!</span>",
		"You climb [istop ? "down" : "up"] \the [src]!",
		"You hear the grunting and clanging of a metal ladder being used."
	)
	T.visible_message(
		"<span class='warning'>Someone climbs [istop ? "down" : "up"] \a [src]!</span>",
		"You hear the grunting and clanging of a metal ladder being used."
	)

	if(do_after(M, 10, src))
		if (target.loc && locate(/obj/train_pseudoturf) in target.loc)
			T = target.loc // this is to prevent the train teleporting error
		playsound(src.loc, 'sound/effects/ladder.ogg', 50, 1, -1)
		var/was_pulling = null
		if (M.pulling)
			was_pulling = M.pulling
			M.pulling.Move(get_step(T, M.dir))
		M.Move(T)
		if (was_pulling)
			M.pulling = was_pulling

////1 Z LEVEL LADDERS - Kachnov////

/obj/structure/multiz/ladder/ww2
	var/ladder_id = null
	var/area_id = "defaultareaid"

/obj/structure/multiz/ladder/ww2/find_target()
	for (var/obj/structure/multiz/ladder/ww2/ladder in world) // todo: get rid of
		if (ladder_id == ladder.ladder_id && ladder != src)
			return ladder

/obj/structure/multiz/ladder/ww2/ex_act(severity)
	return

/obj/structure/multiz/ladder/ww2/up
	icon_state = "ladderup"
	istop = 0

/obj/structure/multiz/ladder/ww2/Destroy()
	if(target && istop)
		qdel(target)
	return ..()



////STAIRS////
/*
//Spizjeno by guap and then by bo20202
/obj/structure/stairs
	name = "Stairs"
	desc = "Stairs leading to another deck.  Not too useful if the gravity goes out."
	icon = 'icons/obj/stairs.dmi'
	icon_state = "rampup"
	layer = 2.4
	density = 0
	opacity = 0
	anchored = 1
	var/istop = 1

	CanPass(obj/mover, turf/source, height, airflow)
		return airflow || !density

/obj/structure/stairs/enter
	icon_state = "ramptop"

/obj/structure/stairs/enter/bottom
	icon_state = "rampbottom"
	istop = 0

/obj/structure/stairs/active
	density = 1

/obj/structure/stairs/active/Bumped(var/atom/movable/M)
	if(istype(src, /obj/structure/stairs/active/bottom) && !locate(/obj/structure/stairs/enter) in M.loc)
		return //If on bottom, only let them go up stairs if they've moved to the entry tile first.
	//If it's the top, they can fall down just fine.
	if(ismob(M) && M:client)
		M:client.moving = 1
	M.Move(locate(src.x, src.y, targetZ()))
	if (ismob(M) && M:client)
		M:client.moving = 0

/obj/structure/stairs/active/attack_hand(mob/user)
	. = ..()
	if(Adjacent(user))
		Bumped(user)


/obj/structure/stairs/active/bottom
	icon_state = "rampdark"
	istop = 0
	opacity = 1

/obj/structure/attack_tk(mob/user as mob)
	return

/obj/structure/stairs/proc/targetZ()
	return src.z + (istop ? -1 : 1)
*/

/obj/structure/multiz/stairs
	name = "Stairs"
	desc = "Stairs leading to another deck.  Not too useful if the gravity goes out."
	icon_state = "rampup"
	layer = 2.4

/obj/structure/multiz/stairs/enter
	icon_state = "ramptop"

/obj/structure/multiz/stairs/enter/bottom
	icon_state = "rampbottom"
	istop = 0

/obj/structure/multiz/stairs/active
	density = 1

/obj/structure/multiz/stairs/active/find_target()
	var/turf/targetTurf = istop ? GetBelow(src) : GetAbove(src)
	target = locate(/obj/structure/multiz/stairs/enter) in targetTurf

/obj/structure/multiz/stairs/active/Bumped(var/atom/movable/M)
	if(isnull(M))
		return

	if(ismob(M) && usr.client)
		usr.client.moving = 1
		usr.Move(get_turf(target))
		usr.client.moving = 0
	else
		M.Move(get_turf(target))

/obj/structure/multiz/stairs/active/attack_robot(mob/user)
	. = ..()
	if(Adjacent(user))
		Bumped(user)

/obj/structure/stairs/active/attack_hand(mob/user)
	. = ..()
	if(Adjacent(user))
		Bumped(user)

/obj/structure/multiz/stairs/active/bottom
	icon_state = "rampdark"
	istop = 0

/obj/structure/multiz/stairs/active/bottom/Bumped(var/atom/movable/M)
	//If on bottom, only let them go up stairs if they've moved to the entry tile first.
	if(!locate(/obj/structure/multiz/stairs/enter) in M.loc)
		return
	return ..()
