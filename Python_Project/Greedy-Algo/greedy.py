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
				if candidate % 1e6 == 0:                                # for REAL long calculations
					print("currently tried:" + str(candidate))
			# found right candidate
			result.append(Fraction(1, candidate))
			print("appended" + str(Fraction(1, candidate)))
		# insert calculating code here!
		
		return result


my_frac = Fraction(41, 42)
my_result = egyptian_partition(my_frac)
print(str(my_frac) + " = ", end='')
print(*my_result, sep=' + ')
if sum(my_result) != my_frac:
	print("failed")
else:
	print("success!")
