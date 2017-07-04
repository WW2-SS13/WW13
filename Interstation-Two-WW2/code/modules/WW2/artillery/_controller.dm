var/datum/artillery_controller/artillery_master = null

/datum/artillery_controller

	var/list/artillery_bases = list()

	New()
		..()
		spawn while (1)
			sleep(30)
			for (var/obj/machinery/artillery/base/arty in artillery_bases)
				if (arty.user)
					for (var/mob/m in range(1, arty))
						if (m == arty.user)
							goto end

					arty.user = null
			end