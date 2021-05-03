# push!(LOAD_PATH,"../src/")

using MIRTio
using Documenter

DocMeta.setdocmeta!(MIRTio, :DocTestSetup, :(using MIRTio); recursive=true)

makedocs(;
    modules = [MIRTio],
    authors = "Jeff Fessler <fessler@umich.edu> and contributors",
    repo = "https://github.com/JeffFessler/MIRTio.jl/blob/{commit}{path}#{line}",
    sitename = "MIRTio.jl",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
#       canonical = "https://JeffFessler.github.io/MIRTio.jl/stable",
#       assets = String[],
    ),
    pages = [
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo = "github.com/JeffFessler/MIRTio.jl.git",
    devbranch = "main",
    devurl = "dev",
    versions = ["stable" => "v^", "dev" => "dev"]
#   push_preview = true,
)
