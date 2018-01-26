/datum/firemode
	var/name = "default"
	var/burst = TRUE
	var/burst_delay = null
	var/fire_delay = null
	var/move_delay = TRUE
	var/list/accuracy = list(0)
	var/list/dispersion = list(0)

//using a list makes defining fire modes for new guns much nicer,
//however we convert the lists to datums in part so that firemodes can be VVed if necessary.
/datum/firemode/New(list/properties = null)
	..()
	if(!properties) return

	for(var/propname in vars)
		if(!isnull(properties[propname]))
			vars[propname] = properties[propname]

//Parent gun type. Guns are weapons that can be aimed at mobs and act over a distance
/obj/item/weapon/gun
	name = "gun"
	desc = "Its a gun. It's pretty terrible, though."
	icon = 'icons/obj/gun.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_guns.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_guns.dmi',
		)
	icon_state = "detective"
	item_state = "gun"
	flags =  CONDUCT
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	w_class = 3
	throwforce = 5
	throw_speed = 4
	throw_range = 5
	force = 5
//	origin_tech = "combat=1"
	attack_verb = list("struck", "hit", "bashed")

	var/fire_delay = 6 	//delay after shooting before the gun can be used again
	var/burst_delay = 2	//delay between shots, if firing in bursts
	var/fire_sound = 'sound/weapons/kar_shot.ogg'
	var/fire_sound_text = "gunshot"
	var/recoil = FALSE		//screen shake
	var/silenced = FALSE
	var/muzzle_flash = 3
	var/accuracy = 0   //accuracy is measured in tiles. +1 accuracy means that everything is effectively one tile closer for the purpose of miss chance, -1 means the opposite. launchers are not supported, at the moment.
	var/scoped_accuracy = null

	var/next_fire_time = FALSE

	var/sel_mode = 1 //index of the currently selected mode
	var/list/firemodes = list()
	var/firemode_type = /datum/firemode //for subtypes that need custom firemode data

	//aiming system stuff
	var/keep_aim = TRUE 	//1 for keep shooting until aim is lowered
						//0 for one bullet after tarrget moves and aim is lowered
	var/multi_aim = FALSE //Used to determine if you can target multiple people.
	var/tmp/list/mob/living/aim_targets //List of who yer targeting.
	var/tmp/mob/living/last_moved_mob //Used to fire faster at more than one person.
	var/tmp/told_cant_shoot = FALSE //So that it doesn't spam them with the fact they cannot hit them.
	var/tmp/lock_time = -100

	var/wielded = FALSE
	var/must_wield = FALSE
	var/can_wield = FALSE
	var/can_scope = FALSE

	var/burst = TRUE
	var/move_delay = TRUE
	var/list/burst_accuracy = list(0)
	var/list/dispersion = list(0)

	var/obj/item/weapon/attachment/bayonet = null

	var/gun_type = GUN_TYPE_GENERIC

	var/autofiring = FALSE

	var/gibs = FALSE

/obj/item/weapon/gun/New()
	..()
	if(!firemodes.len)
		firemodes += new firemode_type
	else
		for(var/i in TRUE to firemodes.len)
			firemodes[i] = new firemode_type(firemodes[i])

	if(isnull(scoped_accuracy))
		scoped_accuracy = accuracy

	for (var/datum/firemode/F in firemodes)
		if (!F.accuracy.len)
			F.accuracy[1] = accuracy

//Checks whether a given mob can use the gun
//Any checks that shouldn't result in handle_click_empty() being called if they fail should go here.
//Otherwise, if you want handle_click_empty() to be called, check in consume_next_projectile() and return null there.
/obj/item/weapon/gun/proc/special_check(var/mob/user)

	if(!istype(user, /mob/living))
		return FALSE

	if(!user.IsAdvancedToolUser())
		return FALSE

	var/mob/living/M = user

	if(HULK in M.mutations)
		M << "<span class='danger'>Your fingers are much too large for the trigger guard!</span>"
		return FALSE
	if((CLUMSY in M.mutations) && prob(40)) //Clumsy handling
		var/obj/P = consume_next_projectile()
		if(P)
			if(process_projectile(P, user, user, pick("l_foot", "r_foot")))
				handle_post_fire(user, user)
				user.visible_message(
					"<span class='danger'>[user] shoots \himself in the foot with \the [src]!</span>",
					"<span class='danger'>You shoot yourself in the foot with \the [src]!</span>"
					)
				M.drop_item()
		else
			handle_click_empty(user)
		return FALSE
	return TRUE

