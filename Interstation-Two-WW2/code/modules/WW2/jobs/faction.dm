
/* Job Factions

 - These are/will be used for spies, partisans, and squads.
 - They're like antagonist datums but much simpler. You can have many
 - different factions depending on your job

 - helper functions are at the bottom

*/

#define TEAM_RU 1
#define TEAM_GE 2
#define TEAM_PN 3

var/global/spies[3]
var/global/officers[3]
var/global/commanders[3]
var/global/squad_leaders[3]
var/global/soldiers[3]
var/global/squad_members[3]

/datum/job_faction
	// redefine these since they don't exist in /datum
	var/icon = 'icons/mob/hud_WW2.dmi'
	var/icon_state = ""
	var/mob/living/carbon/human/holder = null
	var/title = "Something that shouldn't exist"
	var/list/objectives = list()
	var/team = null
	var/image/last_returned_image = null
	var/obj/factionhud/last_returned_hud = null

/datum/job_faction/proc/base_type()
	return "/datum/job_faction"

// you appear to be a partisan to all other partisans
/datum/job_faction/partisan
	icon_state = "partisan_soldier"
	title = "Partisan Soldier"
	team = TEAM_PN

/datum/job_faction/partisan/base_type()
	return "/datum/job_faction/partisan"

// you appear to be an officer to all other partisans (UNUSED)
/datum/job_faction/partisan/officer
	icon_state = "partisan_officer"
	team = TEAM_PN
// you appear to be a partisan leader to all other partisans
/datum/job_faction/partisan/commander
	icon_state = "partisan_commander"
	title = "Partisan Leader"
	team = TEAM_PN
// you appear to be a german soldier to all other germans
/datum/job_faction/german
	icon_state = "german_soldier"
	title = "Wehrmacht Soldier"
	team = TEAM_GE

/datum/job_faction/german/base_type()
	return "/datum/job_faction/german"
// you appear to be a SS soldier to all other germans
/datum/job_faction/german/SS
	icon_state = "ss_soldier"
	title = "SS Soldier"
	team = TEAM_GE
// you appear to be an officer to all other germans
/datum/job_faction/german/officer
	icon_state = "german_officer"
	title = "Wehrmacht Officer"
	team = TEAM_GE
// you appear to be a german leader to all other germans
/datum/job_faction/german/commander
	icon_state = "german_commander"
	title = "Feldwebel"
	team = TEAM_GE
// you appear to be a SS leader to all other germans
/datum/job_faction/german/commander/SS
	icon_state = "ss_commander"
	title = "Feldwebel"
	team = TEAM_GE
// you appear to be a russian soldier to all other russians
/datum/job_faction/russian
	icon_state = "russian_soldier"
	title = "Russian Soldier"
	team = TEAM_RU

/datum/job_faction/russian/base_type()
	return "/datum/job_faction/russian"
// you appear to be an officer to all other russians
/datum/job_faction/russian/officer
	icon_state = "russian_officer"
	team = TEAM_RU
// you appear to be a russian leader to all other russians
/datum/job_faction/russian/commander
	icon_state = "russian_commander"
	team = TEAM_RU
// squads: both german and russian use the same types. What squad you appear
// to be in, and to whom, depends on your true faction. Spies

/datum/job_faction/squad
	var/squad = null
	var/is_leader = 0
	var/number = "#1"
	New(var/mob/living/carbon/human/H, var/datum/job/J)

		var/squadmsg = ""

		if (!is_leader)
			squadmsg = "<span class = 'danger'>You've been assigned to squad [squad].[istype(J, /datum/job/german) ? " Meet with the rest of your squad on train car [number]. " : " "]Examine people to see if they're in your squad, or if they're your squad leader."
		else
			squadmsg = "<span class = 'danger'>You are the [J.title] of squad [squad].[istype(J, /datum/job/german) ? " Meet with your squad on train car [number]. " : " "]Examine people to see if they're one of your soldats."

		squadmsg = replacetext(squadmsg, "<span class = 'danger'>", "")
		squadmsg = replacetext(squadmsg, "</span>", "")

		H.add_memory(squadmsg)

		..(H, J)

/datum/job_faction/squad/one
	icon_state = "squad_one"
	squad = "one"
	number = "#1"
/datum/job_faction/squad/one/leader
	icon_state = "squad_one_leader"
	is_leader = 1

/datum/job_faction/squad/two
	icon_state = "squad_two"
	squad = "two"
	number = "#2"
/datum/job_faction/squad/two/leader
	icon_state = "squad_two_leader"
	is_leader = 1

