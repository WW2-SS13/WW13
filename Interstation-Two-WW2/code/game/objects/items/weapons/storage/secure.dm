/*
 *	Absorbs /obj/item/weapon/secstorage.
 *	Reimplements it only slightly to use existing storage functionality.
 *
 *	Contains:
 *		Secure Briefcase
 *		Wall Safe
 */

// -----------------------------
//         Generic Item
// -----------------------------
/obj/item/weapon/storage/secure
	name = "secstorage"
	var/icon_locking = "secureb"
	var/icon_sparking = "securespark"
	var/icon_opened = "secure0"
	var/locked = TRUE
	var/code = ""
	var/l_code = null
	var/l_set = FALSE
	var/l_setshort = FALSE
	var/l_hacking = FALSE
	var/emagged = FALSE
	var/open = FALSE
	w_class = 3
	max_w_class = 2
	max_storage_space = 14

	examine(mob/user)
		if(..(user, TRUE))
			user << text("The service panel is [src.open ? "open" : "closed"].")

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(locked)

			if (istype(W, /obj/item/weapon/screwdriver))
				if (do_after(user, 20, src))
					src.open =! src.open
					user.show_message(text("<span class='notice'>You [] the service panel.</span>", (src.open ? "open" : "close")))
				return
			if (/*(istype(W, /obj/item/device/multitool)) && */(src.open == TRUE)&& (!src.l_hacking))
				user.show_message("<span class='notice'>Now attempting to reset internal memory, please hold.</span>", TRUE)
				src.l_hacking = TRUE
				if (do_after(usr, 100, src))
					if (prob(40))
						src.l_setshort = TRUE
						src.l_set = FALSE
						user.show_message("<span class='notice'>Internal memory reset. Please give it a few seconds to reinitialize.</span>", TRUE)
						sleep(80)
						src.l_setshort = FALSE
						src.l_hacking = FALSE
					else
						user.show_message("<span class='warning'>Unable to reset internal memory.</span>", TRUE)
						src.l_hacking = FALSE
				else	src.l_hacking = FALSE
				return
			//At this point you have exhausted all the special things to do when locked
			// ... but it's still locked.
			return

		// -> storage/attackby() what with handle insertion, etc
		..()


	MouseDrop(over_object, src_location, over_location)
		if (locked)
			src.add_fingerprint(usr)
			return
		..()


	attack_self(mob/user as mob)
		user.set_machine(src)
		var/dat = text("<TT><B>[]</B><BR>\n\nLock Status: []",src, (src.locked ? "LOCKED" : "UNLOCKED"))
		var/message = "Code"
		if ((src.l_set == FALSE) && (!src.emagged) && (!src.l_setshort))
			dat += text("<p>\n<b>5-DIGIT PASSCODE NOT SET.<br>ENTER NEW PASSCODE.</b>")
		if (src.emagged)
			dat += text("<p>\n<font color=red><b>LOCKING SYSTEM ERROR - 1701</b></font>")
		if (src.l_setshort)
			dat += text("<p>\n<font color=red><b>ALERT: MEMORY SYSTEM ERROR - 6040 201</b></font>")
		message = text("[]", src.code)
		if (!src.locked)
			message = "*****"
		dat += text("<HR>\n>[]<BR>\n<A href='?src=\ref[];type=1'>1</A>-<A href='?src=\ref[];type=2'>2</A>-<A href='?src=\ref[];type=3'>3</A><BR>\n<A href='?src=\ref[];type=4'>4</A>-<A href='?src=\ref[];type=5'>5</A>-<A href='?src=\ref[];type=6'>6</A><BR>\n<A href='?src=\ref[];type=7'>7</A>-<A href='?src=\ref[];type=8'>8</A>-<A href='?src=\ref[];type=9'>9</A><BR>\n<A href='?src=\ref[];type=R'>R</A>-<A href='?src=\ref[];type=0'>0</A>-<A href='?src=\ref[];type=E'>E</A><BR>\n</TT>", message, src, src, src, src, src, src, src, src, src, src, src, src)
		user << browse(dat, "window=caselock;size=300x280")

	Topic(href, href_list)
		..()
		if ((usr.stat || usr.restrained()) || (get_dist(src, usr) > TRUE))
			return
		if (href_list["type"])
			if (href_list["type"] == "E")
				if ((src.l_set == FALSE) && (length(src.code) == 5) && (!src.l_setshort) && (src.code != "ERROR"))
					src.l_code = src.code
					src.l_set = TRUE
				else if ((src.code == src.l_code) && (src.emagged == FALSE) && (src.l_set == TRUE))
					src.locked = FALSE
					src.overlays = null
					overlays += image('icons/obj/storage.dmi', icon_opened)
					src.code = null
				else
					src.code = "ERROR"
			else
				if ((href_list["type"] == "R") && (src.emagged == FALSE) && (!src.l_setshort))
					src.locked = TRUE
					src.overlays = null
					src.code = null
					src.close(usr)
				else
					src.code += text("[]", href_list["type"])
					if (length(src.code) > 5)
						src.code = "ERROR"
			src.add_fingerprint(usr)
			for(var/mob/M in viewers(1, src.loc))
				if ((M.client && M.machine == src))
					src.attack_self(M)
				return
		return


// -----------------------------
//        Secure Briefcase
// -----------------------------
/obj/item/weapon/storage/secure/briefcase
	name = "secure briefcase"
	icon = 'icons/obj/storage.dmi'
	icon_state = "secure"
	item_state = "sec-case"
	desc = "A large briefcase with a digital locking system."
	force = WEAPON_FORCE_NORMAL
	throw_speed = TRUE
	throw_range = 4
	w_class = 4.0

	attack_hand(mob/user as mob)
		if ((src.loc == user) && (src.locked == TRUE))
			usr << "<span class='warning'>[src] is locked and cannot be opened!</span>"
		else if ((src.loc == user) && (!src.locked))
			src.open(usr)
		else
			..()
			for(var/mob/M in range(1))
				if (M.s_active == src)
					src.close(M)
		src.add_fingerprint(user)
		return

// -----------------------------
//        Secure Safe
// -----------------------------

/obj/item/weapon/storage/secure/safe
	name = "secure safe"
	icon = 'icons/obj/storage.dmi'
	icon_state = "safe"
	icon_opened = "safe0"
	icon_locking = "safeb"
	icon_sparking = "safespark"
	force = WEAPON_FORCE_NORMAL
	w_class = 8.0
	max_w_class = 8
	anchored = 1.0
	density = FALSE
	cant_hold = list(/obj/item/weapon/storage/secure/briefcase)

	New()
		..()
		new /obj/item/weapon/paper(src)
		new /obj/item/weapon/pen(src)

	attack_hand(mob/user as mob)
		return attack_self(user)

/obj/item/weapon/storage/secure/safe/HoS/New()
	..()
	//new /obj/item/weapon/storage/lockbox/clusterbang(src) This item is currently broken... and probably shouldnt exist to begin with (even though it's cool)
