/proc/message_germans(msg)
	for (var/mob/living/carbon/human/H in human_mob_list)
		if (H.stat == CONSCIOUS && H.original_job && H.original_job.base_type_flag() == GERMAN)
			if (H.client)
				H << msg