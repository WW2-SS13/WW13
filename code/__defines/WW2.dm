// used for factions and sometimes languages
#define GERMAN "GERMAN"
#define CIVILIAN "CIVILIAN"
#define PARTISAN "PARTISAN" // ukrainian but not with ruskies
#define SOVIET "SOVIET"
#define ITALIAN "ITALIAN"
#define PILLARMEN "PILLARMEN"

// there are things with 'SS' in their type path, thats why the const isn't SS
// this is only used for a few circumstances right now, like faction bans
#define SCHUTZSTAFFEL "SS"
#define SS_TV "SS_TV"
#define SOVIET_PRISONER "SOVIET_PRISONER"
#define GERMAN_REICHSTAG "GERMAN_REICHSTAG"

// used for languages only
#define RUSSIAN "RUSSIAN"
#define POLISH "POLISH"
#define UKRAINIAN "UKRAINIAN"

/proc/faction_const2name(constant)
	if (constant == PILLARMEN)
		return "Pillar Men and Vampires"
	return capitalize(lowertext(constant)) + "s"