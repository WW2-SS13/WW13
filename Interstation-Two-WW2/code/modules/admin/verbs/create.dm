/client/proc/create_crate()
	set name = "Create Custom Crate"
	set category = "Admin"

	if(!check_rights(R_MOD))
		return

	if(!mob || !mob.loc)
		src << "<span class = 'red'>You can't create a crate here.</span>"
		return

	var/list/types = list()

	while (TRUE)
		retype
		var/_type = input("What is the first type you want in the crate?") as text
		if (!ispath(text2path(_type)))
			src << "<span class = 'red'>Invalid path.</span>"
			goto retype

		var/amount = input("How much of this item do you want? (1 - 50, stacks merge") as num
		amount = Clamp(amount, 1, 50)
		types[_type] = amount
		var/cont = input("Add another type?") in list("Yes", "No")
		if (cont == "No")
			break

	var/list/objects = list()

	for (var/_type in types)
		var/amount = types[_type]
		if (findtext(_type, "obj/item/stack"))
			var/path = text2path(_type)
			objects += new path (null, amount)
		else
			for (var/v in 1 to amount)
				var/path = text2path(_type)
				objects += new path (null)

	if (!src || !mob || !mob.loc)
		qdel_list(objects)
		return

	var/obj/structure/closet/crate/empty/C = new/obj/structure/closet/crate/empty(mob.loc)
	C.contents = objects

	message_admins("[key_name(src)] created a custom crate at [mob.loc] ([mob.loc.x], [mob.loc.y], [mob.loc.z])")
	log_admin("[key_name(src)] created a custom crate at [mob.loc] ([mob.loc.x], [mob.loc.y], [mob.loc.z])")