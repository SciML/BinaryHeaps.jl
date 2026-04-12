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

# Abstract type
abstract type AbstractHeap{VT} end
Base.eltype(::Type{<:AbstractHeap{T}}) where {T} = T

const DefaultReverseOrdering = Base.ReverseOrdering{Base.ForwardOrdering}

include("arrays_as_heaps.jl")
include("binary_heap.jl")
include("generic.jl")

end # module
