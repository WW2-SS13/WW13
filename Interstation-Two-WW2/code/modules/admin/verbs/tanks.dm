/client/proc/eject_from_tank()
	set category = "Ghost"
	set name = "Eject People From Tank"

	if(!check_rights(R_MOD))
		return

	if (!locate(/obj/tank) in range(3, src))
		return

	var/obj/tank/tank = locate(/obj/tank) in range(3, src)
	if (!tank)
		return

	tank.forcibly_eject_everyone()

	log_admin("[key_name(usr)] tried to eject everyone from [tank]")
	message_admins("[key_name_admin(usr)] tried to eject everyone from [tank]", 1)