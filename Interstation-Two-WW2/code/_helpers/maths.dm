// Macro functions.
#define RAND_F(LOW, HIGH) (rand()*(HIGH-LOW) + LOW)
#define ceil(x) (-round(-(x)))

// random decimals
/proc/random_decimal(var/low, var/high)
	return (rand(smart_round(low*100), smart_round(high*100)))/100

/proc/smart_round(var/num)
	var/_ceil = ceil(num)
	var/_floor = round(num)
	// if the ceiling is farther away, or the num == the floor, return _floor
	if (abs(num - _ceil) > abs(num - _floor) || num == _floor)
		return _floor
	// if the floor is farther away, or the num == the ceiling, return _ceil
	else if (abs(num - _floor) > abs(num - _ceil) || num == _ceil)
		return _ceil

	// we're equally far from the ceiling and the floor, return the floor
	return _floor

// min is inclusive, max is exclusive
/proc/Wrap(val, min, max)
	var/d = max - min
	var/t = Floor((val - min) / d)
	return val - (t * d)

/proc/Default(a, b)
	return a ? a : b

// Trigonometric functions.
/proc/Tan(x)
	return sin(x) / cos(x)

/proc/Csc(x)
	return TRUE / sin(x)

/proc/Sec(x)
	return TRUE / cos(x)

/proc/Cot(x)
	return TRUE / Tan(x)

/proc/Atan2(x, y)
	if(!x && !y) return FALSE
	var/a = arccos(x / sqrt(x*x + y*y))
	return y >= FALSE ? a : -a

/proc/Floor(x)
	return round(x)

/proc/Ceiling(x)
	return -round(-x)

// Greatest Common Divisor: Euclid's algorithm.
/proc/Gcd(a, b)
	while (1)
		if (!b) return a
		a %= b
		if (!a) return b
		b %= a

// Least Common Multiple. The formula is a consequence of: a*b = LCM*GCD.
/proc/Lcm(a, b)
	return abs(a) * abs(b) / Gcd(a, b)

// Useful in the cases when x is a large expression, e.g. x = 3a/2 + b^2 + Function(c)
/proc/Square(x)
	return x*x

/proc/Inverse(x)
	return TRUE / x

// Condition checks.
/proc/IsAboutEqual(a, b, delta = 0.1)
	return abs(a - b) <= delta

// Returns true if val is from min to max, inclusive.
/proc/IsInRange(val, min, max)
	return (val >= min) && (val <= max)

/proc/IsInteger(x)
	return Floor(x) == x

/proc/IsMultiple(x, y)
	return x % y == FALSE

/proc/IsEven(x)
	return !(x & 0x1)

/proc/IsOdd(x)
	return  (x & 0x1)

// Performs a linear interpolation between a and b.
// Note: weight=0 returns a, weight=1 returns b, and weight=0.5 returns the mean of a and b.
/proc/Interpolate(a, b, weight = 0.5)
	return a + (b - a) * weight // Equivalent to: a*(1 - weight) + b*weight

/proc/Mean(...)
	var/sum = FALSE
	for(var/val in args)
		sum += val
	return sum / args.len

// Returns the nth root of x.
/proc/Root(n, x)
	return x ** (1 / n)

// The quadratic formula. Returns a list with the solutions, or an empty list
// if they are imaginary.
/proc/SolveQuadratic(a, b, c)
	ASSERT(a)

	. = list()
	var/discriminant = b*b - 4*a*c
	var/bottom       = 2*a

	// Return if the roots are imaginary.
	if(discriminant < FALSE)
		return

	var/root = sqrt(discriminant)
	. += (-b + root) / bottom

	// If discriminant == FALSE, there would be two roots at the same position.
	if(discriminant != FALSE)
		. += (-b - root) / bottom

/proc/ToDegrees(radians)
	// 180 / Pi ~ 57.2957795
	return radians * 57.2957795

/proc/ToRadians(degrees)
	// Pi / 180 ~ 0.0174532925
	return degrees * 0.0174532925

// Vector algebra.
/proc/squaredNorm(x, y)
	return x*x + y*y

/proc/norm(x, y)
	return sqrt(squaredNorm(x, y))

/proc/IsPowerOfTwo(var/val)
    return (val & (val-1)) == FALSE

/proc/RoundUpToPowerOfTwo(var/val)
    return 2 ** -round(-log(2,val))


