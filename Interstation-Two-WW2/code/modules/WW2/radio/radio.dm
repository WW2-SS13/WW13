#define MAX_SUPPLYDROP_CRATES 20

// DEFAULT frequency: unused
var/const/DEFAULT_FREQ = 1000

// SOVIET
var/const/SO_BASE_FREQ = 1001
var/const/SO_COMM_FREQ = 1002
var/const/SO_SUPPLY_FREQ = 1003

// GERMAN
var/const/DE_BASE_FREQ = 1004
var/const/DE_COMM_FREQ = 1005
var/const/DE_SUPPLY_FREQ = 1006
var/const/SS_FREQ = 1007 // SS

// UKRAINIAN
var/const/UK_FREQ = 1008

/proc/radio_sanitize_frequency(freq)
	return text2num("[freq].0")

/proc/radio_freq2name(constant)
	if (istext(constant))
		constant = text2num(constant)
	switch (constant)
		if (DEFAULT_FREQ)
			return "DEFAULT"
		if (SO_BASE_FREQ)
			return "Soviet Base"
		if (SO_COMM_FREQ)
			return "Soviet Command"
		if (SO_SUPPLY_FREQ)
			return "Soviet Supply"
		if (DE_BASE_FREQ)
			return "German Base"
		if (DE_COMM_FREQ)
			return "German Command"
		if (DE_SUPPLY_FREQ)
			return "German Supply"
		if (SS_FREQ)
			return "SS"
		if (UK_FREQ)
			return "Partisans"

/proc/radio_freq2span(constant)
	if (istext(constant))
		constant = text2num(constant)
	switch (constant)
		if (DEFAULT_FREQ)
			return "redradio"
		if (SO_BASE_FREQ)
			return "redradio"
		if (SO_COMM_FREQ)
			return "blueradio"
		if (SO_SUPPLY_FREQ)
			return "brownradio"
		if (DE_BASE_FREQ)
			return "redradio"
		if (DE_COMM_FREQ)
			return "blueradio"
		if (DE_SUPPLY_FREQ)
			return "brownradio"
		if (SS_FREQ)
			return "SSradio"
		if (UK_FREQ)
			return "redradio"

// channel = access
var/global/list/default_german_channels = list(
	num2text(DE_BASE_FREQ),
	num2text(DE_SUPPLY_FREQ)
)

var/global/list/command_german_channels = list(
	num2text(DE_BASE_FREQ),
	num2text(DE_SUPPLY_FREQ),
	num2text(DE_COMM_FREQ)
)

var/global/list/SS_german_channels = list(
	num2text(DE_BASE_FREQ),
	num2text(DE_SUPPLY_FREQ),
	num2text(SS_FREQ)
)

var/global/list/SS_command_german_channels = list(
	num2text(DE_BASE_FREQ),
	num2text(DE_SUPPLY_FREQ),
	num2text(DE_COMM_FREQ),
	num2text(SS_FREQ)
)

var/global/list/default_soviet_channels = list(
	num2text(SO_BASE_FREQ),
	num2text(SO_SUPPLY_FREQ)
)

var/global/list/command_soviet_channels = list(
	num2text(SO_BASE_FREQ),
	num2text(SO_SUPPLY_FREQ),
	num2text(SO_COMM_FREQ)
)

var/global/list/default_ukrainian_channels = list(
	num2text(UK_FREQ)
)

var/global/list/all_channels = default_german_channels | command_german_channels | SS_german_channels | SS_command_german_channels | default_soviet_channels | command_soviet_channels | default_ukrainian_channels


