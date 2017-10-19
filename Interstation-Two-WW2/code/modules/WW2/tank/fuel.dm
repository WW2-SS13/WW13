/obj/item/weapon/tank_fueltank
	name = "tank fuel tank"
	desc = "A tank of tank fuel. Funny."
	icon = 'icons/obj/tank.dmi'
	icon_state = "phoron"
	force = WEAPON_FORCE_PAINFUL

/obj/item/weapon/tank_fueltank/empty
	name = "empty tank fuel tank"
	desc = "A tank of tank fuel, but it's empty."

/obj/tank/proc/refuel(var/obj/item/weapon/tank_fueltank/ftank, var/mob/user as mob)
	tank_message("[user] refuels [my_name()] with [ftank].")
	qdel(ftank)
	fuel = max_fuel