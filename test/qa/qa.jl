using SciMLTesting, BinaryHeaps, JET, Test

function documented_names_from_docs_blocks(docs_src)
    names = Set{Symbol}()
    isdir(docs_src) || return names

    for (root, _, files) in walkdir(docs_src)
        for file in files
            endswith(file, ".md") || continue
            in_docs_block = false
            for line in eachline(joinpath(root, file))
                stripped = strip(line)
                if startswith(stripped, "```@docs")
                    in_docs_block = true
                elseif in_docs_block && stripped == "```"
                    in_docs_block = false
                elseif in_docs_block
                    m = match(r"^([A-Za-z_][A-Za-z_0-9!]*)$", stripped)
                    m === nothing || push!(names, Symbol(only(m.captures)))
                end
            end
        end
    end

    return names
end

# BinaryHeaps is a thin re-export of `Base.Order` heap machinery, so it qualifies a
# handful of Base internals that Base has not (yet) declared public. They are stable,
# long-standing Base names; ignore them in the qualified-accesses public-API check
# (they go public as Base releases mark them so). All from `Base`.
run_qa(
    BinaryHeaps;
    explicit_imports = true,
    ei_kwargs = (;
        all_qualified_accesses_are_public = (;
            ignore = (
                Symbol("@propagate_inbounds"), :ForwardOrdering, :Ordering,
                :Reverse, :ReverseOrdering, :lt, :ord, :require_one_based_indexing,
            ),
        ),
    ),
)

@testset "Public API documentation" begin
    api_names = Set(names(BinaryHeaps))
    docs_src = normpath(joinpath(@__DIR__, "..", "..", "docs", "src"))
    documented_names = documented_names_from_docs_blocks(docs_src)

    for name in sort!(collect(api_names))
        @test Base.Docs.hasdoc(BinaryHeaps, name)
        @test name in documented_names
    end
end
