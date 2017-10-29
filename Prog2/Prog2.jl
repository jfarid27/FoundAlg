module Prog2

  T1 = AbstractArray{Int64, 1}
  function swap!(a::T1, i::Int, j::Int)
    hold = a[j];
    a[j] = a[i];
    a[i] = hold;
  end
  
  function medianOfThree!(a::T, start::Int, last::Int)::Void where T <: T1
    if ((last - start) < 2)
      if (a[last] < a[start])
        swap!(a, start, last);
      end
      return;
    end

    # Testing for median out of end and middle
    middle = convert(Int, floor((start + last) / 2));
    testIndexes = [start, middle, last];
    tests = a[testIndexes];
    median = testIndexes[tests .=== median(tests)];
    swap!(a, median, last); # Swapping median with end

    # Continue with regular quicksort with end as pivot
    i = start - 1; #Split between low and high
    for j in start:(last-1)
      if (a[j] < a[last])
        i = i+1;
        swap!(a, i, j);
      end
    end
    if (a[last] < a[i +1])
      swap!(a, i+1, last);
    end
    p = i + 1;
    medianOfThree!(a, start, p-1);
    medianOfThree!(a, p+1, last);
  end

  function quicksort!(a:: T, start::Int, last::Int)::Void where T <: T1
    if ((last - start) < 2)
      if (a[last] < a[start])
        swap!(a, start, last);
      end
      return;
    end
    i = start - 1; #Split between low and high
    for j in start:(last-1)
      if (a[j] < a[last])
        i = i+1;
        swap!(a, i, j);
      end
    end
    if (a[last] < a[i +1])
      swap!(a, i+1, last);
    end
    p = i + 1;
    quicksort!(a, start, p-1);
    quicksort!(a, p+1, last);
  end
end
