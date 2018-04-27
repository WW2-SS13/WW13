var/list/loadout_items = list("Water", "Booze", "Grenade", "Smoke grenade", "Stolen gun", "Stolen gun ammo", "Flare", "Knife", "Cigarettes", "Lighter", "Crowbar", "Wrench", "Screwdriver", "Nothing")

/datum/category_item/player_setup_item/general/loadout
	name = "loadout"
	sort_order = 4

/datum/category_item/player_setup_item/general/loadout/content()
	//name
	. = "<b>Pockets:</b> "
	. += "<br><br>"
	. += "<b>1:</b> <a href='?src=\ref[src];pocket_1=1'>[pref.pockets[1] ? pref.pockets[1] : "Magazine/Nothing"]</a><br>"
	. += "<b>2:</b> <a href='?src=\ref[src];pocket_2=2'>[pref.pockets[2] ? pref.pockets[2] : "Magazine/Nothing"]</a><br>"

/datum/category_item/player_setup_item/general/loadout/OnTopic(var/href,var/list/href_list, var/mob/user)

	// neat stuff
	if(href_list["pocket_1"] || href_list["pocket_2"])
		var/one = href_list["pocket_1"]
		var/two = !one
		var/number = one ? "first" : "second"
		var/object = input(user, "Choose an object to start with in your [number] pocket. Note that this will stop you from spawning with an ammo magazine there.", "Loadout") in loadout_items
		if (!isnull(object) && CanUseTopic(user))
			if (object == "Nothing")
				object = null
			if (one)
				pref.pockets[1] = object
			else if (two)
				pref.pockets[2] = object
			return TOPIC_REFRESH
	return ..()
