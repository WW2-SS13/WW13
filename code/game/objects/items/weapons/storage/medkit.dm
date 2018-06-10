/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 */

/*
 * First Aid Kits
 */
/obj/item/weapon/storage/firstaid
	name = "first-aid kit"
	desc = "It's an emergency medical kit for general wounds."
	icon_state = "firstaid"
	throw_speed = 2
	throw_range = 8
	var/empty = FALSE


/obj/item/weapon/storage/firstaid/fire
	name = "fire first-aid kit"
	desc = "It's an emergency medical kit for burns."
	icon_state = "ointment"
	item_state = "firstaid-ointment"

	New()
		..()
		if (empty) return

		icon_state = pick("ointment","firefirstaid")

		new /obj/item/stack/medical/ointment( src )
		new /obj/item/stack/medical/ointment( src )
		new /obj/item/weapon/reagent_containers/pill/kelotane( src )
		new /obj/item/weapon/reagent_containers/pill/kelotane( src )
		new /obj/item/weapon/reagent_containers/pill/kelotane( src ) //Replaced ointment with these since they actually work --Errorage
		return


/obj/item/weapon/storage/firstaid/regular
	icon_state = "firstaid"

	New()
		..()
		if (empty) return
		new /obj/item/stack/medical/bruise_pack(src)
		new /obj/item/stack/medical/bruise_pack(src)
		new /obj/item/stack/medical/bruise_pack(src)
		new /obj/item/stack/medical/ointment(src)
		new /obj/item/stack/medical/ointment(src)
		return

/obj/item/weapon/storage/firstaid/toxin
	name = "toxin first aid"
	desc = "Used to treat high amounts of toxins in the body."
	icon_state = "antitoxin"
	item_state = "firstaid-toxin"

	New()
		..()
		if (empty) return

		icon_state = pick("antitoxin","antitoxfirstaid","antitoxfirstaid2","antitoxfirstaid3")

		new /obj/item/weapon/reagent_containers/syringe/antitoxin( src )
		new /obj/item/weapon/reagent_containers/syringe/antitoxin( src )
		new /obj/item/weapon/reagent_containers/syringe/antitoxin( src )
		new /obj/item/weapon/reagent_containers/pill/antitox( src )
		new /obj/item/weapon/reagent_containers/pill/antitox( src )
		new /obj/item/weapon/reagent_containers/pill/antitox( src )
		return

/obj/item/weapon/storage/firstaid/o2
	name = "oxygen deprivation first aid"
	desc = "A box full of tools and chemicals for treating oxygen deprivation."
	icon_state = "o2"
	item_state = "firstaid-o2"

	New()
		..()
		if (empty) return
		new /obj/item/weapon/reagent_containers/pill/dexalin( src )
		new /obj/item/weapon/reagent_containers/pill/dexalin( src )
		new /obj/item/weapon/reagent_containers/pill/dexalin( src )
		new /obj/item/weapon/reagent_containers/pill/dexalin( src )
		new /obj/item/weapon/reagent_containers/syringe/inaprovaline( src )
		return

/obj/item/weapon/storage/firstaid/adv
	name = "advanced first-aid kit"
	desc = "Contains advanced medical treatments."
	icon_state = "advfirstaid"
	item_state = "firstaid-advanced"

/obj/item/weapon/storage/firstaid/adv/New()
	..()
	if (empty) return
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/advanced/ointment(src)
	new /obj/item/stack/medical/splint(src)
	return

/obj/item/weapon/storage/firstaid/combat
	name = "combat medicine kit"
	desc = "Contains advanced medicine used in combat."
	icon_state = "bezerk"
	item_state = "firstaid-advanced"

/obj/item/weapon/storage/firstaid/combat/New()
	..()
	if (empty) return
	new /obj/item/weapon/storage/pill_bottle/bicaridine(src)
	new /obj/item/weapon/storage/pill_bottle/dermaline(src)
	new /obj/item/weapon/storage/pill_bottle/dexalin_plus(src)
	new /obj/item/weapon/storage/pill_bottle/dylovene(src)
	new /obj/item/weapon/storage/pill_bottle/tramadol(src)
	new /obj/item/weapon/storage/pill_bottle/penicillin(src)
	new /obj/item/stack/medical/splint(src)
	return

/obj/item/weapon/storage/firstaid/surgery
	name = "surgery kit"
	desc = "Contains tools for surgery. Has precise foam fitting for safe transport."

/obj/item/weapon/storage/firstaid/surgery/New()
	..()
	if (empty) return
	new /obj/item/weapon/bonesetter(src)
	new /obj/item/weapon/cautery(src)
	new /obj/item/weapon/bone_saw(src)
	new /obj/item/weapon/hemostat(src)
	new /obj/item/weapon/retractor(src)
	new /obj/item/weapon/scalpel(src)
	new /obj/item/weapon/surgicaldrill(src)
	new /obj/item/weapon/bonegel(src)
	new /obj/item/weapon/FixOVein(src)
	new /obj/item/stack/medical/advanced/bruise_pack(src)

	make_exact_fit()

/obj/item/weapon/storage/firstaid/injectorpack
	name = "Pack of morphine injectors"
	desc = "Contains five injectors of morphine"
	icon_state = "medbriefcase"
	item_state = "firstaid-advanced"
	storage_slots = 5
	max_w_class = 2
	can_hold = list(/obj/item/weapon/reagent_containers/syringe/morphine)

/obj/item/weapon/storage/firstaid/injectorpack/New()
	..()
	new /obj/item/weapon/reagent_containers/syringe/morphine(src)
	new /obj/item/weapon/reagent_containers/syringe/morphine(src)
	new /obj/item/weapon/reagent_containers/syringe/morphine(src)
	new /obj/item/weapon/reagent_containers/syringe/morphine(src)
	new /obj/item/weapon/reagent_containers/syringe/morphine(src)

	return
