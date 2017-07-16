
/datum/lobby_music_player
    // title = ogg
	var/list/songs = list(
		// HARDBASS
		"Dj Blyatman - Chernobyl" = 'sound/music/WW2/chernobyl.ogg',
		"Dj Snat - Choose Your Power (Gopnik Mcblyat Remix)" = 'sound/music/WW2/chooseyourpower.ogg',
		"Gopnik Mcblyat - Snakes In Tracksuits" = 'sound/music/WW2/snakesintracksuits.ogg',
		// actual ww2 stuff
		"Katyusha" = 'sound/music/WW2/katyusha.ogg',
		"Latvian SS Anthem" = 'sound/music/WW2/latvianss.ogg',
		"ERIKA" = 'sound/music/WW2/ERIKA.ogg',
		// other shit
		"Falco - Der Kommissar" = 'sound/music/WW2/derkommissar.ogg')

	var/list/song_probability_multipliers = list(
		2,
		1,
		1,
		1,
		1,
		1,
		1
	)

	var/song_title = null

/datum/lobby_music_player/New()
	..()
	choose_song()

/datum/lobby_music_player/proc/choose_song()

	var/num = 0
	var/default_prob = ceil(100/7) // songs.len wasn't working for some reason
	for (var/title in songs)
		++num
		if (prob(default_prob * song_probability_multipliers[num]))
			song_title = title
			break
	if (!song_title)
		song_title = pick(songs)

/datum/lobby_music_player/proc/announce(var/client/client)
	client << "<span class = 'notice'><font size = 2>Now playing <b>[song_title]</b></font></span>"

/datum/lobby_music_player/proc/get_song()
	return songs[song_title]