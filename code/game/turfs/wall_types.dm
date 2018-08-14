/turf/wall/r_wall
	icon_state = "rgeneric"
	hitsounds = list('sound/weapons/bullethit/Metal01.ogg', 'sound/weapons/bullethit/Metal02.ogg',\
				'sound/weapons/bullethit/Metal03.ogg', 'sound/weapons/bullethit/Metal04.ogg',\
				'sound/weapons/bullethit/Metal05.ogg', 'sound/weapons/bullethit/Metal06.ogg',\
				'sound/weapons/bullethit/Metal07.ogg', 'sound/weapons/bullethit/Metal08.ogg',\
				'sound/weapons/bullethit/Metal09.ogg')

/turf/wall/r_wall/New(var/newloc)
	..(newloc, "plasteel","plasteel") //3strong

/turf/shuttle/wall
	name = "wall"
	icon_state = "wall1"
	opacity = TRUE
	density = TRUE
//	blocks_air = TRUE
/*
/turf/shuttle/wall/cargo
	name = "Cargo Transport Shuttle (A5)"
	icon = 'icons/turf/shuttlecargo.dmi'
	icon_state = "cargoshwall1"
/turf/shuttle/wall/escpod
	name = "Escape Pod"
	icon = 'icons/turf/shuttleescpod.dmi'
	icon_state = "escpodwall1"
/turf/shuttle/wall/mining
	name = "Mining Barge"
	icon = 'icons/turf/shuttlemining.dmi'
	icon_state = "11,23"

/obj/structure/shuttle_part //For placing them over space, if sprite covers not whole tile.
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	anchored = TRUE
	density = TRUE

/obj/structure/shuttle_part/cargo
	name = "Cargo Transport Shuttle (A5)"
	icon = 'icons/turf/shuttlecargo.dmi'
	icon_state = "cargoshwall1"
/obj/structure/shuttle_part/escpod
	name = "Escape Pod"
	icon = 'icons/turf/shuttleescpod.dmi'
	icon_state = "escpodwall1"
/obj/structure/shuttle_part/mining
	name = "Mining Barge"
	icon = 'icons/turf/shuttlemining.dmi'
	icon_state = "11,23"
/obj/structure/shuttle_part/ex_act(severity) //Making them indestructible, like shuttle walls
    return FALSE*/
/turf/wall/iron
	hitsounds = list('sound/weapons/bullethit/Metal01.ogg', 'sound/weapons/bullethit/Metal02.ogg',\
				'sound/weapons/bullethit/Metal03.ogg', 'sound/weapons/bullethit/Metal04.ogg',\
				'sound/weapons/bullethit/Metal05.ogg', 'sound/weapons/bullethit/Metal06.ogg',\
				'sound/weapons/bullethit/Metal07.ogg', 'sound/weapons/bullethit/Metal08.ogg',\
				'sound/weapons/bullethit/Metal09.ogg')
/turf/wall/iron/New(var/newloc)
	..(newloc,"iron")

/turf/wall/brick
	hitsounds = list('sound/weapons/bullethit/Asphalt1.ogg', 'sound/weapons/bullethit/Asphalt2.ogg',\
				'sound/weapons/bullethit/Asphalt3.ogg', 'sound/weapons/bullethit/Asphalt4.ogg',\
				'sound/weapons/bullethit/Asphalt5.ogg')

/turf/wall/brick/New(var/newloc)
	..(newloc,"brick")

/turf/wall/uranium
	hitsounds = list('sound/weapons/bullethit/Metal01.ogg', 'sound/weapons/bullethit/Metal02.ogg',\
				'sound/weapons/bullethit/Metal03.ogg', 'sound/weapons/bullethit/Metal04.ogg',\
				'sound/weapons/bullethit/Metal05.ogg', 'sound/weapons/bullethit/Metal06.ogg',\
				'sound/weapons/bullethit/Metal07.ogg', 'sound/weapons/bullethit/Metal08.ogg',\
				'sound/weapons/bullethit/Metal09.ogg')

/turf/wall/uranium/New(var/newloc)
	..(newloc,"uranium")

