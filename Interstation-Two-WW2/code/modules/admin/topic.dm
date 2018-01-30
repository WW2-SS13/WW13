/datum/admins/Topic(href, href_list)
	..()

	if(usr.client != owner || !check_rights(0))
		log_admin("[key_name(usr)] tried to use the admin panel without authorization.")
		message_admins("[usr.key] has attempted to override the admin panel!")
		return

	if(ticker.mode && ticker.mode.check_antagonists_topic(href, href_list))
		check_antagonists()
		return
/*
	if(href_list["dbsearchckey"] || href_list["dbsearchadmin"])

		var/adminckey = href_list["dbsearchadmin"]
		var/playerckey = href_list["dbsearchckey"]
		var/playerip = href_list["dbsearchip"]
		var/playercid = href_list["dbsearchcid"]
		var/dbbantype = text2num(href_list["dbsearchbantype"])
		var/match = FALSE

		if("dbmatch" in href_list)
			match = TRUE

		DB_ban_panel(playerckey, adminckey, playerip, playercid, dbbantype, match)
		return

	else if(href_list["dbbanedit"])
		var/banedit = href_list["dbbanedit"]
		var/banid = text2num(href_list["dbbanid"])
		if(!banedit || !banid)
			return

		DB_ban_edit(banid, banedit)
		return

	else if(href_list["dbbanaddtype"])

		var/bantype = text2num(href_list["dbbanaddtype"])
		var/banckey = href_list["dbbanaddckey"]
		var/banip = href_list["dbbanaddip"]
		var/bancid = href_list["dbbanaddcid"]
		var/banduration = text2num(href_list["dbbaddduration"])
		var/banjob = href_list["dbbanaddjob"]
		var/banreason = href_list["dbbanreason"]

		banckey = ckey(banckey)

		switch(bantype)
			if(BANTYPE_PERMA)
				if(!banckey || !banreason)
					usr << "Not enough parameters (Requires ckey and reason)"
					return
				banduration = null
				banjob = null
			if(BANTYPE_TEMP)
				if(!banckey || !banreason || !banduration)
					usr << "Not enough parameters (Requires ckey, reason and duration)"
					return
				banjob = null
			if(BANTYPE_JOB_PERMA)
				if(!banckey || !banreason || !banjob)
					usr << "Not enough parameters (Requires ckey, reason and job)"
					return
				banduration = null
			if(BANTYPE_JOB_TEMP)
				if(!banckey || !banreason || !banjob || !banduration)
					usr << "Not enough parameters (Requires ckey, reason and job)"
					return

		var/mob/playermob

		for(var/mob/M in player_list)
			if(M.ckey == banckey)
				playermob = M
				break

		banreason = "(MANUAL BAN) "+banreason

		if(!playermob)
			if(banip)
				banreason = "[banreason] (CUSTOM IP)"
			if(bancid)
				banreason = "[banreason] (CUSTOM CID)"
		else
			message_admins("Ban process: A mob matching [playermob.ckey] was found at location [playermob.x], [playermob.y], [playermob.z]. Custom ip and computer id fields replaced with the ip and computer id from the located mob")

		notes_add(banckey,banreason,usr)
		var/reason = DB_ban_record(bantype, playermob, banduration, banreason, banjob, null, banckey, banip, bancid )
		if (playermob && playermob.client)
			playermob << "<span class = 'danger'>You've been banned. Reason: [reason].</span>"
			qdel(playermob.client)
*/
	else if(href_list["editrights"])
		if(!check_rights(R_PERMISSIONS))
			message_admins("[key_name_admin(usr)] attempted to edit the admin permissions without sufficient rights.")
			log_admin("[key_name(usr)] attempted to edit the admin permissions without sufficient rights.")
			return

		var/adm_ckey

		var/task = href_list["editrights"]
		if(task == "add")
			var/new_ckey = ckey(input(usr,"New admin's ckey","Admin ckey", null) as text|null)
			if(!new_ckey)	return
			if(new_ckey in admin_datums)
				usr << "<font color='red'>Error: Topic 'editrights': [new_ckey] is already an admin.</font>"
				return
			adm_ckey = new_ckey
			task = "rank"
		else if(task != "show")
			adm_ckey = ckey(href_list["ckey"])
			if(!adm_ckey)
				usr << "<font color='red'>Error: Topic 'editrights': No valid ckey</font>"
				return

		var/datum/admins/D = admin_datums[adm_ckey]

		if(task == "remove")
			if(alert("Are you sure you want to remove [adm_ckey]?","Message","Yes","Cancel") == "Yes")
				if(!D)	return
				admin_datums -= adm_ckey
				D.disassociate()

				message_admins("[key_name_admin(usr)] removed [adm_ckey] from the admins list")
				log_admin("[key_name(usr)] removed [adm_ckey] from the admins list")
				log_admin_rank_modification(adm_ckey, "Removed")

		else if(task == "rank")

			var/new_rank
			if(admin_ranks.len)
				new_rank = input("Please select a rank", "New rank", null, null) as null|anything in (admin_ranks|"*New Rank*")
			else
				new_rank = input("Please select a rank", "New rank", null, null) as null|anything in list("Game Master","Game Admin", "Trial Admin", "Admin Observer","*New Rank*")

	/*		var/rights = FALSE
			if(D)
				rights = D.rights */

			switch(new_rank)
				if(null,"") return
				if("*New Rank*")
					new_rank = input("Please input a new rank", "New custom rank", null, null) as null|text

					if(!new_rank)
						usr << "<font color='red'>Error: Topic 'editrights': Invalid rank</font>"
						return
			/*
			if(D)
				D.disassociate()								//remove adminverbs and unlink from client
				D.rank = new_rank								//update the rank
				D.rights = rights								//update the rights based on admin_ranks (default: FALSE)
			else
				*/

			if (directory.Find(adm_ckey)) // they don't need to be online
				var/client/C = directory[adm_ckey]						//find the client with the specified ckey (if they are logged in)
				if (C.holder)
					C.holder.disassociate()

				D = new /datum/admins(new_rank, FALSE, adm_ckey) // initial rights must be FALSE or their rights do not change!
				D.associate(C)											//link up with the client and add verbs

				C << "<b>[key_name_admin(usr)] has set your admin rank to: [new_rank].</b>"

			message_admins("[key_name_admin(usr)] edited the admin rank of [adm_ckey] to [new_rank].")
			log_admin("[key_name(usr)] edited the admin rank of [adm_ckey] to [new_rank].")
			log_admin_rank_modification(adm_ckey, new_rank)
		//	load_admins(1)

		else if(task == "permissions")
			if(!D)	return
			var/list/permissionlist = list()
			for(var/i=1, i<=R_MAXPERMISSION, i<<=1)		//that <<= is shorthand for i = i << 1. Which is a left bitshift
				permissionlist[rights2text(i)] = i
			var/new_permission = input("Select a permission to turn on/off", "Permission toggle", null, null) as null|anything in permissionlist
			if(!new_permission)	return
			D.rights ^= permissionlist[new_permission]

			var/client/C = directory[adm_ckey]
			C << "[key_name_admin(usr)] has toggled your permission: [new_permission]."
			message_admins("[key_name_admin(usr)] toggled the [new_permission] permission of [adm_ckey]")
			log_admin("[key_name(usr)] toggled the [new_permission] permission of [adm_ckey]")
			log_admin_permission_modification(adm_ckey, permissionlist[new_permission])

		edit_admin_permissions()

	else if(href_list["delay_round_end"])
		if(!check_rights(R_SERVER))	return

		ticker.delay_end = !ticker.delay_end
		log_admin("[key_name(usr)] [ticker.delay_end ? "delayed the round end" : "has made the round end normally"].")
		message_admins("<span class = 'notice'>[key_name(usr)] [ticker.delay_end ? "delayed the round end" : "has made the round end normally"].</span>", TRUE)
		href_list["secretsadmin"] = "check_antagonist"

	else if(href_list["simplemake"])

		if(!check_rights(R_SPAWN))	return

		var/mob/M = locate(href_list["mob"])
		if(!ismob(M))
			usr << "This can only be used on instances of type /mob"
			return

		var/delmob = FALSE
		switch(alert("Delete old mob?","Message","Yes","No","Cancel"))
			if("Cancel")	return
			if("Yes")		delmob = TRUE

		log_admin("[key_name(usr)] has used rudimentary transformation on [key_name(M)]. Transforming to [href_list["simplemake"]]; deletemob=[delmob]")
		message_admins("<span class = 'notice'>[key_name_admin(usr)] has used rudimentary transformation on [key_name_admin(M)]. Transforming to [href_list["simplemake"]]; deletemob=[delmob]</span>", TRUE)

		// only way we can transform ourselves
		var/usr_client = usr.client

		var/mob/New = null
		switch(href_list["simplemake"])
			if("observer")			New = M.change_mob_type( /mob/observer/ghost , null, null, delmob )
			if("larva")				New = M.change_mob_type( /mob/living/carbon/alien/larva , null, null, delmob )
			if("human")				New = M.change_mob_type( /mob/living/carbon/human , null, null, delmob, href_list["species"])
			if("slime")				New = M.change_mob_type( /mob/living/carbon/slime , null, null, delmob )
			if("monkey")			New = M.change_mob_type( /mob/living/carbon/human/monkey , null, null, delmob )
			if("robot")				New = M.change_mob_type( /mob/living/silicon/robot , null, null, delmob )
			if("cat")				New = M.change_mob_type( /mob/living/simple_animal/cat , null, null, delmob )
			if("runtime")			New = M.change_mob_type( /mob/living/simple_animal/cat/fluff/Runtime , null, null, delmob )
			if("corgi")				New = M.change_mob_type( /mob/living/simple_animal/corgi , null, null, delmob )
			if("ian")				New = M.change_mob_type( /mob/living/simple_animal/corgi/Ian , null, null, delmob )
			if("crab")				New = M.change_mob_type( /mob/living/simple_animal/crab , null, null, delmob )
			if("coffee")			New = M.change_mob_type( /mob/living/simple_animal/crab/Coffee , null, null, delmob )
