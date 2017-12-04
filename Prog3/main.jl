include("InterleaveAnalyzer.jl")

tests = [
    #InterleaveAnalyzer.TestCase("1101001", "0010110", "11001010010110"),
    InterleaveAnalyzer.TestCase("101", "00", "100010101")
];

for test in tests
    @show "------------"
    @show test
    @show "----"
    @show InterleaveAnalyzer.runTestCase(test)
end
