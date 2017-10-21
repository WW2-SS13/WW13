/client/proc/randomize_lobby_music()
	set name = "Randomize Lobby Music"
	set category = "Fun"

	if(!src.holder)
		src << "<font color='red'>Only Admins may use this command.</font>"
		return

	lobby_music_player.choose_song()
	lobby_music_player.announce()
	ticker.login_music = lobby_music_player.get_song()

	for (var/mob/new_player/np in player_list)
		if (istype(np))
			np.client << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // stop the jamsz
			np.client.playtitlemusic()

	message_admins("[key_name(src)] randomized the lobby music.")