/turf/wall/diamond
	hitsounds = list('sound/weapons/bullethit/Metal01.ogg', 'sound/weapons/bullethit/Metal02.ogg',\
				'sound/weapons/bullethit/Metal03.ogg', 'sound/weapons/bullethit/Metal04.ogg',\
				'sound/weapons/bullethit/Metal05.ogg', 'sound/weapons/bullethit/Metal06.ogg',\
				'sound/weapons/bullethit/Metal07.ogg', 'sound/weapons/bullethit/Metal08.ogg',\
				'sound/weapons/bullethit/Metal09.ogg')

/turf/wall/diamond/New(var/newloc)
	..(newloc,"diamond")
	hitsounds = list('sound/weapons/bullethit/Metal01.ogg', 'sound/weapons/bullethit/Metal02.ogg',\
				'sound/weapons/bullethit/Metal03.ogg', 'sound/weapons/bullethit/Metal04.ogg',\
				'sound/weapons/bullethit/Metal05.ogg', 'sound/weapons/bullethit/Metal06.ogg',\
				'sound/weapons/bullethit/Metal07.ogg', 'sound/weapons/bullethit/Metal08.ogg',\
				'sound/weapons/bullethit/Metal09.ogg')

/turf/wall/gold
	hitsounds = list('sound/weapons/bullethit/Metal01.ogg', 'sound/weapons/bullethit/Metal02.ogg',\
				'sound/weapons/bullethit/Metal03.ogg', 'sound/weapons/bullethit/Metal04.ogg',\
				'sound/weapons/bullethit/Metal05.ogg', 'sound/weapons/bullethit/Metal06.ogg',\
				'sound/weapons/bullethit/Metal07.ogg', 'sound/weapons/bullethit/Metal08.ogg',\
				'sound/weapons/bullethit/Metal09.ogg')

/turf/wall/gold/New(var/newloc)
	..(newloc,"gold")

/turf/wall/silver
	hitsounds = list('sound/weapons/bullethit/Metal01.ogg', 'sound/weapons/bullethit/Metal02.ogg',\
				'sound/weapons/bullethit/Metal03.ogg', 'sound/weapons/bullethit/Metal04.ogg',\
				'sound/weapons/bullethit/Metal05.ogg', 'sound/weapons/bullethit/Metal06.ogg',\
				'sound/weapons/bullethit/Metal07.ogg', 'sound/weapons/bullethit/Metal08.ogg',\
				'sound/weapons/bullethit/Metal09.ogg')

/turf/wall/silver/New(var/newloc)
	..(newloc,"silver")

/turf/wall/plasma
	hitsounds = list('sound/weapons/bullethit/Metal01.ogg', 'sound/weapons/bullethit/Metal02.ogg',\
				'sound/weapons/bullethit/Metal03.ogg', 'sound/weapons/bullethit/Metal04.ogg',\
				'sound/weapons/bullethit/Metal05.ogg', 'sound/weapons/bullethit/Metal06.ogg',\
				'sound/weapons/bullethit/Metal07.ogg', 'sound/weapons/bullethit/Metal08.ogg',\
				'sound/weapons/bullethit/Metal09.ogg')

/turf/wall/plasma/New(var/newloc)
	..(newloc,"plasma")

/turf/wall/stone
	hitsounds = list('sound/weapons/bullethit/Asphalt1.ogg', 'sound/weapons/bullethit/Asphalt2.ogg',\
				'sound/weapons/bullethit/Asphalt3.ogg', 'sound/weapons/bullethit/Asphalt4.ogg',\
				'sound/weapons/bullethit/Asphalt5.ogg')

/turf/wall/stone/New(var/newloc)
	..(newloc,"stone")

/turf/wall/sandstone
	hitsounds = list('sound/weapons/bullethit/Asphalt1.ogg', 'sound/weapons/bullethit/Asphalt2.ogg',\
				'sound/weapons/bullethit/Asphalt3.ogg', 'sound/weapons/bullethit/Asphalt4.ogg',\
				'sound/weapons/bullethit/Asphalt5.ogg')

/turf/wall/sandstone/New(var/newloc)
	..(newloc,"sandstone")

/turf/wall/wood
	hitsounds = list('sound/weapons/bullethit/Grass1.ogg', 'sound/weapons/bullethit/Grass2.ogg',\
					'sound/weapons/bullethit/Grass3.ogg', 'sound/weapons/bullethit/Grass4.ogg',\
					'sound/weapons/bullethit/Grass5.ogg')

/turf/wall/wood/New(var/newloc)
	..(newloc,"hardwood")

