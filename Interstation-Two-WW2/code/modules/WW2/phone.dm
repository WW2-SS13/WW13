#define RAID "Order katyusha strike"
#define DECLARE_TRAITOR "Declare Traitor" // broken
#define REQUEST_BATTLE_REPORT "Request Battle Status Report"

var/list/german_traitors = list()
var/list/soviet_traitors = list()

/obj/item/weapon/phone
	name = "red phone"
	desc = "Should anything ever go wrong..."
	icon = 'icons/obj/items.dmi'
	icon_state = "red_phone"
	flags = CONDUCT
	force = WEAPON_FORCE_HARMLESS
	throwforce = WEAPON_FORCE_HARMLESS
	throw_speed = TRUE
	throw_range = 4
	w_class = 2
	attack_verb = list("called", "rang")
	hitsound = 'sound/weapons/ring.ogg'

/obj/item/weapon/phone/tohighcommand
	name = "phone"
	desc = "A private line that goes directly to High Command."
	attack_verb = list()
	var/list/options = list(RAID, REQUEST_BATTLE_REPORT)
	var/faction = null

/obj/item/weapon/phone/tohighcommand/german
	faction = GERMAN
	options = list(REQUEST_BATTLE_REPORT)

/obj/item/weapon/phone/tohighcommand/soviet
	faction = SOVIET

/obj/item/weapon/phone/tohighcommand/proc/may_bombard_base()
	return tickerProcess.time_elapsed >= 18000

/obj/item/weapon/phone/tohighcommand/proc/may_bombard_base_message()
	if (may_bombard_base())
		return "We have gained air superiority over the enemy and can attack their base directly"
	return "We have not gained air superiority over the enemy, so we cannot attack their base yet. Bombs will only land inside the town, not the enemy base"

/obj/item/weapon/phone/tohighcommand/attack_hand(var/mob/living/carbon/human/H)
	if (istype(H))
		var/dowhat = input(H, "What would you like to do?") in options + "Cancel"
		if (dowhat != "Cancel")
			switch (dowhat)
				if (RAID)
					if (map && !map.soviets_can_cross_blocks() && faction == SOVIET)
						H << "<span class = 'warning'>You can't use this yet.</span>"
						return
					if (map && !map.germans_can_cross_blocks() && faction == GERMAN)
						H << "<span class = 'warning'>You can't use this yet.</span>"
						return
					if (!H.original_job || H.original_job.base_type_flag() != faction || !H.original_job.is_officer)
						return

					var/list/targets = (faction == SOVIET ? alive_germans : faction == GERMAN ? alive_russians : list())
					// it takes 5 minutes for soviets to generate 300 points, not counting rewards
					var/cost = (targets.len * 5) + battlereport.current_extra_cost_for_air_raid + 250
					var/yesno = input(H, "A Katyusha attack will cost [cost] supply points right now. You have [supply_points[faction]] supply points. [may_bombard_base_message()]. Would you like to call it in?") in list("Yes", "No")
					if (yesno == "Yes")
						if (supply_points[faction] < cost)
							H << "<span class = 'warning'>You can't afford this right now.</span>"
							return
						supply_points[faction] -= cost
						radio2faction("[faction == GERMAN ? "A Luftwaffe" : "A Katyusha"] attack has been called in by [H.real_name]. Stand by.", faction)
						air_raid(faction, src)

				if (REQUEST_BATTLE_REPORT)
					if (!H.original_job || H.original_job.base_type_flag() != faction || !H.original_job.is_officer)
						return

					battlereport2faction(faction)

				if (DECLARE_TRAITOR)
					if (!H.original_job || H.original_job.base_type_flag() != faction || !H.original_job.is_officer)
						return

					var/who = lowertext(input(H, "Declare who as a traitor?") as text)
					var/found = FALSE
					for (var/mob/living/carbon/human/HH in human_mob_list)
						if (HH.loc)
							var/HH_name = lowertext(HH.real_name)
							var/HH_name_no_rank = lowertext(splittext(HH.real_name, ". ")[2])
							if ((HH_name == who || HH_name_no_rank == who) && HH.original_job && HH.original_job.base_type_flag() == faction)
								if (rankcmp(H.original_job, HH.original_job))
									found = HH.real_name
					if (!found)
						H << "<span class = 'warning'>The person was not found.</span>"
					else
						var/list/traitors = list()
						switch (faction)
							if (GERMAN)
								traitors = german_traitors
							if (SOVIET)
								traitors = soviet_traitors
						traitors |= found
						radio2faction("[found] has been declared a traitor by [H.real_name]. They will be targeted in future Katyusha attacks. Military Police are hereby instructed to detain or execute [found].", faction)

/proc/air_raid(faction, var/obj/item/weapon/phone/tohighcommand/caller)

	spawn (rand(40,60))

		var/raiding = null
		if (faction == GERMAN)
			raiding = SOVIET
		else if (faction == SOVIET)
			raiding = GERMAN
		else
			raiding = TRUE // somehow we got here, bomb everyone ayylmao

		var/list/traitors = list()

		if (faction == GERMAN)
			traitors = german_traitors
		else if (faction == SOVIET)
			traitors = soviet_traitors

		var/list/targets = (raiding == SOVIET ? alive_russians : raiding == GERMAN ? alive_germans : player_list)

		var/maximum_targets = max(1, round(targets.len/5))
		var/targeted = 0

		var/shuffled_human_mobs = shuffle(human_mob_list)
		var/list/used_areas = list()

		for (var/mob/living/carbon/human/H in shuffled_human_mobs)
			if (H.loc && (H.stat == CONSCIOUS || H.debugmob))
				var/area/H_area = get_area(H)
				if (used_areas.Find(H_area))
					continue
				if (istype(H_area, /area/prishtina/german))
					if (!caller || !caller.may_bombard_base())
						continue
				if (istype(H_area, /area/prishtina/soviet))
					if (!caller || !caller.may_bombard_base())
						continue
				if (istype(H_area, /area/prishtina/void))
					continue
				if ((H.original_job && H.original_job.base_type_flag() == raiding) || raiding == TRUE || (traitors.Find(H.real_name) && H_area.location == AREA_OUTSIDE))
					if (targeted < maximum_targets)

						++targeted

						var/turf/target = locate(H.x, H.y, H.z)
						var/area/target_area = get_area(target)

						used_areas += target_area

						playsound(target, "artillery_in_distant", 100, TRUE, 100)
						target.visible_message("<span class = 'userdanger'>You see a barrage of rockets in the sky!</span>")

						for (var/v in 1 to 3)
							spawn (40 * v)

								var/target_x = H.x + rand(-3,3)
								var/target_y = H.y + rand(-3,3)
								var/target_z = H.z

								target = locate(target_x, target_y, target_z)

								// two strikes to take down a ceiling, faster than artillery
								// no more partial chances however - Kachnov
								if (target_area.artillery_integrity)
									target_area.artillery_integrity -= 50

								if (target_area.artillery_integrity <= 0 && (!target_area.parent_area || target_area.parent_area.artillery_integrity <= 0))
									explosion(target, 1, 3, 4, 5)
								else
									target.visible_message("<span class = 'userdanger'>The bomb smashes into the ceiling!</span>")
									playsound(target, "explosion", 100, TRUE, 100)
					else
						break