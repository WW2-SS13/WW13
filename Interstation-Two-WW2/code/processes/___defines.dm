/* Simply add this to the last line of a processes setup() proc to turn it into an "internal subsystem"
 * this will make it run independently from other processes, making it more reliable. The benefits
 * of this are very evident at a high ping: the movement process, for example. Not recommended unless you need
 * very high precision and consistency in a process (schedule_intervals < 5) - Kachnov */

var/list/subsystems = list()
var/list/last_ran_subsystem = list()

#define DO_INTERNAL_SUBSYSTEM(process) \
	process:subsystem = 1; \
	subsystems[process:name] = process; \
	spawn while (1) {\
		if (!process || process:killed) { \
			break; \
		} \
		process:schedule_interval = max(process:schedule_interval, world.tick_lag); \
		sleep(process:schedule_interval); \
		process:onStart(); \
		process:fire(); \
		process:onFinish(); \
		++process:ticks; \
	}