/obj/item/device/radio
	icon = 'icons/obj/radio.dmi'
	name = "station bounced radio"
	desc = "A portable communication device. You can speak through it with ':b' when it's in your suit storage slot, and ':l' or ':r' when its in your hand. ';' speaks with the first radio available on your person."
	suffix = "\[3\]"
	icon_state = "walkietalkie"
	item_state = "walkietalkie"

	var/on = TRUE // FALSE for off
	var/frequency = DEFAULT_FREQ
	var/canhear_range = 3 // the range which mobs can hear this radio from
	var/datum/wires/radio/wires = null
	var/broadcasting = TRUE
	var/listening = TRUE
	var/list/channels = list() //see communications.dm for full list. First channel is a "default" for :h
	var/list/listening_on_channel = list()
	flags = CONDUCT
	slot_flags = SLOT_BACK
	throw_speed = 2
	throw_range = 9
	w_class = 2
	matter = list("glass" = 25,DEFAULT_WALL_MATERIAL = 75)
	var/list/internal_channels
	var/last_tick = -1
	var/datum/nanoui/UI
	var/speech_sound = null
	var/last_broadcast = -1
	var/notyetmoved = TRUE // shitty hack to prevent radio piles from broadcasting
	var/is_supply_radio = FALSE

	var/faction = null

/obj/item/device/radio/New()
	..()

	// channels added before this is called
	for (var/channel in internal_channels)
		listening_on_channel[radio_freq2name(channel)] = TRUE

	if (!isturf(loc))
		notyetmoved = FALSE

	if (istype(src, /obj/item/device/radio/intercom) && !istype(src, /obj/item/device/radio/intercom/loudspeaker))
		notyetmoved = FALSE
		if (loc)
			setup_announcement_system("Arrivals Announcement System", (faction == GERMAN ? DE_BASE_FREQ : SO_BASE_FREQ))
			setup_announcement_system("Supplydrop Announcement System", (faction == GERMAN ? DE_SUPPLY_FREQ : SO_SUPPLY_FREQ))
			setup_announcement_system("Supply Train Announcement System", (faction == GERMAN ? DE_SUPPLY_FREQ : SO_SUPPLY_FREQ))
			setup_announcement_system("Reinforcements Announcement System", (faction == GERMAN ? DE_BASE_FREQ : SO_BASE_FREQ))
			setup_announcement_system("High Command Announcement System", (faction == GERMAN ? DE_BASE_FREQ : SO_BASE_FREQ))
			switch (faction)
				if (GERMAN)
					setup_announcement_system("SS Announcement System", SS_FREQ)
					main_radios[GERMAN] = src
				if (SOVIET)
					main_radios[SOVIET] = src

	spawn (100)
		if (map)
			if (map.uses_supply_train && faction == GERMAN)
				is_supply_radio = FALSE

	if (locate(/obj/effect/landmark/train/german_supplytrain_start) in world)
		is_supply_radio = FALSE

	// channels added after this is called
	// necessary for subtypes that want to override channels of their supertypes
	spawn (5)
		for (var/channel in internal_channels)
			listening_on_channel[radio_freq2name(channel)] = TRUE

/obj/item/device/radio/Move()
	..()
	notyetmoved = FALSE

/obj/item/device/radio/pickup(mob/user)
	..(user)
	notyetmoved = FALSE

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

/obj/item/device/radio/attack_hand(mob/user as mob)
	if (anchored)
		attack_self(user)
	else
		return ..(user)

/obj/item/device/radio/attack_self(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/item/device/radio/interact(mob/user)
	if(!user)
		return FALSE

	return ui_interact(user)

/obj/item/device/radio/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = TRUE)
	var/data[0]

	data["mic_status"] = broadcasting
	data["speaker"] = listening
	data["freq"] = format_frequency(frequency)
	data["rawfreq"] = num2text(frequency)

	// supply stuff - Kachnov
	data["is_supply_radio"] = is_supply_radio
	data["supply_points"] = supply_points[faction]

	var/list/supply_crate_objects = list()
	switch (faction)
		if (GERMAN)
			supply_crate_objects = german_supply_crate_types.Copy()
		if (SOVIET)
			supply_crate_objects = soviet_supply_crate_types.Copy()

	for (var/key in supply_crate_objects)
		supply_crate_objects[key] = null
		supply_crate_objects -= key
		supply_crate_objects += "[key] ([supply_crate_costs[key]] points)"

	data["supply_crate_objects"] = supply_crate_objects

	var/list/chanlist = list_channels(user)
	if(islist(chanlist) && chanlist.len)
		data["chan_list"] = chanlist
		data["chan_list_len"] = chanlist.len

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "radio.tmpl", "[name]", 400, 430)
		ui.set_initial_data(data)
		ui.auto_update_content = TRUE
		ui.open()

