/* Simply add this to the last line of a processes setup() proc to turn it into an "internal subsystem"
 * this will make it run independently from other processes, making it more reliable. The benefits
 * of this are very evident at a high ping: the movement process, for example. Not recommended unless you need
 * very high precision and consistency in a process (schedule_intervals < 5) - Kachnov */

// detect hanging of fake subsystems
var/list/subsystems = list()
var/list/last_ran_subsystem = list()

#define DO_INTERNAL_SUBSYSTEM(process) \
	process:subsystem = 1; \
	subsystems[process:name] = process; \
	spawn while (1) {\
		process:schedule_interval = max(process:schedule_interval, world.tick_lag); \
		sleep(process:schedule_interval); \
		process:onStart(); \
		process:fire(); \
		last_ran_subsystem[process:name] = world.time; \
		process:onFinish(); \
		++process:ticks; \
	}

#define FORNEXT(list) for (current in list)

// Process status defines
#define PROCESS_STATUS_IDLE 1
#define PROCESS_STATUS_QUEUED 2
#define PROCESS_STATUS_RUNNING 3
#define PROCESS_STATUS_MAYBE_HUNG 4
#define PROCESS_STATUS_PROBABLY_HUNG 5
#define PROCESS_STATUS_HUNG 6

// Process time thresholds
#define PROCESS_DEFAULT_HANG_WARNING_TIME 	300 // 30 seconds
#define PROCESS_DEFAULT_HANG_ALERT_TIME 	600 // 60 seconds
#define PROCESS_DEFAULT_HANG_RESTART_TIME 	900 // 90 seconds
#define PROCESS_DEFAULT_SCHEDULE_INTERVAL 	50  // 50 ticks
#define PROCESS_DEFAULT_SLEEP_INTERVAL		8	// 2 ticks

// SCHECK macro
// This references src directly to work around a weird bug with try/catch
#define SCHECK sleepCheck(0, 1.0)
#define SCHECK_09 sleepCheck(0, 0.9)