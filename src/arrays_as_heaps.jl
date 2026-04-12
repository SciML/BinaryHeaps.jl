# This contains code that was formerly a part of Julia. License is MIT: http://julialang.org/license
# Extracted from DataStructures.jl — Copyright (c) 2013 Dahua Lin, MIT License.

# Heap operations on flat arrays
# ------------------------------

# Binary heap indexing
heapleft(i::Integer) = 2i
heapright(i::Integer) = 2i + 1
heapparent(i::Integer) = div(i, 2)

# Binary min-heap percolate down.
Base.@propagate_inbounds function percolate_down!(xs::AbstractArray, i::Integer, x,
        o::Ordering = Forward, len::Integer = length(xs))
    @boundscheck checkbounds(xs, i)
    @boundscheck checkbounds(xs, len)

    @inbounds while (l = heapleft(i)) <= len
        r = heapright(i)
        j = r > len || lt(o, xs[l], xs[r]) ? l : r
        lt(o, xs[j], x) || break
        xs[i] = xs[j]
        i = j
    end
    @inbounds xs[i] = x
end
Base.@propagate_inbounds function percolate_down!(xs::AbstractArray, i::Integer,
        o::Ordering = Forward, len::Integer = length(xs))
    percolate_down!(xs, i, xs[i], o, len)
end

# Binary min-heap percolate up.
Base.@propagate_inbounds function percolate_up!(xs::AbstractArray, i::Integer, x,
        o::Ordering = Forward)
    @boundscheck checkbounds(xs, i)

    @inbounds while (j = heapparent(i)) >= 1
        lt(o, x, xs[j]) || break
        xs[i] = xs[j]
        i = j
    end
    @inbounds xs[i] = x
end
Base.@propagate_inbounds function percolate_up!(xs::AbstractArray, i::Integer,
        o::Ordering = Forward)
    percolate_up!(xs, i, xs[i], o)
end

"""
    heappop!(v, [ord])

Given a binary heap-ordered array, remove and return the lowest ordered element.
For efficiency, this function does not check that the array is indeed heap-ordered.
"""
function heappop!(xs::AbstractArray, o::Ordering = Forward)
    Base.require_one_based_indexing(xs)
    x = xs[1]
    y = pop!(xs)
    if !isempty(xs)
        @inbounds percolate_down!(xs, 1, y, o)
    end
    return x
end

"""
    heappush!(v, x, [ord])

Given a binary heap-ordered array, push a new element `x`, preserving the heap property.
For efficiency, this function does not check that the array is indeed heap-ordered.
"""
@inline function heappush!(xs::AbstractArray, x, o::Ordering = Forward)
    Base.require_one_based_indexing(xs)
    push!(xs, x)
    @inbounds percolate_up!(xs, length(xs), o)
    return xs
end

"""
    heapify!(v, ord::Ordering=Forward)

In-place [`heapify`](@ref).
"""
@inline function heapify!(xs::AbstractArray, o::Ordering = Forward)
    Base.require_one_based_indexing(xs)
    for i in heapparent(length(xs)):-1:1
        @inbounds percolate_down!(xs, i, o)
    end
    return xs
end

"""
    heapify(v, ord::Ordering=Forward)

Returns a new vector in binary heap order, optionally using the given ordering.
"""
heapify(xs::AbstractArray, o::Ordering = Forward) = heapify!(copyto!(similar(xs), xs), o)

"""
    isheap(v, ord::Ordering=Forward)

Return `true` if an array is heap-ordered according to the given order.
"""
function isheap(xs::AbstractArray, o::Ordering = Forward)
    Base.require_one_based_indexing(xs)
    for i in 1:div(length(xs), 2)
        if lt(o, xs[heapleft(i)], xs[i]) ||
           (heapright(i) <= length(xs) && lt(o, xs[heapright(i)], xs[i]))
            return false
        end
    end
    return true
end
