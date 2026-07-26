# Generic heap functions
# Extracted from DataStructures.jl — Copyright (c) 2013 Dahua Lin, MIT License.

"""
    extract_all!(h)

Remove and return all values from mutable heap `h` in heap order.

# Arguments

- `h`: An [`AbstractHeap`](@ref) implementing `length` and `pop!`.

# Returns

A vector whose first value is the initial heap head. `h` is empty on return.

# Examples

```julia
using BinaryHeaps

extract_all!(BinaryMinHeap([3, 1, 2])) # returns [1, 2, 3]
```
"""
function extract_all!(h::AbstractHeap{VT}) where {VT}
    n = length(h)
    r = Vector{VT}(undef, n)
    for i in 1:n
        r[i] = pop!(h)
    end
    return r
end

"""
    extract_all_rev!(h)

Remove and return all values from mutable heap `h` in reverse heap order.

# Arguments

- `h`: An [`AbstractHeap`](@ref) implementing `length` and `pop!`.

# Returns

A vector whose last value is the initial heap head. `h` is empty on return.

# Examples

```julia
using BinaryHeaps

extract_all_rev!(BinaryMinHeap([3, 1, 2])) # returns [3, 2, 1]
```
"""
function extract_all_rev!(h::AbstractHeap{VT}) where {VT}
    n = length(h)
    r = Vector{VT}(undef, n)
    for i in 1:n
        r[n + 1 - i] = pop!(h)
    end
    return r
end

"""
    nextreme(lt, n, xs)

Return up to `n` values from vector `xs`, sorted by comparator `lt(a, b)`.

# Arguments

- `lt`: Callable strict ordering comparator.
- `n`: Number of values to return. Values less than or equal to zero return an empty
  vector; values at least `length(xs)` return all values sorted.
- `xs`: One-based vector to search without modifying it.

# Returns

The first `n` values in comparator order.

# Examples

```julia
using BinaryHeaps

nextreme(isless, 2, [4, 1, 3, 2]) # returns [1, 2]
```
"""
function nextreme(lt, n::Int, xs::AbstractVector{T}) where {T}
    _require_one_based_indexing(xs)
    if n <= 0
        return T[]
    elseif n >= length(xs)
        return sort(xs; lt)
    end

    reverse_lt = (a, b) -> lt(b, a)
    buffer = heapify!(xs[1:n], reverse_lt)

    @inbounds for i in (n + 1):length(xs)
        xi = xs[i]
        if reverse_lt(buffer[1], xi)
            buffer[1] = xi
            percolate_down!(buffer, 1, buffer[1], reverse_lt, length(buffer))
        end
    end

    return sort!(buffer; lt)
end

"""
    nlargest(n, arr; kw...)

Return up to `n` largest values from vector `xs`.

# Arguments

- `n`: Number of values to return.
- `xs`: One-based vector to search without modifying it.

# Keyword Arguments

- `lt = isless`: Callable strict ordering comparator for values after applying `by`.
- `by = identity`: Callable mapping each value to the key compared by `lt`.

# Examples

```julia
using BinaryHeaps

nlargest(2, [4, 1, 3, 2]) # returns [4, 3]
```
"""
function nlargest(n::Int, xs::AbstractVector; lt = isless, by = identity)
    key_lt = (a, b) -> lt(by(a), by(b))
    return nextreme((a, b) -> key_lt(b, a), n, xs)
end

"""
    nsmallest(n, arr; kw...)

Return up to `n` smallest values from vector `xs`.

# Arguments

- `n`: Number of values to return.
- `xs`: One-based vector to search without modifying it.

# Keyword Arguments

- `lt = isless`: Callable strict ordering comparator for values after applying `by`.
- `by = identity`: Callable mapping each value to the key compared by `lt`.

# Examples

```julia
using BinaryHeaps

nsmallest(2, [4, 1, 3, 2]) # returns [1, 2]
```
"""
function nsmallest(n::Int, xs::AbstractVector; lt = isless, by = identity)
    return nextreme((a, b) -> lt(by(a), by(b)), n, xs)
end
