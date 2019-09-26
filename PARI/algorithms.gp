listsum(list) = sum(i=1,#list,list[i]);

fibonacci_sylvester(fraction, stepsize, start)={
	local(candidate, result);
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
		/*print("adding ", 1/candidate);*/
		listput(result, 1/candidate);
	);
	return(Vec(result));
}

greedy(fraction) = fibonacci_sylvester(fraction, 1, 1);
greedy_odd(fraction) = {print("\nthis might not come to an end!\n");
			alarm(3600, fibonacci_sylvester(fraction, 2, 1));}
greedy_even(fraction) = fibonacci_sylvester(fraction, 2, 0);

largestUnitFractionLEQ(fraction)={
	/* x: current candidate, ub: currently known upper bound*/
	local(x,ub);
	x=2;
	ub=0;

	/*catch unit fractions for efficiency*/
	if(numerator(fraction) == 1,
		return(fraction);
	);

	while(1/x > fraction,
		x*=2;
	);

	ub=x;

	while(x > 1,
		x /= 2;
		if(1/(ub-x) <= fraction,
			ub -= x;
		);
	);
	return(1/ub);
}

greedy_fast(fraction)={
	local(result);
	result = List();
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
		listput(result, largestUnitFractionLEQ(fraction-listsum(result)));
	);
	return(Vec(result));
}

contains(lst, element)={
	for(i=1, #lst,
		if(element == lst[i],
			return(1);
		);
	);
	return(0);
}

findAdjacent(Fs, fraction)={
	for(i=1, #Fs-1,
		if(fraction == Fs[i],
			return(Fs[i-1]);
		);
		if(fraction > Fs[i],
			if(fraction < Fs[i+1],
				return(Fs[i]);
			);
		);
	);
	return(-1);
}

FareySeries(order)={
	local(result);
	result = List();
	for(den=1,order,
		for(num=0, den,
			if(contains(result, num/den)==0,
				listput(result, num/den);
			);
		);
	);
	result = vecsort(Vec(result));
	return(result);
}

reverse_vecsort(vect)={
	local(result);
	result = List();
	vect = vecsort(vect);
	forstep(i=#vect,1,-1,listput(result, vect[i]));
	return(Vec(result));

}

FS(fract)={
	local(adjacent, remainder, result);
	result = List();
	while(1,
		adjacent = findAdjacent(FareySeries(denominator(fract)), fract);
		remainder = 1/(denominator(fract)*denominator(adjacent));
		listput(result, remainder);
		if(numerator(adjacent) == 1,
			listput(result, adjacent);
			return(reverse_vecsort(Vec(result)));
		);
		fract = adjacent;
	);
	return(-1);
}


/* show timer for each calculation */
#
print("\n#########################\n#    Script provided    #\n#           by          #\n#    Lt. Lars Berger    #\n#    Universität der    #\n#   Bundeswehr München  #\n#########################")
print("\n available main functions, not recommended for usage:\n - fibonacci_sylvester(frac, stepsize, start)\n");
print("Available secondary functions:\n - Farey_Series(order)\n - largestUnitFractionLEQ(frac)\n - isAdjacent(frac1, frac2)\n");
print("Available Algorithms for Egyptian Fractions:\n - greedy(frac)\n - greedy_odd(frac)\n - greedy_even(frac)\n - greedy_fast(frac)");
