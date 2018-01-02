var/datum/controller/process/obj/obj_process = null

/datum/controller/process/obj/setup()
	name = "obj"
	schedule_interval = 20 // every 2 seconds
	start_delay = 8
	obj_process = src

/datum/controller/process/obj/started()
	..()

	if(!processing_objects)
		processing_objects = list()
	if(!nonvital_processing_objects_1)
		nonvital_processing_objects_1 = list()
	if(!nonvital_processing_objects_2)
		nonvital_processing_objects_2 = list()
	if(!nonvital_processing_objects_3)
		nonvital_processing_objects_3 = list()
	if(!nonvital_processing_objects_4)
		nonvital_processing_objects_4 = list()

/datum/controller/process/obj/proc/clear_nonvital_processing_objects()
	nonvital_processing_objects_1.Cut()
	nonvital_processing_objects_2.Cut()
	nonvital_processing_objects_3.Cut()
	nonvital_processing_objects_4.Cut()

/datum/controller/process/obj/doWork()

	for(last_object in processing_objects)
		var/datum/O = last_object
		if(isnull(O.gcDestroyed))
			try
				O:process()
			catch(var/exception/e)
				catchException(e, O)
			SCHECK
		else
			catchBadType(O)
			processing_objects -= O

	// objects here only process about 1/40 ticks
	if (prob(10) && !paused_nonvital)
		var/list/nonvital_list = null

		if (prob(25))
			nonvital_list = nonvital_processing_objects_1
		else if (prob(25))
			nonvital_list = nonvital_processing_objects_2
		else if (prob(25))
			nonvital_list = nonvital_processing_objects_3
		else
			nonvital_list = nonvital_processing_objects_4

		if (islist(nonvital_list))
			for(last_object in nonvital_list)
				var/datum/O = last_object
				if(isnull(O.gcDestroyed))
					try
						O:process()
					catch(var/exception/e)
						catchException(e, O)
					SCHECK
				else
					catchBadType(O)
					nonvital_list -= O


/datum/controller/process/obj/proc/add_nonvital_object(var/obj/o)
	var/list/nonvital_list = null

	if (prob(25))
		nonvital_list = nonvital_processing_objects_1
	else if (prob(25))
		nonvital_list = nonvital_processing_objects_2
	else if (prob(25))
		nonvital_list = nonvital_processing_objects_3
	else
		nonvital_list = nonvital_processing_objects_4

	nonvital_list += o

/datum/controller/process/obj/proc/remove_nonvital_object(var/obj/o)
	nonvital_processing_objects_1 -= o
	nonvital_processing_objects_2 -= o
	nonvital_processing_objects_3 -= o
	nonvital_processing_objects_4 -= o

/datum/controller/process/obj/proc/nonvital_objects()
	return nonvital_processing_objects_1.len + nonvital_processing_objects_2.len + nonvital_processing_objects_3.len + nonvital_processing_objects_4.len

/datum/controller/process/obj/statProcess()
	..()
	stat(null, "[processing_objects.len] objects in the vital loop")
	stat(null, "[nonvital_objects()] objects in the nonvital loop")
