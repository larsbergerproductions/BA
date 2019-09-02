from fractions import Fraction
import numpy as np


def egyptian_partition(frac):
	if frac.numerator == 1:
		return [Fraction(frac.numerator, frac.denominator)]
	else:
		result = []
		remainder = Fraction(frac.numerator, frac.denominator)
		candidate = Fraction(1, 1)
		while Fraction(sum(result)) < frac:
			if len(result) > 0:
				candidate = Fraction(min(result)).denominator + 1
			while Fraction(1, candidate) > frac - sum(result):
				candidate += 1
				if candidate % 1e6 == 0:  # for REALLY long calculations
					print("currently tried:" + str(candidate))
			# found right candidate
			result.append(Fraction(1, candidate))
			# print("appended" + str(Fraction(1, candidate)))
		return result


def find_largest_fitting_unit_fraction(frac):
	result = Fraction(1, frac.denominator)
	while result < frac:
		result += Fraction(1,result.denominator)
	return result


def optimize_egyptian_partition(part_list):
	
	return None


# frac_to_find_for = Fraction(5,129)
# found_for_frac = find_largest_fitting_unit_fraction(frac_to_find_for)
# print("the largest unit fraction fitting into {0} is {1}".format(frac_to_find_for, found_for_frac))

# insert fraction here:
my_frac = Fraction(41, 42)
my_result = egyptian_partition(my_frac)
print("\n\n\n\n")
print(str(my_frac) + " = ", end='')
print(*my_result, sep=' + ')
# if sum(my_result) != my_frac:
# 	print("failed")
# else:
# 	print("success!")
#
# optimized = optimize_egyptian_partition(my_result)
# print(optimized)
