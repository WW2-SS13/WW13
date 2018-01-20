/mob/living/carbon/human/var/last_scream = -1

/mob/living/carbon/human/emote(var/act,var/m_type=1,var/message = null)

	// no more screaming when you shoot yourself
	var/do_after = 0
	if (act == "scream")
		do_after = 1

	spawn (do_after)
		if (act == "scream" && stat == UNCONSCIOUS || stat == DEAD)
			return

		var/param = null

		if (findtext(act, "-", TRUE, null))
			var/t1 = findtext(act, "-", TRUE, null)
			param = copytext(act, t1 + TRUE, length(act) + TRUE)
			act = copytext(act, TRUE, t1)

		if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
			act = copytext(act,1,length(act))

		var/muzzled = istype(wear_mask, /obj/item/clothing/mask/muzzle) || istype(wear_mask, /obj/item/weapon/grenade)
		//var/m_type = TRUE

		for (var/obj/item/weapon/implant/I in src)
			if (I.implanted)
				I.trigger(act, src)

		if(stat == 2.0 && (act != "deathgasp"))
			return

		switch(act)
			if ("airguitar")
				if (!restrained())
					message = "is strumming the air and headbanging like a safari chimp."
					m_type = TRUE

			if ("blink")
				message = "blinks."
				m_type = TRUE

			if ("blink_r")
				message = "blinks rapidly."
				m_type = TRUE

			if ("bow")
				if (!buckled)
					var/M = null
					if (param)
						for (var/mob/A in view(null, null))
							if (param == A.name)
								M = A
								break
					if (!M)
						param = null

					if (param)
						message = "bows to [param]."
					else
						message = "bows."
				m_type = TRUE

			if ("custom")
				var/input = sanitize(input("Choose an emote to display.") as text|null)
				if (!input)
					return
				var/input2 = input("Is this a visible or hearable emote?") in list("Visible","Hearable")
				if (input2 == "Visible")
					m_type = TRUE
				else if (input2 == "Hearable")
					if (miming)
						return
					m_type = 2
				else
					alert("Unable to use this emote, must be either hearable or visible.")
					return
				return custom_emote(m_type, message)

			if ("me")

				//if(silent && silent > FALSE && findtext(message,"\"",1, null) > FALSE)
				//	return //This check does not work and I have no idea why, I'm leaving it in for reference.

				if (client)
					if (client.prefs.muted & MUTE_IC)
						src << "\red You cannot send IC messages (muted)."
						return
					if (client.handle_spam_prevention(message,MUTE_IC))
						return
				if (stat)
					return
				if(!(message))
					return
				return custom_emote(m_type, message)

			if ("salute")
				if (!buckled)
					var/M = null
					if (param)
						for (var/mob/A in view(null, null))
							if (param == A.name)
								M = A
								break
					if (!M)
						param = null

					if (param)
						message = "salutes to [param]."
					else
						message = "salutes."
				m_type = TRUE

			if ("choke")
				if(miming)
					message = "clutches [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] throat desperately!"
					m_type = TRUE
				else
					if (!muzzled)
						message = "chokes!"
						m_type = 2
					else
						message = "makes a strong noise."
						m_type = 2

			if ("clap")
				if (!restrained())
					message = "claps."
					m_type = 2
					if(miming)
						m_type = TRUE
			if ("flap")
				if (!restrained())
					message = "flaps [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] wings."
					m_type = 2
					if(miming)
						m_type = TRUE

			if ("aflap")
				if (!restrained())
					message = "flaps [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] wings ANGRILY!"
					m_type = 2
					if(miming)
						m_type = TRUE

			if ("drool")
				message = "drools."
				m_type = TRUE

			if ("eyebrow")
				message = "raises an eyebrow."
				m_type = TRUE

			if ("chuckle")
				if(miming)
					message = "appears to chuckle."
					m_type = TRUE
				else
					if (!muzzled)
						message = "chuckles."
						m_type = 2
					else
						message = "makes a noise."
						m_type = 2

			if ("twitch")
				message = "twitches violently."
				m_type = TRUE

			if ("twitch_s")
				message = "twitches."
				m_type = TRUE

			if ("faint")
				message = "faints."
				if(sleeping)
					return //Can't faint while asleep
				sleeping += 10 //Short-short nap
				m_type = TRUE

			if ("cough")
				if(miming)
					message = "appears to cough!"
					m_type = TRUE
				else
					if (!muzzled)
						message = "coughs!"
						m_type = 2
					else
						message = "makes a strong noise."
						m_type = 2

			if ("frown")
				message = "frowns."
				m_type = TRUE

			if ("nod")
				message = "nods."
				m_type = TRUE

			if ("blush")
				message = "blushes."
				m_type = TRUE

			if ("wave")
				message = "waves."
				m_type = TRUE

			if ("gasp")
				if(miming)
					message = "appears to be gasping!"
					m_type = TRUE
				else
					if (!muzzled)
						message = "gasps!"
						m_type = 2
					else
						message = "makes a weak noise."
						m_type = 2

			if ("giggle")
				if(miming)
					message = "giggles silently!"
					m_type = TRUE
				else
					if (!muzzled)
						message = "giggles."
						m_type = 2
					else
						message = "makes a noise."
						m_type = 2

			if ("glare")
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "glares at [param]."
				else
					message = "glares."

			if ("stare")
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "stares at [param]."
				else
					message = "stares."

			if ("look")
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break

				if (!M)
					param = null

				if (param)
					message = "looks at [param]."
				else
					message = "looks."
				m_type = TRUE

			if ("grin")
				message = "grins."
				m_type = TRUE

			if ("cry")
				if(miming)
					message = "cries."
					m_type = TRUE
				else
					if (!muzzled)
						message = "cries."
						m_type = 2
					else
						message = "makes a weak noise. [get_visible_gender() == MALE ? "He" : get_visible_gender() == FEMALE ? "She" : "They"] [get_visible_gender() == NEUTER ? "frown" : "frowns"]."
						m_type = 2

			if ("sigh")
				if(miming)
					message = "sighs."
					m_type = TRUE
				else
					if (!muzzled)
						message = "sighs."
						m_type = 2
					else
						message = "makes a weak noise."
						m_type = 2

			if ("laugh")
				if(miming)
					message = "acts out a laugh."
					m_type = TRUE
				else
					if (!muzzled)
						message = "laughs."
						m_type = 2
					else
						message = "makes a noise."
						m_type = 2

			if ("mumble")
				message = "mumbles!"
				m_type = 2
				if(miming)
					m_type = TRUE

			if ("grumble")
				if(miming)
					message = "grumbles!"
					m_type = TRUE
				if (!muzzled)
					message = "grumbles!"
					m_type = 2
				else
					message = "makes a noise."
					m_type = 2

			if ("groan")
				if(miming)
					message = "appears to groan!"
					m_type = TRUE
				else
					if (!muzzled)
						message = "groans!"
						m_type = 2
					else
						message = "makes a loud noise."
						m_type = 2

			if ("moan")
				if(miming)
					message = "appears to moan!"
					m_type = TRUE
				else
					message = "moans!"
					m_type = 2

			if ("johnny")
				var/M
				if (param)
					M = param
				if (!M)
					param = null
				else
					if(miming)
						message = "takes a drag from a cigarette and blows \"[M]\" out in smoke."
						m_type = TRUE
					else
						message = "says, \"[M], please. He had a family.\" [name] takes a drag from a cigarette and blows his name out in smoke."
						m_type = 2

			if ("point")
				if (!restrained())
					var/mob/M = null
					if (param)
						for (var/atom/A as mob|obj|turf|area in view(null, null))
							if (param == A.name)
								M = A
								break

					if (!M)
						message = "points."
					else
						pointed(M)

					if (M)
						message = "points to [M]."
					else
				m_type = TRUE

			if ("raise")
				if (!restrained())
					message = "raises a hand."
				m_type = TRUE

			if("shake")
				message = "shakes [get_visible_gender() == MALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"] head."
				m_type = TRUE

			if ("shrug")
				message = "shrugs."
				m_type = TRUE

			if ("signal")
				if (!restrained())
					var/t1 = round(text2num(param))
					if (isnum(t1))
						if (t1 <= 5 && (!r_hand || !l_hand))
							message = "raises [t1] finger\s."
						else if (t1 <= 10 && (!r_hand && !l_hand))
							message = "raises [t1] finger\s."
				m_type = TRUE

			if ("smile")
				message = "smiles."
				m_type = TRUE

			if ("shiver")
				message = "shivers."
				m_type = 2
				if(miming)
					m_type = TRUE

			if ("pale")
				message = "goes pale for a second."
				m_type = TRUE

			if ("tremble")
				message = "trembles in fear!"
				m_type = TRUE

			if ("sneeze")
				if (miming)
					message = "sneezes."
					m_type = TRUE
				else
					if (!muzzled)
						message = "sneezes."
						m_type = 2
					else
						message = "makes a strange noise."
						m_type = 2

			if ("sniff")
				message = "sniffs."
				m_type = 2
				if(miming)
					m_type = TRUE

			if ("snore")
				if (miming)
					message = "sleeps soundly."
					m_type = TRUE
				else
					if (!muzzled)
						message = "snores."
						m_type = 2
					else
						message = "makes a noise."
						m_type = 2

			if ("whimper")
				if (miming)
					message = "appears hurt."
					m_type = TRUE
				else
					if (!muzzled)
						message = "whimpers."
						m_type = 2
					else
						message = "makes a weak noise."
						m_type = 2

			if ("wink")
				message = "winks."
				m_type = TRUE

			if ("yawn")
				if (!muzzled)
					message = "yawns."
					m_type = 2
					if(miming)
						m_type = TRUE

			if ("collapse")
				Paralyse(2)
				message = "collapses!"
				m_type = 2
				if(miming)
					m_type = TRUE

			if("hug")
				m_type = TRUE
				if (!restrained())
					var/M = null
					if (param)
						for (var/mob/A in view(1, null))
							if (param == A.name)
								M = A
								break
					if (M == src)
						M = null

					if (M)
						message = "hugs [M]."
					else
						message = "hugs [get_visible_gender() == MALE ? "himself" : get_visible_gender() == FEMALE ? "herself" : "themselves"]."

			if ("handshake")
				m_type = TRUE
				if (!restrained() && !r_hand)
					var/mob/M = null
					if (param)
						for (var/mob/A in view(1, null))
							if (param == A.name)
								M = A
								break
					if (M == src)
						M = null

					if (M)
						if (M.canmove && !M.r_hand && !M.restrained())
							message = "shakes hands with [M]."
						else
							var/datum/gender/g = gender_datums[gender]
							message = "holds out [g.his] hand to [M]."

			if ("scream")
				if (last_scream != -1 && world.time - last_scream < 30)
					return
				last_scream = world.time
				if (miming)
					message = "acts out a scream!"
					m_type = TRUE
				else
					if (!muzzled)
						message = "screams!"
						m_type = 2
						scream_sound(src, FALSE)
					else
						message = "makes a very loud noise."
						m_type = 2

			if ("dab")
				m_type = TRUE
				if (!restrained())
					var/mob/M = locate() in get_step(src, dir)
					if (M)
						message = "dabs on [M]."
					else
						message = "dabs."

			if ("help")
				src << {"blink, blink_r, blush, bow-(none)/mob, burp, choke, chuckle, clap, collapse, cough,
	cry, custom, deathgasp, drool, eyebrow, frown, gasp, giggle, groan, grumble, handshake, hug-(none)/mob, glare-(none)/mob,
	grin, laugh, look-(none)/mob, moan, mumble, nod, pale, point-atom, raise, salute, shake, shiver, shrug,
	sigh, signal-#1-10, smile, sneeze, sniff, snore, stare-(none)/mob, tremble, twitch, twitch_s, whimper,
	wink, yawn, swish, sway/wag, fastsway/qwag, stopsway/swag, dab"}

			else
				src << "\blue Unusable emote '[act]'. Say *help for a list."





		if (message)
			log_emote("[name]/[key] : [message]")
			custom_emote(m_type,message)

/*/mob/living/carbon/human/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	pose =  sanitize(input(usr, "This is [src]. [get_visible_gender() == MALE ? "He" : get_visible_gender() == FEMALE ? "She" : "They"] [get_visible_gender() == NEUTER ? "are" : "is"]...", "Pose", null)  as text)
*/
