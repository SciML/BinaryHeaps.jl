# This contains code that was formerly a part of Julia. License is MIT: http://julialang.org/license
# Extracted from DataStructures.jl — Copyright (c) 2013 Dahua Lin, MIT License.

# Heap operations on flat arrays
# ------------------------------

# Binary heap indexing
"""
    heapleft(i::Integer)

Return the one-based array index of the left child of heap node `i`.

# Arguments

- `i`: One-based heap node index.

# Returns

The one-based index of the left child.
"""
heapleft(i::Integer) = 2i

"""
    heapright(i::Integer)

Return the one-based array index of the right child of heap node `i`.

# Arguments

- `i`: One-based heap node index.

# Returns

The one-based index of the right child.
"""
heapright(i::Integer) = 2i + 1

"""
    heapparent(i::Integer)

Return the one-based array index of the parent of heap node `i`.

# Arguments

- `i`: One-based heap node index.

# Returns

The one-based index of the parent node.
"""
heapparent(i::Integer) = div(i, 2)

# Binary min-heap percolate down.
function _require_one_based_indexing(xs::AbstractVector)
    firstindex(xs) == 1 || throw(ArgumentError("heap vectors must use one-based indexing"))
    return nothing
end

@inline function percolate_down!(
        xs::AbstractVector, i::Integer, x, lt, len::Integer
    )
    _require_one_based_indexing(xs)
    @boundscheck checkbounds(xs, i)
    @boundscheck checkbounds(xs, len)

    @inbounds while (l = heapleft(i)) <= len
        r = heapright(i)
        j = r > len || lt(xs[l], xs[r]) ? l : r
        lt(xs[j], x) || break
        xs[i] = xs[j]
        i = j
    end
    return @inbounds xs[i] = x
end

# Binary min-heap percolate up.
@inline function percolate_up!(xs::AbstractVector, i::Integer, x, lt)
    _require_one_based_indexing(xs)
    @boundscheck checkbounds(xs, i)

    @inbounds while (j = heapparent(i)) >= 1
        lt(x, xs[j]) || break
        xs[i] = xs[j]
        i = j
    end
    return @inbounds xs[i] = x
end

"""
    heappop!(xs, [lt])

Remove and return the heap head of one-based heap vector `xs`. `lt(a, b)` determines
whether `a` belongs before `b`; it defaults to `isless`.

# Arguments

- `xs`: Mutable, one-based vector already satisfying the heap invariant.
- `lt`: Callable strict ordering comparator.

# Examples

```julia
using BinaryHeaps

heappop!(heapify!([3, 1, 2])) # returns 1
```
"""
function heappop!(xs::AbstractVector, lt = isless)
    _require_one_based_indexing(xs)
    x = xs[1]
    y = pop!(xs)
    if !isempty(xs)
        @inbounds percolate_down!(xs, 1, y, lt, length(xs))
    end
    return x
end

"""
    heappush!(xs, value, [lt])

Insert `value` into one-based heap vector `xs`, preserving its heap invariant. `lt(a,
b)` determines whether `a` belongs before `b`; it defaults to `isless`.

# Arguments

- `xs`: Mutable, one-based vector already satisfying the heap invariant.
- `value`: Value to insert.
- `lt`: Callable strict ordering comparator.

# Returns

Returns `xs`.

# Examples

```julia
using BinaryHeaps

xs = heapify!([3, 1])
heappush!(xs, 2)
first(xs) # returns 1
```
"""
@inline function heappush!(xs::AbstractVector, value, lt = isless)
    _require_one_based_indexing(xs)
    push!(xs, value)
    @inbounds percolate_up!(xs, length(xs), value, lt)
    return xs
end

"""
    heapify!(xs, [lt])

Transform one-based vector `xs` into a heap in place, using comparator `lt(a, b)`.

# Arguments

- `xs`: Mutable, one-based vector to heapify.
- `lt`: Callable strict ordering comparator. Defaults to `isless`.

# Returns

Returns `xs` after heapification.

# Examples

```julia
using BinaryHeaps

isheap(heapify!([3, 1, 2])) # returns true
```
"""
@inline function heapify!(xs::AbstractVector, lt = isless)
    _require_one_based_indexing(xs)
    for i in heapparent(length(xs)):-1:1
        @inbounds percolate_down!(xs, i, xs[i], lt, length(xs))
    end
    return xs
end

"""
    heapify(xs, [lt])

Return a new vector containing `xs` in heap order according to `lt(a, b)`.

# Arguments

- `xs`: One-based vector to copy and heapify.
- `lt`: Callable strict ordering comparator. Defaults to `isless`.

# Examples

```julia
using BinaryHeaps

xs = [3, 1, 2]
heap = heapify(xs)
xs == [3, 1, 2] && isheap(heap) # returns true
```
"""
heapify(xs::AbstractVector, lt = isless) = heapify!(copyto!(similar(xs), xs), lt)

"""
    isheap(xs, [lt])

Return whether one-based vector `xs` satisfies the heap invariant for comparator
`lt(a, b)`.

# Arguments

- `xs`: One-based vector to inspect.
- `lt`: Callable strict ordering comparator. Defaults to `isless`.

# Examples

```julia
using BinaryHeaps

isheap([1, 3, 2]) # returns true
```
"""
function isheap(xs::AbstractVector, lt = isless)
    _require_one_based_indexing(xs)
    for i in 1:div(length(xs), 2)
        if lt(xs[heapleft(i)], xs[i]) ||
                (heapright(i) <= length(xs) && lt(xs[heapright(i)], xs[i]))
            return false
        end
    end
    return true
end
