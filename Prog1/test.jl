module Prog1Test

  include("Prog1.jl");
  using Base.Test;

  # Test for merge arrays
  function mergeArray()

    # Merge case 1
    k1::Array{Integer, 1} = [1, 5, 6, 7, 8, -1, -1, -1];
    j1::Array{Integer, 1} = [2, 3, 4];
    result1:: Array{Integer, 1} = Prog1.mergeArrays(k1, j1, 5);
    for i = 1:8
      @test result1[i] === i;
    end

    # Merge case 2
    k2::Array{Integer, 1} = [5, 6, -1, -1, -1, -1, -1];
    j2::Array{Integer, 1} = [2, 3, 4];
    result2:: Array{Integer, 1} = Prog1.mergeArrays(k2, j2, 2);
    for i = 2:6
      @test result2[i-1] === i;
    end

    #=
      Tests if an error is thrown when trying to merge a small array
    =#
    k0::Array{Integer, 1} = collect(1:8);
    j0::Array{Integer, 1} = collect(1:2);
    @test_throws BoundsError Prog1.mergeArrays(k0, j0, 8);
  end

  # Test for insert arrays 
  function insertArray()
    k::Array{Integer, 1} = [1, 3, 4, 5, -1];
    result:: Array{Integer, 1} = Prog1.insertArray(k, 5, 2);
    for i = 1:5
      @test result[i] === i;
    end
  end

  # Test for insert
  function insert()

    # Test for basic Set that doesn't require merge
    k1::Array{Integer, 1} = zeros(11);
    l1::Array{Integer, 1} = [1, 3, 4, -1, -1];
    set = Prog1.MySet(l1, k1, 3, 10);
    result = Prog1.insert(set, 2);
    for i = 1:4
      @test result.small[i] === i;
      @test result.sizeSmall === 4;
    end

    # Test for Set that does require merge
    k2::Array{Integer, 1} = [1, 5, 6, 7, -1, -1, -1, -1];
    l2::Array{Integer, 1} = [2, 4, -1];
    set = Prog1.MySet(l2, k2, 2, 4);
    result = Prog1.insert(set, 3);
    @test result.sizeSmall === 0;
    for i = 1:7
      @test result.large[i] === i;
    end
  end

  function search()
    k1::Array{Integer, 1} = [1, 5, 6, 7, -1, -1, -1, -1];
    l1::Array{Integer, 1} = [2, 4, -1];
    set = Prog1.MySet(l1, k1, 2, 4);
    @test Prog1.search(set, 7);
    @test !Prog1.search(set, 0);
    @test Prog1.search(set, 1);
    @test Prog1.search(set, 2);
    @test !Prog1.search(set, 3);
    @test Prog1.search(set, 4);
    @test !Prog1.search(set, 8);
    @test Prog1.search(set, 5);

  end

  insertArray();
  mergeArray();
  insert();
  search();
  @printf "Tests OK\n";
end
