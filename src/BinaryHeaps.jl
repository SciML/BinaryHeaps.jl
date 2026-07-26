"""
    BinaryHeaps

Lightweight binary heap implementation extracted from
[DataStructures.jl](https://github.com/JuliaCollections/DataStructures.jl)
to avoid the invalidation overhead of the full DataStructures package.

Original code is Copyright (c) 2013 Dahua Lin, MIT License.
"""
module BinaryHeaps

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

# Interface

`AbstractHeap` is an extension interface for mutable heap containers. A subtype must
implement `Base.length(h)` and `Base.pop!(h)`, where each `pop!` removes and returns
the current heap head. `extract_all!` and `extract_all_rev!` use only those generic
functions. Implement `Base.first(h)` and `Base.push!(h, value)` as well when the
subtype is intended to support the normal heap-container workflow.

# Examples

```julia
using BinaryHeaps

mutable struct OneElementHeap{T} <: AbstractHeap{T}
    value::T
end

Base.length(::OneElementHeap) = 1
Base.pop!(h::OneElementHeap) = h.value

extract_all!(OneElementHeap(3)) # returns [3]
```
"""
abstract type AbstractHeap{VT} end
Base.eltype(::Type{<:AbstractHeap{T}}) where {T} = T

include("arrays_as_heaps.jl")
include("binary_heap.jl")
include("generic.jl")

end # module
