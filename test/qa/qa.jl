using SciMLTesting, BinaryHeaps, JET

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
    api_docs_kwargs = (; rendered = true),
)
