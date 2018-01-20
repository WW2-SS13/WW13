//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/website()
	set name = "website"
	set desc = "Visit the website"
	set hidden = TRUE
	if( config.websiteurl )
		if(alert("This will open the website in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.websiteurl)
	else
		src << "<span class='warning'>The website URL is not set in the server configuration.</span>"
	return

/client/verb/wiki()
	set name = "wiki"
	set desc = "Visit the wiki"
	set hidden = TRUE
	if( config.wikiurl )
		if(alert("This will open the wiki in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.wikiurl)
	else
		src << "<span class='warning'>The wiki URL is not set in the server configuration.</span>"
	return

/client/verb/forum()
	set name = "forum"
	set desc = "Visit the forum"
	set hidden = TRUE
	if( config.forumurl )
		if(alert("This will open the forum in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.forumurl)
	else
		src << "<span class='warning'>The forum URL is not set in the server configuration.</span>"
	return

/client/verb/donate()
	set name = "donate"
	set desc = "Support the server via paypal."
	set hidden = TRUE
	if( config.donationurl )
		if(alert("This will open Paypal in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.donationurl)
	else
		src << "<span class='warning'>The donation URL is not set in the server configuration.</span>"
	return

/client/verb/github()
	set name = "Github"
	set desc = "Visit the Github"
	set hidden = TRUE
	if( config.githuburl )
		if(alert("This will open the Github in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.githuburl)
	else
		src << "<span class='warning'>The Github URL is not set in the server configuration.</span>"
	return

/client/verb/discord()
	set name = "discord"
	set desc = "Visit the discord"
	set hidden = TRUE
	if( config.discordurl )
		if(alert("This will open the Discord in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.discordurl)
	else
		src << "<span class='warning'>The Discord URL is not set in the server configuration.</span>"
	return

#define RULES_FILE "config/rules.html"
/client/verb/rules()
	set name = "Rules"
	set desc = "Show Server Rules"
	set hidden = TRUE
	if( config.rulesurl )
		if(alert("This will open the rules in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.rulesurl)
	else
		src << "<span class='warning'>The rules URL is not set in the server configuration.</span>"
	return
//	src << browse(/*file(RULES_FILE)*/"https://discord.gg/3zjPhfb", "window=rules;size=480x320")
#undef RULES_FILE

/client/verb/hotkeys_help()
	set name = "hotkeys-help"
	set category = "OOC"

	var/admin = {"<font color='purple'>
Admin:
\tF5 = Aghost (admin-ghost)
\tF6 = player-panel-new
\tF7 = admin-pm
\tF8 = Invisimin
</font>"}

	var/hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = toggle hotkey-mode
\ta = left
\ts = down
\td = right
\tw = up
\tq = drop
\te = equip
\tr = throw
\tt = say
\t5 = emote
\tx = swap-hand
\tspace = Use-iron-sights
\t, = rest
\tz = activate held object (or y)
\tj = toggle-aiming-mode
\tf = cycle-intents-left
\tg = cycle-intents-right
\t1 = help-intent
\t2 = disarm-intent
\t3 = grab-intent
\t4 = harm-intent
\tPgUp = go up
\tPgDwn = go down
\tCtrl = drag
\tShift = examine
\tCtrl+S = scream
\tSpace = fire while in a tank
</font>"}

	var/other = {"<font color='purple'>
Any-Mode: (hotkey doesn't need to be on)
\tCtrl+q = drop
\tCtrl+e = equip
\tCtrl+r = throw
\tCtrl+x = swap-hand
\tCtrl+z = activate held object (or Ctrl+y)
\tCtrl+f = cycle-intents-left
\tCtrl+g = cycle-intents-right
\tCtrl+1 = help-intent
\tCtrl+2 = disarm-intent
\tCtrl+3 = grab-intent
\tCtrl+4 = harm-intent
\tF1 = adminhelp
\tF2 = ooc
\tF3 = say
\tF4 = emote
\tDEL = pull
\tINS = cycle-intents-right
\tHOME = drop
\tPGUP = swap-hand
\tPGDN = activate held object
\tEND = throw
\tCtrl+S = scream
\tSpace = fire while in a tank
</font>"}

	var/robot_hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = toggle hotkey-mode
\ta = left
\ts = down
\td = right
\tw = up
\tq = unequip active module
\tt = say
\tspace = Use-iron-sights
\t, = rest
\tx = cycle active modules
\tz = activate held object (or y)
\tf = cycle-intents-left
\tg = cycle-intents-right
\t1 = activate module TRUE
\t2 = activate module 2
\t3 = activate module 3
\t4 = toggle intents
\t5 = emote
\tCtrl = drag
\tShift = examine
</font>"}

	var/robot_other = {"<font color='purple'>
Any-Mode: (hotkey doesn't need to be on)
\tCtrl+a = left
\tCtrl+s = down
\tCtrl+d = right
\tCtrl+w = up
\tCtrl+q = unequip active module
\tCtrl+x = cycle active modules
\tCtrl+z = activate held object (or Ctrl+y)
\tCtrl+f = cycle-intents-left
\tCtrl+g = cycle-intents-right
\tCtrl+1 = activate module TRUE
\tCtrl+2 = activate module 2
\tCtrl+3 = activate module 3
\tCtrl+4 = toggle intents
\tF1 = adminhelp
\tF2 = ooc
\tF3 = say
\tF4 = emote
\tDEL = pull
\tINS = toggle intents
\tPGUP = cycle active modules
\tPGDN = activate held object
</font>"}

	if(isrobot(mob))
		src << robot_hotkey_mode
		src << robot_other
	else
		src << hotkey_mode
		src << other
	if(holder)
		src << admin
