#define forlist(list) for (var/current in list)
#define forrange(x) for (var/current = 1 to x)

/proc/test()

	for (var/last_object in clients)
		var/client/C = last_object

	for (var/v in 1 to 10)
		world << v

	forlist(clients)
		var/client/C = current

	forrange(10)
		world << current // will output 1 through 10