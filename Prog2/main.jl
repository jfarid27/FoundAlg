Pkg.add("Plotly");
using Plotly;
using Blink;
Blink.AtomShell.install();

include("Prog2.jl");

ns=10:1000;
results = Prog2.runWithRandoms(ns);
trace1 = Plotly.scatter(x=ns, y=results[1], name="QS");
trace2 = Plotly.scatter(x=ns, y=results[2], name="MOT");
Plotly.plot([trace1, trace2], Plotly.Layout());
