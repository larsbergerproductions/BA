listsum(list) = sum(i=1,#list,list[i]);


egyp(fraction)=
{ local(candidate, result);
	result=List();
	candidate = 1; /*only allowing fractions $a/b < 1$ */
	
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
		candidate += 1;
		while (1/candidate > fraction - listsum(result),
			candidate += 1;
		);
		print("adding ", 1/candidate);
		listput(result, 1/candidate);
	);
	
	return(result);
}


/* +++ for shorter usage in command line use +++ */
e(fraction) = egyp(fraction);

/* show timer for each calculation */
#

print("You can use \"e(frac)\" to get the egyptian fraction sum for frac. Note, that frac should be less than or equal to one.")
