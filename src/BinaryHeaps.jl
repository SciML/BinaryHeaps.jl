"""
    BinaryHeaps

Lightweight binary heap implementation extracted from
[DataStructures.jl](https://github.com/JuliaCollections/DataStructures.jl)
to avoid the invalidation overhead of the full DataStructures package.

Original code is Copyright (c) 2013 Dahua Lin, MIT License.
"""
module BinaryHeaps

using Base.Order: Forward, Ordering, lt

export AbstractHeap,
    BinaryHeap, BinaryMinHeap, BinaryMaxHeap,
    FasterForward, FasterReverse,
    extract_all!, extract_all_rev!,
    heapify!, heapify, isheap,
    heappush!, heappop!,
    heapleft, heapright, heapparent,
    nlargest, nsmallest, nextreme

"""
    AbstractHeap{T}

Abstract supertype for heap containers whose elements have type `T`.

# Type Parameters

- `T`: Element type stored by the heap.
"""
abstract type AbstractHeap{VT} end
Base.eltype(::Type{<:AbstractHeap{T}}) where {T} = T

const DefaultReverseOrdering = Base.Order.ReverseOrdering{Base.Order.ForwardOrdering}

include("arrays_as_heaps.jl")
include("binary_heap.jl")
include("generic.jl")

using PrecompileTools: @compile_workload, @setup_workload

@setup_workload begin
    @compile_workload begin
        values = [4, 1, 3, 2, 16, 9, 10, 14, 8, 7]
        min_heap = BinaryMinHeap(values)
        push!(min_heap, 0)
        pop!(min_heap)
        extract_all!(BinaryMinHeap(values))
        heapify(values)
        nlargest(3, values)
        nsmallest(3, values)
    end
end

end # module
