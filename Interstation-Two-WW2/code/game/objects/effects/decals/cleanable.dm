/obj/effect/decal/cleanable
	var/list/random_icon_states = list()

/obj/effect/decal/cleanable/clean_blood(var/ignore = FALSE)
	if(!ignore)
		qdel(src)
		return
	..()

/obj/effect/decal/cleanable/New()
	if (random_icon_states && length(random_icon_states) > FALSE)
		icon_state = pick(random_icon_states)
	..()