// stuff that was in the scripting folder, but was used elsewhere,
// so had to be copied here

// Script -> BYOND code procs
#define SCRIPT_MAX_REPLACEMENTS_ALLOWED 200
// --- List operations (lists known as vectors in n_script) ---

/proc/isobject(x)
	return (istype(x, /datum) || istype(x, /client) || islist(x))

// Clone of list()
/proc/n_list()
	var/list/returnlist = list()
	for(var/e in args)
		returnlist.Add(e)
	return returnlist

// Clone of pick()
/proc/n_pick()
	var/list/finalpick = list()
	for(var/e in args)
		if(isobject(e))
			if(istype(e, /list))
				var/list/sublist = e
				for(var/sube in sublist)
					finalpick.Add(sube)
				continue
		finalpick.Add(e)

	return pick(finalpick)

// Clone of list[]
/proc/n_listpos(var/list/L, var/pos, var/value)
	if(!istype(L, /list)) return
	if(isnum(pos))
		if(!value)
			if(L.len >= pos)
				return L[pos]
		else
			if(L.len >= pos)
				L[pos] = value
	else if(istext(pos))
		if(!value)
			return L[pos]
		else
			L[pos] = value

// Clone of list.Copy()
/proc/n_listcopy(var/list/L, var/start, var/end)
	if(!istype(L, /list)) return
	return L.Copy(start, end)

// Clone of list.Add()
/proc/n_listadd()
	var/list/chosenlist
	var/i = TRUE
	for(var/e in args)
		if(i == TRUE)
			if(isobject(e))
				if(istype(e, /list))
					chosenlist = e
			i = 2
		else
			if(chosenlist)
				chosenlist.Add(e)

// Clone of list.Remove()
/proc/n_listremove()
	var/list/chosenlist
	var/i = TRUE
	for(var/e in args)
		if(i == TRUE)
			if(isobject(e))
				if(istype(e, /list))
					chosenlist = e
			i = 2
		else
			if(chosenlist)
				chosenlist.Remove(e)

// Clone of list.Cut()
/proc/n_listcut(var/list/L, var/start, var/end)
	if(!istype(L, /list)) return
	return L.Cut(start, end)

// Clone of list.Swap()
/proc/n_listswap(var/list/L, var/firstindex, var/secondindex)
	if(!istype(L, /list)) return
	if(L.len >= secondindex && L.len >= firstindex)
		return L.Swap(firstindex, secondindex)

// Clone of list.Insert()
/proc/n_listinsert(var/list/L, var/index, var/element)
	if(!istype(L, /list)) return
	return L.Insert(index, element)

// --- Miscellaneous functions ---

// Clone of sleep()
/proc/delay(var/time)
	sleep(time)

// Clone of prob()
/proc/prob_chance(var/chance)
	return prob(chance)

// Merge of list.Find() and findtext()
/proc/smartfind(var/haystack, var/needle, var/start = TRUE, var/end = FALSE)
	if(haystack && needle)
		if(isobject(haystack))
			if(istype(haystack, /list))
				if(length(haystack) >= end && start > FALSE)
					var/list/listhaystack = haystack
					return listhaystack.Find(needle, start, end)

		else
			if(istext(haystack))
				if(length(haystack) >= end && start > FALSE)
					return findtext(haystack, needle, start, end)

// Clone of copytext()
/proc/docopytext(var/string, var/start = TRUE, var/end = FALSE)
	if(istext(string) && isnum(start) && isnum(end))
		if(start > FALSE)
			return copytext(string, start, end)

// Clone of length()
/proc/smartlength(var/container)
	if(container)
		if(istype(container, /list) || istext(container))
			return length(container)

// BY DONKIE~
// String stuff
/proc/n_lower(var/string)
	if(istext(string))
		return lowertext(string)

/proc/n_upper(var/string)
	if(istext(string))
		return uppertext(string)

