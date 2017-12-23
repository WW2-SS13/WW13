/turf/floor/ex_act(severity)
	switch(severity)
		if(1.0)
			ChangeTurf(get_base_turf_by_area(src))
		if(2.0)
			if (prob(75))
				ChangeTurf(get_base_turf_by_area(src))
			else
				break_tile()
				hotspot_expose(1000,CELL_VOLUME)
		if(3.0)
			if (prob(50))
				break_tile()
				hotspot_expose(1000,CELL_VOLUME)
	return

/turf/floor/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)

	var/temp_destroy = get_damage_temperature()
	if(!burnt && prob(5))
		burn_tile(exposed_temperature)
	else if(temp_destroy && exposed_temperature >= (temp_destroy + 100) && prob(1) && !is_plating())
		make_plating() //destroy the tile, exposing plating
		burn_tile(exposed_temperature)
	return

//should be a little bit lower than the temperature required to destroy the material
/turf/floor/proc/get_damage_temperature()
	return flooring ? flooring.damage_temperature : null

/turf/floor/adjacent_fire_act(turf/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	var/dir_to = get_dir(src, adj_turf)

	for(var/obj/structure/window/W in src)
		if(W.dir == dir_to || W.is_fulltile()) //Same direction or diagonal (full tile)
			W.fire_act(adj_air, adj_temp, adj_volume)
