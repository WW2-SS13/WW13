/* SmartFridge.  Much todo
*/
/obj/machinery/smartfridge
	name = "\improper SmartFridge"
	icon = 'icons/obj/vending.dmi'
	icon_state = "smartfridge"
	layer = 2.9
	density = TRUE
	anchored = TRUE
	use_power = TRUE
	idle_power_usage = 5
	active_power_usage = 100
	flags = NOREACT
	var/global/max_n_of_items = 999 // Sorry but the BYOND infinite loop detector doesn't look things over 1000.
	var/icon_on = "smartfridge"
	var/icon_off = "smartfridge-off"
	var/icon_panel = "smartfridge-panel"
	var/item_quants = list()
	var/seconds_electrified = FALSE;
	var/shoot_inventory = FALSE
	var/locked = FALSE
	var/scan_id = TRUE
	var/is_secure = FALSE
	var/datum/wires/smartfridge/wires = null

/obj/machinery/smartfridge/secure
	is_secure = TRUE

/obj/machinery/smartfridge/New()
	..()
	if(is_secure)
		wires = new/datum/wires/smartfridge/secure(src)
	else
		wires = new/datum/wires/smartfridge(src)

/obj/machinery/smartfridge/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/smartfridge/proc/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/grown/))
		return TRUE
	return FALSE

/obj/machinery/smartfridge/secure/medbay
	name = "\improper Refrigerated Medicine Storage"
	desc = "A refrigerated storage unit for storing medicine and chemicals."
	icon_state = "smartfridge" //To fix the icon in the map editor.
	icon_on = "smartfridge_chem"
//	req_one_access = list(access_medical,access_chemistry)

/obj/machinery/smartfridge/secure/medbay/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/glass/))
		return TRUE
	if(istype(O,/obj/item/weapon/storage/pill_bottle/))
		return TRUE
	if(istype(O,/obj/item/weapon/reagent_containers/pill/))
		return TRUE
	return FALSE

/obj/machinery/smartfridge/chemistry
	name = "\improper Smart Chemical Storage"
	desc = "A refrigerated storage unit for medicine and chemical storage."

/obj/machinery/smartfridge/chemistry/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/storage/pill_bottle) || istype(O,/obj/item/weapon/reagent_containers))
		return TRUE
	return FALSE

/obj/machinery/smartfridge/chemistry/virology
	name = "\improper Smart Virus Storage"
	desc = "A refrigerated storage unit for volatile sample storage."


/obj/machinery/smartfridge/drinks
	name = "\improper Drink Showcase"
	desc = "A refrigerated storage unit for tasty tasty alcohol."

/obj/machinery/smartfridge/drinks/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/weapon/reagent_containers/glass) || istype(O,/obj/item/weapon/reagent_containers/food/drinks) || istype(O,/obj/item/weapon/reagent_containers/food/condiment))
		return TRUE

/obj/machinery/smartfridge/drying_rack
	name = "\improper Drying Rack"
	desc = "A machine for drying plants."
	icon_state = "drying_rack"
	icon_on = "drying_rack_on"
	icon_off = "drying_rack"

/obj/machinery/smartfridge/drying_rack/accept_check(var/obj/item/O as obj)
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/))
		var/obj/item/weapon/reagent_containers/food/snacks/S = O
		if (S.dried_type)
			return TRUE
	return FALSE

/obj/machinery/smartfridge/drying_rack/process()
	..()
	if(inoperable())
		return
	if(contents.len)
		dry()
		update_icon()

/obj/machinery/smartfridge/drying_rack/update_icon()
	overlays.Cut()
	if(inoperable())
		icon_state = icon_off
	else
		icon_state = icon_on
	if(contents.len)
		overlays += "drying_rack_filled"
		if(!inoperable())
			overlays += "drying_rack_drying"

/obj/machinery/smartfridge/drying_rack/proc/dry()
	for(var/obj/item/weapon/reagent_containers/food/snacks/S in contents)
		if(S.dry) continue
		if(S.dried_type == S.type)
			S.dry = TRUE
			item_quants[S.name]--
			S.name = "dried [S.name]"
			S.color = "#AAAAAA"
			S.loc = loc
		else
			var/D = S.dried_type
			new D(loc)
			item_quants[S.name]--
			qdel(S)
		return
	return

/obj/machinery/smartfridge/process()
	if(stat & (BROKEN|NOPOWER))
		return
	if(seconds_electrified > FALSE)
		seconds_electrified--
	if(shoot_inventory && prob(2))
		throw_item()

/obj/machinery/smartfridge/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/smartfridge/update_icon()
	if(stat & (BROKEN|NOPOWER))
		icon_state = icon_off
	else
		icon_state = icon_on

/*******************
*   Item Adding
********************/

