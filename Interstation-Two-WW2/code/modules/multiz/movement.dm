/mob/observer/ghost/verb/moveup()
	set name = "Move Upwards"
	set category = "Ghost"
	var/turf/T = GetAbove(get_turf(src))
	if(T)
		src.Move(T)


/mob/observer/ghost/verb/movedown()
	set name = "Move Downwards"
	set category = "Ghost"
	var/turf/T = GetBelow(get_turf(src))
	if(T)
		src.Move(T)
