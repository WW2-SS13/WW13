
/datum/lobby_music_player
    // title = ogg
	var/list/songs = list(
		// HARDBASS
		"Dj Blyatman - Tsar Bomb" = 'sound/music/WW2/tsarbomb.ogg',
		"Dj Blyatman - Chernobyl" = 'sound/music/WW2/chernobyl.ogg',
		"Dj Snat - Choose Your Power (Gopnik Mcblyat Remix)" = 'sound/music/WW2/chooseyourpower.ogg',
		"Gopnik Mcblyat - Snakes In Tracksuits" = 'sound/music/WW2/snakesintracksuits.ogg',
		// actual ww2 stuff
		"Katyusha" = 'sound/music/WW2/katyusha.ogg',
		"Latvian SS Anthem" = 'sound/music/WW2/latvianss.ogg',
		"ERIKA" = 'sound/music/WW2/ERIKA.ogg',
		// other shit
		"Falco - Der Kommissar" = 'sound/music/WW2/derkommissar.ogg',
		"DJ Blyatman - Dragunov" = 'sound/music/WW2/dragunov.ogg',
		"M.O.O.N._-_Dust_Official_Hotline_Miami_2_OST" = 'sound/music/WW2/moon.ogg')

	var/list/song_probability_multipliers = list(
		"Dj Blyatman - Tsar Bomb" = 2,
		"Dj Snat - Choose Your Power (Gopnik Mcblyat Remix)" = 1,
		"Katyusha" = 1,
		"ERIKA" = 1,
		"Falco - Der Kommissar" = 1,
		"M.O.O.N._-_Dust_Official_Hotline_Miami_2_OST" = 1
	)

	var/song_title = null

/datum/lobby_music_player/New()
	..()
	choose_song()

/datum/lobby_music_player/proc/choose_song()

	// for some reason byond is horrible with randomness and overwhelmingly
	// plays the first few songs in the list. The solution is randomizing the list
	// - Kachnov

	var/last_song_title = song_title

	var/list/random_order_songs = shuffle(songs)
	var/songs_len = random_order_songs.len

	var/default_prob = ceil(100/songs_len)
	for (var/title in random_order_songs)
		var/multiplier = (song_probability_multipliers[title] || 1)
		if (prob(default_prob * multiplier))
			song_title = title
			break
	if (!song_title)
		song_title = pick(random_order_songs)

	while (song_title == last_song_title)
		song_title = pick(random_order_songs)

/datum/lobby_music_player/proc/announce(var/client/client)
	client << "<span class = 'notice'><font size = 2>Now playing <b>[song_title]</b></font></span>"

/datum/lobby_music_player/proc/get_song()
	return songs[song_title]