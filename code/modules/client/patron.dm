/client/proc/highest_patreon_level()
	if (isPatron("$3+"))
		if (isPatron("$5+"))
			if (isPatron("$10+"))
				if (isPatron("$15+"))
					if (isPatron("$20+"))
						if (isPatron("$50+"))
							return "$50+"
						return "$20+"
					return "$15+"
				return "$10+"
			return "$5+"
		return "$3+"
	return null

/client/proc/isPatron(pledge = "$3+")
	var/number = text2num(replacetext(replacetext(pledge, "$", ""), "+", ""))
	if (serverswap && serverswap.Find("masterdir"))
		var/list/patron2pledge = file2list("[serverswap["masterdir"]]patrons.txt")
		for (var/string in patron2pledge)
			var/list/splitString = splittext(string, "=")
			if (splitString.len)
				var/patron = ckey(splitString[1])
				// ignore second field, discord id
				var/pledge2 = text2num(splitString[3])
				if (patron == ckey && pledge2 >= number)
					return TRUE
	return FALSE

/client/proc/enable_disable_dabs()
	set category = "Patron"
	set name = "Enable/Disable Dabbing"
	config.allow_dabbing = !config.allow_dabbing
	if (config.allow_dabbing)
		world << "<big>[key] has enabled *dab.</big>"
	else
		world << "<big>[key] has disabled *dab.</big>"
/client
	var/list/usedup = list()

/client/proc/favor()
	set category = "Patron"
	set name = "Gods Favor"
	var/list/choices = list()
	choices += "MESSAGE SERVER"
	choices += "ROLL THE DICE"
	choices += "START A VOTE"
	choices += "NANI?"
	choices += "KANA"
	choices += "PING EVERYONE AND REMIND THEM HOW GREAT YOU ARE"
	choices += "CANCEL"

	if(!(key in usedup))

		world << "<big>[key] has envoked a favor of the gods.</big>"

		var/choice = input("What favor do you want?") in choices

		//usedup += key

		if (choice == "CANCEL")
			usedup -= key
			return

		if (findtext(choice, "MESSAGE SERVER"))
			var/announce = input("What is your message?")
			world << "<h1 class='alert'>[announce]</h1>"
		if (findtext(choice, "START A VOTE"))
			vote.initiate_vote("custom", "The Gods", TRUE)
		if (findtext(choice, "PING EVERYONE AND REMIND THEM HOW GREAT YOU ARE"))
			world << sound('sound/machines/ping.ogg', repeat = FALSE, wait = FALSE, volume = 50, channel = 3)
		if (findtext(choice, "ROLL THE DICE"))
			var/sum = input("How many times should we throw?") as num
			var/side = input("Select the number of sides.") as num
			if(!side)
				side = 6
			if(!sum)
				sum = 2

			var/dice = num2text(sum) + "d" + num2text(side)

			if(alert("Do you want to inform the world about your game?",,"Yes", "No") == "Yes")
				world << "<h2 style=\"color:#A50400\">The dice have been rolled by Gods!</h2>"

			var/result = roll(dice)

			if(alert("Do you want to inform the world about the result?",,"Yes", "No") == "Yes")
				world << "<h2 style=\"color:#A50400\">Gods rolled [dice], result is [result]</h2>"

			message_admins("[key_name_admin(src)] rolled dice [dice], result is [result]", 1)
		if (findtext(choice, "NANI?"))
			world << "<h1 class='alert'>You are already dead.</h1>"
			world << sound('sound/nani.ogg', repeat = FALSE, wait = FALSE, volume = 50, channel = 3)
			for (var/mob/living/carbon/human/H)
				H.SpinAnimation(15,1)

		if (findtext(choice, "KANA"))
			world << sound('sound/effects/awaken.ogg', repeat = FALSE, wait = FALSE, volume = 50, channel = 3)
			for (var/mob/living/carbon/human/H)
				new/obj/effect/kana(H)
				H.SpinAnimation(7,1)
