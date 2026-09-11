using BinaryHeaps, BenchmarkTools
using StableRNGs

const SUITE = BenchmarkGroup()
const rng = StableRNG(123)

N = 10_000
data = rand(rng, N)

# =============================================================================
# Heap construction and core operations
# =============================================================================

SUITE["heap"] = BenchmarkGroup()

SUITE["heap"]["construct_min"] = @benchmarkable BinaryMinHeap($data)
SUITE["heap"]["construct_max"] = @benchmarkable BinaryMaxHeap($data)
SUITE["heap"]["heapify!"] = @benchmarkable heapify!(copy($data))

SUITE["heap"]["push!"] = @benchmarkable push!(h, 0.5) setup = (
    h = BinaryMinHeap(
        Float64[]
    )
)
SUITE["heap"]["pop!"] = @benchmarkable pop!(h) setup = (h = BinaryMinHeap($data))
SUITE["heap"]["top"] = @benchmarkable first($(BinaryMinHeap(data)))

SUITE["heap"]["push_pop_loop"] = @benchmarkable begin
    h = BinaryMinHeap{Float64}()
    for i in 1:1000
        push!(h, i * 0.37)
    end
    for _ in 1:500
        pop!(h)
    end
end

# =============================================================================
# Extrema queries
# =============================================================================

SUITE["extrema"] = BenchmarkGroup()

SUITE["extrema"]["nlargest_100"] = @benchmarkable nlargest(100, $data)
SUITE["extrema"]["nsmallest_100"] = @benchmarkable nsmallest(100, $data)
SUITE["extrema"]["extract_all"] = @benchmarkable extract_all!(
    $(BinaryMinHeap(data))
)