/obj/machinery/smartfridge/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/screwdriver))
		panel_open = !panel_open
		user.visible_message("[user] [panel_open ? "opens" : "closes"] the maintenance panel of \the [src].", "You [panel_open ? "open" : "close"] the maintenance panel of \the [src].")
		overlays.Cut()
		if(panel_open)
			overlays += image(icon, icon_panel)
		nanomanager.update_uis(src)
		return
/*
	if(istype(O, /obj/item/device/multitool)||istype(O, /obj/item/weapon/wirecutters))
		if(panel_open)
			attack_hand(user)
		return*/

	if(stat & NOPOWER)
		user << "<span class='notice'>\The [src] is unpowered and useless.</span>"
		return

	if(accept_check(O))
		if(contents.len >= max_n_of_items)
			user << "<span class='notice'>\The [src] is full.</span>"
			return TRUE
		else
			user.remove_from_mob(O)
			O.loc = src
			if(item_quants[O.name])
				item_quants[O.name]++
			else
				item_quants[O.name] = TRUE
			user.visible_message("<span class='notice'>[user] has added \the [O] to \the [src].</span>", "<span class='notice'>You add \the [O] to \the [src].</span>")

			nanomanager.update_uis(src)

	else if(istype(O, /obj/item/weapon/storage/bag))
		var/obj/item/weapon/storage/bag/P = O
		var/plants_loaded = FALSE
		for(var/obj/G in P.contents)
			if(accept_check(G))
				if(contents.len >= max_n_of_items)
					user << "<span class='notice'>\The [src] is full.</span>"
					return TRUE
				else
					P.remove_from_storage(G,src)
					if(item_quants[G.name])
						item_quants[G.name]++
					else
						item_quants[G.name] = TRUE
					plants_loaded++
		if(plants_loaded)

			user.visible_message("<span class='notice'>[user] loads \the [src] with \the [P].</span>", "<span class='notice'>You load \the [src] with \the [P].</span>")
			if(P.contents.len > FALSE)
				user << "<span class='notice'>Some items are refused.</span>"

		nanomanager.update_uis(src)

	else
		user << "<span class='notice'>\The [src] smartly refuses [O].</span>"
		return TRUE


/obj/machinery/smartfridge/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	wires.Interact(user)
	ui_interact(user)

/*******************
*   SmartFridge Menu
********************/

/obj/machinery/smartfridge/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = TRUE)
	user.set_machine(src)

	var/data[0]
	data["contents"] = null
	data["electrified"] = seconds_electrified > FALSE
	data["shoot_inventory"] = shoot_inventory
	data["locked"] = locked
	data["secure"] = is_secure

	var/list/items[0]
	for (var/i=1 to length(item_quants))
		var/K = item_quants[i]
		var/count = item_quants[K]
		if(count > FALSE)
			items.Add(list(list("display_name" = rhtml_encode(capitalize(K)), "vend" = i, "quantity" = count)))

	if(items.len > FALSE)
		data["contents"] = items

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "smartfridge.tmpl", name, 400, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/smartfridge/Topic(href, href_list)
	if(..()) return FALSE

	var/mob/user = usr
	var/datum/nanoui/ui = nanomanager.get_open_ui(user, src, "main")

	add_fingerprint(user)

	if(href_list["close"])
		user.unset_machine()
		ui.close()
		return FALSE

	if(href_list["vend"])
		var/index = text2num(href_list["vend"])
		var/amount = text2num(href_list["amount"])
		var/K = item_quants[index]
		var/count = item_quants[K]

		// Sanity check, there are probably ways to press the button when it shouldn't be possible.
		if(count > FALSE)
			item_quants[K] = max(count - amount, FALSE)

			var/i = amount
			for(var/obj/O in contents)
				if(O.name == K)
					O.loc = loc
					i--
					if(i <= FALSE)
						return TRUE

		return TRUE
	return FALSE

/obj/machinery/smartfridge/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return FALSE

	for (var/O in item_quants)
		if(item_quants[O] <= FALSE) //Try to use a record that actually has something to dump.
			continue

		item_quants[O]--
		for(var/obj/T in contents)
			if(T.name == O)
				T.loc = loc
				throw_item = T
				break
		break
	if(!throw_item)
		return FALSE
	spawn(0)
		throw_item.throw_at(target,16,3,src)
	visible_message("<span class='warning'>[src] launches [throw_item.name] at [target.name]!</span>")
	return TRUE

/************************
*   Secure SmartFridges
*************************/

/obj/machinery/smartfridge/secure/Topic(href, href_list)
	if(stat & (NOPOWER|BROKEN)) return FALSE
	if(usr.contents.Find(src) || (in_range(src, usr) && istype(loc, /turf)))
		if(!emagged && locked != -1 && href_list["vend"])
			usr << "<span class='warning'>Access denied.</span>"
			return FALSE
	return ..()
