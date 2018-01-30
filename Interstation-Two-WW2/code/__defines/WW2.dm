#define GERMAN "GERMAN"
#define CIVILIAN "CIVILIAN"
#define PARTISAN "PARTISAN" // ukrainian but not with ruskies
#define SOVIET "SOVIET"
#define UKRAINIAN "UKRAINIAN" // the army, not partisans
#define ITALIAN "ITALIAN"
#define PILLARMEN "PILLARMEN"

// there are things with 'SS' in their type path, thats why the const isn't SS
// this is only used for a few circumstances right now, like faction bans
#define SCHUTZSTAFFEL "SS"

// used for languages only
#define RUSSIAN "RUSSIAN"

/proc/faction_const2name(constant)
	if (constant == PILLARMEN)
		return "Pillar Men and Vampires"
	return capitalize(lowertext(constant)) + "s"