/obj/item/weapon/gun/emp_act(severity)
	for(var/obj/O in contents)
		O.emp_act(severity)
/*
/obj/item/weapon/gun/afterattack(atom/A, mob/living/user, adjacent, params)
	if(adjacent) return //A is adjacent, is the user, or is on the user's person

	//decide whether to aim or shoot normally
	var/aiming = FALSE
	if(user && user.client && !(A in aim_targets))
		if(user.client.gun_mode)
			aiming = PreFire(A,user,params) //They're using the new gun system, locate what they're aiming at.

	if (!aiming)
		if(must_wield && !wielded)
			user << "\red You must wield the [name] before shooting."
		//if(user && user.a_intent == I_HELP) //regardless of what happens, refuse to shoot if help intent is on
		//	user << "\red You refrain from firing your [src] as your intent is set to help."
		else
			Fire(A,user,params) //Otherwise, fire normally.
*/

/obj/item/weapon/gun/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(default_parry_check(user, attacker, damage_source) && w_class >= 4) // Only big guns can stop attacks.
		if(bayonet && prob(40)) // If they have a bayonet they get a higher chance to stop the attack.
			user.visible_message("<span class='danger'>\The [user] blocks [attack_text] with \the [src]!</span>")
			playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, TRUE)
			return TRUE
		else
			if(prob(10))// Much smaller chance to block it due to no bayonet.
				user.visible_message("<span class='danger'>\The [user] blocks [attack_text] with \the [src]!</span>")
				playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, TRUE)
				return TRUE
	return FALSE

/obj/item/weapon/gun/afterattack(atom/A, mob/living/user, adjacent, params)
	if(adjacent) return //A is adjacent, is the user, or is on the user's person

	if(!user.aiming)
		user.aiming = new(user)

	if(user && user.client && user.aiming && user.aiming.active && user.aiming.aiming_at != A)
		PreFire(A,user,params) //They're using the new gun system, locate what they're aiming at.
		return

	//DUAL WIELDING: only works with pistols edition
	var/obj/item/weapon/gun/off_hand = null
	if(ishuman(user) && user.a_intent == "harm")
		var/mob/living/carbon/human/H = user
		if (istype(H.l_hand, /obj/item/weapon/gun/projectile/pistol))
			if (istype(H.r_hand, /obj/item/weapon/gun/projectile/pistol))
				if(H.r_hand == src)
					off_hand = H.l_hand

				else if(H.l_hand == src)
					off_hand = H.r_hand

				if(off_hand && off_hand.can_hit(user))
					spawn(1)
					off_hand.Fire(A,user,params)

	Fire(A,user,params) //Otherwise, fire normally.

/obj/item/weapon/gun/attack(atom/A, mob/living/user, def_zone)
	if (A == user && user.targeted_organ == "mouth" && !mouthshoot)
		handle_suicide(user)

	if(user.a_intent == I_HURT && !bayonet) //point blank shooting
		Fire(A, user, pointblank=1)
	else
		if(bayonet && isliving(A))
			var/mob/living/L = A
			var/mob/living/carbon/C = A
			if (!istype(C) || !C.check_attack_throat(src, user))
				if (prob(40) && L != user && !L.lying)
					visible_message("<span class = 'danger'>[user] tries to bayonet [L], but they miss!</span>")
				else
					var/obj/item/weapon/attachment/bayonet/a = bayonet
					user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN) // No more rapid stabbing for you.
					visible_message("<span class = 'danger'>[user] impales [L] with their gun's bayonet!</span>")
					if (ishuman(L))
						var/mob/living/carbon/human/H = L
						if (H.takes_less_bullet_damage) // mechahitler/megastalin
							H.apply_damage(a.force, BRUTE, def_zone)
							goto __playsound__
					L.apply_damage(a.force * 2, BRUTE, def_zone)
					L.Weaken(rand(1,2))
					if (L.stat == CONSCIOUS && prob(50))
						L.emote("scream")
					__playsound__
					playsound(get_turf(src), a.attack_sound, rand(90,100))
			else
				var/obj/item/weapon/attachment/bayonet/a = bayonet
				playsound(get_turf(src), a.attack_sound, rand(90,100))

		else
			..() //Pistolwhippin'