//			if("parrot")			M.change_mob_type( /mob/living/simple_animal/parrot , null, null, delmob )
	//		if("polyparrot")		M.change_mob_type( /mob/living/simple_animal/parrot/Poly , null, null, delmob )
			if("constructarmoured")	New = M.change_mob_type( /mob/living/simple_animal/construct/armoured , null, null, delmob )
			if("constructbuilder")	New = M.change_mob_type( /mob/living/simple_animal/construct/builder , null, null, delmob )
			if("constructwraith")	New = M.change_mob_type( /mob/living/simple_animal/construct/wraith , null, null, delmob )
			if("shade")				New = M.change_mob_type( /mob/living/simple_animal/shade , null, null, delmob )
			if("mechahitler")		New = M.change_mob_type( /mob/living/carbon/human/mechahitler , null, null, delmob, href_list["species"])
			if("megastalin")		New = M.change_mob_type( /mob/living/carbon/human/megastalin , null, null, delmob, href_list["species"])
			if("nazicyborg")			New = M.change_mob_type( /mob/living/carbon/human/nazicyborg , null, null, delmob, href_list["species"])
			if("pillarman")		New = M.change_mob_type( /mob/living/carbon/human/pillarman , null, null, delmob, href_list["species"])
			if("vampire")			New = M.change_mob_type( /mob/living/carbon/human/vampire , null, null, delmob, href_list["species"])
		if (New)
			if (New.type == /mob/living/carbon/human)
				var/mob/living/carbon/human/H = New
				if ((input(usr_client, "Assign [H] a new job?") in list("Yes", "No")) == "Yes")

					var/list/job_master_occupation_names = list()
					for (var/datum/job/J in job_master.occupations)
						if (J.title)
							job_master_occupation_names[J.title] = J

					var/oloc_H = H.loc

					var/J = input(usr_client, "Which job?") in (list("Cancel") | job_master_occupation_names)
					if (J != "Cancel")
						job_master.EquipRank(H, J)
						H.original_job = job_master_occupation_names[J]
						var/msg = "[key_name(usr)] assigned the new mob [H] the job '[J]'."
						message_admins(msg)
						log_admin(msg)
						spawn (1)
							H.loc = oloc_H

							switch (H.original_job.default_language)
								if ("German")
									H.name = H.client.prefs.german_name
									H.real_name = H.client.prefs.german_name
								if ("Russian")
									H.name = H.client.prefs.russian_name
									H.real_name = H.client.prefs.russian_name
								if ("Ukrainian")
									H.name = H.client.prefs.ukrainian_name
									H.real_name = H.client.prefs.ukrainian_name


	else if(href_list["warn"])
		usr.client.warn(href_list["warn"])

	else if(href_list["boot2"])
		var/mob/M = locate(href_list["boot2"])
		if (ismob(M))
			if(!check_if_greater_rights_than(M.client))
				return
			var/reason = sanitize(input("Please enter reason"))
			if(!reason)
				M << "<span class = 'userdanger'>You have been kicked from the server.</span>"
			else
				M << "<span class = 'userdanger'>You have been kicked from the server. ([reason])</span>"
			log_admin("[key_name(usr)] booted [key_name(M)].")
			message_admins("<span class = 'notice'>[key_name_admin(usr)] booted [key_name_admin(M)].</span>", TRUE)
			//M.client = null
			qdel(M.client)

	else if(href_list["mute"])
		if(!check_rights(R_MOD,0) && !check_rights(R_ADMIN))  return

		var/mob/M = locate(href_list["mute"])
		if(!ismob(M))	return
		if(!M.client)	return

		var/mute_type = href_list["mute_type"]
		if(istext(mute_type))	mute_type = text2num(mute_type)
		if(!isnum(mute_type))	return

		cmd_admin_mute(M, mute_type)

	else if(href_list["c_mode"])
		if(!check_rights(R_ADMIN))	return

		if(ticker && ticker.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		var/dat = {"<b>What mode do you wish to play?</b><HR>"}
		for(var/mode in config.modes)
			dat += {"<A href='?src=\ref[src];c_mode2=[mode]'>[config.mode_names[mode]]</A><br>"}
		dat += {"<A href='?src=\ref[src];c_mode2=secret'>Secret</A><br>"}
		dat += {"<A href='?src=\ref[src];c_mode2=random'>Random</A><br>"}
		dat += {"Now: [master_mode]"}
		usr << browse(dat, "window=c_mode")

	else if(href_list["f_secret"])
		if(!check_rights(R_ADMIN))	return

		if(ticker && ticker.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		if(master_mode != "secret")
			return alert(usr, "The game mode has to be secret!", null, null, null, null)
		var/dat = {"<b>What game mode do you want to force secret to be? Use this if you want to change the game mode, but want the players to believe it's secret. This will only work if the current game mode is secret.</b><HR>"}
		for(var/mode in config.modes)
			dat += {"<A href='?src=\ref[src];f_secret2=[mode]'>[config.mode_names[mode]]</A><br>"}
		dat += {"<A href='?src=\ref[src];f_secret2=secret'>Random (default)</A><br>"}
		dat += {"Now: [secret_force_mode]"}
		usr << browse(dat, "window=f_secret")

	else if(href_list["c_mode2"])
		if(!check_rights(R_ADMIN|R_SERVER))	return

		if (ticker && ticker.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		master_mode = href_list["c_mode2"]
		log_admin("[key_name(usr)] set the mode as [master_mode].")
		message_admins("<span class = 'notice'>[key_name_admin(usr)] set the mode as [master_mode].</span>", TRUE)
		world << "<span class = 'notice'><b>The mode is now: [master_mode]</b></span>"
		game_panel() // updates the main game menu
		world.save_mode(master_mode)
		.(href, list("c_mode"=1))

	else if(href_list["f_secret2"])
		if(!check_rights(R_ADMIN|R_SERVER))	return

		if(ticker && ticker.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		if(master_mode != "secret")
			return alert(usr, "The game mode has to be secret!", null, null, null, null)
		secret_force_mode = href_list["f_secret2"]
		log_admin("[key_name(usr)] set the forced secret mode as [secret_force_mode].")
		message_admins("<span class = 'notice'>[key_name_admin(usr)] set the forced secret mode as [secret_force_mode].</span>", TRUE)
		game_panel() // updates the main game menu
		.(href, list("f_secret"=1))
/*
	else if(href_list["monkeyone"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["monkeyone"])
		if(!istype(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return

		log_admin("[key_name(usr)] attempting to monkeyize [key_name(H)]")
		message_admins("\blue [key_name_admin(usr)] attempting to monkeyize [key_name_admin(H)]", TRUE)
		H.monkeyize()
*/
	else if(href_list["corgione"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["corgione"])
		if(!istype(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return

		log_admin("[key_name(usr)] attempting to corgize [key_name(H)]")
		message_admins("<span class = 'notice'>[key_name_admin(usr)] attempting to corgize [key_name_admin(H)]</span>", TRUE)
		H.corgize()

	else if(href_list["forcespeech"])
		if(!check_rights(R_FUN))	return

		var/mob/M = locate(href_list["forcespeech"])
		if(!ismob(M))
			usr << "this can only be used on instances of type /mob"

		var/speech = input("What will [key_name(M)] say?.", "Force speech", "")// Don't need to sanitize, since it does that in say(), we also trust our admins.
		if(!speech)	return
		M.say(speech)
		speech = sanitize(speech) // Nah, we don't trust them
		log_admin("[key_name(usr)] forced [key_name(M)] to say: [speech]")
		message_admins("<span class = 'notice'>[key_name_admin(usr)] forced [key_name_admin(M)] to say: [speech]</span>")

	else if(href_list["revive"])
		if(!check_rights(R_REJUVINATE))	return

		var/mob/living/L = locate(href_list["revive"])
		if(!istype(L))
			usr << "This can only be used on instances of type /mob/living"
			return

		if(config.allow_admin_rev)
			L.revive()
			if (ishuman(L))
				var/mob/living/carbon/human/H = L
				H.nutrition = H.max_nutrition
				H.water = H.max_water
				for (var/obj/item/organ/external/E in H.bad_external_organs)
					E.wounds.Cut()
					H.bad_external_organs -= E
				var/obj/item/organ/external/head/U = locate() in H.organs
				if(istype(U))
					U.teeth_list.Cut() //Clear out their mouth of teeth
					var/obj/item/stack/teeth/T = new H.species.teeth_type(U)
					U.max_teeth = T.max_amount //Set max teeth for the head based on teeth spawntype
					T.amount = T.max_amount
					U.teeth_list += T
			message_admins("<span class = 'red'>Admin [key_name_admin(usr)] healed / revived [key_name_admin(L)]!</span>", TRUE)
			log_admin("[key_name(usr)] healed / Rrvived [key_name(L)]")
		else
			usr << "Admin Rejuvinates have been disabled"
/*
	else if(href_list["makeslime"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["makeslime"])
		if(!istype(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return

		usr.client.cmd_admin_slimeize(H)
*/
	else if(href_list["makeanimal"])
		if(!check_rights(R_SPAWN))	return

		var/mob/M = locate(href_list["makeanimal"])
		if(istype(M, /mob/new_player))
			usr << "This cannot be used on instances of type /mob/new_player"
			return

		usr.client.cmd_admin_animalize(M)

	else if(href_list["togmutate"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["togmutate"])
		if(!istype(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return
		var/block=text2num(href_list["block"])
		//testing("togmutate([href_list["block"]] -> [block])")
		usr.client.cmd_admin_toggle_block(H,block)
		show_player_panel(H)
		//H.regenerate_icons()

	else if(href_list["adminplayeropts"])
		var/mob/M = locate(href_list["adminplayeropts"])
		show_player_panel(M)

	else if(href_list["adminplayerobservejump"])
		if(!check_rights(R_MENTOR|R_MOD|R_ADMIN))	return

		var/mob/M = locate(href_list["adminplayerobservejump"])

		var/client/C = usr.client
		if(!isghost(usr))	C.admin_ghost()
		sleep(2)
		C.jumptomob(M)

	else if(href_list["check_antagonist"])
		check_antagonists()

	else if(href_list["adminplayerobservecoodjump"])
		if(!check_rights(R_ADMIN|R_MOD))	return

		var/x = text2num(href_list["X"])
		var/y = text2num(href_list["Y"])
		var/z = text2num(href_list["Z"])

		var/client/C = usr.client
		if(!isghost(usr))	C.admin_ghost()
		sleep(2)
		C.jumptocoord(x,y,z)

	else if(href_list["adminchecklaws"])
		output_ai_laws()

	else if(href_list["adminmoreinfo"])
		var/mob/M = locate(href_list["adminmoreinfo"])
		if(!ismob(M))
			usr << "This can only be used on instances of type /mob"
			return

		var/location_description = ""
		var/special_role_description = ""
		var/health_description = ""
		var/gender_description = ""
		var/turf/T = get_turf(M)

		//Location
		if(isturf(T))
			if(isarea(T.loc))
				location_description = "([M.loc == T ? "at coordinates " : "in [M.loc] at coordinates "] [T.x], [T.y], [T.z] in area <b>[T.loc]</b>)"
			else
				location_description = "([M.loc == T ? "at coordinates " : "in [M.loc] at coordinates "] [T.x], [T.y], [T.z])"

		//Job + antagonist
		if(M.mind)
			special_role_description = "Role: <b>[M.mind.assigned_role]</b>; Antagonist: <font color='red'><b>[M.mind.special_role]</b></font>; Has been rev: [(M.mind.has_been_rev)?"Yes":"No"]"
		else
			special_role_description = "Role: <i>Mind datum missing</i> Antagonist: <i>Mind datum missing</i>; Has been rev: <i>Mind datum missing</i>;"

		//Health
		if(isliving(M))
			var/mob/living/L = M
			var/status
			switch (M.stat)
				if (0) status = "Alive"
				if (1) status = "<font color='orange'><b>Unconscious</b></font>"
				if (2) status = "<font color='red'><b>Dead</b></font>"
			health_description = "Status = [status]"
			health_description += "<BR>Oxy: [L.getOxyLoss()] - Tox: [L.getToxLoss()] - Fire: [L.getFireLoss()] - Brute: [L.getBruteLoss()] - Clone: [L.getCloneLoss()] - Brain: [L.getBrainLoss()]"
		else
			health_description = "This mob type has no health to speak of."

		//Gener
		switch(M.gender)
			if(MALE,FEMALE)	gender_description = "[M.gender]"
			else			gender_description = "<font color='red'><b>[M.gender]</b></font>"

		owner << "<b>Info about [M.name]:</b> "
		owner << "Mob type = [M.type]; Gender = [gender_description] Damage = [health_description]"
		owner << "Name = <b>[M.name]</b>; Real_name = [M.real_name]; Mind_name = [M.mind?"[M.mind.name]":""]; Key = <b>[M.key]</b>;"
		owner << "Location = [location_description];"
		owner << "[special_role_description]"
		owner << "(<a href='?src=\ref[usr];priv_msg=\ref[M]'>PM</a>) (<A HREF='?src=\ref[src];adminplayeropts=\ref[M]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[M]'>VV</A>) (<A HREF='?src=\ref[src];subtlemessage=\ref[M]'>SM</A>) ([admin_jump_link(M, src)]) (<A HREF='?src=\ref[src];secretsadmin=check_antagonist'>CA</A>)"

	else if(href_list["adminspawncookie"])
		if(!check_rights(R_ADMIN|R_FUN))	return

		var/mob/living/carbon/human/H = locate(href_list["adminspawncookie"])
		if(!ishuman(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return

		H.equip_to_slot_or_del( new /obj/item/weapon/reagent_containers/food/snacks/cookie(H), slot_l_hand )
		if(!(istype(H.l_hand,/obj/item/weapon/reagent_containers/food/snacks/cookie)))
			H.equip_to_slot_or_del( new /obj/item/weapon/reagent_containers/food/snacks/cookie(H), slot_r_hand )
			if(!(istype(H.r_hand,/obj/item/weapon/reagent_containers/food/snacks/cookie)))
				log_admin("[key_name(H)] has their hands full, so they did not receive their cookie, spawned by [key_name(owner)].")
				message_admins("[key_name(H)] has their hands full, so they did not receive their cookie, spawned by [key_name(owner)].")
				return
			else
				H.update_inv_r_hand()//To ensure the icon appears in the HUD
		else
			H.update_inv_l_hand()
		log_admin("[key_name(H)] got their cookie, spawned by [key_name(owner)]")
		message_admins("[key_name(H)] got their cookie, spawned by [key_name(owner)]")

		H << "<span class = 'notice'>Your prayers have been answered!! You received the <b>best cookie</b>!</span>"

	else if(href_list["jumpto"])
		if(!check_rights(R_ADMIN))	return

		var/mob/M = locate(href_list["jumpto"])
		usr.client.jumptomob(M)

	else if(href_list["getmob"])
		if(!check_rights(R_ADMIN))	return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")	return
		var/mob/M = locate(href_list["getmob"])
		usr.client.Getmob(M)

	else if(href_list["sendmob"])
		if(!check_rights(R_ADMIN))	return

		var/mob/M = locate(href_list["sendmob"])
		usr.client.sendmob(M)

	else if(href_list["narrateto"])
		if(!check_rights(R_ADMIN))	return

		var/mob/M = locate(href_list["narrateto"])
		usr.client.cmd_admin_direct_narrate(M)

	else if(href_list["subtlemessage"])
		if(!check_rights(R_MOD,0) && !check_rights(R_ADMIN))  return

		var/mob/M = locate(href_list["subtlemessage"])
		usr.client.cmd_admin_subtle_message(M)

	else if(href_list["traitor"])
		if(!check_rights(R_ADMIN|R_MOD))	return

		if(!ticker || !ticker.mode)
			alert("The game hasn't started yet!")
			return

		var/mob/M = locate(href_list["traitor"])
		if(!ismob(M))
			usr << "This can only be used on instances of type /mob."
			return
		show_traitor_panel(M)

	else if(href_list["create_object"])
		if(!check_rights(R_SPAWN))	return
		return create_object(usr)

	else if(href_list["quick_create_object"])
		if(!check_rights(R_SPAWN))	return
		return quick_create_object(usr)

	else if(href_list["create_turf"])
		if(!check_rights(R_SPAWN))	return
		return create_turf(usr)

	else if(href_list["create_mob"])
		if(!check_rights(R_SPAWN))	return
		return create_mob(usr)

	else if(href_list["debug_global"])
		if(!check_rights(R_DEBUG))	return
		var/client/C = isclient(usr) ? usr : usr.client
		var/somevar = input(usr, "Debug what global variable?") as text
		if (global.vars[somevar])
			var/thing = global.vars[somevar]
			if (isdatum(thing) || isclient(thing))
				C.debug_variables(thing)
			else if (!islist(thing))
				usr << "[somevar] = [thing]"
			else
				var/list/L = thing
				if (!L.len)
					usr << "[somevar] is an empty list"
				else if (list_is_assoc(L))
					usr << "[somevar] is an <b>ASSOCIATIVE</b> list"
					for (var/i in TRUE to L.len)
						usr << "element [i]: [thing[i]] = [thing[thing[i]]]"
				else
					usr << "[thing] is a list"
					for (var/i in TRUE to L.len)
						usr << "element [i]: [thing[i]]"

	else if(href_list["modify_global"])
		if(!check_rights(R_DEBUG))	return
		var/somevar = input(usr, "Modify what global variable?") as text
		if (global.vars[somevar])
			var/thing = global.vars[somevar]
			if (isdatum(thing) || isclient(thing) || islist(thing))
				usr << "[somevar] is a datum, client, or list. You can't edit it here. For datums & clients, use the 'View/Debug a global' to edit their variables."
				return
			else
				var/changeto = input(usr, "Change this global variable to what type?") in list("Empty List", "Text", "Num", "Cancel")
				switch (lowertext(changeto))
					if ("empty list")
						global.vars[somevar] = list()
					if ("text")
						global.vars[somevar] = input(usr, "What text?") as text
					if ("num")
						global.vars[somevar] = input(usr, "What num?") as num

	else if(href_list["modify_world_var"])
		if(!check_rights(R_DEBUG))	return
		var/somevar = input(usr, "Modify what world variable?") as text
		if (world.vars[somevar])
			var/thing = world.vars[somevar]
			if (isdatum(thing) || isclient(thing) || islist(thing))
				usr << "[somevar] is a datum, client, or list. You can't edit it here. For datums & clients, use the 'View/Debug a global' to edit their variables."
				return
			else
				usr << "[somevar] is [thing]"
				// this is somehow broken
				var/changeto = input(usr, "Change this world variable to what type?") in list("Empty List", "Text", "Num", "Cancel")
				switch (lowertext(changeto))
					if ("empty list")
						world.vars[somevar] = list()
					if ("text")
						world.vars[somevar] = input(usr, "What text?") as text
					if ("num")
						world.vars[somevar] = input(usr, "What num?") as num

	else if(href_list["object_list"])			//this is the laggiest thing ever
		if(!check_rights(R_SPAWN))	return

		if(!config.allow_admin_spawning)
			usr << "Spawning of items is not allowed."
			return

		var/atom/loc = usr.loc

		var/dirty_paths
		if (istext(href_list["object_list"]))
			dirty_paths = list(href_list["object_list"])
		else if (istype(href_list["object_list"], /list))
			dirty_paths = href_list["object_list"]

		var/paths = list()

		for(var/dirty_path in dirty_paths)
			var/path = text2path(dirty_path)
			if(!path)
				continue
			paths += path

		if(!paths)
			alert("The path list you sent is empty")
			return
		if(length(paths) > 5)
			alert("Select fewer object types, (max 5)")
			return

		var/list/offset = splittext(href_list["offset"],",")
		var/number = dd_range(1, 100, text2num(href_list["object_count"]))
		var/X = offset.len > FALSE ? text2num(offset[1]) : FALSE
		var/Y = offset.len > TRUE ? text2num(offset[2]) : FALSE
		var/Z = offset.len > 2 ? text2num(offset[3]) : FALSE
		var/tmp_dir = href_list["object_dir"]
		var/obj_dir = tmp_dir ? text2num(tmp_dir) : 2
		if(!obj_dir || !(obj_dir in list(1,2,4,8,5,6,9,10)))
			obj_dir = 2
		var/obj_name = sanitize(href_list["object_name"])


		var/atom/target //Where the object will be spawned
		var/where = href_list["object_where"]
		if (!( where in list("onfloor","inhand","inmarked") ))
			where = "onfloor"

		switch(where)
			if("inhand")
				if (!iscarbon(usr) && !isrobot(usr))
					usr << "Can only spawn in hand when you're a carbon mob or cyborg."
					where = "onfloor"
				target = usr

			if("onfloor")
				switch(href_list["offset_type"])
					if ("absolute")
						target = locate(0 + X,0 + Y,0 + Z)
					if ("relative")
						target = locate(loc.x + X,loc.y + Y,loc.z + Z)
			if("inmarked")
				if(!marked_datum())
					usr << "You don't have any object marked. Abandoning spawn."
					return
				else if(!istype(marked_datum(),  /atom))
					usr << "The object you have marked cannot be used as a target. Target must be of type /atom. Abandoning spawn."
					return
				else
					target = marked_datum()

		if(target)
			for (var/path in paths)
				for (var/i = FALSE; i < number; i++)
					if(path in typesof(/turf))
						var/turf/O = target
						var/turf/N = O.ChangeTurf(path)
						if(N && obj_name)
							N.name = obj_name
					else
						var/atom/O = new path(target)
						if(O)
							O.set_dir(obj_dir)
							if(obj_name)
								O.name = obj_name
								if(istype(O,/mob))
									var/mob/M = O
									M.real_name = obj_name
							if(where == "inhand" && isliving(usr) && istype(O, /obj/item))
								var/mob/living/L = usr
								var/obj/item/I = O
								L.put_in_hands(I)


		log_and_message_admins("created [number] [english_list(paths)]")
		return

	else if(href_list["admin_secrets"])
		var/datum/admin_secret_item/item = locate(href_list["admin_secrets"]) in admin_secrets.items
		item.execute(usr)
/*
	else if(href_list["populate_inactive_customitems"])
		if(check_rights(R_ADMIN|R_SERVER))
			populate_inactive_customitems_list(owner)*/
/*
	else if(href_list["vsc"])
		if(check_rights(R_ADMIN|R_SERVER))
			if(href_list["vsc"] == "airflow")
				vsc.ChangeSettingsDialog(usr,vsc.settings)
			if(href_list["vsc"] == "plasma")
				vsc.ChangeSettingsDialog(usr,vsc.plc.settings)
			if(href_list["vsc"] == "default")
				vsc.SetDefault(usr)*/

	else if(href_list["toglang"])
		if(check_rights(R_SPAWN))
			var/mob/M = locate(href_list["toglang"])
			if(!istype(M))
				usr << "[M] is illegal type, must be /mob!"
				return
			var/lang2toggle = href_list["lang"]
			var/datum/language/L = all_languages[lang2toggle]

			if(L in M.languages)
				if(!M.remove_language(lang2toggle))
					usr << "Failed to remove language '[lang2toggle]' from \the [M]!"
			else
				if(!M.add_language(lang2toggle))
					usr << "Failed to add language '[lang2toggle]' from \the [M]!"

			show_player_panel(M)

	// player info stuff

	if(href_list["add_player_info"])
		var/key = href_list["add_player_info"]
		var/add = sanitize(input("Add Player Info") as null|text)
		if(!add) return

		notes_add(key,add,usr)
		show_player_info(key)

	if(href_list["remove_player_info"])
		var/key = href_list["remove_player_info"]
		var/index = text2num(href_list["remove_index"])

		notes_del(key, index)
		show_player_info(key)

	if(href_list["notes"])
		var/ckey = href_list["ckey"]
		if(!ckey)
			var/mob/M = locate(href_list["mob"])
			if(ismob(M))
				ckey = M.ckey

		switch(href_list["notes"])
			if("show")
				show_player_info(ckey)
			if("list")
				PlayerNotesPage(text2num(href_list["index"]))
		return

mob/living/proc/can_centcom_reply()
	return FALSE

mob/living/carbon/human/can_centcom_reply()
	return FALSE

/atom/proc/extra_admin_link()
	return

/mob/extra_admin_link(var/source)
/*	if(client && eyeobj)
		return "|<A HREF='?[source];adminplayerobservejump=\ref[eyeobj]'>EYE</A>"
*/
	return null

/mob/observer/ghost/extra_admin_link(var/source)
	if(mind && mind.current)
		return "|<A HREF='?[source];adminplayerobservejump=\ref[mind.current]'>BDY</A>"

/proc/admin_jump_link(var/atom/target, var/source)
	if(!target) return
	// The way admin jump links handle their src is weirdly inconsistent...
	if(istype(source, /datum/admins))
		source = "src=\ref[source]"
	else
		source = "_src_=holder"

	. = "<A HREF='?[source];adminplayerobservejump=\ref[target]'>JMP</A>"
	. += target.extra_admin_link(source)
