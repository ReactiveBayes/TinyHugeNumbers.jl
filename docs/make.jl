using TinyHugeNumbers
using Documenter

DocMeta.setdocmeta!(TinyHugeNumbers, :DocTestSetup, :(using TinyHugeNumbers); recursive=true)

makedocs(;
    modules  = [ TinyHugeNumbers ],
    strict   = [ :doctest, :eval_block, :example_block, :meta_block, :parse_error, :setup_block ],
    authors  = "Bagaev Dmitry <bvdmitri@gmail.com> and contributors",
    repo     = "https://github.com/reactivebayes/TinyHugeNumbers.jl/blob/{commit}{path}#{line}",
    sitename = "TinyHugeNumbers.jl",
    format   = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical  = "https://reactivebayes.github.io/TinyHugeNumbers.jl",
        edit_link  = "main",
        assets     = String[],
    ),
    pages = [
        "Documentation" => "index.md",
    ],
)

deploydocs(; repo="github.com/reactivebayes/TinyHugeNumbers.jl", devbranch="main")