/obj/item/weapon/gun/proc/force_fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	if(!user || !target) return

	add_fingerprint(user)

	if(!special_check(user))
		return

	var/shoot_time = (burst - TRUE)* burst_delay
	user.setClickCooldown(shoot_time) //no clicking on things while shooting
//	user.setMoveCooldown(shoot_time) //no moving while shooting either
	next_fire_time = world.time + shoot_time


	var/held_acc_mod = FALSE
	var/held_disp_mod = FALSE
/*
	if(requires_two_hands)
		if((user.l_hand == src && user.r_hand) || (user.r_hand == src && user.l_hand))
			held_acc_mod = -3
			held_disp_mod = 3
*/
	//actually attempt to shoot
	var/turf/targloc = get_turf(target) //cache this in case target gets deleted during shooting, e.g. if it was a securitron that got destroyed.
	for(var/i in TRUE to burst)
		var/obj/projectile = consume_next_projectile(user)
		if(!projectile)
			handle_click_empty(user)
			break

		var/acc = burst_accuracy[min(i, burst_accuracy.len)] + held_acc_mod
		var/disp = dispersion[min(i, dispersion.len)] + held_disp_mod
		process_accuracy(projectile, user, target, acc, disp)

		if(pointblank)
			process_point_blank(projectile, user, target)

		if(process_projectile(projectile, user, target, user.targeted_organ, clickparams))
			handle_post_fire(user, target, pointblank, reflex)
			update_icon()

		if(i < burst)
			sleep(burst_delay)

		if(!(target && target.loc))
			target = targloc
			pointblank = FALSE

	//update timing
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
//	user.setMoveCooldown(move_delay)
	next_fire_time = world.time + fire_delay

	if(muzzle_flash)
		set_light(0)

// only update our in-hands icon if we aren't using a scope (invisible)
/obj/item/weapon/gun/update_held_icon()
	if (loc && ismob(loc))
		if (ishuman(loc))
			var/mob/living/carbon/human/H = loc
			if (H.using_zoom())
				return FALSE
	..()

/obj/item/weapon/gun/proc/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)

	if(!user || !target) return

	// stops admemes from sending immortal dummies into combat
	if (user)
		if (istype(user, /mob/living/carbon/human/dummy))
			if (user.client)
				if (clients.len > 1)
					user << "<span class = 'danger'>Hey you fucking meme, don't send immortal dummies into combat.</span>"
					return

	add_fingerprint(user)

	if(!special_check(user))
		return

	if(world.time < next_fire_time)
		if (world.time % 3) //to prevent spam
			user << "<span class='warning'>[src] is not ready to fire again!</span>"
		return

	//unpack firemode data
	var/datum/firemode/firemode = firemodes[sel_mode]
	var/_burst = firemode.burst
	var/_burst_delay = isnull(firemode.burst_delay)? burst_delay : firemode.burst_delay
	var/_fire_delay = isnull(firemode.fire_delay)? fire_delay : firemode.fire_delay
	var/_move_delay = firemode.move_delay + (can_wield && !wielded) ? 2 : FALSE

	var/shoot_time = (_burst - TRUE)*_burst_delay
	user.next_move = world.time + shoot_time  //no clicking on things while shooting
	if(user.client) user.client.move_delay = world.time + shoot_time //no moving while shooting either
	next_fire_time = world.time + shoot_time

	//actually attempt to shoot
	var/turf/targloc = get_turf(target) //cache this in case target gets deleted during shooting, e.g. if it was a securitron that got destroyed.

	for(var/i in TRUE to _burst)
		var/obj/projectile = consume_next_projectile(user)

		if(!projectile)
			handle_click_empty(user)
			break

		var/acc = firemode.accuracy[min(i, firemode.accuracy.len)]
		var/disp = firemode.dispersion[min(i, firemode.dispersion.len)]


		if (istype(projectile, /obj/item/projectile))
			var/obj/item/projectile/P = projectile

			if (gun_type == GUN_TYPE_RIFLE)
				P.KD_chance *= 12
				if (ishuman(user))
					var/mob/living/carbon/human/H = user
					P.KD_chance *= H.getStatCoeff("rifle")
					acc += max(H.getStatCoeff("rifle")-1, FALSE)

			else if (gun_type == GUN_TYPE_HEAVY)
				P.KD_chance *= 15
				if (ishuman(user))
					var/mob/living/carbon/human/H = user
					P.KD_chance *= H.getStatCoeff("heavyweapon")
					acc += max(H.getStatCoeff("heavyweapon")-1, FALSE)

			else if (gun_type == GUN_TYPE_MG)
				P.KD_chance *= 3
				if (ishuman(user))
					var/mob/living/carbon/human/H = user
					P.KD_chance *= H.getStatCoeff("mg")
					acc += max(H.getStatCoeff("mg")-1, FALSE)

			else if (gun_type == GUN_TYPE_PISTOL)
				P.KD_chance *= 2
				if (ishuman(user))
					var/mob/living/carbon/human/H = user
					P.KD_chance *= H.getStatCoeff("pistol")
					acc += max(H.getStatCoeff("pistol")-1, FALSE)

		process_accuracy(projectile, user, target, acc, disp)

		if(pointblank)
			if (istype(projectile, /obj/item/projectile))
				var/obj/item/projectile/P = projectile
				P.KD_chance = 100
			process_point_blank(projectile, user, target)

		if(process_projectile(projectile, user, target, user.targeted_organ, clickparams))
			handle_post_fire(user, target, pointblank, reflex)
			update_icon()

		if(i < _burst)
			sleep(_burst_delay)

		if(!(target && target.loc))
			target = targloc
			pointblank = FALSE

	update_held_icon()

	//update timing
	user.next_move = world.time + 4
	if(user.client) user.client.move_delay = world.time + _move_delay
	next_fire_time = world.time + _fire_delay

	if(muzzle_flash)
		spawn(5)
			set_light(0)


