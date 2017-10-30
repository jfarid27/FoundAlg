module Prog2
  randomizationSeed = 83503274094;

  T1 = AbstractArray{Int64, 1};
  Count = Int64; # Making a type for the total counts

  function swap!{T<:T1}(a::T, i::Int, j::Int)::Count
    hold = a[j];
    a[j] = a[i];
    a[i] = hold;
    return 1;
  end
  
  function medianOfThree!(a::T, start::Int, last::Int)::Count where T <: T1
    count = 0;
    if (last < start) return 0 end;
    if ((last - start) < 2)
      if (a[last] < a[start])
        swap!(a, start, last);
        count += 1;
      end
      return count;
    end

    # Testing for median out of end and middle
    middle = convert(Int, floor((start + last) / 2));
    testIndexes = [start, middle, last];
    tests = a[testIndexes];
    # Neccesary conversion since median only returns floats
    foundMedian = convert(typeof(a[1]), median(tests));
    medianIndex = testIndexes[tests .=== foundMedian];
    count += swap!(a, medianIndex[1], last); # Swapping median with end

    # Continue with regular quicksort with end as pivot
    i = start - 1; #Split between low and high
    for j in start:(last-1)
      if (a[j] < a[last])
        i = i+1;
        count += swap!(a, i, j);
      end
    end
    if (a[last] < a[i+1])
      count += swap!(a, i+1, last);
    end
    p = i + 1;
    return count + medianOfThree!(a, start, p-1) + 
      medianOfThree!(a, p+1, last);
  end

  function quicksort!(a:: T, start::Int, last::Int)::Count where T <: T1
    count = 0;
    if (last < start) return 0 end;
    if ((last - start) < 2)
      if (a[last] < a[start])
        count += swap!(a, start, last);
      end
      return count;
    end
    i = start - 1; #Split between low and high
    for j in start:(last-1)
      if (a[j] < a[last])
        i = i+1;
        count += swap!(a, i, j);
      end
    end
    if (a[last] < a[i+1])
      count += swap!(a, i+1, last);
    end
    p = i + 1;
    return count + quicksort!(a, start, p-1) +
      quicksort!(a, p+1, last);
  end

  function flattenArgs(a1, a2)
    return (agg, x) -> begin
      push!(a1, x[1]);
      push!(a2, x[2]);
    end
  end

  function runWithRandoms(ns)
    qsSamples = [];
    motSamples = [];
    rng = MersenneTwister(randomizationSeed);
    @parallel (flattenArgs(qsSamples, motSamples)) for i = ns
      avq = [];
      avm = [];
      for sample in 1:100
        rq = randperm(rng, i);
        rs = [k for k in rq];
        push!(avq, quicksort!(rq, 1, length(rq)));
        push!(avm, medianOfThree!(rs, 1, length(rs)));
      end
      (mean(avq), mean(avm));
    end
    return (qsSamples, motSamples);
  end

end
