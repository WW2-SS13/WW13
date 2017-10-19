/* for backend reasons, any songs here should not contain ':' in the title
   only the end of the title should contain :1, or :2, representing the
   relative probability of that song */

/datum/lobby_music_player
	var/song_title = null
    // format is 'title:probability_multiplier = ogg'
	var/list/songs = list(
		// HARDBASS
		"Dj Blyatman - Tsar Bomb:1" = 'sound/music/WW2/tsarbomb.ogg',
		"Dj Blyatman - Chernobyl:1" = 'sound/music/WW2/chernobyl.ogg',
		"Dj Snat - Choose Your Power (Gopnik Mcblyat Remix):1" = 'sound/music/WW2/chooseyourpower.ogg',
		"Gopnik Mcblyat - Snakes In Tracksuits:1" = 'sound/music/WW2/snakesintracksuits.ogg',
		// actual ww2 stuff
		"Katyusha:1" = 'sound/music/WW2/katyusha.ogg',
		"Latvian SS Anthem:1" = 'sound/music/WW2/latvianss.ogg',
		"ERIKA:1" = 'sound/music/WW2/ERIKA.ogg',
		// other stupid shit
		"Falco - Der Kommissar:1" = 'sound/music/WW2/derkommissar.ogg',
		"DJ Blyatman - Dragunov:1" = 'sound/music/WW2/dragunov.ogg',
		"M.O.O.N._-_Dust_Official_Hotline_Miami_2_OST:1" = 'sound/music/WW2/moon.ogg')



/datum/lobby_music_player/New()
	..()
	choose_song()

/datum/lobby_music_player/proc/choose_song()

	// for some reason byond is horrible with randomness and overwhelmingly
	// plays the first few songs in the list. The solution is randomizing the list
	// - Kachnov

	var/last_song_title = song_title
	var/list/random_order_songs = shuffle(songs)
	var/default_prob = ceil(100/songs.len)

	for (var/title_mult in random_order_songs)
		var/split_title_mult = splittext(title_mult, ":")
		var/multiplier = (text2num(split_title_mult[2]) || 1)
		if (prob(default_prob * multiplier))
			song_title = title_mult // yes, not title
			break

	// somehow we have no song, pick a random one
	if (!song_title)
		song_title = pick(random_order_songs)

	// don't play the same song as before
	while (song_title == last_song_title)
		song_title = pick(random_order_songs)

/datum/lobby_music_player/proc/announce(var/client/client)
	client << "<span class = 'notice'><font size = 2>Now playing <b>[splittext(song_title, ":")[1]]</b></font></span>"

/datum/lobby_music_player/proc/get_song()
	return songs[song_title]