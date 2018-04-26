var/list/engineer_exclusive_recipe_types = list(/obj/structure/girder, /obj/structure/anti_tank)

/material/proc/get_recipes()
	if(!recipes)
		generate_recipes()
	return recipes

/material/proc/generate_recipes()
	recipes = list()

	// If is_brittle() returns true, these are only good for a single strike.
	recipes += new/datum/stack_recipe("[display_name] ashtray", /obj/item/weapon/material/ashtray, 2, _one_per_turf = TRUE, _on_floor = TRUE, _supplied_material = "[name]")
	recipes += new/datum/stack_recipe("[display_name] spoon", /obj/item/weapon/material/kitchen/utensil/spoon/plastic, TRUE, _on_floor = TRUE, _supplied_material = "[name]")

	if(integrity>=50)
	//	recipes += new/datum/stack_recipe("[display_name] door", /obj/machinery/door/unpowered/simple, 10, _time = 35, _one_per_turf = TRUE, _on_floor = TRUE, _supplied_material = "[name]")
		recipes += new/datum/stack_recipe("[display_name] barricade", /obj/structure/barricade, 5, _time = 35, _one_per_turf = TRUE, _on_floor = TRUE, _supplied_material = "[name]")
		recipes += new/datum/stack_recipe("[display_name] stool", /obj/item/weapon/stool, _one_per_turf = TRUE, _on_floor = TRUE, _supplied_material = "[name]")
		if (!istype(src, /material/wood))
			recipes += new/datum/stack_recipe("[display_name] chair", /obj/structure/bed/chair, _one_per_turf = TRUE, _on_floor = TRUE, _supplied_material = "[name]")
		recipes += new/datum/stack_recipe("[display_name] bed", /obj/structure/bed, 2, _one_per_turf = TRUE, _on_floor = TRUE, _supplied_material = "[name]")

	if(hardness>50)
		recipes += new/datum/stack_recipe("[display_name] fork", /obj/item/weapon/material/kitchen/utensil/fork/plastic, TRUE, _on_floor = TRUE, _supplied_material = "[name]")
		recipes += new/datum/stack_recipe("[display_name] knife", /obj/item/weapon/material/kitchen/utensil/knife/plastic, TRUE, _on_floor = TRUE, _supplied_material = "[name]")
		recipes += new/datum/stack_recipe("[display_name] blade", /obj/item/weapon/material/butterflyblade, 6, _time = 15, _one_per_turf = FALSE, _on_floor = TRUE, _supplied_material = "[name]")

