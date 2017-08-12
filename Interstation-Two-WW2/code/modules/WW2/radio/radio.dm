// ww2 specific channels

var/const/DEFAULT_FREQ = 1000

var/const/RU_BASE_FREQ = 1220
var/const/RU_COMM_FREQ = 1230

var/const/DE_BASE_FREQ = 1240
var/const/DE_COMM_FREQ = 1250

var/const/UK_FREQ = 1260

/proc/radio_freq2name(constant)
	switch (constant)
		if (DEFAULT_FREQ)
			return "DEFAULT"
		if (RU_BASE_FREQ)
			return "Russian Base"
		if (RU_COMM_FREQ)
			return "Russian Command"
		if (DE_BASE_FREQ)
			return "German Base"
		if (DE_COMM_FREQ)
			return "German Command"
		if (UK_FREQ)
			return "Partisans"

/proc/radio_freq2color(constant)
	switch (constant)
		if (DEFAULT_FREQ)
			return "brown"
		if (RU_BASE_FREQ)
			return "brown"
		if (RU_COMM_FREQ)
			return "blue"
		if (DE_BASE_FREQ)
			return "brown"
		if (DE_COMM_FREQ)
			return "blue"
		if (UK_FREQ)
			return "blue"

var/global/list/default_german_channels = list(
	num2text(DE_COMM_FREQ) = list()
)

var/global/list/default_russian_channels = list(
	num2text(RU_COMM_FREQ) = list()
)

var/global/list/default_ukrainian_channels = list(
	num2text(UK_FREQ) = list()
)


/obj/item/device/radio
	icon = 'icons/obj/radio.dmi'
	name = "station bounced radio"
	suffix = "\[3\]"
	icon_state = "walkietalkie"
	item_state = "walkietalkie"

	var/on = 1 // 0 for off
	var/last_transmission
	var/frequency = DEFAULT_FREQ //common chat
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

/* Hearing radios, less stupid and telecomms free edition - Kachnov

 This is really simple. When a mob says something near a radio,
 or while there is a radio in their contents, their message
 gets broadcasted exactly 1/2 of a second later. I was planning to
 add randomness to this time interval, but then I would have to store
 messages to make sure they get broadcasted in chronological order.
 I may do this some time in the future.
*/

/mob/living/carbon/human/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="")
	..()
	var/list/used_radio_turfs = list()
	for (var/obj/item/device/radio/radio in range(1, src))
		if (used_radio_turfs.Find(get_turf(radio)))
			continue
		if (!radio.on)
			continue
		if (radio == s_store)
			if (!dd_hasprefix(message, ":b"))
				continue
			else
				message = copytext(message, 3)
		if (radio == l_hand)
			if (!dd_hasprefix(message, ":l"))
				continue
			else
				message = copytext(message, 3)
		if (radio == r_hand)
			if (!dd_hasprefix(message, ":r"))
				continue
			else
				message = copytext(message, 3)
		used_radio_turfs += get_turf(radio)
		spawn (5)
			if (!stuttering || stuttering < 4)
				radio.broadcast(message, src, 0)
			else
				radio.broadcast(message, src, 1)

/obj/item/device/radio/proc/broadcast(var/msg, var/mob/living/carbon/human/speaker, var/hardtohear = 0)
	var/list/used_radio_turfs = list()
	for (var/mob/living/carbon/human/hearer in human_mob_list)
		if (istype(hearer) && hearer.stat == CONSCIOUS)
			var/list/radios = list()
			for (var/obj/item/device/radio/radio in view(world.view, hearer))
				radios += radio
			for (var/obj/item/device/radio/radio in hearer.contents)
				radios += radio
			for (var/obj/item/device/radio/radio in radios)
				if (used_radio_turfs.Find(get_turf(radio)))
					continue
				if (!radio.on)
					continue
				used_radio_turfs += get_turf(radio)
				if (radio.frequency == src.frequency)
					hearer.hear_radio(msg, "says", speaker.default_language, null, null, speaker, hardtohear)

/obj/item/device/radio
	var/speech_sound = null
	var/freerange = 1

/obj/item/device/radio/proc/bracketed_name()
	var/lbracket = "\["
	var/rbracket = "\]"
	return "[lbracket][radio_freq2name(frequency)][rbracket]"

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

// german

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

// partisan clone of german radios

/obj/item/device/radio/feldfu/partisan

/obj/item/device/radio/feldfu/partisan/New()
	..()
	internal_channels = default_ukrainian_channels.Copy()

/obj/item/clothing/suit/radio_harness
	name = "radio harness"
	desc = "Use this to hold your big clunky radios."
	icon_state = "radio_harness"
	item_state = "radio_harness"
	allowed = list(/obj/item/device/radio/rbs,/obj/item/device/radio/feldfu)