//obtains the next projectile to fire
/obj/item/weapon/gun/proc/consume_next_projectile()
	return null

//used by aiming code
/obj/item/weapon/gun/proc/can_hit(atom/target as mob, var/mob/living/user as mob)
	if(!special_check(user))
		return 2
	//just assume we can shoot through glass and stuff. No big deal, the player can just choose to not target someone
	//on the other side of a window if it makes a difference. Or if they run behind a window, too bad.
	return check_trajectory(target, user)

//called if there was no projectile to shoot
/obj/item/weapon/gun/proc/handle_click_empty(mob/user)
	if (user)
		user.visible_message("*click click*", "<span class='danger'>*click*</span>")
	else
		visible_message("*click click*")

	playsound(loc, 'sound/weapons/empty.ogg', 100, TRUE)

//called after successfully firing
/obj/item/weapon/gun/proc/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0)
	if(silenced)
		playsound(get_turf(user), fire_sound, 10, TRUE, 50)
	else
		playsound(get_turf(user), fire_sound, 100, TRUE, 50)

		/*
		if(reflex)
			user.visible_message(
				"<span class='reflex_shoot'><b>\The [user] fires \the [src][pointblank ? " point blank at \the [target]":""] by reflex!<b></span>",
				"<span class='reflex_shoot'>You fire \the [src] by reflex!</span>",
				"You hear a [fire_sound_text]!"
			)
		else
			user.visible_message(
				"<span class='danger'>\The [user] fires \the [src][pointblank ? " point blank at \the [target]":""]!</span>",
				"<span class='warning'>You fire \the [src]!</span>",
				"You hear a [fire_sound_text]!"
				)
		*/

		if(muzzle_flash)
			set_light(muzzle_flash)

	if(recoil)
		spawn()
			var/shake_strength = recoil
			if(can_wield && !wielded)
				shake_strength += 2
			shake_strength -= TRUE
			if (shake_strength > FALSE)
				shake_camera(user, shake_strength+1, shake_strength)
	update_icon()


/obj/item/weapon/gun/proc/process_point_blank(obj/projectile, mob/user, atom/target)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return //default behaviour only applies to true projectiles

	//default point blank multiplier
	var/damage_mult = 1.33

	//determine multiplier due to the target being grabbed
	if(ismob(target))
		var/mob/M = target
		if(M.grabbed_by.len)
			var/grabstate = FALSE
			for(var/obj/item/weapon/grab/G in M.grabbed_by)
				grabstate = max(grabstate, G.state)
			if(grabstate >= GRAB_NECK)
				damage_mult = 4
			else if(grabstate >= GRAB_AGGRESSIVE)
				damage_mult = 3
	P.damage *= damage_mult

