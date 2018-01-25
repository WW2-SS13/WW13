#define Clamp(value, low, high) 	(value <= low ? low : (value >= high ? high : value))
#define CLAMP01(x) 		(Clamp(x, FALSE, TRUE))

#define isdatum(A) istype(A, /datum)

#define isimage(A) istype(A, /image)

#define isicon(A) istype(A, /icon)

#define isscreen(A) istype(A, /obj/screen)
#define ishud(A) istype(A, /obj/screen)

//MOB LEVEL

#define ismob(A) istype(A, /mob)

#define isobserver(A) istype(A, /mob/observer)

#define isghost(A) istype(A, /mob/observer/ghost)

#define isEye(A) istype(A, /mob/observer/eye)

#define isnewplayer(A) istype(A, /mob/new_player)
//++++++++++++++++++++++++++++++++++++++++++++++

#define isliving(A) istype(A, /mob/living)
//---------------------------------------------------

#define iscarbon(A) istype(A, /mob/living/carbon)

#define isalien(A) istype(A, /mob/living/carbon/alien)

#define isslime(A) istype(A, /mob/living/carbon/slime)

#define isbrain(A) istype(A, /mob/living/carbon/brain)

#define ishuman(A) istype(A, /mob/living/carbon/human)
//---------------------------------------------------

#define isanimal(A) istype(A, /mob/living/simple_animal)

#define iscorgi(A) istype(A, /mob/living/simple_animal/corgi)

#define ismouse(A) istype(A, /mob/living/simple_animal/mouse)
//---------------------------------------------------

#define issilicon(A) istype(A, /mob/living/silicon)

#define isAI(A) istype(A, /mob/living/silicon/ai)

#define ispAI(A) istype(A, /mob/living/silicon/pai)

#define isrobot(A) istype(A, /mob/living/silicon/robot)

#define isdrone(A) istype(A, /mob/living/silicon/robot/drone)


//---------------------------------------------------


//OBJECT LEVEL
#define isobj(A) istype(A, /obj)

#define isairlock(A) istype(A, /obj/machinery/door/airlock)

#define isorgan(A) istype(A, /obj/item/organ/external)

#define isitem(A) istype(A, /obj/item)


#define islist(A) istype(A, /list)

#define isatom(A) istype(A, /atom)
#define ismovable(A) istype(A, /atom/movable)

#define attack_animation(A) if(istype(A)) A.do_attack_animation(src)

// other
#define isclient(A) istype(A, /client)