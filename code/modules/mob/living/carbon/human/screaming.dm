/proc/scream_sound(var/mob/m, var/dying = FALSE)

	if (!ishuman(m))
		return FALSE

	if (m.stat == UNCONSCIOUS || m.stat == DEAD)
		return FALSE

	var/mob/living/carbon/human/H = m

	if (istype(H, /mob/living/carbon/human/pillarman))
		playsound(get_turf(H), 'sound/voice/scream_pillarman.ogg', 100, extrarange = 100)
	else if (istype(H, /mob/living/carbon/human/vampire))
		playsound(get_turf(H), "wryyy", 100, extrarange = 50)
	else
		if (H.gender == MALE)
			if(H.client && H.client.prefs)
				var/list/screams
				switch(H.client.prefs.scream_type)
					if(2)
						screams = list('sound/voice/pack1/PainScream1.ogg',\
										'sound/voice/pack1/PainScream2.ogg',\
										'sound/voice/pack1/PainScream4.ogg',\
										'sound/voice/pack1/PainScream5.ogg',\
										'sound/voice/pack1/PainScream6.ogg',\
										'sound/voice/pack1/PainScream7.ogg',\
										'sound/voice/pack1/PainScream8.ogg'
										)
					if(1)
						screams = list('sound/voice/pack2/Inf_Charging_N_139.ogg',\
										'sound/voice/pack2/Inf_Charging_N_142.ogg',\
										'sound/voice/pack2/Inf_Wounded_N_097.ogg',\
										'sound/voice/pack2/Inf_Wounded_N_098.ogg',\
										'sound/voice/pack2/Inf_Wounded_N_099.ogg',\
										'sound/voice/pack2/Inf_Wounded_N_102.ogg'
										)
				if(screams)
					playsound(get_turf(H), safepick(screams), 100, extrarange = 50)
				else
					playsound(get_turf(H), 'sound/voice/scream_male.ogg', 100, extrarange = 50)
			else
				playsound(get_turf(H), 'sound/voice/scream_male.ogg', 100, extrarange = 50)
		else
			playsound(get_turf(H), 'sound/voice/scream_female.ogg', 100, extrarange = 50)