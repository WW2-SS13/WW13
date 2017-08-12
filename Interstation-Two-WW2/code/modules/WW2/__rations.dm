// the only reason this exists is because apparently new pick(listoftypes)
// is invalid code

/proc/new_ration(faction, sort)
	switch (faction)
		if ("GERMAN")
			switch (sort)
				if ("solid")
					var/solid = pick(german_rations_solids)
					return new solid
				if ("liquid")
					var/liquid = pick(german_rations_liquids)
					return new liquid
				if ("dessert")
					var/liquid = pick(german_rations_desserts)
					return new liquid
		if ("SOVIET")
			switch (sort)
				if ("solid")
					var/solid = pick(soviet_rations_solids)
					return new solid
				if ("liquid")
					var/liquid = pick(soviet_rations_liquids)
					return new liquid
				if ("dessert")
					var/liquid = pick(soviet_rations_desserts)
					return new liquid
// GERMAN RATIONS

var/list/german_rations_solids = list(/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread,
/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesewheel,
/obj/item/weapon/reagent_containers/food/snacks/sandwich,
/obj/item/weapon/reagent_containers/food/snacks/mint
)

var/list/german_rations_liquids = list(
/obj/item/weapon/reagent_containers/food/snacks/mushroomsoup,
/obj/item/weapon/reagent_containers/food/snacks/stew,
)

var/list/german_rations_desserts = list(
/obj/item/weapon/reagent_containers/food/snacks/sliceable/carrotcake,
/obj/item/weapon/reagent_containers/food/snacks/appletart,
)

// soviet RATIONS

var/list/soviet_rations_solids = list(/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread,
/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesewheel,
/obj/item/weapon/reagent_containers/food/snacks/sandwich,
/obj/item/weapon/reagent_containers/food/snacks/mint
)

var/list/soviet_rations_liquids = list(
/obj/item/weapon/reagent_containers/food/snacks/mushroomsoup,
/obj/item/weapon/reagent_containers/food/snacks/beetsoup,
)

// blin no dessert in mother russia
var/list/soviet_rations_desserts = list(

)
