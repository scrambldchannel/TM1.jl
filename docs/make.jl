using TM1
using Documenter

makedocs(;
    modules=[TM1],
    authors="Alexander Sutcliffe <sutcliffe.alex@gmail.com>",
    repo="https://github.com/scrambldchannel/TM1.jl/blob/{commit}{path}#L{line}",
    sitename="TM1.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://scrambldchannel.github.io/TM1.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/scrambldchannel/TM1.jl",
)
