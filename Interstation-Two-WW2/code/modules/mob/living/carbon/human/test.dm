/*Hardcore mode stuff. This was moved here because constants that are only used
  at one spot in the code shouldn't be in the __defines folder */

#define DEHYDRATION_MIN 0 //If you have less water than this value, the hunger indicator starts flashing

#define DEHYDRATION_NOTICE -15 //If you have more water than this value, you get an occasional message reminding you that you're going to starve soon

#define DEHYDRATION_WEAKNESS -40 //Otherwise, if you have more water than this value, you occasionally become weak and receive minor damage

#define DEHYDRATION_NEARDEATH -55 //Otherwise, if you have more water than this value, you have seizures and occasionally receive damage

#define DEHYDRATION_NEGATIVE_INFINITY -10000 // because trying to parse INFINITY into text is bad

//If you have less water than DEHYDRATION_NEARDEATH, you start getting damage

#define DEHYDRATION_OXY_DAMAGE 2.5
#define DEHYDRATION_TOX_DAMAGE 2.5
#define DEHYDRATION_BRAIN_DAMAGE 2.5
#define DEHYDRATION_OXY_HEAL_RATE 1 //While starving, THIS much oxygen damage is restored per life tick (instead of the default 5)

/mob/living/carbon/human/var/list/informed_dehydration[4]

/mob/living/carbon/human/proc/handle_dehydration()//Making this it's own proc for my sanity's sake - Matt

	if(water < 350 && water >= 250)
		if (prob(3))
			src << "<span class = 'notice'>You're getting a bit thirsty.</span>"

	if(water < 250)
		if (prob(4))
			src << "<span class = 'notice'>You're pretty thirsty.</span>"

	if(water < 20) //Nutrition is below 20 = dehydration

		var/list/thirst_phrases = list(
			"You feel weak and malnourished. You must find something to drink now!",
			"You haven't drank in ages, and your body feels weak! It's time to drink something.",
			"You can barely remember the last time you had something to drink!",
			"Your body is starting to dehydrate! You have to drink something soon.",
			"If you don't drink something very soon, you're going to dehydrate to death."
			)

		//When you're starving, the rate at which oxygen damage is healed is reduced by 80% (you only restore 1 oxygen damage per life tick, instead of 5)

		switch(water)
			if(DEHYDRATION_NOTICE to DEHYDRATION_MIN)
				if(sleeping) return

				if (!informed_dehydration[num2text(-DEHYDRATION_NOTICE)])
					src << "<span class='notice'>[pick("You're very thirsty.","You really could use some water right now.")]</span>"

				informed_dehydration[num2text(-DEHYDRATION_NOTICE)] = 1
				informed_dehydration[num2text(-DEHYDRATION_WEAKNESS)] = 0
				informed_dehydration[num2text(-DEHYDRATION_NEARDEATH)] = 0
				informed_dehydration[num2text(-DEHYDRATION_NEGATIVE_INFINITY)] = 0

				if(prob(10))
					src << "<span class='notice'>[pick("You're very thirsty.","You really could use some water right now.")]</span>"

			if(DEHYDRATION_WEAKNESS to DEHYDRATION_NOTICE)
				if(sleeping) return

				if (!informed_dehydration[num2text(-DEHYDRATION_WEAKNESS)])
					src << "<span class='danger'>[pick(thirst_phrases)]</span>"

				informed_dehydration[num2text(-DEHYDRATION_NOTICE)] = 1
				informed_dehydration[num2text(-DEHYDRATION_WEAKNESS)] = 1
				informed_dehydration[num2text(-DEHYDRATION_NEARDEATH)] = 0
				informed_dehydration[num2text(-DEHYDRATION_NEGATIVE_INFINITY)] = 0

				if(prob(6)) //6% chance of a tiny amount of oxygen damage (1-5)

					adjustOxyLoss(rand(1,5))
					src << "<span class='danger'>[pick(thirst_phrases)]</span>"

				else if(prob(5)) //5% chance of being weakened

					eye_blurry += 10
					Weaken(10)
					adjustOxyLoss(rand(1,15))
					src << "<span class='danger'>You're dehydrating! The lack of strength makes you black out for a few moments...</span>"

			if(DEHYDRATION_NEARDEATH to DEHYDRATION_WEAKNESS) //5-30, 5% chance of weakening and 1-230 oxygen damage. 5% chance of a seizure. 10% chance of dropping item
				if(sleeping) return

				if (!informed_dehydration[num2text(-DEHYDRATION_NEARDEATH)])
					src << "<span class='danger'>You're dehydrating. You feel your life force slowly leaving your body...</span>"

				informed_dehydration[num2text(-DEHYDRATION_NOTICE)] = 1
				informed_dehydration[num2text(-DEHYDRATION_WEAKNESS)] = 1
				informed_dehydration[num2text(-DEHYDRATION_NEARDEATH)] = 1
				informed_dehydration[num2text(-DEHYDRATION_NEGATIVE_INFINITY)] = 0

				if(prob(7))

					adjustOxyLoss(rand(1,20))
					src << "<span class='danger'>You're dehydrating. You feel your life force slowly leaving your body...</span>"
					eye_blurry += 20
					if(weakened < 1) Weaken(20)

				else if(paralysis<1 && prob(7)) //Mini seizure (25% duration and strength of a normal seizure)

					visible_message("<span class='danger'>\The [src] starts having a seizure!</span>", \
							"<span class='warning'>You have a seizure!</span>")
					Paralyse(5)
					make_jittery(500)
					adjustOxyLoss(rand(1,25))
					eye_blurry += 20

			if(-INFINITY to DEHYDRATION_NEARDEATH) //Fuck the whole body up at this point

				if (!informed_dehydration[num2text(-DEHYDRATION_NEGATIVE_INFINITY)])
					src << "<span class='danger'>You are dying from dehydration!</span>"

				informed_dehydration[num2text(-DEHYDRATION_NOTICE)] = 1
				informed_dehydration[num2text(-DEHYDRATION_WEAKNESS)] = 1
				informed_dehydration[num2text(-DEHYDRATION_NEARDEATH)] = 1
				informed_dehydration[num2text(-DEHYDRATION_NEGATIVE_INFINITY)] = 1

				if (prob(10))
					src << "<span class='danger'>You are dying from dehydration!</span>"

				adjustToxLoss(DEHYDRATION_TOX_DAMAGE)
				adjustOxyLoss(DEHYDRATION_OXY_DAMAGE)
				adjustBrainLoss(DEHYDRATION_BRAIN_DAMAGE)

				if(prob(10))
					Weaken(15)