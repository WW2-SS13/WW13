
/obj/item/device/radio
	var/speech_sound = null
	var/freerange = 1

/obj/item/device/radio/nato
	name = "AN/PRC-148"
	icon_state = "AN148"
	freerange = 1
	frequency = 1200
	canhear_range = 1
	speech_sound = 'sound/effects/roger_beep2.ogg'

/obj/item/device/radio/headset/nato
	freerange = 1
	frequency = 1200
	icon_state = "mine_headset"
	subspace_transmission = 0


/obj/item/device/radio/russia
	name = "P-168-0.5"
	icon_state = "P168"
	freerange = 1
	frequency = 1599
	canhear_range = 1
	speech_sound = 'sound/effects/roger_beep.ogg'

/obj/item/device/radio/headset/ru
	freerange = 1
	frequency = 1599
	icon_state = "cent_headset"
	subspace_transmission = 0

/obj/item/device/radio/russia
	name = "P-168-0.5"
	icon_state = "P168"
	freerange = 1
	frequency = 1599
	canhear_range = 1
	speech_sound = 'sound/effects/roger_beep.ogg'

/obj/item/device/radio/intercom/a7b
	name = "A-7-B"
	icon_state = "a7b"
	item_state = "a7b"
	freerange = 0
	frequency = 1599
	anchored = 1
	canhear_range = 1
	speech_sound = 'sound/effects/roger_beep.ogg'

/obj/item/device/radio/intercom/a7b/process()
	if(((world.timeofday - last_tick) > 30) || ((world.timeofday - last_tick) < 0))
		last_tick = world.timeofday

		if(!src.loc)
			on = 0
		else
			var/area/A = src.loc.loc
			if(!A || !isarea(A))
				on = 0
			else
				on = A.powered(EQUIP) // set "on" to the power status

		if(!on)
			icon_state = "a7b"
		else
			icon_state = "a7b"

/obj/item/device/radio/rbs
	name = "RBS1"
	icon_state = "rbs1"
	slot_flags = SLOT_BACK
	freerange = 0
	frequency = 1599
	canhear_range = 1
	w_class = 5
	speech_sound = 'sound/effects/roger_beep.ogg'

/obj/item/device/radio/intercom/fu2
	name = "Torn.Fu.d2"
	icon_state = "fud2"
	item_state = "fud2"
	freerange = 0
	frequency = 1200
	anchored = 1
	canhear_range = 1
	speech_sound = 'sound/effects/roger_beep2.ogg'

/obj/item/device/radio/intercom/fu2/process()
	if(((world.timeofday - last_tick) > 30) || ((world.timeofday - last_tick) < 0))
		last_tick = world.timeofday

		if(!src.loc)
			on = 0
		else
			var/area/A = src.loc.loc
			if(!A || !isarea(A))
				on = 0
			else
				on = A.powered(EQUIP) // set "on" to the power status

		if(!on)
			icon_state = "fud2"
		else
			icon_state = "fud2"

/obj/item/device/radio/feldfu
	name = "Feldfu.f"
	icon_state = "feldfu"
	slot_flags = SLOT_BACK
	freerange = 0
	frequency = 1200
	canhear_range = 1
	w_class = 4
	speech_sound = 'sound/effects/roger_beep2.ogg'