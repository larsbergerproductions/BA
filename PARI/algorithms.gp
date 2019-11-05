listsum(list) = sum(i=1,#list,list[i]);
listmin(list) = {local(minimum); minimum=list[1]; for(i=1,#list,if(list[i]<minimum, minimum = list[i])); return(minimum)}
listmax(list) = {local(maximum); maximum=list[1]; for(i=1,#list,if(list[i]>maximum, maximum = list[i])); return(maximum)}

fibonacci_sylvester(fraction, stepsize, start)={
	/*candidate: current candidate, result: list with resulting unit fractions*/
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
		print("adding ", 1/candidate);
		listput(result, 1/candidate);
	);
	print("Greedy: ", fraction, " = ", printEgypFrac(result));
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
	print("Greedy fast:\t", fraction, " = ", printEgypFrac(result));
	return(Vec(result));
}

contains(list, element)={
	for(i=1, #list,
		if(element == list[i],
			return(1);
		);
	);
	return(0);
}

reverse_vecsort(vect)={
	local(result);
	result = List();
	vect = vecsort(vect);
	forstep(i = #vect, 1, -1, listput(result, vect[i]));
	return(Vec(result));
}

FareySeries(order)={
	local(result);
	result = List();
	for(den=1,order,
		for(num=0, den,
			listput(result, num/den);
		);
	);
	result = vecsort(Vec(Set(result)));
	return(result);
}

findAdjacent(Fs, fraction)={
	/*lb: lower bound, ub: upper bound, index: index of currently examiined fraction in Fq*/
	local(lb,ub,index);
	if(fraction == Fs[#Fs],
		return(Fs[#Fs-1]);
	);
	lb=1;
	ub=#Fs;
	index = #Fs\2;
	while(Fs[index] != fraction,
		if(Fs[index] > fraction,
			ub=index;
			index = (ub-lb)\2+lb,
		/*else*/
			lb = index;
			index = (ub-lb)\2+lb;
		);
	);
	return(Fs[index-1]);
}

mediant(frac1, frac2)={return((numerator(frac1)+numerator(frac2))/(denominator(frac1)+denominator(frac2)));}

adjacentFrel(fract)={
	/*lb: lower bound, ub: upper bound, med: mediant fraction of ub and lb*/
	local(lb,ub,med);
	if(fract <= 0/1 || fract >= 1/1, return(0/1););
	lb=0/1;
	ub=1/1;
	med = mediant(lb,ub);
	while(fract != med,
		if(fract < med,
			ub = med,
			lb = med;
		);
		med = mediant(lb,ub);
	);
	return(lb);
}

FS(fraction)={
	/*adjacent: the adjacent fraction to current_fraction, remainder: 1/qs */
	local(adjacent, remainder, result, current_fraction);
	result = List();
	current_fraction = fraction;
	while(1,
		/*old: adjacent = findAdjacent(FareySeries(denominator(current_fraction)), current_fraction);*/
		adjacent = adjacentFrel(current_fraction);
		remainder = 1/(denominator(current_fraction)*denominator(adjacent));
		listput(result, remainder);
		if(numerator(adjacent) == 1,
			listput(result, adjacent);
			result = reverse_vecsort(Vec(result));
			/*print("Farey_Sequence:\t", fraction, " = ", printEgypFrac(result));*/
			return(result);
		);
		current_fraction = adjacent;
	);
	return(-1);
}

findDivisorsOf_k_addingup_n(k,n)={
	local(result);
	if(k<n,return(Vec([-1])););
	res = List();
	while((listsum(res) != n) && (k >= 1),
		if(listsum(res) + k <= n,
			listput(res,k);
		);
		k /= 2;
	);
	return(res);
}

binary_algo(fraction)={
	/*summands: the divisors of Nk which add up to p or s, r respectively*/
	local(p,q,r,s,Nk,summands,result);
	result = List();
	p = numerator(fraction);
	q = denominator(fraction);
	Nk=1;
	while(q > Nk, Nk*=2;);
	if(q == Nk,
		summands = findDivisorsOf_k_addingup_n(Nk,p);
		for(i=1, #summands, listput(result, 1/(Nk/summands[i]))),
	/*else*/
		[s,r] = divrem(p*Nk,q);
		summands = findDivisorsOf_k_addingup_n(Nk,s);
		for(i=1, #summands, listput(result, 1/(Nk/summands[i])));
		summands = findDivisorsOf_k_addingup_n(Nk,r);
		for(i=1, #summands, listput(result, 1/((q*Nk)/summands[i])));
	);
	/*print("Binary:\t\t", fraction, " = ", printEgypFrac(result));*/
	return(reverse_vecsort(Vec(result)));
}


printEgypFrac(arguments)={
	local(result);
	result = "";
	if(#arguments <= 0,
		result = "0";
		return(result);
	);
	if(#arguments == 1,
		result = Str(arguments[1]);
		return(result);
	);
	for(i=1, #arguments-1,
		result = Str(result, Str(arguments[i]));
		result = Str(result, " + ");
	);
	result = Str(result, arguments[#arguments]);
	return(result);
}

test_main(fraction)={
	local(res_greedy_fast, res_farey, res_binary);
	res_greedy_fast = greedy_fast(fraction);
	res_farey = FS(fraction);
	res_binary = binary_algo(fraction);

	print("\nAlgorithm \t\t\t#terms \t\tmaximum denominator\n---------\t\t\t------ \t\t-------------------");
	print("Greedy Algorithm \t\t", #res_greedy_fast, "\t\t", 1/res_greedy_fast[#res_greedy_fast]);
	print("Farey-Sequence Algorithm \t", #res_farey, "\t\t", 1/res_farey[#res_farey]);
	print("Binary Algorithm \t\t", #res_binary, "\t\t", 1/res_binary[#res_binary]);

	return();
}

automatic_test_greedy(start,end)={
	local(t, result, LenDenom, Terms, Time);
	LenDenom = List();
	Terms=List();
	Time=List();

	write("/home/lars/Schreibtisch/results_greedy.csv", "Nenner,AVG #Terms,MIN #Terms,MAX #Terms,MIN longest Denominator,MAX longest Denominator,Time");
	for(denom=start,end,
		if(denom%10==0, print(denom));
		for(num=2, denom,
			if(gcd(denom,num) == 1,
				t = getabstime();
				result = greedy_fast(num/denom);
				listput(Time, getabstime()-t);
				listput(LenDenom, denominator(result[#result]));
				listput(Terms, #result);
			);
		);
		write("/home/lars/Schreibtisch/results_greedy.csv", denom, ",", round(listsum(Terms)/#Terms), ",", listmin(Terms), ",", listmax(Terms), ",", listmin(LenDenom), ",", listmax(LenDenom),"," round(listsum(Time)/#Time));
		LenDenom = List();
		Terms = List();
		Time = List();
	);
}


FS_automatic(fraction, fareyseries)={
	local(adjacent, remainder, result, current_fraction);
	result = List();
	current_fraction = fraction;
	while(1,
		adjacent = findAdjacent(fareyseries, current_fraction);
		remainder = 1/(denominator(current_fraction)*denominator(adjacent));
		listput(result, remainder);
		if(numerator(adjacent) == 1,
			listput(result, adjacent);
			result = reverse_vecsort(Vec(result));
			/*print("Farey_Sequence: ", fraction, " = ", printEgypFrac(result));*/
			return(result);
		);
		current_fraction = adjacent;
	);
	return(-1);
}

automatic_test_farey(start,end)={
	local(t, result, LenDenom, Terms, Time);
	LenDenom = List();
	Terms=List();
	Time=List();

	write("results_farey.csv", "Nenner,AVG #Terms,MIN #Terms,MAX #Terms,MIN longest Denominator,MAX longest Denominator,Time");
	for(denom=start,end,
		fareysequenceOfDenom = FareySeries(denom);
		if(denom%10==0, print(denom));
		for(num=2, denom,
			if(gcd(denom,num) == 1,
				t = getabstime();
				result = FS_automatic(num/denom, fareysequenceOfDenom);
				listput(Time, getabstime()-t);
				listput(LenDenom, denominator(result[#result]));
				listput(Terms, #result);
			);
		);
		write("/home/lars/Schreibtisch/results_farey.csv", denom, ",", round(listsum(Terms)/#Terms), ",", listmin(Terms), ",", listmax(Terms), ",", listmin(LenDenom), ",", listmax(LenDenom),"," round(listsum(Time)/#Time));
		LenDenom = List();
		Terms = List();
		Time = List();
	);
}

automatic_test_fastfarey(start,end,path)={
	local(result, LenDenom, Terms, Time);
	LenDenom = List();
	Terms=List();
	Time=List();
	write(path, "Nenner,AVG #Terms,MIN #Terms,MAX #Terms,MIN longest Denominator,MAX longest Denominator,Time");
	for(denom=start,end,
		for(num=2,denom,
			if(gcd(num,denom)==1,
				t = getabstime();
				result = FS(num/denom);
				listput(Time, getabstime()-t);
				listput(LenDenom, denominator(result[#result]));
				listput(Terms, #result);
			);
		);
		write(path, denom, ",", round(listsum(Terms)/#Terms), ",", listmin(Terms), ",", listmax(Terms), ",", listmin(LenDenom), ",", listmax(LenDenom),"," round(listsum(Time)/#Time));
		LenDenom = List();
		Terms = List();
		Time = List();
	);
}
/*fastfarey1()=automatic_test_fastfarey(3,1000,"/home/lars/Schreibtisch/fastfarey3-1000.csv");*/

fastfarey1_stube()=automatic_test_fastfarey(7802,8000, "/home/lars/Programming/Bachelorarbeit/PARI/fastfarey7802-8000.csv");
fastfarey2()=automatic_test_fastfarey(8001,8500, "/home/lars/Schreibtisch/fastfarey8001-8500.csv");
fastfarey3()=automatic_test_fastfarey(8501,9000, "/home/lars/Schreibtisch/fastfarey8501-9000.csv");
fastfarey4()=automatic_test_fastfarey(9001,9500, "/home/lars/Schreibtisch/fastfarey9001-9500.csv");
fastfarey5()=automatic_test_fastfarey(9501,10000, "/home/lars/Schreibtisch/fastfarey9501-10000.csv");


automatic_test_binary(start,end)={
	local(t, result, LenDenom, Terms, Time);
	LenDenom = List();
	Terms=List();
	Time=List();

	write("/home/lars/Schreibtisch/results_binary.csv", "Nenner,AVG #Terms,MIN #Terms,MAX #Terms,MIN longest Denominator,MAX longest Denominator,Time");
	for(denom=start,end,
		if(denom%10==0, print(denom));
		for(num=2, denom,
			if(gcd(denom,num) == 1,
				t = getabstime();
				result = binary_algo(num/denom);
				listput(Time, getabstime()-t);
				listput(LenDenom, denominator(result[#result]));
				listput(Terms, #result);
			);
		);
		write("/home/lars/Schreibtisch/results_binary.csv", denom, ",", round(listsum(Terms)/#Terms), ",", listmin(Terms), ",", listmax(Terms), ",", listmin(LenDenom), ",", listmax(LenDenom),"," round(listsum(Time)/#Time));
		LenDenom = List();
		Terms = List();
		Time = List();
	);
}

test_binary_corr(start,end)={
	local(den,res);
	den=start;
	while(den<=end,
		for(num=1,den-1,
			if(gcd(num,den)==1,
				res = binary_algo(num/den);
				if(den*2==denominator(res[#res]), print("works for: ", num/den));
			);
		);
	den++;
	);
}

reverse_farey()={
	local(as);
	write("/home/lars/Desktop/reverse_farey11.csv", "Numerator,Denominator,minDenom_farey");
	as = List();
	list11=[210, 420, 630, 840, 1050, 1260, 1470, 1680, 1890, 2100, 2520, 2730, 2940, 3150, 3360, 3570, 3780, 3990, 4200, 4410, 4830, 5040, 5250, 5460, 5670, 5880, 6090, 6300, 6510, 6720, 7140, 7350, 7560, 7770, 7980, 8190, 8400, 8610, 8820, 9030, 9450, 9660, 9870];
	for(i=1, #list11,
		den=list11[i];
		for(num=2, den-1,
			if(gcd(num,den)==1,
				result = FS(num/den);
				if(denominator(result[#result]) == 11*list11[i],
					listput(as, num);
					print(num/den, ": ", denominator(result[#result]));
					write("/home/lars/Desktop/reverse_farey11.csv", num, ",", den, ",", denominator(result[#result]));
				);
			);
		);
	);
	return(as);
}

/* show timer for each calculation */
#
print("\n\n\n#########################\n#    Script provided    #\n#           by          #\n#    Lt. Lars Berger    #\n#    Universität der    #\n#   Bundeswehr München  #\n#########################\n\n")
/*
print("\n available main functions, not recommended for usage:\n - fibonacci_sylvester(frac, stepsize, start)\n");
print("Available secondary functions:\n - Farey_Series(order)\n - largestUnitFractionLEQ(frac)\n - isAdjacent(frac1, frac2)\n");
*/
print("Available Algorithms for Egyptian Fractions:\n - greedy(frac)\n - greedy_odd(frac)\n - greedy_even(frac)\n - greedy_fast(frac)\n - FS(frac): Farey-Sequence-Algorithm\n - binary_algo(fraction): Binary Algorithm");
print("Please use \";\" after the commands since every algorithm produces a custom output.");

/*****************************************************

LAST EDITED:

				2019/10/31; 09:15:00

*****************************************************/