/obj/item/weapon/gun/proc/process_accuracy(obj/projectile, mob/user, atom/target, acc_mod, dispersion)
	var/obj/item/projectile/P = projectile

	if(!istype(P))
		return //default behaviour only applies to true projectiles

	//Accuracy modifiers
	P.accuracy = accuracy + acc_mod
	P.dispersion = dispersion + (can_wield && !wielded) ? 2 : FALSE

	//accuracy bonus from aiming
	if (aim_targets && (target in aim_targets))
		//If you aim at someone beforehead, it'll hit more often.
		//Kinda balanced by fact you need like 2 seconds to aim
		//As opposed to no-delay pew pew
		P.accuracy += 2

/* // since weilding was removed
	if(can_wield && !wielded)
		P.accuracy -= 2 */

//does the actual launching of the projectile
/obj/item/weapon/gun/proc/process_projectile(obj/projectile, mob/user, atom/target, var/target_zone, var/params=null)

	var/obj/item/projectile/P = projectile

	if(!istype(P))
		return FALSE //default behaviour only applies to true projectiles

	if(params)
		P.set_clickpoint(params)

	//shooting while in shock
	var/x_offset = FALSE
	var/y_offset = FALSE
	if(istype(user, /mob/living/carbon))
		var/mob/living/carbon/mob = user
		if(mob.shock_stage > 120)
			y_offset = rand(-2,2)
			x_offset = rand(-2,2)
		else if(mob.shock_stage > 70)
			y_offset = rand(-1,1)
			x_offset = rand(-1,1)

	return !P.launch(target, user, src, target_zone, x_offset, y_offset)

