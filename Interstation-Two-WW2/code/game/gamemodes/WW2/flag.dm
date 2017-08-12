

/obj/machinery/flag
	name = "The flag."
	desc = "The flag.  Russians defend, germans attack"
	icon = 'icons/obj/machines/ww2_flag.dmi'
	icon_state = "soviet_flag"
	var/under_german_control = FALSE  //German control TRUE is adding capture time
	var/russian_countdown = 1800
	var/german_capture_time = 0

/obj/machinery/flag/New()
	set_light(2)
	..()

/obj/machinery/flag/attack_hand(mob/user as mob)
	if(!ishuman(user))
		return

	if (!user)
		return

	if(under_german_control)
		under_german_control = FALSE
		update_icon()
	else
		under_german_control = TRUE
		update_icon()

/obj/machinery/flag/process()
	if(under_german_control)
		if (german_capture_time > 600)
			playsound(loc, 'sound/machines/buzz-two.ogg', 50, 0)
			return
		else
			german_capture_time++
	if (game_started)
		if (russian_countdown <= 0)
			playsound(loc, 'sound/machines/buzz-two.ogg', 50, 0)
			return
		else
			russian_countdown--


/obj/machinery/flag/update_icon()
	if(under_german_control)
		icon_state = "nazi_flag"
	else
		icon_state = "soviet_flag"