/material/steel/generate_recipes()
	..()

	recipes += new/datum/stack_recipe_list("comfy chairs", list( \
		new/datum/stack_recipe("beige comfy chair", /obj/structure/bed/chair/comfy/beige, 2, _one_per_turf = TRUE, _on_floor = TRUE), \
		new/datum/stack_recipe("black comfy chair", /obj/structure/bed/chair/comfy/black, 2, _one_per_turf = TRUE, _on_floor = TRUE), \
		new/datum/stack_recipe("brown comfy chair", /obj/structure/bed/chair/comfy/brown, 2, _one_per_turf = TRUE, _on_floor = TRUE), \
		new/datum/stack_recipe("lime comfy chair", /obj/structure/bed/chair/comfy/lime, 2, _one_per_turf = TRUE, _on_floor = TRUE), \
		new/datum/stack_recipe("teal comfy chair", /obj/structure/bed/chair/comfy/teal, 2, _one_per_turf = TRUE, _on_floor = TRUE), \
		new/datum/stack_recipe("red comfy chair", /obj/structure/bed/chair/comfy/red, 2, _one_per_turf = TRUE, _on_floor = TRUE), \
		new/datum/stack_recipe("blue comfy chair", /obj/structure/bed/chair/comfy/blue, 2, _one_per_turf = TRUE, _on_floor = TRUE), \
		new/datum/stack_recipe("purple comfy chair", /obj/structure/bed/chair/comfy/purp, 2, _one_per_turf = TRUE, _on_floor = TRUE), \
		new/datum/stack_recipe("green comfy chair", /obj/structure/bed/chair/comfy/green, 2, _one_per_turf = TRUE, _on_floor = TRUE), \
		))


	recipes += new/datum/stack_recipe_list("floor tile", list( \
		new/datum/stack_recipe("regular floor tile", /obj/item/stack/tile/floor, TRUE, 4, 20), \
		new/datum/stack_recipe("grey techfloor tile", /obj/item/stack/tile/floor/techgrey, TRUE, 4, 20), \
		new/datum/stack_recipe("grid techfloor tile", /obj/item/stack/tile/floor/techgrid, TRUE, 4, 20), \
		))

	recipes += new/datum/stack_recipe("table", /obj/structure/table, TRUE, _time = 7, _one_per_turf = TRUE, _on_floor = TRUE)
	recipes += new/datum/stack_recipe("rack", /obj/structure/table/rack, TRUE, _time = 5, _one_per_turf = TRUE, _on_floor = TRUE)
	recipes += new/datum/stack_recipe("closet", /obj/structure/closet, 2, _time = 10, _one_per_turf = TRUE, _on_floor = TRUE)

	recipes += new/datum/stack_recipe("metal rod", /obj/item/stack/rods, TRUE, 2, 60)
	recipes += new/datum/stack_recipe("wall girders", /obj/structure/girder, 2, _time = 50, _one_per_turf = TRUE, _on_floor = TRUE)
	recipes += new/datum/stack_recipe("railing", /obj/structure/railing, 2, _time = 50, _one_per_turf = FALSE, _on_floor = TRUE)

	recipes += new/datum/stack_recipe("grenade casing", /obj/item/weapon/grenade/chem_grenade)
	recipes += new/datum/stack_recipe("unlocked door", /obj/structure/simple_door/key_door/anyone, 5, _time = 35, _one_per_turf = TRUE, _on_floor = TRUE)
	recipes += new/datum/stack_recipe("locked door", /obj/structure/simple_door/key_door/anyone, 5, _time = 35, _one_per_turf = TRUE, _on_floor = TRUE)
	recipes += new/datum/stack_recipe("anti-tank hedgehog", /obj/structure/anti_tank, 15, _time = 60, _one_per_turf = TRUE, _on_floor = TRUE)

/material/wood/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("sandals", /obj/item/clothing/shoes/sandal, TRUE)
	recipes += new/datum/stack_recipe("floor tile", /obj/item/stack/tile/wood, TRUE, 4, 20)
	recipes += new/datum/stack_recipe("chair", /obj/structure/bed/chair/wood, 3, _time = 7, _one_per_turf = TRUE, _on_floor = TRUE)
	recipes += new/datum/stack_recipe("coffin", /obj/structure/closet/coffin, 5, _time = 10, _one_per_turf = TRUE, _on_floor = TRUE)
	recipes += new/datum/stack_recipe("book shelf", /obj/structure/bookcase, 5, _time = 10, _one_per_turf = TRUE, _on_floor = TRUE)
	recipes += new/datum/stack_recipe("unlocked door", /obj/structure/simple_door/key_door/anyone/wood, 5, _time = 30, _one_per_turf = TRUE, _on_floor = TRUE)
	recipes += new/datum/stack_recipe("locked door", /obj/structure/simple_door/key_door/anyone/wood, 5, _time = 30, _one_per_turf = TRUE, _on_floor = TRUE)
	recipes += new/datum/stack_recipe("table", /obj/structure/table/wood, TRUE, _time = 7, _one_per_turf = TRUE, _on_floor = TRUE)

/material/barbedwire/generate_recipes()
	recipes = list(new/datum/stack_recipe("barbwire", /obj/structure/barbwire, _time = 20))

/material/rope/generate_recipes()
	recipes = list(new/datum/stack_recipe("noose", /obj/structure/noose, _time = 20))

/material/glass/generate_recipes()
	recipes = list(new/datum/stack_recipe("window", /obj/structure/window/classic, _time = 30, _one_per_turf = TRUE, _on_floor = TRUE))


