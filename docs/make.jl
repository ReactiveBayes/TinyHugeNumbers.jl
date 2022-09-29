using TinyHugeNumbers
using Documenter

DocMeta.setdocmeta!(TinyHugeNumbers, :DocTestSetup, :(using TinyHugeNumbers); recursive=true)

makedocs(;
    modules=[TinyHugeNumbers],
    authors="Bagaev Dmitry <bvdmitri@gmail.com> and contributors",
    repo="https://github.com/bvdmitri/TinyHugeNumbers.jl/blob/{commit}{path}#{line}",
    sitename="TinyHugeNumbers.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://bvdmitri.github.io/TinyHugeNumbers.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/bvdmitri/TinyHugeNumbers.jl",
    devbranch="main",
)
