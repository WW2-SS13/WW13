/datum/controller/process/human
	var/tmp/datum/updateQueue/updateQueueInstance

/datum/controller/process/human/setup()
	name = "human"
	schedule_interval = 1 // every 1/10 seconds
	start_delay = 16

/datum/controller/process/human/started()
	..()

/datum/controller/process/human/doWork()
	for (var/v in 1 to 2)
		for(last_object in human_mob_list)
			var/mob/living/carbon/human/H = last_object

			if(isnull(H))
				return

			if(isnull(H.gcDestroyed))
				try
					switch (v)
						if (1)
							for (var/image in H.client.images)
								H.client.images -= image
								qdel(image)
							H.faction_images = initial(H.faction_images)
						if (2)
							H.update_faction_huds_to_nearby_mobs()
				catch(var/exception/e)
					catchException(e, H)
				SCHECK
			else
				catchBadType(H)
				human_mob_list -= H

/datum/controller/process/human/statProcess()
	..()
	stat(null, "[human_mob_list.len] humans being processed")
