module Prog1 

  #=
    Main struct for the set object
  =#
  mutable struct MySet
    small::Array{Int64, 1}
    large::Array{Int64, 1}
    sizeSmall::Int64
    sizeLarge::Int64
  end

  #=
    Searches for elem in the smaller set, then larger set using binary search.
  =#
  function search(set::MySet, elem::Int64)::Bool
    return binarySearch(set.small, set.sizeSmall, elem) || 
      binarySearch(set.large, set.sizeLarge, elem); 
  end
  
  function binarySearch(arr::Array{Int64, 1}, size::Int64, elem::Int64)::Bool
    k = (1, size);
    m::Int64 = 0;
    while (k[1] < k[2])
      m = k[1] + floor((k[2] - k[1])/2)
      if (arr[m] < elem)
        k = (m+1, k[2])
      else  
        k = (k[1], m-1)
      end
    end
    return arr[m] == elem || arr[k[1]] == elem; 
  end

  #=
    Inserts element into a MySet instance, inserting into the smaller array
    instance, or merging with the larger array instance.
  =#
  function insert(set::MySet, elem::Int64)::MySet
    if (set.sizeSmall + 1 == length(set.small))
      newSmall = insertArray(set.small, set.sizeSmall + 1, elem);
      set.large = mergeArrays(set.large, newSmall, set.sizeLarge);
      Infi::Int64 = (2^63) - 1;           # Int64 infinity
      set.small::Array{Int64, 1} = [ Infi for i=1:length(set.small) ];
      set.sizeSmall = 0;
    else
      set.small = insertArray(set.small, set.sizeSmall + 1, elem);
      set.sizeSmall += 1;
    end
    return set;
  end

  #= 
    Takes a sorted array arr, and inserts i first in position n, then
    places i in the correct sorted position using insertion sorting.
  =#
  function insertArray(arr::Array{Int64, 1},
    i::Int64, elem::Int64)::Array{Int64, 1}

    curr = i;
    arr[i] = elem;
    while (curr > 1 && arr[curr] < arr[curr-1] )
      hold = arr[curr-1];
      # swapping
      arr[curr-1] = arr[curr];
      arr[curr] = hold;
      curr -= 1;
    end
    return arr;
  end

  #=
    Takes two sorted arrays, one large and one small and merges them into a new array
    that is the size of the larger array. Inlcuded are integers for the total elements
    in the large array currently. If the merge has more elements than the large array
    can hold, an index out of bounds error is thrown.
  =#
  function mergeArrays(largeArr::Array{Int64,1},
    smallArr::Array{Int64,1}, sizeLarge::Int64)::Array{Int64, 1}

    newArray = Array{Int64,1}(length(largeArr));

    if (length(largeArr) < length(smallArr) + sizeLarge)
      throw(BoundsError("Combined new length is larger than available size"));
      return;
    end

    k = 1; # Index for current value of old large array
    j = 1; # Index for current value of old small array
    i = 1; # Index for current value of new array

    newSize = sizeLarge + length(smallArr);
    while(i <= newSize)
      if (largeArr[k] < smallArr[j])
        newArray[i] = largeArr[k];
        k += 1;
      else
        newArray[i] = smallArr[j];
        j += 1;
      end

      i += 1;

      # if small array is filled, fill the new array
      if (j > length(smallArr))
        while (i <= newSize)
          newArray[i] = largeArr[k];
          i += 1;
          k += 1;
        end
      end
    end
    return newArray;
  end

end
