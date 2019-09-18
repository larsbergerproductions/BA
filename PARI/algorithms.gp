listsum(list) = sum(i=1,#list,list[i]);


fibonacci_sylvester(fraction, stepsize, start)=
{ local(candidate, result);
	result=List();
	candidate = start;

	/* print error if fraction is larger one */
	if (numerator(fraction) > denominator(fraction),
		print("fraction is larger than 1. Use fractions smaller or equal to 1.");
		return;
	);

	/* check if fraction is a unit fraction */
	if (numerator(fraction) == 1,
		print("fraction was already a unit fraction");
		listput(result, fraction);
	);

	/* calculate summands and add them to the result */
	while (listsum(result) < fraction,
		candidate += stepsize;
		while (1/candidate > fraction - listsum(result),
			candidate += stepsize;
		);
		print("adding ", 1/candidate);
		listput(result, 1/candidate);
	);

	return(result);
}


greedy(fraction) = fibonacci_sylvester(fraction, 1, 1);
greedy_odd(fraction) = {print("\nthis might not come to an end!\n");
			alarm(3600, fibonacci_sylvester(fraction, 2, 1));}
greedy_even(fraction) = fibonacci_sylvester(fraction, 2, 0);


FareySeries(order)=
{local(result);
	result = List();
	for(den=1,order,
		for(num=0, den,
			candidate = num/den;
			if(setsearch(result, candidate)==0,
				listput(result, num/den);
			)
		)
	);
	result = vecsort(Vec(result));
	return(result);
}


/* show timer for each calculation */
#
print("\n available main functions, not recommended for usage:\n - fibonacci_sylvester(frac, stepsize, start)\n");
print("Available algos:\n - greedy(frac)\n - greedy_odd(frac)\n - greedy_even(frac)");
