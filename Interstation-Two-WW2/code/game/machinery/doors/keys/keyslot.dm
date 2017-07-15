/datum/keyslot
	var/code = -1
	var/locked = 1

/datum/keyslot/New()
	..()

/datum/keyslot/proc/check_user(var/mob/living/carbon/human/H, var/msg = 0)
	if (code == -1)
		return 1

	else if (istype(H))

		var/obj/item/weapon/storage/belt/belt = H.belt
		var/list/keys = list()

		if (belt && istype(belt) && belt.keychain && istype(belt.keychain))
			keys |= belt.keychain.keys
		if (istype(H.l_hand, /obj/item/weapon/storage/belt/keychain))
			keys |= H.l_hand:keys
		if (istype(H.r_hand, /obj/item/weapon/storage/belt/keychain))
			keys |= H.r_hand:keys
		if (istype(H.l_hand, /obj/item/weapon/key))
			keys |= H.l_hand
		if (istype(H.r_hand, /obj/item/weapon/key))
			keys |= H.r_hand

		if (istype(H.wear_id, /obj/item/weapon/storage/belt/keychain))
			var/obj/item/weapon/storage/belt/keychain/keychain = H.wear_id
			keys |= keychain.keys

		for (var/obj/item/weapon/key/key in keys)
			if (check_key(key))
				return 1

	if (msg)
		if (istype(H.get_active_hand(), /obj/item/weapon/key))
			H << "<span class = 'danger'>Your key doesn't match this lock.</span>"
		else
			H << "<span class = 'danger'>You don't have a key which matches this lock.</span>"

	return 0

/datum/keyslot/proc/check_key(var/obj/item/weapon/key/key)
	if (key.code == code)
		return 1
	return 0