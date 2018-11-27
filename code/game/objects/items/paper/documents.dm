/obj/item/documents
	name = "sheet of paper"
	gender = NEUTER
	icon = 'icons/WW2/documents.dmi'
	icon_state = "paper"
	item_state = "paper"
	var/info = "None"

/obj/item/documents/examine(mob/user)
	..()
	if (in_range(user, src) || isghost(user))
		show_content(usr)
	else
		user << "<span class='notice'>You have to go closer if you want to read it.</span>"
	return

/obj/item/documents/proc/show_content(var/mob/user, var/forceshow=0)
	user << browse("<HTML><HEAD><TITLE>[name]</TITLE></HEAD><BODY>[info]</BODY></HTML>", "window=[name]")
	onclose(user, "[name]")


/obj/item/documents/card
	name = "Post Card"
	desc = "Wish you were here!"
	icon_state = "passport_1"
	item_state = "paper"
	info = null

/obj/item/documents/passport
	name = "Passport"
	desc = "This gives you access to the city. "
	icon_state = "postcard"
	item_state = "paper"
	info = null

/obj/item/documents/passport/New()
	var/num = pick("1","2","3","4","5","6")
	icon_state = "passport_[num]"


/obj/item/documents/topsecretger
	name = "Battle Documents"
	desc = "Looks pretty important!"
	icon_state = "postcard"
	item_state = "paper"
	info = null