/* Hearing radios, less stupid and telecomms free edition - Kachnov */

/mob/living/carbon/human/proc/post_say(var/message)

	if (!locate(/obj/item/device/radio) in range(1, src))
		return

	if (stat != CONSCIOUS)
		return

	var/list/used_radio_turfs = list()
	var/list/used_radios = list()
	var/list/possible_radio_locations = range(1, src)
	if (istype(loc, /obj/tank))
		possible_radio_locations += contents

	for (var/obj/item/device/radio/radio in possible_radio_locations)
		if (!used_radio_turfs.Find(radio.faction))
			used_radio_turfs[radio.faction] = list()
		if (used_radio_turfs[radio.faction].Find(get_turf(radio)))
			continue
		if (used_radios.Find(radio))
			continue
		if (radio.notyetmoved)
			continue
		if (!istype(radio, /obj/item/device/radio/intercom))
			if (!istype(radio.loc, /mob))
				continue
		if (!radio.on)
			continue
		if (radio == s_store)
			if (dd_hasprefix(message, ":b"))
				message = copytext(message, 3)
			else if (dd_hasprefix(message, ";"))
				message = copytext(message, 2)
			else
				continue
		else if (radio == l_hand)
			if (dd_hasprefix(message, ":l"))
				message = copytext(message, 3)
			else if (dd_hasprefix(message, ";"))
				message = copytext(message, 2)
			else
				continue
		else if (radio == r_hand)
			if (dd_hasprefix(message, ":r"))
				message = copytext(message, 3)
			else if (dd_hasprefix(message, ";"))
				message = copytext(message, 2)
			else
				continue
		else if (istype(radio.loc, /turf) && !radio.broadcasting)
			continue

		message = capitalize(trim_left(message))

		if (!loc || !loc.loc || !istype(loc.loc, /obj/tank))
			used_radio_turfs[radio.faction] += get_turf(radio)

		used_radios += radio

		spawn (5)
			if (!stuttering || stuttering < 4)
			//	log_debug("4")
				radio.broadcast(rhtml_encode(message), src, FALSE)
			else
			//	log_debug("5")
				radio.broadcast(rhtml_encode(message), src, TRUE)

/obj/item/device/radio/proc/broadcast(var/msg, var/mob/living/carbon/human/speaker, var/hardtohear = FALSE, var/needs_loc = TRUE)

	if (!loc && needs_loc)
		return

	hardtohear = FALSE // wip

	// ignore emotes.
	if (dd_hasprefix(msg, "*"))
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
		if (hearer.stat == CONSCIOUS)
			var/list/radios = list()
			for (var/obj/item/device/radio/radio in view(world.view, hearer))
				if (radio.broadcasting)
					radios |= radio
			for (var/obj/item/device/radio/radio in hearer.contents)
				radios |= radio
			for (var/obj/item/device/radio/radio in radios)
				if (!loc && radio == src)
					continue
				if (!used_radio_turfs.Find(radio.faction))
					used_radio_turfs[radio.faction] = list()
				if (used_radio_turfs[radio.faction].Find(get_turf(radio)))
					continue
				if (used_radios.Find(radio))
					continue
				if (radio.notyetmoved)
					continue
				if (!istype(radio, /obj/item/device/radio/intercom))
					if (!istype(radio.loc, /mob))
						continue
				if (!radio.on)
					continue
				if (!radio.listening)
					continue
				if (!radio.loc || !radio.loc.loc || !istype(radio.loc.loc, /obj/tank))
					used_radio_turfs[radio.faction] += get_turf(radio)
				used_radios += radio
				if (radio.listening_on_channel[radio_freq2name(frequency)])
					hearer.hear_radio(msg, speaker.sayverb, speaker.default_language, speaker, src, hardtohear)
	// let observers hear it
	for (var/mob/observer/O in mob_list)
		O.hear_radio(msg, speaker.sayverb, speaker.default_language, speaker, src, hardtohear)

	post_broadcast()

