/obj/item/weapon/flamethrower
	name = "flamethrower"
	desc = "You are a firestarter!"
	icon = 'icons/obj/flamethrower.dmi'
	icon_state = "flamethrowerbase"
	item_state = "flamethrower_0"
	flags = CONDUCT
	force = WEAPON_FORCE_PAINFUL
	throwforce = WEAPON_FORCE_NORMAL
	throw_speed = TRUE
	throw_range = 5
	w_class = 3.0
//	origin_tech = list(TECH_COMBAT = TRUE, TECH_PLASMA = TRUE)
	matter = list(DEFAULT_WALL_MATERIAL = 500)
	var/status = FALSE
	var/throw_amount = 1000
	var/lit = TRUE	//on or off
	var/operating = FALSE//cooldown
	var/turf/previousturf = null
	var/obj/item/weapon/weldingtool/weldtool = null
	var/obj/item/assembly/igniter/igniter = null
	var/obj/item/weapon/tank/plasma/ptank = null


/obj/item/weapon/flamethrower/Destroy()
	if (weldtool)
		qdel(weldtool)
	if (igniter)
		qdel(igniter)
	if (ptank)
		qdel(ptank)
	..()
	return


/obj/item/weapon/flamethrower/process()
	if (!lit)
		processing_objects.Remove(src)
		return null
	var/turf/location = loc
	if (istype(location, /mob/))
		var/mob/M = location
		if (M.l_hand == src || M.r_hand == src)
			location = M.loc
	if (isturf(location)) //start a fire if possible
		location.hotspot_expose(700, 2)
	return


/obj/item/weapon/flamethrower/update_icon()
	if (!istype(src, /obj/item/weapon/flamethrower/flammenwerfer))
		overlays.Cut()
		if (igniter)
			overlays += "+igniter[status]"
		if (ptank)
			overlays += "+ptank"
		if (lit)
			overlays += "+lit"
			item_state = "flamethrower_1"
		else
			item_state = "flamethrower_0"

/obj/item/weapon/flamethrower/afterattack(atom/target, mob/user, proximity)
	if (!proximity) return
	// Make sure our user is still holding us
	if (user && user.get_active_hand() == src)
		var/turf/target_turf = get_turf(target)
		if (target_turf)
			var/turflist = getline(user, target_turf, TRUE)
			flame_turfs(turflist)

/obj/item/weapon/flamethrower/attackby(obj/item/W as obj, mob/user as mob)
	if (user.stat || user.restrained() || user.lying)	return
	if (iswrench(W) && !status)//Taking this apart
		var/turf/T = get_turf(src)
		if (weldtool)
			weldtool.loc = T
			weldtool = null
		if (igniter)
			igniter.loc = T
			igniter = null
		if (ptank)
			ptank.loc = T
			ptank = null
		PoolOrNew(/obj/item/stack/rods, T)
		qdel(src)
		return

	if (isscrewdriver(W) && igniter && !lit)
		status = !status
		user << "<span class='notice'>[igniter] is now [status ? "secured" : "unsecured"]!</span>"
		update_icon()
		return

	if (isigniter(W))
		var/obj/item/assembly/igniter/I = W
		if (I.secured)	return
		if (igniter)		return
		user.drop_item()
		I.loc = src
		igniter = I
		update_icon()
		return

	if (istype(W,/obj/item/weapon/tank/plasma))
		if (ptank)
			user << "<span class='notice'>There appears to already be a plasma tank loaded in [src]!</span>"
			return
		user.drop_item()
		ptank = W
		W.loc = src
		update_icon()
		return
/*
	if (istype(W, /obj/item/analyzer))
		var/obj/item/analyzer/A = W
		A.analyze_gases(src, user)
		return*/
	..()
	return


/obj/item/weapon/flamethrower/attack_self(mob/user as mob)
	if (user.stat || user.restrained() || user.lying)	return
	return


//Called from turf.dm turf/dblclick
/obj/item/weapon/flamethrower/proc/flame_turfs(turflist)
	var/turf/my_turf = get_turf(loc)
	if (!lit || operating)	return
	operating = TRUE
	playsound(my_turf, 'sound/weapons/flamethrower.ogg', 100, TRUE)
	for (var/turf/T in turflist)
		if (T == my_turf)
			continue
		if (T.density || istype(T, /turf/space))
			break
		if (!previousturf && length(turflist)>1)
			previousturf = get_turf(src)
			continue	//so we don't burn the tile we be standin on
		if (previousturf && LinkBlocked(previousturf, T))
			break
		ignite_turf(T)
		sleep(1)
	previousturf = null
	operating = FALSE
	for (var/mob/M in viewers(1, loc))
		if ((M.client && M.using_object == src))
			attack_self(M)
	return


/obj/item/weapon/flamethrower/proc/ignite_turf(turf/target)
	//TODO: DEFERRED Consider checking to make sure tank pressure is high enough before doing this...
	//Transfer 5% of current tank air contents to turf
	var/datum/gas_mixture/air_transfer = ptank.air_contents.remove_ratio(0.02*(throw_amount/100))
	//air_transfer.toxins = air_transfer.toxins * 5 // This is me not comprehending the air system. I realize this is retarded and I could probably make it work without fucking it up like this, but there you have it. -- TLE
	new/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel(target,air_transfer.gas["plasma"],get_dir(loc,target))
	air_transfer.gas["plasma"] = FALSE
	target.assume_air(air_transfer)
	//Burn it based on transfered gas
	//target.hotspot_expose(part4.air_contents.temperature*2,300)
	target.hotspot_expose((ptank.air_contents.temperature*2) + 380,500) // -- More of my "how do I shot fire?" dickery. -- TLE
	//location.hotspot_expose(1000,500,1)

	return

/obj/item/weapon/flamethrower/full/New(var/loc)
	..()
	weldtool = new /obj/item/weapon/weldingtool(src)
	weldtool.status = FALSE
	igniter = new /obj/item/assembly/igniter(src)
	igniter.secured = FALSE
	status = TRUE
	update_icon()
	return
