# Programming Assignment 3

## Code

This code implements non-deterministic finite automata to determine whether a given string is
an interleaving of two strings.

#### run and runTestCase

Takes 2 signal strings and a testString to determine if test string is an interleaving of repetitions of the
signal strings. Returns a tuple of correct interleaving assignments,
a boolean if assignments were found at all, and an Int counting the number of transactions.

## Running and Plotting Output

Included in the file is a file called main.jl. Start the julia repl and run

`include("main.jl")`

This is required since the program requires plotting libraries to plot the output.
The plotted output is generated using Plotly.js, so some interactivity is included.
