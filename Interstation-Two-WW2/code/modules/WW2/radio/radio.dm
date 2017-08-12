var/global/list/default_german_channels = list(
	num2text(DE_COMM_FREQ) = list()
)

var/global/list/default_russian_channels = list(
	num2text(RU_COMM_FREQ) = list()
)


/obj/item/device/radio
	icon = 'icons/obj/radio.dmi'
	name = "station bounced radio"
	suffix = "\[3\]"
	icon_state = "walkietalkie"
	item_state = "walkietalkie"

	var/on = 1 // 0 for off
	var/last_transmission
	var/frequency = PUB_FREQ //common chat
	var/traitor_frequency = 0 //tune to frequency to unlock traitor supplies
	var/canhear_range = 3 // the range which mobs can hear this radio from
	var/datum/wires/radio/wires = null
	var/b_stat = 0
	var/broadcasting = 0
	var/listening = 1
	var/list/channels = list() //see communications.dm for full list. First channel is a "default" for :h
	var/subspace_transmission = 0
	var/syndie = 0//Holder to see if it's a syndicate encrypted radio
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throw_speed = 2
	throw_range = 9
	w_class = 2

	matter = list("glass" = 25,DEFAULT_WALL_MATERIAL = 75)
	var/const/FREQ_LISTENING = 1
	var/list/internal_channels

	var/last_tick = -1

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

/obj/item/device/radio/intercom/a7b
	name = "A-7-B"
	icon_state = "a7b"
	item_state = "a7b"
	freerange = 0
	frequency = RU_BASE_FREQ
	anchored = 1
	canhear_range = 1
	speech_sound = 'sound/effects/roger_beep.ogg'

/obj/item/device/radio/intercom/a7b/New()
	..()
	internal_channels = default_russian_channels.Copy()
	internal_channels += num2text(RU_BASE_FREQ)
	internal_channels[num2text(RU_BASE_FREQ)] = list()


/obj/item/device/radio/intercom/a7b/process()
	if(world.time - last_tick > 30 || last_tick == -1)
		last_tick = world.time

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
	item_state = "rbs1"
	freerange = 0
	frequency = RU_COMM_FREQ
	canhear_range = 1
	w_class = 5
	speech_sound = 'sound/effects/roger_beep.ogg'

/obj/item/device/radio/rbs/New()
	..()
	internal_channels = default_russian_channels.Copy()


/obj/item/device/radio/intercom/fu2
	name = "Torn.Fu.d2"
	icon_state = "fud2"
	item_state = "fud2"
	freerange = 0
	frequency = DE_BASE_FREQ
	anchored = 1
	canhear_range = 1
	speech_sound = 'sound/effects/roger_beep2.ogg'

/obj/item/device/radio/intercom/fu2/New()
	..()
	internal_channels = default_german_channels.Copy()
	internal_channels += num2text(DE_BASE_FREQ)
	internal_channels[num2text(DE_BASE_FREQ)] = list()

/obj/item/device/radio/intercom/fu2/process()
	if(world.time - last_tick > 30 || last_tick == -1)
		last_tick = world.time

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
	item_state = "feldfu"
	freerange = 0
	frequency = DE_COMM_FREQ
	canhear_range = 1
	w_class = 4
	speech_sound = 'sound/effects/roger_beep2.ogg'

/obj/item/device/radio/feldfu/New()
	..()
	internal_channels = default_german_channels.Copy()

/obj/item/clothing/suit/radio_harness
	name = "radio harness"
	desc = "Use this to hold your big clunky radios."
	icon_state = "radio_harness"
	item_state = "radio_harness"
	allowed = list(/obj/item/device/radio/rbs,/obj/item/device/radio/feldfu)
