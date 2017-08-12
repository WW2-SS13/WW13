var/civilians_toggled = 1
var/SS_toggled = 1
var/paratroopers_toggled = 1

/client/proc/toggle_subfactions()
	set name = "Toggle Subfactions"
	set category = "WW2"

	if(!check_rights(R_ADMIN))
		src << "<span class = 'danger'>You don't have the permissions.</span>"
		return
	if (!istype(ticker.mode, /datum/game_mode/ww2))
		src << "<span class = 'danger'>You can't do this on this game mode.</span>"
		return

	var/list/choices = list()
	choices += "CIVILIANS ([civilians_toggled ? "ENABLED" : "DISABLED"])"
	choices += "WAFFEN-SS ([SS_toggled ? "ENABLED" : "DISABLED"])"
	choices += "PARATROOPERS ([paratroopers_toggled ? "ENABLED" : "DISABLED"])"

	var/choice = input("Enable/Disable what subfaction?") in choices
	if (findtext(choice, "CIVILIANS"))
		civilians_toggled = !civilians_toggled
		src << "<span class = 'danger'>The Civilian faction has been [civilians_toggled ? "<i>ENABLED</i>" : "<i>DISABLED</i>"].</span>"
	if (findtext(choice, "WAFFEN-SS"))
		SS_toggled = !SS_toggled
		src << "<span class = 'danger'>The SS faction has been [SS_toggled ? "<i>ENABLED</i>" : "<i>DISABLED</i>"].</span>"
	if (findtext(choice, "PARATROOPERS"))
		paratroopers_toggled = !paratroopers_toggled
		src << "<span class = 'danger'>The Paratrooper faction has been [paratroopers_toggled ? "<i>ENABLED</i>" : "<i>DISABLED</i>"].</span>"
