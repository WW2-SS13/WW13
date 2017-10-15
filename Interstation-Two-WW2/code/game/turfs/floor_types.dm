/turf/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0
	layer = 2

/turf/shuttle/floor
	name = "floor"
	icon_state = "floor"

/turf/shuttle/floor/mining
	icon_state = "6,19"
	icon = 'icons/turf/shuttlemining.dmi'

/turf/shuttle/plating
	name = "plating"
	icon = 'icons/turf/flooring/plating.dmi'
	icon_state = "plating"
	level = 1

/turf/shuttle/plating/is_plating()
	return 1

/turf/floor/plating/under
	name = "underplating"
	icon_state = "un"
	icon = 'icons/turf/un.dmi'
	var/icon_base = "un"
	flags = TURF_HAS_EDGES | TURF_HAS_CORNERS
	var/has_base_range = null
	//style = "underplating"

/turf/floor/plating/under/update_icon(var/update_neighbors)
	// Set initial icon and strings.
	if(!isnull(set_update_icon) && istext(set_update_icon))
		icon_state = set_update_icon
	else if(flooring_override)
		icon_state = flooring_override
	else
		icon_state = icon_base
		if(has_base_range)
			icon_state = "[icon_state][rand(0,has_base_range)]"
			flooring_override = icon_state
	// Apply edges, corners, and inner corners.
	overlays.Cut()
	var/has_border = 0
	if(isnull(set_update_icon) && (flags & TURF_HAS_EDGES))
		for(var/step_dir in cardinal)
			var/turf/floor/T = get_step(src, step_dir)
			if((!istype(T) || !T || T.name != name) && !istype(T, /turf/open) && !istype(T, /turf/space))
				has_border |= step_dir
				overlays |= get_flooring_overlayu("[icon_base]-edge-[step_dir]", "[icon_base]_edges", step_dir)
		if ((flags & TURF_USE0ICON) && has_border)
			icon_state = icon_base+"0"

		// There has to be a concise numerical way to do this but I am too noob.
		if((has_border & NORTH) && (has_border & EAST))
			overlays |= get_flooring_overlayu("[icon_base]-edge-[NORTHEAST]", "[icon_base]_edges", NORTHEAST)
		if((has_border & NORTH) && (has_border & WEST))
			overlays |= get_flooring_overlayu("[icon_base]-edge-[NORTHWEST]", "[icon_base]_edges", NORTHWEST)
		if((has_border & SOUTH) && (has_border & EAST))
			overlays |= get_flooring_overlayu("[icon_base]-edge-[SOUTHEAST]", "[icon_base]_edges", SOUTHEAST)
		if((has_border & SOUTH) && (has_border & WEST))
			overlays |= get_flooring_overlayu("[icon_base]-edge-[SOUTHWEST]", "[icon_base]_edges", SOUTHWEST)

		if(flags & TURF_HAS_CORNERS)
			// As above re: concise numerical way to do this.
			if(!(has_border & NORTH))
				if(!(has_border & EAST))
					var/turf/floor/T = get_step(src, NORTHEAST)
					if((!istype(T) || !T || T.name != name) && !istype(T, /turf/open) && !istype(T, /turf/space))
						overlays |= get_flooring_overlayu("[icon_base]-corner-[NORTHEAST]", "[icon_base]_corners", NORTHEAST)
				if(!(has_border & WEST))
					var/turf/floor/T = get_step(src, NORTHWEST)
					if((!istype(T) || !T || T.name != name) && !istype(T, /turf/open) && !istype(T, /turf/space))
						overlays |= get_flooring_overlayu("[icon_base]-corner-[NORTHWEST]", "[icon_base]_corners", NORTHWEST)
			if(!(has_border & SOUTH))
				if(!(has_border & EAST))
					var/turf/floor/T = get_step(src, SOUTHEAST)
					if((!istype(T) || !T || T.name != name) && !istype(T, /turf/open) && !istype(T, /turf/space))
						overlays |= get_flooring_overlayu("[icon_base]-corner-[SOUTHEAST]", "[icon_base]_corners", SOUTHEAST)
				if(!(has_border & WEST))
					var/turf/floor/T = get_step(src, SOUTHWEST)
					if((!istype(T) || !T || T.name != name) && !istype(T, /turf/open) && !istype(T, /turf/space))
						overlays |= get_flooring_overlayu("[icon_base]-corner-[SOUTHWEST]", "[icon_base]_corners", SOUTHWEST)

	if(decals && decals.len)
		overlays |= decals

	if(is_plating() && !(isnull(broken) && isnull(burnt))) //temp, todo
		icon = 'icons/turf/floors.dmi'
		icon_state = "dmg[rand(1,4)]"
	else
		if(!isnull(broken) && (flags & TURF_CAN_BREAK))
			overlays |= get_flooring_overlayu("[icon_base]-broken-[broken]", "broken[broken]")
		if(!isnull(burnt) && (flags & TURF_CAN_BURN))
			overlays |= get_flooring_overlayu("[icon_base]-burned-[burnt]", "burned[burnt]")
	if(update_neighbors)
		for(var/turf/floor/F in range(src, 1))
			if(F == src)
				continue
			F.update_icon()

