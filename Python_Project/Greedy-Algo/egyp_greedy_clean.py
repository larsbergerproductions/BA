from fractions import Fraction


def egyptian_partition(frac):
	if frac.numerator == 1:
		return [Fraction(frac.numerator, frac.denominator)]
	else:
		result = []  # list of fractions representing all summands of the egyptian sum
		candidate = 1  # begin with 1/1 as first candidate fraction
		while sum(result) < frac:
			if len(result) != 0:
				print("current result (unfinished): adding " + str(min(result)) + " = " + str(sum(result)))
			candidate += 1  # don't use the same candidate twice
			while Fraction(1, candidate) > frac - sum(result):
				candidate += 1
				if candidate % 1e6 == 0:  # for REALLY long calculations
					print("currently tried: 1/" + str(candidate))
			# found right candidate
			result.append(Fraction(1, candidate))
		return result


# main loop with inputs and outputs
while True:
	my_numerator = input("Type in your numerator or put \"q\" to exit: ")
	if my_numerator.lower() == "q":
		break
	else:
		my_numerator = int(my_numerator)
	my_denominator = int(input("Type in your denominator: "))
	if my_denominator == 0:
		print("Division by Zero error!\n")
		continue
	my_frac = Fraction(my_numerator, my_denominator)
	my_result = egyptian_partition(my_frac)
	print(str(my_frac) + " = ", end='')
	print(*my_result, sep=' + ', end="\n")
