using JuliaTM1
using Documenter

makedocs(;
    modules=[JuliaTM1],
    authors="Alexander Sutcliffe <sutcliffe.alex@gmail.com>",
    repo="https://github.com/scrambldchannel/JuliaTM1.jl/blob/{commit}{path}#L{line}",
    sitename="JuliaTM1.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://scrambldchannel.github.io/JuliaTM1.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/scrambldchannel/JuliaTM1.jl",
)
