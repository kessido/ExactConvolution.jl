using ExactConvolution
using Documenter

DocMeta.setdocmeta!(ExactConvolution, :DocTestSetup, :(using ExactConvolution); recursive=true)

makedocs(;
    modules=[ExactConvolution],
    authors="Ido Kessler",
    repo="https://github.com/kessido/ExactConvolution.jl/blob/{commit}{path}#{line}",
    sitename="ExactConvolution.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://kessido.github.io/ExactConvolution.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/kessido/ExactConvolution.jl",
    devbranch="main",
)