/turf/floor/plating/under/proc/get_flooring_overlayu(var/cache_key, var/icon_base, var/icon_dir = 0)
	if(!flooring_cache[cache_key])
		var/image/I = image(icon = icon, icon_state = icon_base, dir = icon_dir)
		I.layer = layer
		flooring_cache[cache_key] = I
	return flooring_cache[cache_key]


/turf/floor/plating/under/New()
	..()
	update_icon(1)

/turf/floor/plating/under/Entered(mob/living/M as mob)
	..()
	for(var/obj/structure/catwalk/C in get_turf(src))
		return

	if(!ishuman(M) || !has_gravity(src))
		return
	if(M.m_intent == "run")
		if(prob(75))
			M.adjustBruteLoss(5)
			M.weakened += 3
			playsound(src, 'sound/effects/bang.ogg', 50, 1)
			M << "<span class='warning'>You tripped over!</span>"
			return

/turf/floor/plating/under/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = C
		if(R.amount <= 2)
			return
		else
			R.use(2)
			user << "<span class='notice'>You start connecting [R.name]s to [src.name], creating catwalk ...</span>"
			if(do_after(user,50))
				src.alpha = 0
				var/obj/structure/catwalk/CT = new /obj/structure/catwalk(src.loc)
				src.contents += CT
			return
	return

/turf/shuttle/plating/vox //Skipjack plating
//	oxygen = 0
//	nitrogen = MOLES_N2STANDARD + MOLES_O2STANDARD

/turf/shuttle/floor4 // Added this floor tile so that I have a seperate turf to check in the shuttle -- Polymorph
	name = "Brig floor"        // Also added it into the 2x3 brig area of the shuttle.
	icon_state = "floor4"

/turf/shuttle/floor4/vox //skipjack floors
	name = "skipjack floor"
//	oxygen = 0
//	nitrogen = MOLES_N2STANDARD + MOLES_O2STANDARD

/turf/floor/airless
	icon_state = "floor"
	name = "airless floor"
//	oxygen = 0
//	nitrogen = 0
	temperature = TCMB

	New()
		..()
		name = "floor"

/turf/floor/airless/ceiling
	icon_state = "rockvault"

/turf/floor/light
	name = "Light floor"
	light_range = 5
	icon_state = "light_on"
	floor_type = /obj/item/stack/tile/light

	New()
		var/n = name //just in case commands rename it in the ..() call
		..()
		spawn(4)
			if(src)
				update_icon()
				name = n

/turf/floor/wood
	name = "floor"
	icon_state = "wood"
	floor_type = /obj/item/stack/tile/wood
	stepsound = "wood"

