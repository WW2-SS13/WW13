/obj/item/weapon/gun/energy
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon_state = "energy"
	fire_sound = 'sound/weapons/Taser.ogg'
	fire_sound_text = "laser blast"

	var/obj/item/weapon/cell/power_supply //What type of power cell this uses
	var/charge_cost = 200 //How much energy is needed to fire.
	var/max_shots = 10 //Determines the capacity of the weapon's power cell. Specifying a cell_type overrides this value.
	var/cell_type = null
	var/projectile_type = /obj/item/projectile/beam/practice
	var/modifystate
	var/charge_meter = TRUE	//if set, the icon state will be chosen based on the current charge

	//self-recharging
	var/self_recharge = FALSE	//if set, the weapon will recharge itself
	var/use_external_power = FALSE //if set, the weapon will look for an external power source to draw from, otherwise it recharges magically
	var/recharge_time = 4
	var/charge_tick = FALSE

/obj/item/weapon/gun/energy/switch_firemodes()
	. = ..()
	if(.)
		update_icon()

/obj/item/weapon/gun/energy/emp_act(severity)
	..()
	update_icon()

/obj/item/weapon/gun/energy/New()
	..()
	if(cell_type)
		power_supply = new cell_type(src)
	else
		power_supply = new /obj/item/weapon/cell/device/variable(src, max_shots*charge_cost)
	if(self_recharge)
		processing_objects.Add(src)
	update_icon()

/obj/item/weapon/gun/energy/Destroy()
	if(self_recharge)
		processing_objects.Remove(src)
	..()

/obj/item/weapon/gun/energy/process()
	if(self_recharge) //Every [recharge_time] ticks, recharge a shot for the cyborg
		charge_tick++
		if(charge_tick < recharge_time) return FALSE
		charge_tick = FALSE

		if(!power_supply || power_supply.charge >= power_supply.maxcharge)
			return FALSE // check if we actually need to recharge

		if(use_external_power)
			var/obj/item/weapon/cell/external = get_external_power_supply()
			if(!external || !external.use(charge_cost)) //Take power from the borg...
				return FALSE

		power_supply.give(charge_cost) //... to recharge the shot
		update_icon()
	return TRUE

/obj/item/weapon/gun/energy/consume_next_projectile()
	if(!power_supply) return null
	if(!ispath(projectile_type)) return null
	if(!power_supply.checked_use(charge_cost)) return null
	return new projectile_type(src)

/obj/item/weapon/gun/energy/proc/get_external_power_supply()
	return null

/obj/item/weapon/gun/energy/examine(mob/user)
	..(user)
	var/shots_remaining = round(power_supply.charge / charge_cost)
	user << "Has [shots_remaining] shot\s remaining."
	return

/obj/item/weapon/gun/energy/update_icon(var/ignore_inhands)
	if(charge_meter)
		var/ratio = power_supply.charge / power_supply.maxcharge

		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		if(power_supply.charge < charge_cost)
			ratio = FALSE
		else
			ratio = max(round(ratio, 0.25) * 100, 25)

		if(modifystate)
			icon_state = "[modifystate][ratio]"
		else
			icon_state = "[initial(icon_state)][ratio]"
	if(!ignore_inhands) update_held_icon()
