// for helper
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

// Process priorities
#define PROCESS_PRIORITY_VERY_HIGH 1
#define PROCESS_PRIORITY_HIGH 2
#define PROCESS_PRIORITY_MEDIUM 3
#define PROCESS_PRIORITY_LOW 4
#define PROCESS_PRIORITY_VERY_LOW 5
#define PROCESS_PRIORITY_IRRELEVANT 6 // we don't process or only process once, meaning PROCESS_TICK_CHECK never happens

// Makes a process return if it's spent enough of our tick
#define PROCESS_TICK_CHECK_RETURNED_EARLY "PTCRE"

// this uses world.timeofday because world.time doesn't work
#define PROCESS_TICK_CHECK if (world.timeofday - run_start_time >= (run_time_allowance*run_time_allowance_multiplier)) return PROCESS_TICK_CHECK_RETURNED_EARLY