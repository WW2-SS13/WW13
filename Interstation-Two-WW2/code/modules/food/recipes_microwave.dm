// see code/datums/recipe.dm

/datum/recipe/food
	var/base_cooking_time = 50

/datum/recipe/food/proc/calculate_cooking_time()
	return (base_cooking_time + (reagents.len*4))

/datum/recipe/food/friedegg
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/friedegg

/datum/recipe/food/boiledegg
	reagents = list("water" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/boiledegg

/datum/recipe/food/jellydonut
	reagents = list("berryjuice" = 5, "sugar" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/donut/jelly

/datum/recipe/food/jellydonut/cherry
	reagents = list("cherryjelly" = 5, "sugar" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/donut/cherryjelly

/datum/recipe/food/donut
	reagents = list("sugar" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/donut/normal

/datum/recipe/food/humanburger
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/human,
		/obj/item/weapon/reagent_containers/food/snacks/bun
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/human/burger

/datum/recipe/food/plainburger
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/weapon/reagent_containers/food/snacks/meat //do not place this recipe before /datum/recipe/food/humanburger
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/monkeyburger

/datum/recipe/food/tofuburger
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/weapon/reagent_containers/food/snacks/tofu
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/tofuburger

/datum/recipe/food/waffles
	reagents = list("sugar" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/waffles

/datum/recipe/food/meatbread
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/meatbread

/datum/recipe/food/bananabread
	fruit = list("banana" = TRUE)
	reagents = list("milk" = 5, "sugar" = 15)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/bananabread

/datum/recipe/food/omelette
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/omelette

/datum/recipe/food/muffin
	reagents = list("milk" = 5, "sugar" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/muffin

/datum/recipe/food/eggplantparm
	fruit = list("eggplant" = TRUE)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
		)
	result = /obj/item/weapon/reagent_containers/food/snacks/eggplantparm

/datum/recipe/food/meatpie
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/meatpie

/datum/recipe/food/tofupie
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/tofupie

/datum/recipe/food/pie
	fruit = list("banana" = TRUE)
	reagents = list("sugar" = 5)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/weapon/reagent_containers/food/snacks/pie

/datum/recipe/food/cherrypie
	fruit = list("cherries" = TRUE)
	reagents = list("sugar" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cherrypie

/datum/recipe/food/berryclafoutis
	fruit = list("berries" = TRUE)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/berryclafoutis

/datum/recipe/food/monkeykabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/weapon/reagent_containers/food/snacks/meat/monkey,
		/obj/item/weapon/reagent_containers/food/snacks/meat/monkey,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/monkeykabob

/datum/recipe/food/tofukabob
	items = list(
		/obj/item/stack/rods,
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/tofukabob

/datum/recipe/food/tofubread
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/tofubread

/datum/recipe/food/loadedbakedpotato
	fruit = list("potato" = TRUE)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/cheesewedge)
	result = /obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato

/datum/recipe/food/cheesyfries
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/fries,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cheesyfries

/datum/recipe/food/cubancarp
	fruit = list("chili" = TRUE)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cubancarp

/datum/recipe/food/popcorn
	fruit = list("corn" = TRUE)
	result = /obj/item/weapon/reagent_containers/food/snacks/popcorn

/datum/recipe/food/cookie
	reagents = list("milk" = 5, "sugar" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/chocolatebar,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cookie

/datum/recipe/food/fortunecookie
	reagents = list("sugar" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/doughslice,
		/obj/item/weapon/paper,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/fortunecookie
	make_food(var/obj/container as obj)
		var/obj/item/weapon/paper/paper = locate() in container
		paper.loc = null //prevent deletion
		var/obj/item/weapon/reagent_containers/food/snacks/fortunecookie/being_cooked = ..(container)
		paper.loc = being_cooked
		being_cooked.trash = paper //so the paper is left behind as trash without special-snowflake(TM Nodrak) code ~carn
		return being_cooked
	check_items(var/obj/container as obj)
		. = ..()
		if (.)
			var/obj/item/weapon/paper/paper = locate() in container
			if (!paper.info)
				return FALSE
		return .

/datum/recipe/food/meatsteak
	items = list(/obj/item/weapon/reagent_containers/food/snacks/meat)
	result = /obj/item/weapon/reagent_containers/food/snacks/meatsteak

/datum/recipe/food/pizzamargherita
	fruit = list("tomato" = TRUE)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/margherita

/datum/recipe/food/meatpizza
	fruit = list("tomato" = TRUE)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/meat,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/meatpizza

/datum/recipe/food/mushroompizza
	fruit = list("mushroom" = 5, "tomato" = TRUE)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/mushroompizza

/datum/recipe/food/vegetablepizza
	fruit = list("eggplant" = TRUE, "carrot" = TRUE, "corn" = TRUE, "tomato" = TRUE)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza

/datum/recipe/food/meatballsoup
	fruit = list("carrot" = TRUE, "potato" = TRUE)
	reagents = list("water" = 10)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/meatball)
	result = /obj/item/weapon/reagent_containers/food/snacks/meatballsoup

/datum/recipe/food/vegetablesoup
	fruit = list("carrot" = TRUE, "potato" = TRUE, "corn" = TRUE, "eggplant" = TRUE)
	reagents = list("water" = 10)
	result = /obj/item/weapon/reagent_containers/food/snacks/vegetablesoup

/datum/recipe/food/hotchili
	fruit = list("chili" = TRUE, "tomato" = TRUE)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/meat)
	result = /obj/item/weapon/reagent_containers/food/snacks/hotchili

/datum/recipe/food/coldchili
	fruit = list("icechili" = TRUE, "tomato" = TRUE)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/meat)
	result = /obj/item/weapon/reagent_containers/food/snacks/coldchili

/datum/recipe/food/creamcheesebread
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/creamcheesebread

/datum/recipe/food/baguette
	reagents = list("sodiumchloride" = TRUE, "blackpepper" = TRUE)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/baguette

/datum/recipe/food/fishandchips
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/fries,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/fishandchips

/datum/recipe/food/bread
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/egg
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/bread

/datum/recipe/food/sandwich
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meatsteak,
		/obj/item/weapon/reagent_containers/food/snacks/breadslice,
		/obj/item/weapon/reagent_containers/food/snacks/breadslice,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sandwich

/datum/recipe/food/toastedsandwich
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sandwich
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/toastedsandwich

/datum/recipe/food/grilledcheese
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/breadslice,
		/obj/item/weapon/reagent_containers/food/snacks/breadslice,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/grilledcheese

/datum/recipe/food/tomatosoup
	fruit = list("tomato" = 2)
	reagents = list("water" = 10)
	result = /obj/item/weapon/reagent_containers/food/snacks/tomatosoup

/datum/recipe/food/rofflewaffles
	reagents = list("psilocybin" = 5, "sugar" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough,
		/obj/item/weapon/reagent_containers/food/snacks/dough,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/rofflewaffles

/datum/recipe/food/stew
	fruit = list("potato" = TRUE, "tomato" = TRUE, "carrot" = TRUE, "eggplant" = TRUE, "mushroom" = TRUE)
	reagents = list("water" = 10)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/meat)
	result = /obj/item/weapon/reagent_containers/food/snacks/stew

/datum/recipe/food/slimetoast
	reagents = list("slimejelly" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/breadslice,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/jelliedtoast/slime

/datum/recipe/food/jelliedtoast
	reagents = list("cherryjelly" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/breadslice,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/jelliedtoast/cherry

/datum/recipe/food/milosoup
	reagents = list("water" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/soydope,
		/obj/item/weapon/reagent_containers/food/snacks/soydope,
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
		/obj/item/weapon/reagent_containers/food/snacks/tofu,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/milosoup

/datum/recipe/food/stewedsoymeat
	fruit = list("carrot" = TRUE, "tomato" = TRUE)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/soydope,
		/obj/item/weapon/reagent_containers/food/snacks/soydope
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/stewedsoymeat

/datum/recipe/food/boiledspagetti
	reagents = list("water" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/spagetti,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/boiledspagetti

/datum/recipe/food/boiledrice
	reagents = list("water" = 5, "rice" = 10)
	result = /obj/item/weapon/reagent_containers/food/snacks/boiledrice

/datum/recipe/food/ricepudding
	reagents = list("milk" = 5, "rice" = 10)
	result = /obj/item/weapon/reagent_containers/food/snacks/ricepudding

/datum/recipe/food/pastatomato
	fruit = list("tomato" = 2)
	reagents = list("water" = 5)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/spagetti)
	result = /obj/item/weapon/reagent_containers/food/snacks/pastatomato

/datum/recipe/food/poppypretzel
	fruit = list("poppy" = TRUE)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/dough)
	result = /obj/item/weapon/reagent_containers/food/snacks/poppypretzel

/datum/recipe/food/meatballspagetti
	reagents = list("water" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/spagetti,
		/obj/item/weapon/reagent_containers/food/snacks/meatball,
		/obj/item/weapon/reagent_containers/food/snacks/meatball,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/meatballspagetti

/datum/recipe/food/candiedapple
	fruit = list("apple" = TRUE)
	reagents = list("water" = 5, "sugar" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/candiedapple

/datum/recipe/food/applepie
	fruit = list("apple" = TRUE)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough)
	result = /obj/item/weapon/reagent_containers/food/snacks/applepie

/datum/recipe/food/twobread
	reagents = list("wine" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/breadslice,
		/obj/item/weapon/reagent_containers/food/snacks/breadslice,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/twobread

/datum/recipe/food/cherrysandwich
	reagents = list("cherryjelly" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/breadslice,
		/obj/item/weapon/reagent_containers/food/snacks/breadslice,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/jellysandwich/cherry

/datum/recipe/food/bloodsoup
	reagents = list("blood" = 30)
	result = /obj/item/weapon/reagent_containers/food/snacks/bloodsoup

/datum/recipe/food/chocolateegg
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/chocolatebar,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/chocolateegg

/datum/recipe/food/sausage
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/meatball,
		/obj/item/weapon/reagent_containers/food/snacks/cutlet,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sausage

/datum/recipe/food/fishfingers
	reagents = list("flour" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/fishfingers

/datum/recipe/food/pumpkinpie
	fruit = list("pumpkin" = TRUE)
	reagents = list("milk" = 5, "sugar" = 5, "egg" = 3, "flour" = 10)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/pumpkinpie

/datum/recipe/food/mushroomsoup
	fruit = list("mushroom" = TRUE)
	reagents = list("water" = 5, "milk" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/mushroomsoup

/datum/recipe/food/chawanmushi
	fruit = list("mushroom" = TRUE)
	reagents = list("water" = 5, "soysauce" = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/egg
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/chawanmushi

/datum/recipe/food/beetsoup
	fruit = list("whitebeet" = TRUE, "cabbage" = TRUE)
	reagents = list("water" = 10)
	result = /obj/item/weapon/reagent_containers/food/snacks/beetsoup

/datum/recipe/food/appletart
	fruit = list("goldapple" = TRUE)
	reagents = list("sugar" = 5, "milk" = 5, "flour" = 10)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/appletart

/datum/recipe/food/tossedsalad
	fruit = list("cabbage" = 2, "tomato" = TRUE, "carrot" = TRUE, "apple" = TRUE)
	result = /obj/item/weapon/reagent_containers/food/snacks/tossedsalad

/datum/recipe/food/validsalad
	fruit = list("potato" = TRUE, "ambrosia" = 3)
	items = list(/obj/item/weapon/reagent_containers/food/snacks/meatball)
	result = /obj/item/weapon/reagent_containers/food/snacks/validsalad
	make_food(var/obj/container as obj)
		var/obj/item/weapon/reagent_containers/food/snacks/validsalad/being_cooked = ..(container)
		being_cooked.reagents.del_reagent("toxin")
		return being_cooked

/datum/recipe/food/cracker
	reagents = list("sodiumchloride" = TRUE)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/doughslice
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cracker

/datum/recipe/food/stuffing
	reagents = list("water" = 5, "sodiumchloride" = TRUE, "blackpepper" = TRUE)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread,
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/stuffing

//////////////////////////////////////////
// bs12 food port stuff
//////////////////////////////////////////

/datum/recipe/food/taco
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/doughslice,
		/obj/item/weapon/reagent_containers/food/snacks/cutlet,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/taco

/datum/recipe/food/bun
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/dough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/bun

/datum/recipe/food/flatbread
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/flatbread

/datum/recipe/food/meatball
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/rawmeatball
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/meatball

/datum/recipe/food/cutlet
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/rawcutlet
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cutlet

/datum/recipe/food/fries
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/rawsticks
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/fries

/datum/recipe/food/mint
	reagents = list("sugar" = 5, "frostoil" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/mint

// Cakes.
/datum/recipe/food/cake
	reagents = list("milk" = 5, "flour" = 15, "sugar" = 15, "egg" = 9)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/plaincake

/datum/recipe/food/cake/carrot
	fruit = list("carrot" = 3)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/carrotcake

/datum/recipe/food/cake/cheese
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesecake

/datum/recipe/food/cake/orange
	fruit = list("orange" = TRUE)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "orangejuice" = 3, "sugar" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/orangecake

/datum/recipe/food/cake/lime
	fruit = list("lime" = TRUE)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "limejuice" = 3, "sugar" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/limecake

/datum/recipe/food/cake/lemon
	fruit = list("lemon" = TRUE)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "lemonjuice" = 3, "sugar" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/lemoncake

/datum/recipe/food/cake/chocolate
	items = list(/obj/item/weapon/reagent_containers/food/snacks/chocolatebar)
	reagents = list("milk" = 5, "flour" = 15, "egg" = 9, "coco" = 4, "sugar" = 5)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/chocolatecake

/datum/recipe/food/cake/birthday
	items = list(/obj/item/clothing/head/cakehat)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/birthdaycake

/datum/recipe/food/cake/apple
	fruit = list("apple" = 2)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/applecake