/turf/wall/indestructable
	hitsounds = list('sound/weapons/bullethit/Asphalt1.ogg', 'sound/weapons/bullethit/Asphalt2.ogg',\
				'sound/weapons/bullethit/Asphalt3.ogg', 'sound/weapons/bullethit/Asphalt4.ogg',\
				'sound/weapons/bullethit/Asphalt5.ogg')

/turf/wall/indestructable
	icon_state = "rgeneric" // so we look better on the map

/turf/wall/indestructable/black
	color = "#000000"

/turf/wall/indestructable/New(var/newloc)
	icon_state = initial(icon_state)
	..(newloc,"indestructable")

/turf/wall/indestructable/ex_act(severity)
	return FALSE

/turf/wall/ironplasma
	hitsounds = list('sound/weapons/bullethit/Metal01.ogg', 'sound/weapons/bullethit/Metal02.ogg',\
				'sound/weapons/bullethit/Metal03.ogg', 'sound/weapons/bullethit/Metal04.ogg',\
				'sound/weapons/bullethit/Metal05.ogg', 'sound/weapons/bullethit/Metal06.ogg',\
				'sound/weapons/bullethit/Metal07.ogg', 'sound/weapons/bullethit/Metal08.ogg',\
				'sound/weapons/bullethit/Metal09.ogg')

/turf/wall/ironplasma/New(var/newloc)
	..(newloc,"iron","plasma")

/turf/wall/golddiamond
	hitsounds = list('sound/weapons/bullethit/Metal01.ogg', 'sound/weapons/bullethit/Metal02.ogg',\
				'sound/weapons/bullethit/Metal03.ogg', 'sound/weapons/bullethit/Metal04.ogg',\
				'sound/weapons/bullethit/Metal05.ogg', 'sound/weapons/bullethit/Metal06.ogg',\
				'sound/weapons/bullethit/Metal07.ogg', 'sound/weapons/bullethit/Metal08.ogg',\
				'sound/weapons/bullethit/Metal09.ogg')

/turf/wall/golddiamond/New(var/newloc)
	..(newloc,"gold","diamond")

/turf/wall/silvergold
	hitsounds = list('sound/weapons/bullethit/Metal01.ogg', 'sound/weapons/bullethit/Metal02.ogg',\
				'sound/weapons/bullethit/Metal03.ogg', 'sound/weapons/bullethit/Metal04.ogg',\
				'sound/weapons/bullethit/Metal05.ogg', 'sound/weapons/bullethit/Metal06.ogg',\
				'sound/weapons/bullethit/Metal07.ogg', 'sound/weapons/bullethit/Metal08.ogg',\
				'sound/weapons/bullethit/Metal09.ogg')

/turf/wall/silvergold/New(var/newloc)
	..(newloc,"silver","gold")

/turf/wall/sandstonediamond
	hitsounds = list('sound/weapons/bullethit/Metal01.ogg', 'sound/weapons/bullethit/Metal02.ogg',\
				'sound/weapons/bullethit/Metal03.ogg', 'sound/weapons/bullethit/Metal04.ogg',\
				'sound/weapons/bullethit/Metal05.ogg', 'sound/weapons/bullethit/Metal06.ogg',\
				'sound/weapons/bullethit/Metal07.ogg', 'sound/weapons/bullethit/Metal08.ogg',\
				'sound/weapons/bullethit/Metal09.ogg')

/turf/wall/sandstonediamond/New(var/newloc)
	..(newloc,"sandstone","diamond")

// Kind of wondering if this is going to bite me in the butt.
/turf/wall/voxshuttle/New(var/newloc)
	..(newloc,"voxalloy")

/turf/wall/voxshuttle/attackby()
	return

/turf/wall/titanium
	hitsounds = list('sound/weapons/bullethit/Metal01.ogg', 'sound/weapons/bullethit/Metal02.ogg',\
				'sound/weapons/bullethit/Metal03.ogg', 'sound/weapons/bullethit/Metal04.ogg',\
				'sound/weapons/bullethit/Metal05.ogg', 'sound/weapons/bullethit/Metal06.ogg',\
				'sound/weapons/bullethit/Metal07.ogg', 'sound/weapons/bullethit/Metal08.ogg',\
				'sound/weapons/bullethit/Metal09.ogg')

/turf/wall/titanium/New(var/newloc)
	..(newloc,"titanium")
