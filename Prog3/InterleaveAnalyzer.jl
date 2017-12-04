module InterleaveAnalyzer
#=
    A Julia implementation of the logic for programming assignment 3.
    This module exposes data wrapper objects to store state data,
    as well as runner functions to test whether a given string t is an
    interleaving of strings x and y, called by

    > InterleaveAnalyzer.run(x, y, t)
=#

    # States are just integer positions in the strings.
    State = Int;

    # A transition object is data about the symbol to match and
    #    the state to transition to if the symbol matches.
    struct Transition
        symbol::Char
        state::State
    end

    #= A DFAState object stores state data for the DFA State of x
       and for y, as well as data keeping track of which DFA a symbol
       was assigned to for a transition.
    =#
    mutable struct DFAState
        x::State
        y::State
        assignment::String
        DFAState(x, y) = new(x, y, "")
        DFAState(x, y, a) = new(x, y, a)
    end

    #=
        The DFA is a structure to store transitions data for a given string. When
        constructed, it builds a map from state to DFAState objects, which store
        the symbol to match for the transition, as well as the state to transition
        to.
    =#
    struct DFA
        matrix::Dict{State, Transition}
        finalState::State

        function DFA(inputString::String)
            m::Dict{Int, Transition} = Dict()
            i = 1;
            while (i < length(inputString))
                char = inputString[i+1];
                t = Transition(char, i+1);
                m = merge(m, Dict(i => t));
                i += 1;
            end
            finalState = i;
            finalTransition = Dict(i => Transition(inputString[1], 1));
            startingTransition = Dict(0 => Transition(inputString[1], 1))
            m = merge(m, finalTransition, startingTransition);
            return new(m, finalState);
        end
    end

    # Wrapper store for state instances and the DFA transitions for each string.
    mutable struct NDFA
        stateInstances:: Array{DFAState}
        xDFA::DFA
        yDFA::DFA

        function NDFA(x::String, y::String)
            return new([DFAState(0, 0)], DFA(x), DFA(y));
        end
    end

    # Takes a given character and transitions each stateInstance using the character
    #   if a transition is available.
    function transition!(ndfa::NDFA, character::Char)::Bool
        if length(ndfa.stateInstances) == 0
            return false;
        end
        newInstances = [];
        for instance in ndfa.stateInstances
            availableX = get(ndfa.xDFA.matrix, instance.x, nothing);
            availableY = get(ndfa.yDFA.matrix, instance.y, nothing);
            if ((availableX !== nothing) && availableX.symbol === character)
                push!(newInstances, DFAState(availableX.state, instance.y, instance.assignment * "x"))
            end
            if ((availableY !== nothing) && availableY.symbol === character)
                push!(newInstances, DFAState(instance.x, availableY.state, instance.assignment * "y"))
            end
        end
        ndfa.stateInstances = newInstances;
        return true;
    end

    # This is just a test case wrapper object to help with code running.
    struct TestCase
        x::String
        y::String
        testString::String
    end

    # This runs the NDFA for a given string and test string set.
    function run(x::String, y::String, testString::String)::Tuple{Array{DFAState}, Bool}
        ndfa = NDFA(x, y);
        for symbol in testString
            if (!transition!(ndfa, symbol))
                return (ndfa.stateInstances, false);
            end
        end
        return (ndfa.stateInstances, true);
    end

    # This is a convenience function running the code for test case wrappers.
    function runTestCase(testCase::TestCase)::Tuple{Array{DFAState}, Bool}
        return run(testCase.x, testCase.y, testCase.testString)
    end
end
