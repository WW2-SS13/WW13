/obj/machinery/computer/shuttle_control/mining
	name = "mining shuttle control console"
	shuttle_tag = "Mining"
	//req_access = list(access_mining)
	circuit = /obj/item/weapon/circuitboard/mining_shuttle

/obj/machinery/computer/shuttle_control/engineering
	name = "engineering shuttle control console"
	shuttle_tag = "Engineering"
	//req_one_access = list(access_engine_equip,access_atmospherics)
	circuit = /obj/item/weapon/circuitboard/engineering_shuttle

/obj/machinery/computer/shuttle_control/research
	name = "research shuttle control console"
	shuttle_tag = "Research"
	//req_access = list(access_research)
	circuit = /obj/item/weapon/circuitboard/research_shuttle

/obj/machinery/computer/shuttle_control/multi/nato1
	name = "Helicopter controls"
	icon_state = ":3"
	density = 0
	shuttle_tag = "Helicopter1"
	req_one_access = list(access_nato_squad_leader, access_nato_commander)
	circuit = /obj/item/weapon/circuitboard/research_shuttle
	pixel_y = 1

/obj/machinery/computer/shuttle_control/multi/nato2
	name = "Helicopter controls"
	icon_state = ":3"
	density = 0
	shuttle_tag = "Helicopter2"
	req_one_access = list(access_nato_squad_leader, access_nato_commander)
	circuit = /obj/item/weapon/circuitboard/research_shuttle
	pixel_y = 1