/mob
	//thou shall always be able to see the Geometer of Blood
	var/image/narsimage = null
	var/image/narglow = null

/mob/proc/cultify()
	return

/mob/observer/ghost/cultify()
	if(icon_state != "ghost-narsie")
		icon = 'icons/mob/mob.dmi'
		icon_state = "ghost-narsie"
		overlays = 0
		invisibility = 0
		src << "<span class='sinister'>Even as a non-corporal being, you can feel Nar-Sie's presence altering you. You are now visible to everyone.</span>"

/mob/living/cultify()
	return 0

/mob/proc/see_narsie(var/obj/singularity/narsie/large/N, var/dir)
	return 0