/turf/floor/wood/broken
	name = "floor"
	icon_state = "wood-broken"

/turf/floor/wood/broken/New()
	..()
	icon_state = "wood-broken[rand(1,7)]"

/turf/floor/vault
	icon_state = "rockvault"

	New(location,type)
		..()
		icon_state = "[type]vault"

/turf/wall/vault
	icon_state = "rockvault"

	New(location,type)
		..()
		icon_state = "[type]vault"

/turf/floor/engine
	name = "reinforced floor"
	icon_state = "engine"
	thermal_conductivity = 0.025
	heat_capacity = 325000
	intact = 0

/turf/floor/engine/nitrogen
//	oxygen = 0

/turf/floor/engine/attackby(obj/item/weapon/C as obj, mob/user as mob)
	if(!C)
		return
	if(!user)
		return
	if(istype(C, /obj/item/weapon/wrench))
		user << "\blue Removing rods..."
		playsound(src, 'sound/items/Ratchet.ogg', 80, 1)
		if(do_after(user, 30))
			PoolOrNew(/obj/item/stack/rods, list(loc, 2))
			ChangeTurf(/turf/floor)
			var/turf/floor/F = src
			F.make_plating()
			return

/turf/floor/engine/cult
	name = "engraved floor"
	icon_state = "cult"

/turf/floor/engine/n20
	New()
		. = ..()
	//	assume_gas("sleeping_agent", 2000)

/turf/floor/engine/vacuum
	name = "vacuum floor"
	icon_state = "engine"
//	oxygen = 0
//	nitrogen = 0
	temperature = TCMB

/turf/floor/plating
	name = "plating"
	icon_state = "plating"
	floor_type = null
	intact = 0

/turf/floor/plating/ex_act(severity)
		//set src in oview(1)
	switch(severity)
		if(1.0)
			ChangeTurf(world.turf)
		if(2.0)
			if(prob(40))
				ChangeTurf(world.turf)
	return

/turf/floor/plating/airless
	icon_state = "plating"
	name = "airless plating"
//	oxygen = 0
//	nitrogen = 0
	temperature = TCMB

	New()
		..()
		name = "plating"

/turf/floor/bluegrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "bcircuit"

/turf/floor/greengrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "gcircuit"


/turf/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0
	layer = TURF_LAYER

/turf/shuttle/wall
	name = "wall"
	icon_state = "wall1"
	opacity = 1
	density = 1
//	blocks_air = 1

/turf/shuttle/floor
	name = "floor"
	icon_state = "floor"

/turf/shuttle/plating
	name = "plating"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"

/turf/shuttle/plating/vox	//Skipjack plating
//	oxygen = 0
//	nitrogen = MOLES_N2STANDARD + MOLES_O2STANDARD

/turf/shuttle/floor4 // Added this floor tile so that I have a seperate turf to check in the shuttle -- Polymorph
	name = "Brig floor"        // Also added it into the 2x3 brig area of the shuttle.
	icon_state = "floor4"

/turf/shuttle/floor4/vox	//skipjack floors
	name = "skipjack floor"
//	oxygen = 0
//	nitrogen = MOLES_N2STANDARD + MOLES_O2STANDARD


/turf/floor/grass
	name = "Grass patch"
	icon_state = "grass1"
	floor_type = /obj/item/stack/tile/grass

	New()
		icon_state = "grass[pick("1","2","3","4")]"
		..()
		spawn(4)
			if(src)
				update_icon()
				for(var/direction in cardinal)
					if(istype(get_step(src,direction),/turf/floor))
						var/turf/floor/FF = get_step(src,direction)
						FF.update_icon() //so siding get updated properly