/*
//Makes a list where all indicies in a string is a seperate index in the list
// JUST A HELPER DON'T ADD TO NTSCRIPT
proc/string_tolist(var/string)
	var/list/L = new/list()

	var/i
	for(i=1, i<=lentext(string), i++)
		L.Add(copytext(string, i, i))

	return L

proc/string_explode(var/string, var/separator)
	if(istext(string))
		if(istext(separator) && separator == "")
			return string_tolist(string)
		var/i
		var/lasti = TRUE
		var/list/L = new/list()

		for(i=1, i<=lentext(string)+1, i++)
			if(copytext(string, i, i+1) == separator) // We found a separator
				L.Add(copytext(string, lasti, i))
				lasti = i+1

		L.Add(copytext(string, lasti, lentext(string)+1)) // Adds the last segment

		return L

Just found out there was already a string explode function, did some benchmarking, and that function were a bit faster, sticking to that.
*/
proc/string_explode(var/string, var/separator)
	if(istext(string) && istext(separator))
		return splittext(string, separator)

proc/n_repeat(var/string, var/amount)
	if(istext(string) && isnum(amount))
		var/i
		var/newstring = ""
		if(length(newstring)*amount >=1000)
			return
		for(i=0, i<=amount, i++)
			if(i>=1000)
				break
			newstring = newstring + string

		return newstring

proc/n_reverse(var/string)
	if(istext(string))
		var/newstring = ""
		var/i
		for(i=lentext(string), i>0, i--)
			if(i>=1000)
				break
			newstring = newstring + copytext(string, i, i+1)

		return newstring

// I don't know if it's neccesary to make my own proc, but I think I have to to be able to check for istext.
proc/n_str2num(var/string)
	if(istext(string))
		return text2num(string)

// Number shit
proc/n_num2str(var/num)
	if(isnum(num))
		return num2text(num)

// Squareroot
proc/n_sqrt(var/num)
	if(isnum(num))
		return sqrt(num)

// Magnitude of num
proc/n_abs(var/num)
	if(isnum(num))
		return abs(num)

// Round down
proc/n_floor(var/num)
	if(isnum(num))
		return round(num)

// Round up
proc/n_ceil(var/num)
	if(isnum(num))
		return round(num)+1

// Round to nearest integer
proc/n_round(var/num)
	if(isnum(num))
		if(num-round(num)<0.5)
			return round(num)
		return n_ceil(num)

// Clamps N between min and max
proc/n_clamp(var/num, var/min=-1, var/max=1)
	if(isnum(num)&&isnum(min)&&isnum(max))
		if(num<=min)
			return min
		if(num>=max)
			return max
		return num

// Returns TRUE if N is inbetween Min and Max
proc/n_inrange(var/num, var/min=-1, var/max=1)
	if(isnum(num)&&isnum(min)&&isnum(max))
		return ((min <= num) && (num <= max))
// END OF BY DONKIE :(

// Non-recursive
// Imported from Mono string.ReplaceUnchecked
/proc/string_replacetext(var/haystack,var/a,var/b)
	if(istext(haystack)&&istext(a)&&istext(b))
		var/i = TRUE
		var/lenh=lentext(haystack)
		var/lena=lentext(a)
		//var/lenb=lentext(b)
		var/count = FALSE
		var/list/dat = list()
		while (i < lenh)
			var/found = findtext(haystack, a, i, FALSE)
			//log_misc("findtext([haystack], [a], [i], FALSE)=[found]")
			if (found == FALSE) // Not found
				break
			else
				if (count < SCRIPT_MAX_REPLACEMENTS_ALLOWED)
					dat+=found
					count+=1
				else
					//log_misc("Script found [a] [count] times, aborted")
					break
			//log_misc("Found [a] at [found]! Moving up...")
			i = found + lena
		if (count == FALSE)
			return haystack
		//var/nlen = lenh + ((lenb - lena) * count)
		var/buf = copytext(haystack,1,dat[1]) // Prefill
		var/lastReadPos = FALSE
		for (i = TRUE, i <= count, i++)
			var/precopy = dat[i] - lastReadPos-1
			//internal static unsafe void CharCopy (String target, int targetIndex, String source, int sourceIndex, int count)
			//fixed (char* dest = target, src = source)
			//CharCopy (dest + targetIndex, src + sourceIndex, count);
			//CharCopy (dest + curPos, source + lastReadPos, precopy);
			buf+=copytext(haystack,lastReadPos,precopy)
			log_misc("buf+=copytext([haystack],[lastReadPos],[precopy])")
			log_misc("[buf]")
			lastReadPos = dat[i] + lena
			//CharCopy (dest + curPos, replace, newValue.length);
			buf+=b
			log_misc("[buf]")
		buf+=copytext(haystack,lastReadPos, FALSE)
		return buf