/obj/item/device/radio/proc/bracketed_name()
	var/lbracket = "\["
	var/rbracket = "\]"
	return "[lbracket][radio_freq2name(frequency)][rbracket]"

/obj/item/device/radio/proc/can_broadcast()
	if (last_broadcast > world.time)
		return FALSE
	for (var/obj/item/device/radio/radio in get_turf(src))
		// the reason radio.can_broadcast() is not checked is because
		// it might cause an infinite loop
		if (radio.last_broadcast > world.time)
			return FALSE
	return TRUE

/obj/item/device/radio/proc/post_broadcast()
	last_broadcast = world.time + 5

/obj/item/device/radio/intercom
	broadcasting = FALSE
	desc = "A stationary radio device, used for long-distance communication and supply requisition."

/obj/item/device/radio/intercom/a7b
	name = "A-7-B"
	icon_state = "a7b"
	item_state = "a7b"
	frequency = SO_BASE_FREQ
	anchored = TRUE
	canhear_range = 1
	speech_sound = 'sound/effects/roger_beep.ogg'
	is_supply_radio = TRUE
	faction = SOVIET

/obj/item/device/radio/intercom/a7b/New()
	..()
	internal_channels = command_soviet_channels.Copy()

/obj/item/device/radio/intercom/a7b/process()
	if(world.time - last_tick > 30 || last_tick == -1)
		last_tick = world.time

		if(!loc)
			on = FALSE
		else
			var/area/A = loc.loc
			if(!A || !isarea(A))
				on = FALSE
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
	frequency = SO_BASE_FREQ
	canhear_range = 1
	w_class = 5
	speech_sound = 'sound/effects/roger_beep.ogg'
	faction = SOVIET

/obj/item/device/radio/rbs/command

/obj/item/device/radio/rbs/New()
	..()
	internal_channels = default_soviet_channels.Copy()

/obj/item/device/radio/rbs/command/New()
	..()
	internal_channels = command_soviet_channels.Copy()

/obj/item/device/radio/intercom/fu2
	name = "Torn.Fu.d2"
	icon_state = "fud2"
	item_state = "fud2"
	frequency = DE_BASE_FREQ
	anchored = TRUE
	canhear_range = 1
	speech_sound = 'sound/effects/roger_beep2.ogg'
	is_supply_radio = TRUE
	faction = GERMAN

/obj/item/device/radio/intercom/fu2/New()
	..()
	internal_channels = command_german_channels.Copy()

/obj/item/device/radio/intercom/fu2/process()
	if(world.time - last_tick > 30 || last_tick == -1)
		last_tick = world.time

		if(!loc)
			on = FALSE
		else
			var/area/A = loc.loc
			if(!A || !isarea(A))
				on = FALSE
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
	frequency = DE_BASE_FREQ
	canhear_range = 1
	w_class = 4
	speech_sound = 'sound/effects/roger_beep2.ogg'
	faction = GERMAN

/obj/item/device/radio/feldfu/command

/obj/item/device/radio/feldfu/SS
	frequency = SS_FREQ

/obj/item/device/radio/feldfu/SS/command

/obj/item/device/radio/feldfu/announcer

/obj/item/device/radio/feldfu/New()
	..()
	internal_channels = default_german_channels.Copy()

/obj/item/device/radio/feldfu/command/New()
	..()
	internal_channels = command_german_channels.Copy()

/obj/item/device/radio/feldfu/SS/New()
	..()
	internal_channels = SS_german_channels.Copy()

/obj/item/device/radio/feldfu/SS/command/New()
	..()
	internal_channels = SS_command_german_channels.Copy()

/obj/item/device/radio/feldfu/announcer/New()
	..()
	internal_channels = all_channels.Copy()

// partisan clone of german radios. Doesn't inherit from the feldfu for
// callback meme reasons

/obj/item/device/radio/partisan
	name = "Feldfu.f"
	icon_state = "feldfu"
	item_state = "feldfu"
	frequency = UK_FREQ
	canhear_range = 1
	w_class = 4
	speech_sound = 'sound/effects/roger_beep2.ogg'
	faction = PARTISAN

