# BinaryHeaps.jl

[![Build Status](https://github.com/SciML/BinaryHeaps.jl/workflows/CI/badge.svg)](https://github.com/SciML/BinaryHeaps.jl/actions?query=workflow%3ACI)

Lightweight binary heap implementation extracted from
[DataStructures.jl](https://github.com/JuliaCollections/DataStructures.jl)
to minimize method invalidations.

Loading the full `DataStructures` package causes significant method invalidations
that slow down first-call latency in downstream packages. `BinaryHeaps.jl`
provides the same `BinaryHeap`, `BinaryMinHeap`, `BinaryMaxHeap`, and
`FasterForward`/`FasterReverse` types with zero invalidation overhead.

## Installation

```julia
using Pkg
Pkg.add("BinaryHeaps")
```

## Usage

```julia
using BinaryHeaps

# Min-heap
h = BinaryMinHeap{Int}()
push!(h, 5)
push!(h, 3)
push!(h, 1)
first(h)  # 1
pop!(h)   # 1

# Max-heap
h = BinaryMaxHeap{Int}()

# Heap from vector
h = BinaryMinHeap([5, 3, 7, 1, 9, 2])

# FasterForward for NaN-free float data (2x faster comparison)
h = BinaryHeap{Float64}(FasterForward())

# Array-based heap operations
xs = [5, 3, 7, 1]
heapify!(xs)
heappush!(xs, 2)
heappop!(xs)  # 1

# N largest/smallest
nsmallest(3, [5, 3, 7, 1, 9])  # [1, 3, 5]
nlargest(3, [5, 3, 7, 1, 9])   # [9, 7, 5]
```

## Attribution

The heap implementation is extracted from
[DataStructures.jl](https://github.com/JuliaCollections/DataStructures.jl)
(Copyright (c) 2013 Dahua Lin, MIT License).
