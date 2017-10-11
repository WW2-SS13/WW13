// ww2 specific channels

var/const/DEFAULT_FREQ = 1000

var/const/RU_BASE_FREQ = 1220
var/const/RU_COMM_FREQ = 1230

var/const/DE_BASE_FREQ = 1240
var/const/DE_COMM_FREQ = 1250

var/const/UK_FREQ = 1260

/proc/radio_sanitize_frequency(freq)
	return text2num("[freq].0")

/proc/radio_freq2name(constant)
	if (istext(constant))
		constant = text2num(constant)
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

/proc/radio_freq2span(constant)
	if (istext(constant))
		constant = text2num(constant)
	switch (constant)
		if (DEFAULT_FREQ)
			return "secradio"
		if (RU_BASE_FREQ)
			return "secradio"
		if (RU_COMM_FREQ)
			return "comradio"
		if (DE_BASE_FREQ)
			return "secradio"
		if (DE_COMM_FREQ)
			return "comradio"
		if (UK_FREQ)
			return "secradio"

// channel = access
var/global/list/default_german_channels = list(
	num2text(DE_COMM_FREQ) = list(),
	num2text(DE_BASE_FREQ) = list()
)

var/global/list/default_russian_channels = list(
	num2text(RU_COMM_FREQ) = list(),
	num2text(RU_BASE_FREQ) = list()
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
	var/list/listening_on_channel = list()
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
	var/datum/nanoui/UI
	var/speech_sound = null
	var/freerange = 1
	var/last_broadcast = -1
	var/notyetmoved = 1 // shitty variable to prevent radio piles from broadcasting

/obj/item/device/radio/New()
	..()
	for (var/channel in internal_channels)
		listening_on_channel[radio_freq2name(channel)] = 1

	if (!isturf(loc))
		notyetmoved = 0

/obj/item/device/radio/Move()
	..()
	notyetmoved = 0

/obj/item/device/radio/pickup(mob/user)
	..(user)
	notyetmoved = 0

/obj/item/device/radio/proc/list_internal_channels(var/mob/user)
	var/dat[0]
	for(var/internal_chan in internal_channels)
		dat.Add(list(list("chan" = internal_chan, "display_name" = radio_freq2name(text2num(internal_chan)), "chan_span" = radio_freq2span(text2num(internal_chan)))))

	return dat

/obj/item/device/radio/proc/list_channels(var/mob/user)
	return list_internal_channels(user)

/obj/item/device/radio/proc/format_frequency(var/f)
	return "[round(f / 10)].[f % 10]"

/obj/item/device/radio/proc/span_class()
	return radio_freq2span(frequency)

/* New code for interacting with radios - Kachnov */

/obj/item/device/radio/attack_self(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/item/device/radio/interact(mob/user)
	if(!user)
		return 0

	return ui_interact(user)

/obj/item/device/radio/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	data["mic_status"] = broadcasting
	data["speaker"] = listening
	data["freq"] = format_frequency(frequency)
	data["rawfreq"] = num2text(frequency)

	var/list/chanlist = list_channels(user)
	if(islist(chanlist) && chanlist.len)
		data["chan_list"] = chanlist
		data["chan_list_len"] = chanlist.len

	if(syndie)
		data["useSyndMode"] = 1

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "radio_basic.tmpl", "[name]", 400, 430)
		ui.set_initial_data(data)
		ui.open()

/* Hearing radios, less stupid and telecomms free edition - Kachnov

 This is really simple. When a mob says something near a radio,
 or while there is a radio in their contents, their message
 gets broadcasted exactly 1/2 of a second later. I was planning to
 add randomness to this time interval, but then I would have to store
 messages to make sure they get broadcasted in chronological order.
 I may do this some time in the future.
*/

/mob/living/carbon/human/proc/post_say(var/message)
	if (!locate(/obj/item/device/radio) in range(1, src))
		return
	if (stat != CONSCIOUS)
		return
	var/list/used_radio_turfs = list()
	var/list/used_radios = list()
	for (var/obj/item/device/radio/radio in range(1, src))
		if (used_radio_turfs.Find(get_turf(radio)))
			continue
		if (used_radios.Find(radio))
			continue
		if (radio.notyetmoved)
			continue
		if (!radio.on)
			continue
		if (radio == s_store)
			if (!dd_hasprefix(message, ":b"))
				continue
			else
				message = copytext(message, 3)
		else if (radio == l_hand)
			if (!dd_hasprefix(message, ":l"))
				continue
			else
				message = copytext(message, 3)
		else if (radio == r_hand)
			if (!dd_hasprefix(message, ":r"))
				continue
			else
				message = copytext(message, 3)
		else if (istype(radio.loc, /turf) && !radio.broadcasting)
			continue

		used_radio_turfs += get_turf(radio)
		used_radios += radio

		spawn (5)
			if (!stuttering || stuttering < 4)
				radio.broadcast(rhtml_encode(message), src, 0)
			else
				radio.broadcast(rhtml_encode(message), src, 1)

/obj/item/device/radio/proc/broadcast(var/msg, var/mob/living/carbon/human/speaker, var/hardtohear = 0)

	// ignore emotes.
	if (copytext(msg, 1, 2) == "*")
		return

	if (!can_broadcast())
		return

	if (notyetmoved)
		return

	var/list/used_radio_turfs = list()
	var/list/used_radios = list()
	var/list/tried_mobs = list()
	// let people playing near radios hear it
	for (var/mob/living/carbon/human/hearer in human_mob_list)
		if (tried_mobs.Find(hearer))
			continue
		tried_mobs += hearer
		if (istype(hearer) && hearer.stat == CONSCIOUS)
			var/list/radios = list()
			for (var/obj/item/device/radio/radio in view(world.view, hearer))
				radios |= radio
			for (var/obj/item/device/radio/radio in hearer.contents)
				radios |= radio
			for (var/obj/item/device/radio/radio in radios)
				if (used_radio_turfs.Find(get_turf(radio)))
					continue
				if (used_radios.Find(radio))
					continue
				if (radio.notyetmoved)
					continue
				if (!radio.on)
					continue
				if (!radio.listening)
					continue
				used_radio_turfs += get_turf(radio)
				used_radios += radio
				if (radio.listening_on_channel[radio_freq2name(frequency)])
					hearer.hear_radio(msg, "says", speaker.default_language, speaker, src, hardtohear)
	// let observers hear it
	for (var/mob/observer/o in mob_list)
		if (istype(o))
			// first, try to find an actual radio that the message could be sent to (to get the right radio icon)
			for (var/obj/item/device/radio/radio in world)
				if (radio.listening_on_channel[radio_freq2name(frequency)])
					o.hear_radio(msg, "says", speaker.default_language, speaker, src, hardtohear)
					return
			// failing that, pick the first radio we can find.
			for (var/obj/item/device/radio/radio in world)
				o.hear_radio(msg, "says", speaker.default_language, speaker, src, hardtohear)
				return

	post_broadcast()

/obj/item/device/radio/proc/bracketed_name()
	var/lbracket = "\["
	var/rbracket = "\]"
	return "[lbracket][radio_freq2name(frequency)][rbracket]"

/obj/item/device/radio/proc/can_broadcast()
	if (last_broadcast > world.time)
		return 0
	for (var/obj/item/device/radio/radio in get_turf(src))
		// the reason radio.can_broadcast() is not checked is because
		// it might cause an infinite loop
		if (radio.last_broadcast > world.time)
			return 0
	return 1

/obj/item/device/radio/proc/post_broadcast()
	last_broadcast = world.time + 5

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
	internal_channels = default_russian_channels.Copy()
	..()

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
	internal_channels = default_russian_channels.Copy()
	..()

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
	internal_channels = default_german_channels.Copy()
	..()

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
	internal_channels = default_german_channels.Copy()
	..()

// partisan clone of german radios. Doesn't inherit from the feldfu for
// callback meme reasons

/obj/item/device/radio/partisan
	name = "Feldfu.f"
	icon_state = "feldfu"
	item_state = "feldfu"
	freerange = 0
	frequency = UK_FREQ
	canhear_range = 1
	w_class = 4
	speech_sound = 'sound/effects/roger_beep2.ogg'

/obj/item/device/radio/partisan/New()
	internal_channels = default_ukrainian_channels.Copy()
	..()

// radio topic stuff

/obj/item/device/radio/Topic(href, href_list)
	if(..())
		return 1

	usr.set_machine(src)

	if (href_list["freq"])
		var/new_frequency = (frequency + text2num(href_list["freq"]))
		if ((new_frequency != 0))
			new_frequency = radio_sanitize_frequency(new_frequency)
		frequency = new_frequency
		. = 1
	else if (href_list["talk"])
		broadcasting = !broadcasting
		. = 1
	else if (href_list["listen"])
		listening = !listening
		. = 1
	else if(href_list["spec_freq"])
		frequency = (text2num(href_list["spec_freq"]))
		. = 1

	for (var/channel in internal_channels)
		listening_on_channel[radio_freq2name(channel)] = 1

	if(.)
		nanomanager.update_uis(src)

	playsound(loc, 'sound/machines/machine_switch.ogg', 100, 1)