/turf/floor/carpet
	name = "Carpet"
	icon_state = "carpet"
	floor_type = /obj/item/stack/tile/carpet

	New()
		if(!icon_state)
			icon_state = "carpet"
		..()
		spawn(4)
			if(src)
				update_icon()
				for(var/direction in list(1,2,4,8,5,6,9,10))
					if(istype(get_step(src,direction),/turf/floor))
						var/turf/floor/FF = get_step(src,direction)
						FF.update_icon() //so siding get updated properly



/turf/floor/plating/ironsand/New()
	..()
	icon = 'icons/turf/floors.dmi'
	name = "Iron Sand"
	icon_state = "ironsand[rand(1,15)]"

/turf/floor/plating/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"

/turf/floor/plating/snow/ex_act(severity)
	return

/turf/floor/plating/grass
	name = "grass"
	icon = 'icons/turf/floors.dmi'
	icon_state = "grass_dark"
	interior = 0
	stepsound = "dirt"
	uses_winter_overlay = 1

/turf/floor/plating/grass/New()
	..()
	grass_turf_list += src

/turf/floor/plating/grass/wild
	name = "wild grass"

/turf/floor/plating/grass/wild/New()
	..()
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass[rand(0,3)]"

/turf/floor/plating/beach
	name = "Beach"
	icon = 'icons/misc/beach.dmi'

/turf/floor/plating/beach/sand
	name = "Sand"
	icon_state = "sand"

/turf/floor/plating/beach/coastline
	name = "Coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/floor/plating/beach/water
	name = "Water"
	icon_state = "seadeep"

/turf/floor/plating/beach/water/ex_act(severity)
	return

/turf/floor/plating/beach/water/New()
	..()
	overlays += image("icon"='icons/misc/beach.dmi',"icon_state"="water5","layer"=MOB_LAYER+0.1)

/turf/floor/plating/dirt
	name = "dirt"
	icon = 'icons/turf/floors.dmi'
	icon_state = "dirt"
	interior = 0
	stepsound = "dirt"

/turf/floor/plating/sand
	name = "sand"
	icon = 'icons/turf/floors.dmi'
	icon_state = "sand1"
	interior = 0
	stepsound = "dirt"

/turf/floor/plating/sand/New()
	..()
	icon_state = "sand[rand(1, 3)]"

/turf/floor/plating/concrete
	name = "concrete"
	icon = 'icons/turf/floors.dmi'
	icon_state = "concrete6"
	interior = 0

/turf/floor/plating/concrete/New()
	..()
	if(icon_state == "concrete2")
		icon_state = pick("concrete2", "concrete3")
		return
	if(icon_state == "concrete6")
		icon_state = pick("concrete6", "concrete7")
		return
	if(icon_state == "concrete10")
		icon_state = pick("concrete10", "concrete11")
		return

/turf/floor/plating/road
	name = "road"
	icon = 'icons/turf/floors.dmi'
	icon_state = "road_1"
	interior = 0
	var/icon_mode = ""

/turf/floor/plating/road/New()
	..()
	icon_state = "road_[icon_mode][rand(1, 3)]"

/turf/floor/plating/cobblestone
	name = "road"
	icon = 'icons/turf/floors.dmi'
	icon_state = "cobble_horizontal"
	interior = 0

/turf/floor/plating/cobblestone/dark
	name = "road"
	icon = 'icons/turf/floors.dmi'
	icon_state = "cobble_horizontal_dark"
	interior = 0

/turf/floor/plating/cobblestone/vertical
	name = "road"
	icon = 'icons/turf/floors.dmi'
	icon_state = "cobble_vertical"
	interior = 0

/turf/floor/plating/cobblestone/vertical/dark
	name = "road"
	icon = 'icons/turf/floors.dmi'
	icon_state = "cobble_vertical_dark"
	interior = 0

turf/air
	icon_state = "air"
	name = "air"
	icon = 'icons/WW2/ju57.dmi'

turf/junkers
	icon = 'icons/WW2/ju57.dmi'
	name = "Ju-52 cassis"

