# Bachelor Thesis: Egyptian Fractions
This is the source code of my Bachelor Thesis I wrote in late 2019 (LaTeX).
It won't evolve any further, just because of it's nature of having to come to an end.
Feel free to look at how I did things (be it formatting in LaTeX, implementation of some algorithms in PARI/GP or whatever you can use).

The thesis was written in German language, btw.

The Thesis is dedicated to the problem of converting normal fractions to those known to be "Egyptian Fractions"; being a sum of unit fractions, that is.
It evaluates 3 Algorithms:
  * the greedy algorithm
  * the Farey Series algorithm
  * the Binary algorithm

and additionally goes into some theory and historical context.

## This Repo contains
* PARI/GP code I used to generate data and implement algorithms for Egyptian Fractions.
  algorithm implementation should be ok, evaluation part is a bit messy due to use of different computers, that ran the tests.
* the LaTeX-Code for the thesis
* the LaTeX-Code for my beamer presentation
* some python scripts to evaluate the data generated from the PARI/GP code and making graphs of it.