/datum/job_faction/squad/three
	icon_state = "squad_three"
	squad = "three"
	number = "#3"
/datum/job_faction/squad/three/leader
	icon_state = "squad_three_leader"
	is_leader = 1

/datum/job_faction/squad/four
	icon_state = "squad_four"
	squad = "four"
	number = "#4"
/datum/job_faction/squad/four/leader
	icon_state = "squad_four_leader"
	is_leader = 1

// spies use normal faction types

// CODE
/datum/job_faction/New(var/mob/living/carbon/human/H, var/datum/job/J)

	if (!H || !istype(H))
		return

	holder = H

	if (findtext("[type]", "leader"))
		if (istype(J, /datum/job/german))
			squad_leaders["GERMAN"]++
		else if (istype(J, /datum/job/russian))
			squad_leaders["RUSSIAN"]++
		else if (istype(J, /datum/job/partisan))
			squad_leaders["PARTISAN"]++
	else if (findtext("[type]", "officer"))
		if (istype(J, /datum/job/german))
			officers["GERMAN"]++
		else if (istype(J, /datum/job/russian))
			officers["RUSSIAN"]++
		else if (istype(J, /datum/job/partisan))
			officers["PARTISAN"]++
	else if (findtext("[type]", "commander"))
		if (istype(J, /datum/job/german))
			commanders["GERMAN"]++
		else if (istype(J, /datum/job/russian))
			commanders["RUSSIAN"]++
		else if (istype(J, /datum/job/partisan))
			commanders["PARTISAN"]++
	else if (!J.is_officer && !J.is_commander && !J.is_squad_leader)
		if (istype(J, /datum/job/german))
			if ("[type]" == "/datum/job_faction/german")
				soldiers["GERMAN"]++
			else if (findtext("[type]", "squad") && !src:is_leader)
				squad_members["GERMAN"]++
		else if (istype(J, /datum/job/russian))
			if ("[type]" == "/datum/job_faction/russian")
				soldiers["RUSSIAN"]++
			else if (findtext("[type]", "squad") && !src:is_leader)
				squad_members["RUSSIAN"]++
		else if (istype(J, /datum/job/partisan))
			if ("[type]" == "/datum/job_faction/partisan")
				soldiers["PARTISAN"]++
			else if (findtext("[type]", "squad") && !src:is_leader)
				squad_members["PARTISAN"]++
	H.all_job_factions += src
	..()

/datum/job_faction/proc/return_image()
	qdel(last_returned_image)
	var/image/i = image(icon, get_turf(holder), icon_state, MOB_LAYER + 20.0)
	last_returned_image = i
	return i
/*
/obj/factionhud // for displaying huds with screen_loc
	// for checking if our mob moved
	var/turf/reference_loc = null
	var/mob/reference_mob = null

/datum/job_faction/proc/return_image(var/mob/source, var/mob/target)
	var/obj/factionhud/factionhud = new
	factionhud.icon = icon
	factionhud.icon_state = icon_state
	factionhud.layer = MOB_LAYER + 20.0
	factionhud.pixel_x = ((source.x - target.x) * world.icon_size)
	factionhud.pixel_y = ((source.y - target.y) * world.icon_size)
	factionhud.reference_loc = get_turf(target)
	factionhud.reference_mob = target
	last_returned_hud = factionhud
	return factionhud

*/
/mob/living/carbon/human/proc/update_faction_huds_to_nearby_mobs()
	return // FIX THIS SHIT - kachnov
	for (var/mob/living/carbon/human/H in view(client ? client.view : world.view, src))
		update_faction_huds(H)

/proc/factiondebug(who, whom, scenario)
	#ifdef FACTIONDEBUG
	world << "[who] sent a faction image to [whom] in [scenario]"
	#endif

