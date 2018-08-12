/obj/item/letter
	name = "letter"
	desc = "Unsuspicious white letter."
	icon = 'icons/WW2/misc.dmi'
	icon_state = "letter_full"
	var/datum/browser/popup = null
	var/used = 0
	var/points = 50
	var/obj/effect/landmark/recieve_landmark = null
	var/list/cart = list()
	var/list/agent_menu = list(
		new /datum/data/agent_equipment("Tokarev",/obj/item/weapon/gun/projectile/pistol/tokarev, 15, 1),
		new /datum/data/agent_equipment("Kar Rifle", /obj/item/weapon/gun/projectile/boltaction/kar98k, 40, 1),
		new /datum/data/agent_equipment("Sniper Scope", /obj/item/weapon/attachment/scope/adjustable/sniper_scope, 10, 1),
		new /datum/data/agent_equipment("Plastiqe Explosives", /obj/item/weapon/plastique/russian, 15, 1),
		new /datum/data/agent_equipment("Shotgun", /obj/item/weapon/gun/projectile/shotgun/pump, 40, 1),
		new /datum/data/agent_equipment("Blyskawica", /obj/item/weapon/gun/projectile/submachinegun/bly, 50, 1),
		new /datum/data/agent_equipment("Knife", /obj/item/weapon/material/knife/combat, 10, 1),
		new /datum/data/agent_equipment("Black Paint (great for night time stealth) ", /obj/item/weapon/reagent_containers/glass/paint/black, 10, 1),
		new /datum/data/agent_equipment("Kamikaze Charge", /obj/item/weapon/grenade/explosive/kamikaze, 50, 1)
		)

var/list/obj/effect/landmark/recieve/drop_points = list()

/obj/effect/landmark/recieve
	name = "Recieve landmark"

/obj/effect/landmark/recieve/New()
	..()
	drop_points += src

/obj/item/letter/New()
	..()
	sleep(5)
	recieve_landmark = safepick(drop_points)

/datum/data/agent_equipment
	var/name = "Agent Equipment"
	var/equipment_type = null
	var/cost = 5
	var/quantity = 0

/datum/data/agent_equipment/New(name, equipment_type, cost)
	src.name = name
	src.equipment_type = equipment_type
	src.cost = cost
	src.quantity = quantity

/obj/item/letter/attack_self(mob/user)
	interact(user)

/obj/item/letter/interact(mob/user)
	if(used)
		return

	var/dat

	dat += "<A href='?src=\ref[src];choice=order'><b>Order Supplies.</b></A><br>"
	dat += "<b>Points left</b>: [points]<br>"
	if(recieve_landmark)
		dat += "<b>Drop location:</b> [recieve_landmark.x], [recieve_landmark.y]<br>"
	else
		dat += "<b>Drop location:</b> unknown<br>"
	dat += "<div class='lenta_scroll'>"
	dat += "<br><BR><table border='0' width='400'>"
	for(var/datum/data/agent_equipment/AE in agent_menu)
		dat += "<tr><td>[AE.name]</td><td>[AE.cost]</td><td><A href='?src=\ref[src];add=\ref[AE]'>+</A><A href='?src=\ref[src];remove=\ref[AE]'>-</A></td><td>[AE.quantity]</td></tr>"
	dat += "</table>"
	dat += "</div>"

	popup = new /datum/browser(user, "letter", "Letter", 450, 700)
	popup.set_content(dat)
	popup.open()

/obj/item/letter/Topic(href, href_list)
	if(..())
		return

	if(href_list["choice"])
		if(href_list["choice"] == "order")
			if(cart.len)
				SendSupplies()

	if(href_list["add"])
		var/datum/data/agent_equipment/AE = locate(href_list["add"])

		if(!AE)
			return

		if(AE.cost > points)
			return

		if(!(AE in cart))
			cart += AE

		points -= AE.cost
		AE.quantity++

		updateUsrDialog()
		interact(usr)
		return

	if(href_list["remove"])
		var/datum/data/agent_equipment/AE = locate(href_list["remove"])

		if(!AE)
			return

		if(!(AE in cart))
			return

		points += AE.cost
		AE.quantity--
		if(AE.quantity == 0)
			cart -= AE
		updateUsrDialog()
		interact(usr)

		return

/obj/item/letter/proc/SendSupplies()
	if(recieve_landmark)
		var/obj/structure/closet/crate/C = new /obj/structure/closet/crate(recieve_landmark.loc)
		for(var/datum/data/agent_equipment/AE in cart)
			for(var/i = 1, i <= AE.quantity, i++)
				C.contents += new AE.equipment_type()
		cart = list()
		icon_state = "letter_empty"
		points = 0
		used = 1
		popup.close()
		//usr << "<B>Drop location</B>: <span class='danger'>\"[recieve_landmark.x]\", \"[recieve_landmark.y]\"</span>"
		if(recieve_landmark.x > usr.x)
			usr << "<span class='notice'>You need to go [recieve_landmark.x - usr.x] tiles east and ...</span>"
		else
			usr << "<span class='notice'>You need to go [usr.x - recieve_landmark.x] tiles west and ...</span>"

		if(recieve_landmark.y > usr.y)
			usr << "<span class='notice'>[recieve_landmark.y - usr.y] tiles north.</span>"
		else
			usr << "<span class='notice'>[usr.y - recieve_landmark.y] tiles south.</span>"

		usr.mind.store_memory("<b>Drop location</b>: \"[recieve_landmark.x]\", \"[recieve_landmark.y]\"")
	else
		recieve_landmark = safepick(drop_points)
		if(recieve_landmark)
			SendSupplies()
	return