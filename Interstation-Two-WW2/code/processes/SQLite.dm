/* SQLite3 queries with INSERT, UPDATE, DELETE, MERGE, DROP TABLE are handled via this helper process that uses python3 - Kachnov */
var/process/SQLite/SQLite_process = null

/process/SQLite
	var/list/queries = list()

/process/SQLite/setup()
	name = "SQLite Process"
	schedule_interval = 2 // every 1/5th second, giving pythonSQL.py time to run
	fires_at_gamestates = list(GAME_STATE_PREGAME, GAME_STATE_SETTING_UP, GAME_STATE_PLAYING, GAME_STATE_FINISHED)
	SQLite_process = src

/process/SQLite/fire()
	SCHECK
	for (var/query in queries)
		var/file = getFile()
		if (!file)
			continue
		file << query
		queries -= query
		SCHECK
	if (shell())
		shell("cd && sudo python3 [getWriteDir()]pythonSQL.py")

/process/SQLite/proc/getWriteDir()
	if (serverswap && serverswap.Find("master"))
		. = "[serverswap["masterdir"]]/SQL/"
	else
		. = "SQL/"
	return .

/process/SQLite/proc/getFile()
	return file("[getWriteDir()]topython.txt")