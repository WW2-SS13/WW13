
/////////////////////////////
////WW 2 injectors define////
/////////////////////////////


/obj/item/weapon/reagent_containers/hypospray/autoinjector/ww2
	name = "ww2 autoinjector"
	icon = 'icons/WW2/medical.dmi'
	icon_state = "ww2_injector"
	w_class = 2
	volume = 5

/obj/item/weapon/reagent_containers/hypospray/autoinjector/ww2/update_icon()
	if(reagents.total_volume >= FALSE)
		icon_state = "ww2_injector_full"
	else
		icon_state = "ww2_injector_empty"

/obj/item/weapon/reagent_containers/hypospray/autoinjector/ww2/morphine
	name = "Morphine injector"
	desc = "Injector containing 5 units of morphine. Administer two of these to make someone sleep."

	New()
		..()
		reagents.del_reagents(TRUE)
		reagents.add_reagent("morphine", 5)
