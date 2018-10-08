/obj/effect/decal/snowstep
	icon = 'icons\obj\snowstep.dmi'
	icon_state = "step"
proc/SnowStep(var/comingdir, var/goingdir)
		var/updated=0
		// Shift our goingdir 4 spaces to the left so it's in the GOING bitblock.
		var/realgoing=goingdir<<4

		// Current bit
		var/b=0

		// When tracks will go away
		var/t=world.time + TRACKS_SNOW_OVER

		var/datum/fluidtrack/track

		// Process 4 bits
		for (var/bi=0;bi<4;bi++)
			b=1<<bi
			// COMING BIT
			// If setting
			if (comingdir&b)
				// If not wet or not set
				if (dirs&b)
					var/sid=setdirs["[b]"]
					track=stack[sid]
					if (track.wet==t && track.basecolor==bloodcolor)
						continue
					// Remove existing stack entry
					stack.Remove(track)
				track=new /datum/fluidtrack(b,bloodcolor,t)
				stack.Add(track)
				setdirs["[b]"]=stack.Find(track)
				updatedtracks |= b
				updated=1

			// GOING BIT (shift up 4)
			b=b<<4
			if (realgoing&b)
				// If not wet or not set
				if (dirs&b)
					var/sid=setdirs["[b]"]
					track=stack[sid]
					if (track.wet==t && track.basecolor==bloodcolor)
						continue
					// Remove existing stack entry
					stack.Remove(track)
				track=new /datum/fluidtrack(b,bloodcolor,t)
				stack.Add(track)
				setdirs["[b]"]=stack.Find(track)
				updatedtracks |= b
				updated=1

		dirs |= comingdir|realgoing
		if (islist(blood_DNA))
			blood_DNA |= DNA.Copy()
		if (updated)
			update_icon()

	update_icon()
		overlays.Cut()
		color = "#FFFFFF"
		var/truedir=0

		// Update ONLY the overlays that have changed.
		for (var/datum/fluidtrack/track in stack)
			var/stack_idx=setdirs["[track.direction]"]
			var/state=coming_state
			truedir=track.direction
			if (truedir&240) // Check if we're in the GOING block
				state=going_state
				truedir=truedir>>4

			if (track.overlay)
				track.overlay=null
			var/image/I = image(icon, icon_state=state, dir=num2dir(truedir))
			I.color = track.basecolor

			track.fresh=0
			track.overlay=I
			stack[stack_idx]=track
			overlays += I
		updatedtracks=0 // Clear our memory of updated tracks.