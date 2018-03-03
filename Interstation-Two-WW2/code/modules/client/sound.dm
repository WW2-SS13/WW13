/client/proc/playsound_personal(var/soundin, var/_volume = 50)
	soundin = get_sfx(soundin)
	var/sound/S = sound(soundin)
	src << sound(S, repeat = FALSE, wait = FALSE, volume = _volume, channel = 1)

/client/proc/playtitlemusic()
	if(!ticker || !ticker.login_music)	return
	if(!istype(mob, /mob/new_player)) return
	if(is_preference_enabled(/datum/client_preference/play_lobby_music))
		src << sound(ticker.login_music, repeat = TRUE, wait = FALSE, volume = 50, channel = TRUE)
		lobby_music_player.announce(src)