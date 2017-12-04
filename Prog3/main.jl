Pkg.add("Plotly");
using Plotly;
using Blink;
Blink.AtomShell.install();

include("InterleaveAnalyzer.jl")

tests = [
    ("1101001", "0010110", "11001010010110"),
    ("101", "00", "100010101")
];

function aggregateResults(results, group)
    @show results
    @show group
    return cat(1, results, group)
end

results = [];

ns = 1:5

for test in tests
    r = @parallel aggregateResults for j = ns
        rep = foldl((agg, string) -> agg * test[3], test[3], 1:j)
        testCase = InterleaveAnalyzer.TestCase(test[1], test[2], rep)
        result = InterleaveAnalyzer.runTestCase(testCase);
        [result[3]]
    end
    push!(results, r);
end

nx = map((x) -> 10*i, n)
nx1 = map((x) -> length(tests[1][3])*x, ns)
nx2 = map((x) -> length(tests[2][3])*x, ns)

trace1 = Plotly.scatter(x=nx1, y=results[1], name="Test1");
trace2 = Plotly.scatter(x=nx2, y=results[2], name="Test2");
Plotly.plot([trace1, trace2], Plotly.Layout())
