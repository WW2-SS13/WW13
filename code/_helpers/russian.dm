
//HTML ENCODE/DECODE + RUS TO CP1251 TODO: OVERRIDE html_encode after fix
/proc/rhtml_encode(var/msg)
//	msg = jointext(splittext(msg, "<"), "&lt;")
//	msg = jointext(splittext(msg, ">"), "&gt;")
//	msg = jointext(splittext(msg, "ÿ"), "&#255;")
	return msg

/proc/rhtml_decode(var/msg)
///	msg = jointext(splittext(msg, "&gt;"), ">")
//	msg = jointext(splittext(msg, "&lt;"), "<")
//	msg = jointext(splittext(msg, "&#255;"), "ÿ")
	return msg


//UPPER/LOWER TEXT + RUS TO CP1251 TODO: OVERRIDE uppertext
/proc/ruppertext(text as text)
	text = uppertext(text)
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if (a == 1105 || a == 1025)
			t += ascii2text(1025)
			continue
		if (a < 1072 || a > 1105)
			t += ascii2text(a)
			continue
		t += ascii2text(a - 32)
	return t


/proc/rlowertext(text as text)
	text = lowertext(text)
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if (a == 1105 || a == 1025)
			t += ascii2text(1105)
			continue
		if (a < 1040 || a > 1071)
			t += ascii2text(a)
			continue
		t += ascii2text(a + 32)
	return t


//TEXT SANITIZATION + RUS TO CP1251
/*
sanitize_simple(var/t,var/list/repl_chars = list("\n"="#","\t"="#","ÿ"="&#255;","<"="(",">"=")"))
	for (var/char in repl_chars)
		var/index = findtext(t, char)
		while (index)
			t = copytext(t, TRUE, index) + repl_chars[char] + copytext(t, index+1)
			index = findtext(t, char)
	return t
*/


//RUS CONVERTERS
/proc/russian_to_cp1251(var/msg)//CHATBOX
//	return jointext(splittext(msg, "ÿ"), "&#255;")
	return msg

/proc/russian_to_utf8(var/msg)//PDA PAPER POPUPS
//	return jointext(splittext(msg, "ÿ"), "&#1103;")
	return msg
/proc/utf8_to_cp1251(msg)
//	return jointext(splittext(msg, "&#1103;"), "&#255;")
	return msg
/proc/cp1251_to_utf8(msg)
//	return jointext(splittext(msg, "&#255;"), "&#1103;")
	return msg
/proc/edit_cp1251(msg)
//	return jointext(splittext(msg, "&#255;"), "\\ß")
	return msg
/proc/edit_utf8(msg)
//	return jointext(splittext(msg, "&#1103;"), "\\ß")
	return msg
/proc/post_edit_cp1251(msg)
//	return jointext(splittext(msg, "\\ß"), "&#255;")
	return msg
/proc/post_edit_utf8(msg)
//	return jointext(splittext(msg, "\\ß"), "&#1103;")
	return msg
var/global/list/rkeys = list(
	"à" = "f", "â" = "d", "ã" = "u", "ä" = "l",
	"å" = "t", "ç" = "p", "è" = "b", "é" = "q",
	"ê" = "r", "ë" = "k", "ì" = "v", "í" = "y",
	"î" = "j", "ï" = "g", "ð" = "h", "ñ" = "c",
	"ò" = "n", "ó" = "e", "ô" = "a", "ö" = "w",
	"÷" = "x", "ø" = "i", "ù" = "o", "û" = "s",
	"ü" = "m", "ÿ" = "z"
)

//RKEY2KEY
/proc/rkey2key(t)
	if (t in rkeys) return rkeys[t]
	return (t)

//TEXT MODS RUS
/proc/capitalize_cp1251(var/t as text)
	var/first = ascii2text(text2ascii(t))
	return ruppertext(first) + copytext(t, length(first) + 1)
	//return ruppertext(copytext(t, TRUE, s)) + copytext(t, s)

/proc/intonation(text)
	if (copytext(text,-1) == "!")
		text = "<b>[text]</b>"
	return text