/obj/item/device/radio/partisan/New()
	..()
	internal_channels = default_ukrainian_channels.Copy()

// radio topic stuff

/obj/item/device/radio/Topic(href, href_list)
	if(..())
		return TRUE

	usr.set_machine(src)

	if (href_list["freq"])
		var/new_frequency = (frequency + text2num(href_list["freq"]))
		if ((new_frequency != FALSE))
			new_frequency = radio_sanitize_frequency(new_frequency)
		frequency = new_frequency
		. = TRUE
	else if (href_list["talk"])
		broadcasting = !broadcasting
		. = TRUE
	else if (href_list["listen"])
		listening = !listening
		. = TRUE
	else if(href_list["spec_freq"])
		frequency = (text2num(href_list["spec_freq"]))
		. = TRUE
	else if (href_list["purchase"])
		var/split_purchase = splittext(href_list["purchase"], " (")
		var/item = split_purchase[1]
		var/points = text2num(replacetext(split_purchase[2], ")", ""))
		var/choices = list()
		switch (faction)
			if (GERMAN)
				choices = german_supply_crate_types | soviet_supply_crate_types
				// crash prevention + balance - Kachnov
				if (supplydrop_processing_objects_german.len >= MAX_SUPPLYDROP_CRATES)
					usr << "<span class = 'danger'>There are too many items already arriving! Please wait before ordering more.</span>"
					return
			if (SOVIET)
				// crash prevention + balance - Kachnov
				choices = soviet_supply_crate_types | soviet_supply_crate_types
				if (supplydrop_processing_objects_soviet.len >= MAX_SUPPLYDROP_CRATES)
					usr << "<span class = 'danger'>There are too many items already arriving! Please wait before ordering more.</span>"
					return
		purchase(item, choices[item], points)

	for (var/channel in internal_channels)
		listening_on_channel[radio_freq2name(channel)] = TRUE

	if(.)
		nanomanager.update_uis(src)

	playsound(loc, 'sound/machines/machine_switch.ogg', 100, TRUE)

/obj/item/device/radio/proc/purchase(var/itemname, var/path, var/pointcost = FALSE)

	if (supply_points[faction] <= pointcost)
		return

	announce("[itemname] has been purchased and will arrive soon.", "Supplydrop Announcement System")
	supply_points[faction] -= pointcost

	// sanity checking due to crashing, not sure it will help - Kachnov
	if (ispath(path) && list(GERMAN, SOVIET).Find(faction))
		supplydrop_process.add("[path]", faction)

// shitcode copied from the german supplytrain system - Kachnov
/obj/item/device/radio
	var/list/announcers = list()
	var/list/mobs = list()

/obj/item/device/radio/proc/setup_announcement_system(aname, channel)

	// our personal radio. Yes, even though we're a radio. Works better this way.
	announcers[aname] = new /obj/item/device/radio/feldfu/announcer
	var/obj/item/device/radio/announcer = announcers[aname]
	announcer.broadcasting = TRUE
	announcer.faction = faction
	announcer.frequency = channel
	announcer.speech_sound = speech_sound
	announcer.icon = icon
	announcer.icon_state = icon_state

	// hackish code because radios need a mob, with a language, to announce
	mobs[aname] = new/mob/living/carbon/human
	var/mob/living/carbon/human/H = mobs[aname]
	H.name = aname
	H.real_name = aname
	H.original_job = new/datum/job/german/trainsystem
	H.special_job_title = null
	H.sayverb = "announces"
	H.languages.Cut()

	switch (faction)
		if (GERMAN)
			H.languages = list(new/datum/language/german)
		if (SOVIET)
			H.languages = list(new/datum/language/russian)

	H.default_language = H.languages[1]

/obj/item/device/radio/proc/announce(msg, _announcer)

	var/obj/item/device/radio/intercom/fu2/announcer = null
	var/mob/living/carbon/human/mob = null

	if (!announcers.Find(_announcer))
		return FALSE

	announcer = announcers[_announcer]
	mob = mobs[_announcer]

	announcer.broadcast(msg, mob, needs_loc = FALSE)

	return TRUE