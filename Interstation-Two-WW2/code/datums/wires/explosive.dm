/datum/wires/explosive
	wire_count = TRUE

var/const/WIRE_EXPLODE = TRUE

/datum/wires/explosive/proc/explode()
	return

/datum/wires/explosive/UpdatePulsed(var/index)
	switch(index)
		if(WIRE_EXPLODE)
			explode()

/datum/wires/explosive/UpdateCut(var/index, var/mended)
	switch(index)
		if(WIRE_EXPLODE)
			if(!mended)
				explode()

/datum/wires/explosive/c4
	holder_type = /obj/item/weapon/plastique

/datum/wires/explosive/c4/CanUse(var/mob/living/L)
	var/obj/item/weapon/plastique/P = holder
	if(P.open_panel)
		return TRUE
	return FALSE

/datum/wires/explosive/c4/explode()
	var/obj/item/weapon/plastique/P = holder
	P.explode(get_turf(P))
