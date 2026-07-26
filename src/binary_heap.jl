# Binary heap (non-mutable)
# Extracted from DataStructures.jl — Copyright (c) 2013 Dahua Lin, MIT License.

#################################################
#
#   Comparator types for faster float comparison
#
#################################################

"""
    FasterForward()

Callable comparator that evaluates `a < b` directly. It can be faster than `isless`
for NaN-free floating-point data, but its ordering is undefined when either operand is
`NaN`.

# Examples

```julia
using BinaryHeaps

heap = BinaryHeap{Float64}(FasterForward(), [3.0, 1.0])
pop!(heap) # returns 1.0
```
"""
struct FasterForward end
(::FasterForward)(a, b) = a < b

"""
    FasterReverse()

Callable comparator that evaluates `a > b` directly. It can be faster than a reversed
`isless` comparator for NaN-free floating-point data, but its ordering is undefined
when either operand is `NaN`.

# Examples

```julia
using BinaryHeaps

heap = BinaryHeap{Float64}(FasterReverse(), [3.0, 1.0])
pop!(heap) # returns 3.0
```
"""
struct FasterReverse end
(::FasterReverse)(a, b) = a > b

_reverse_isless(a, b) = isless(b, a)

#################################################
#
#   heap type and constructors
#
#################################################

"""
    BinaryHeap{T, F} <: AbstractHeap{T}
    BinaryHeap{T}(lt = isless)
    BinaryHeap{T}(lt, xs::AbstractVector)
    BinaryHeap(lt, xs::AbstractVector{T})

Mutable binary heap storing values of type `T`, ordered by the callable comparator
`lt(a, b)::Bool`. The heap head is the value for which no other stored value compares
less than it. The default comparator is `isless`.

# Type Parameters

- `T`: Element type stored by the heap.
- `F`: Type of the comparator function.

# Fields

- `lt`: Callable comparator used to compare heap elements. It must define a strict,
  transitive ordering for the stored values.
- `valtree`: One-based array storing the heap tree.

# Examples

```julia
using BinaryHeaps

h = BinaryHeap{Int}(isless)
push!(h, 3)
push!(h, 1)
pop!(h) # returns 1
```
"""
mutable struct BinaryHeap{T, F} <: AbstractHeap{T}
    lt::F
    valtree::Vector{T}

    BinaryHeap{T, F}(lt::F, valtree::Vector{T}) where {T, F} =
        new{T, F}(lt, valtree)
end

function BinaryHeap{T}(lt::F = isless) where {T, F}
    return BinaryHeap{T, F}(lt, Vector{T}())
end

function BinaryHeap{T}(lt::F, xs::AbstractVector) where {T, F}
    valtree = heapify!(Vector{T}(xs), lt)
    return BinaryHeap{T, F}(lt, valtree)
end

function BinaryHeap(lt::F, xs::AbstractVector{T}) where {T, F}
    return BinaryHeap{T}(lt, xs)
end

"""
    BinaryMinHeap{T}
    BinaryMinHeap{T}()
    BinaryMinHeap{T}(xs::AbstractVector)
    BinaryMinHeap(xs::AbstractVector{T})

Alias for [`BinaryHeap`](@ref) using `isless`, so the smallest element is at the
top of the heap.

# Type Parameters

- `T`: Element type stored by the heap.

# Examples

```julia
using BinaryHeaps

pop!(BinaryMinHeap([3, 1, 2])) # returns 1
```
"""
const BinaryMinHeap{T} = BinaryHeap{T, typeof(isless)}

"""
    BinaryMaxHeap{T}
    BinaryMaxHeap{T}()
    BinaryMaxHeap{T}(xs::AbstractVector)
    BinaryMaxHeap(xs::AbstractVector{T})

Alias for [`BinaryHeap`](@ref) using a package-local reverse `isless` comparator, so
the largest element is at the top of the heap.

# Type Parameters

- `T`: Element type stored by the heap.

# Examples

```julia
using BinaryHeaps

pop!(BinaryMaxHeap([3, 1, 2])) # returns 3
```
"""
const BinaryMaxHeap{T} = BinaryHeap{T, typeof(_reverse_isless)}

BinaryMinHeap{T}() where {T} = BinaryHeap{T}()
BinaryMinHeap{T}(xs::AbstractVector) where {T} = BinaryHeap{T}(isless, xs)
BinaryMaxHeap{T}() where {T} = BinaryHeap{T}(_reverse_isless)
BinaryMaxHeap{T}(xs::AbstractVector) where {T} = BinaryHeap{T}(_reverse_isless, xs)
BinaryMinHeap(xs::AbstractVector{T}) where {T} = BinaryMinHeap{T}(xs)
BinaryMaxHeap(xs::AbstractVector{T}) where {T} = BinaryMaxHeap{T}(xs)

#################################################
#
#   interfaces
#
#################################################

"""
    length(h::BinaryHeap)

Returns the number of elements in heap `h`.
"""
Base.length(h::BinaryHeap) = length(h.valtree)

"""
    isempty(h::BinaryHeap)

Returns whether the heap `h` is empty.
"""
Base.isempty(h::BinaryHeap) = isempty(h.valtree)

"""
    push!(h::BinaryHeap, value)

Adds the `value` element to the heap `h`.
"""
@inline function Base.push!(h::BinaryHeap, v)
    heappush!(h.valtree, convert(eltype(h), v), h.lt)
    return h
end

"""
    first(h::BinaryHeap)

Returns the element at the top of the heap `h`.
"""
@inline Base.first(h::BinaryHeap) = h.valtree[1]

"""
    pop!(h::BinaryHeap)

Removes and returns the element at the top of the heap `h`.
"""
Base.pop!(h::BinaryHeap) = heappop!(h.valtree, h.lt)

function Base.empty!(h::BinaryHeap)
    empty!(h.valtree)
    return h
end

function Base.sizehint!(h::BinaryHeap, n::Integer)
    sizehint!(h.valtree, n)
    return h
end
