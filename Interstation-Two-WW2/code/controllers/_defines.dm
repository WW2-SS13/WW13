#define DO_INTERNAL_SUBSYSTEM(process) \
	process:is_subsystem = 1; \
	spawn while (1) {\
		sleep(process:schedule_interval); \
		process:doWork(); \
	}