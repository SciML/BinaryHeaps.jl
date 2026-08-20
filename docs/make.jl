using BinaryHeaps
using Documenter

makedocs(;
    modules = [BinaryHeaps],
    sitename = "BinaryHeaps.jl",
    pages = [
        "Home" => "index.md",
        "API" => "api.md",
    ],
    checkdocs = :exports,
)