//Suicide handling.
/obj/item/weapon/gun/var/mouthshoot = FALSE //To stop people from suiciding twice... >.>
/obj/item/weapon/gun/proc/handle_suicide(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/M = user

	mouthshoot = TRUE
	M.visible_message("\red [user] sticks their gun in their mouth, ready to pull the trigger...")
	if(!do_after(user, 15))
		M.visible_message("\blue [user] failed to commit suicide.")
		mouthshoot = FALSE
		return
	var/obj/item/projectile/in_chamber = consume_next_projectile()
	if (istype(in_chamber))
		user.visible_message("<span class = 'warning'>[user] pulls the trigger.</span>")
		if(silenced)
			playsound(user, fire_sound, 10, TRUE)
		else
			playsound(user, fire_sound, 50, TRUE)

		in_chamber.on_hit(M)
		if (in_chamber.damage_type != HALLOSS)
			user.apply_damage(in_chamber.damage*2.5, in_chamber.damage_type, "head", used_weapon = "Point blank shot in the mouth with \a [in_chamber]", sharp=1)
			user.death()
		else
			user << "<span class = 'notice'>Ow...</span>"
			user.apply_effect(110,AGONY,0)
		qdel(in_chamber)
		mouthshoot = FALSE
		return
	else
		handle_click_empty(user)
		mouthshoot = FALSE
		return

/obj/item/weapon/gun/examine(mob/user)
	..()
	if(firemodes.len > TRUE)
		var/datum/firemode/current_mode = firemodes[sel_mode]
		user.visible_message("The fire selector is set to [current_mode.name].")

/obj/item/weapon/gun/proc/switch_firemodes(mob/user=null)
	sel_mode++
	if(sel_mode > firemodes.len)
		sel_mode = TRUE
	var/datum/firemode/new_mode = firemodes[sel_mode]
	user << "<span class='notice'>\The [src] is now set to [new_mode.name].</span>"

/obj/item/weapon/gun/attack_self(mob/user)
	if(firemodes.len > TRUE)
		switch_firemodes(user)

/obj/item/weapon/gun/proc/wield(mob/user as mob)
	if(wielded)
		return

	wielded = TRUE
	update_icon()

	var/obj/item/weapon/offhand/O = new(src)
	if(user.get_inactive_hand() == src)
		user:swap_hand()
	user.drop_inactive_hand()
	user.put_in_inactive_hand(O)

/obj/item/weapon/gun/proc/unwield(mob/user as mob)
	if(!wielded)
		return

	wielded = FALSE
	update_icon()

	var/obj/item/weapon/offhand/O = user.get_inactive_hand()
	if(istype(O))
		user.drop_inactive_hand()
		qdel(O)
	else
		O = user.get_active_hand()
		if(istype(O))
			user.drop_active_hand()
			qdel(O)

/obj/item/weapon/gun/dropped(mob/user)
	..()
	if(wielded)
		unwield(user)

/obj/item/weapon/gun/mob_can_equip(M as mob, slot) //Dirty hack
	. = ..()
	if(.)
		unwield(M)
	return

/obj/item/weapon/offhand
	w_class = 5
	icon_state = "offhand"
	name = "offhand"
/*
/obj/item/weapon/offhand/proc/remove()
	if(!removed)
		removed = TRUE
		var/mob/user = usr
		if(user.get_active_hand() == src)
			user.drop_active_hand()
			var/obj/item/weapon/gun/G = user.get_inactive_hand()
			if(istype(G))
				G.unwield()
			qdel(src)
		else if(user.get_inactive_hand() == src)
			user.drop_inactive_hand()
			var/obj/item/weapon/gun/G = user.get_active_hand()
			if(istype(G))
				G.unwield()
			qdel(src)
		else
			user << "\red Something is WRONG!!"
*/

/obj/item/weapon/offhand/update_icon()
	return

/obj/item/weapon/offhand/dropped(mob/user as mob)
	qdel(src)

/obj/item/weapon/offhand/attackby(obj/I as obj, mob/user as mob)
	if(user.get_inactive_hand() == src)
		user:swap_hand()

/*
/mob/living/carbon/human/verb/wield_weapon()
	set name = "Wield"
	set category = "Weapons"

	var/obj/item/weapon/gun/G = get_active_hand()
	if(!G || !istype(G))
		G = get_inactive_hand()
		if(!G || !istype(G))
			src << "\red You can't wield anything in your hands."
			return

	if(G.wielded)
		src << "\red The [G.name] is already wielded."
		return

	if(!G.can_wield)
		usr << "\red You can't wield the [G.name]."
		return

	G.wield(src)

	usr << "\red You wielded the [G.name]."

/mob/living/carbon/human/verb/unwield_weapon()
	set name = "Unwield"
	set category = "Weapons"

	var/obj/item/weapon/gun/G = get_active_hand()
	if(!G || !istype(G))
		G = get_inactive_hand()
		if(!G || !istype(G))
			src << "\red You can't unwield anything in your hands."
			return

	if(!G.wielded)
		src << "\red The [G.name] is not wielded."
		return

	G.unwield(src)
	//if(G != get_active_hand())
	//	H:swap_hand()

	usr << "\red You unwielded the [name]."
*/
/mob/living/carbon/human/verb/eject_magazine()
	set name = "Eject magazine"
	set category = "Weapons"

	var/obj/item/weapon/gun/projectile/G = get_active_hand()
	if(!G || !istype(G))
		G = get_inactive_hand()
		if(!G || !istype(G))
			src << "\red You can't unload magazine from anything in your hands."
			return

	if(G.load_method == MAGAZINE && G.ammo_magazine == null)
		src << "\red The [G.name] is already unloaded."
		return

	//if(G.wielded)
	//	G.unwield()

	G.ammo_magazine.loc = get_turf(loc)
	visible_message(
		"[G.ammo_magazine] falls out and clatters on the floor!",
		"<span class='notice'>[G.ammo_magazine] falls out and clatters on the floor!</span>"
		)
	G.ammo_magazine.update_icon()
	G.ammo_magazine = null
	G.update_icon() //make sure to do this after unsetting ammo_magazine
/*
/mob/living/carbon/human/verb/toggle_firerate()
	set name = "Toggle firerate"
	set category = "Weapons"

	var/obj/item/weapon/gun/G = get_active_hand()
	if(!G || !istype(G))
		G = get_inactive_hand()
		if(!G || !istype(G))
			src << "\red You have no weapon in hands."
			return

	if(G.firemodes.len > TRUE)
		G.switch_firemodes(src)
*/
