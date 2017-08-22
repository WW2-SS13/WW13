// all russians
#define RUSSIAN_CODE 995 * 2
/datum/keyslot/russian
	code = RUSSIAN_CODE

/obj/item/weapon/key/russian
	code = RUSSIAN_CODE
	name = "General Access Key"

/obj/structure/simple_door/key_door/russian
	keyslot_type = /datum/keyslot/russian
	unique_door_name = "General Access"
#undef RUSSIAN_CODE
// all russian SOLDAT
#define RUSSIAN_SOLDAT_CODE 900 * 2
/datum/keyslot/russian/soldat
	code = RUSSIAN_SOLDAT_CODE

/obj/item/weapon/key/russian/soldat
	code = RUSSIAN_SOLDAT_CODE
	name = "Soldier Access Key"

/obj/structure/simple_door/key_door/russian/soldat
	keyslot_type = /datum/keyslot/russian/soldat
	unique_door_name = "Soldier Access"
#undef RUSSIAN_SOLDAT_CODE
// medics
#define RUSSIAN_MEDIC_CODE 901 * 2
/datum/keyslot/russian/medic
	code = RUSSIAN_MEDIC_CODE

/obj/item/weapon/key/russian/medic
	code = RUSSIAN_MEDIC_CODE
	name = "Medical Access Key"

/obj/structure/simple_door/key_door/russian/medic
	keyslot_type = /datum/keyslot/russian/medic
	unique_door_name = "Medical Supplies"
#undef RUSSIAN_MEDIC_CODE
// engineering
#define RUSSIAN_ENGINEER_CODE 902 * 2
/datum/keyslot/russian/engineer
	code = RUSSIAN_ENGINEER_CODE

/obj/item/weapon/key/russian/engineer
	code = RUSSIAN_ENGINEER_CODE
	name = "Engineering Access Key"

/obj/structure/simple_door/key_door/russian/engineer
	keyslot_type = /datum/keyslot/russian/engineer
	unique_door_name = "Engineering"
#undef RUSSIAN_ENGINEER_CODE
// the russian quartermaster
#define RUSSIAN_QM_CODE 997 * 2
/datum/keyslot/russian/QM
	code = RUSSIAN_QM_CODE

/obj/item/weapon/key/russian/QM
	code = RUSSIAN_QM_CODE
	name = "Supply Access Key"

/obj/structure/simple_door/key_door/russian/QM
	keyslot_type = /datum/keyslot/russian/QM
	unique_door_name = "Cargo"
#undef RUSSIAN_QM_CODE
// all intermediate (and above) command
#define RUSSIAN_INTER_COMMAND_CODE 999 * 2
/datum/keyslot/russian/command_intermediate
	code = RUSSIAN_INTER_COMMAND_CODE

/obj/item/weapon/key/russian/command_intermediate
	code = RUSSIAN_INTER_COMMAND_CODE
	name = "Intermediate Command Access Key"

/obj/structure/simple_door/key_door/russian/command_intermediate
	keyslot_type = /datum/keyslot/russian/command_intermediate
	unique_door_name = "Intermediate Command Access"
#undef RUSSIAN_INTER_COMMAND_CODE

// all high (and above) command
#define RUSSIAN_HIGH_COMMAND_CODE 1000 * 2
/datum/keyslot/russian/command_high
	code = RUSSIAN_HIGH_COMMAND_CODE

/obj/item/weapon/key/russian/command_high
	code = RUSSIAN_HIGH_COMMAND_CODE
	name = "High Command Access Key"

/obj/structure/simple_door/key_door/russian/command_high
	keyslot_type = /datum/keyslot/russian/command_high
	unique_door_name = "High Command Access"
#undef RUSSIAN_HIGH_COMMAND_CODE
// bunker doors
#define RUSSIAN_BUNKER_DOORS_CODE 1001 * 2
/datum/keyslot/russian/bunker_doors
	code = RUSSIAN_BUNKER_DOORS_CODE

/obj/item/weapon/key/russian/bunker_doors
	code = RUSSIAN_BUNKER_DOORS_CODE
	name = "Bunker Doors Access Key"

/obj/structure/simple_door/key_door/russian/bunker_doors
	keyslot_type = /datum/keyslot/russian/bunker_doors
	unique_door_name = "Bunker Doors Access"
#undef RUSSIAN_BUNKER_DOORS_CODE