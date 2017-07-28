/obj/structure/sign/portrait

/obj/structure/sign/portrait/verb/tear()
	set src in oview(1, usr)
	if (!locate(src) in get_step(usr, usr.dir))
		return 0
	visible_message("<span class = 'danger'>[usr] starts to tear down [src]...</span>")
	if (do_after(usr, 30, src))
		visible_message("<span class = 'danger'>[usr] tears down [src]!</span>")
		qdel(src)

/obj/structure/sign/portrait/hitler
	name = "Portrait of Hitler"
	desc = "Our glorious Führer!"
	icon_state = "hitler"

/obj/structure/sign/portrait/stalin
	name = "Portrait of Stalin"
	icon_state = "stalin"

/obj/structure/sign/portrait/propaganda

/obj/structure/sign/portrait/propaganda/sov1
	name = "Soviet Propaganda Poster"
	icon_state = "soviet_prop_1"
