#define RAID "Order bombing raid"
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

/obj/item/weapon/phone/tohighcommand/soviet
	faction = SOVIET

/obj/item/weapon/phone/tohighcommand/attack_hand(var/mob/living/carbon/human/H)
	if (istype(H))
		var/dowhat = input(H, "What would you like to do?") in options + "Cancel"
		if (dowhat != "Cancel")
			switch (dowhat)
				if (RAID)
					if (!H.original_job || H.original_job.base_type_flag() != faction || !H.original_job.is_officer)
						return

					var/list/targets = (faction == SOVIET ? alive_germans : faction == GERMAN ? alive_russians : list())
					var/cost = (targets.len * 5) + battlereport.current_extra_cost_for_air_raid + 50
					var/yesno = input(H, "An air raid will cost [cost] supply points right now. Would you like to call it in?") in list("Yes", "No")
					if (yesno == "Yes")
						if (supply_points[faction] < cost)
							H << "<span class = 'warning'>You can't afford this right now.</span>"
							return
						supply_points[faction] -= cost
						radio2faction("[faction == GERMAN ? "A Luftwaffe" : "An air"] raid has been called in by [H]. Stand by.", faction)
						air_raid(faction)

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
						radio2faction("[found] has been declared a traitor by [H]. They will be targeted in future air raids. Military Police are hereby instructed to detain or execute [found].", faction)

/proc/air_raid(faction)
	var/raiding = null
	if (faction == GERMAN)
		raiding = SOVIET
	else if (faction == SOVIET)
		raiding = GERMAN
	else
		raiding = TRUE // somehow we got here, bomb everyone

	var/list/traitors = list()

	if (faction == GERMAN)
		traitors = german_traitors
	else if (faction == SOVIET)
		traitors = soviet_traitors

	var/maximum_targets = max(1, round(player_list.len/5))
	var/targeted = 0

	for (var/mob/living/carbon/human/H in human_mob_list)
		if (H.loc && H.stat == CONSCIOUS)
			var/area/H_area = get_area(H)
			if ((H.original_job && H.original_job.base_type_flag() == raiding) || raiding == TRUE || (traitors.Find(H.real_name) && H_area.location == AREA_OUTSIDE))
				if (targeted < maximum_targets)

					++targeted

					var/turf/target = locate(H.x, H.y, H.z)
					var/area/target_area = get_area(target)

					playsound(target, "artillery_in_distant", 100, TRUE, 100)
					target.visible_message("<span class = 'userdanger'>You hear a plane coming!</span>")

					for (var/v in 1 to 3)
						spawn (rand(7*v,21*v))

							var/target_x = H.x + pick(0,0,-1,1)
							var/target_y = H.y + pick(0,0,-1,1)
							var/target_z = H.z

							target = locate(target_x, target_y, target_z)

							if (target_area.artillery_integrity)
								target_area.artillery_integrity -= rand(15,20)

							if (target_area.artillery_integrity <= 0 || prob(100 - target_area.artillery_integrity))
								explosion(target, 1, 3, 5, 7)
							else
								target.visible_message("<span class = 'userdanger'>The bomb smashes into the ceiling!</span>")
								playsound(target, "explosion", 100, TRUE, 100)