// updates the HUDs that target (a human) has for src
/mob/living/carbon/human/proc/update_faction_huds(var/mob/living/carbon/human/target)

	if (!base_job_faction || !target.base_job_faction) // we just spawned.
		return 0

	if (!target.client)
		return 0

	if (base_job_faction.base_type() != target.base_job_faction.base_type() && (!spy_job_faction || spy_job_faction.base_type() != target.base_job_faction.base_type()))
		return 0 // no HUDs if we don't share a base faction or spy faction

	// scenario 0.0: this is you: this works
	if (src == target)
		factiondebug(src, target, "scenario 0.0")
		var/datum/job_faction/optimal = squad_job_faction
		if (officer_job_faction && !issquadleader(src))
			optimal = officer_job_faction
		if (!optimal)
			optimal = base_job_faction
		target.job_faction_images[real_name] = optimal.return_image(src, target)
		goto addoverlay

	// scenario 1.0: we're a spy and they're on the team we're spying for
	else if (base_job_faction.base_type() != target.base_job_faction.base_type() && spy_job_faction && spy_job_faction.base_type() == target.base_job_faction.base_type())
		target.job_faction_images[real_name] = spy_job_faction.return_image(src, target)
		factiondebug(src, target, "scenario 1.0")
		goto addoverlay

	// scenario 1.1: they're a spy and we're on the team we're spying for
	else if (target.base_job_faction.base_type() != base_job_faction.base_type() && target.spy_job_faction && target.spy_job_faction.base_type() == base_job_faction.base_type())
		target.job_faction_images[real_name] = base_job_faction.return_image(src, target)
		factiondebug(src, target, "scenario 1.1")
		goto addoverlay

	// if we're on the same team
	else if (base_job_faction.base_type() == target.base_job_faction.base_type())

		// scenario 2.0: we're both non-officers
		if (officer_job_faction == null && target.officer_job_faction == null)

			// scenario 2.1: we're both non-officers, different squads
			if (getsquad(src) != getsquad(target))
				target.job_faction_images[real_name] = base_job_faction.return_image(src, target)
				factiondebug(src, target, "scenario 2.1")
				goto addoverlay

			// scenario 2.2: we're both non-officer squaddies
			else if (getsquad(src) == getsquad(target) && getsquad(src) != null)
				target.job_faction_images[real_name] = squad_job_faction.return_image(src, target)
				factiondebug(src, target, "scenario 2.2")
				goto addoverlay

		// scenario 3.0: we're an officer, they aren't
		else if (officer_job_faction && !target.officer_job_faction)

			// scenario 3.1: we're a squad leader, they aren't our soldat
			if (issquadleader(src) && !issquadleader(target) && !isleader(src, target))
				factiondebug(src, target, "scenario 3.1")
				target.job_faction_images[real_name] = officer_job_faction.return_image(src, target)
				goto addoverlay

			// scenario 3.2: you're an SL, they're your soldat
			else if (issquadleader(src) && isleader(src, target))
				factiondebug(src, target, "scenario 3.2")
				target.job_faction_images[real_name] = squad_job_faction.return_image(src, target)
				goto addoverlay

			// scenario 3.3: you're a generic officer or the CO, they're literally anyone else
			else if (officer_job_faction)
				factiondebug(src, target, "scenario 3.3")
				target.job_faction_images[real_name] = officer_job_faction.return_image(src, target)
				goto addoverlay

		// scenario 4.0: we're both officers
		else if (officer_job_faction && target.officer_job_faction)
			factiondebug(src, target, "scenario 4.0")
			target.job_faction_images[real_name] = officer_job_faction.return_image(src, target)
			goto addoverlay
		// scenario 5.0: they're an officer, we aren't
		else if (!officer_job_faction && target.officer_job_faction)
			// scenario 5.1: they're a squad leader, we aren't their soldat
			if (issquadleader(target) && !issquadleader(src) && !isleader(target, src))
				factiondebug(src, target, "scenario 5.1")
				target.job_faction_images[real_name] = base_job_faction.return_image(src, target)
				goto addoverlay

			// scenario 5.2: they're an SL, you're their soldat
			else if (issquadleader(target) && isleader(target, src))
				target.job_faction_images[real_name] = squad_job_faction.return_image(src, target)
				factiondebug(src, target, "scenario 5.2")
				goto addoverlay

			// scenario 5.3: they're an officer or the CO, you're literally anyone else
			else if (target.officer_job_faction)
				factiondebug(src, target, "scenario 5.3")
				target.job_faction_images[real_name] = base_job_faction.return_image(src, target)
				goto addoverlay

	addoverlay
	target.client.images |= target.job_faction_images[real_name]

/* HELPER FUNCTIONS */

/proc/issquadleader(var/mob/living/carbon/human/H)
	if (H.squad_job_faction && H.squad_job_faction.is_leader)
		return 1
	return 0

/proc/issquadmember(var/mob/living/carbon/human/H)
	if (H.squad_job_faction && !H.squad_job_faction.is_leader)
		return 1
	return 0

/proc/getsquad(var/mob/living/carbon/human/H)
	if (H.squad_job_faction)
		return H.squad_job_faction.squad
	return null

/proc/isleader(var/mob/living/carbon/human/H, var/mob/living/carbon/human/HH)
	if (issquadleader(H) && issquadmember(HH) && getsquad(H) == getsquad(HH))
		return 1
	return 0