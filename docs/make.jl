execute = isempty(ARGS) || ARGS[1] == "run"

org, reps = :JeffFessler, :MIRTio
eval(:(using $reps))
import Documenter

# https://juliadocs.github.io/Documenter.jl/stable/man/syntax/#@example-block
ENV["GKSwstype"] = "100"
ENV["GKS_ENCODING"] = "utf-8"

# generate examples using Literate
src = joinpath(@__DIR__, "src")

base = "$org/$reps.jl"
repo_root_url = "https://github.com/$base/blob/main"

repo = eval(:($reps))
Documenter.DocMeta.setdocmeta!(repo, :DocTestSetup, :(using $reps); recursive=true)

# Documentation structure
ismd(f) = splitext(f)[2] == ".md"

isci = get(ENV, "CI", nothing) == "true"

format = Documenter.HTML(;
    prettyurls = isci,
    edit_link = "main",
    canonical = "https://$org.github.io/$repo.jl/stable/",
    assets = ["assets/custom.css"],
)

Documenter.makedocs(;
    modules = [repo],
    authors = "Jeff Fessler and contributors",
    sitename = "$repo.jl",
    format,
    pages = [
        "Home" => "index.md",
#       "Methods" => "methods.md",
    ],
)

if isci
    Documenter.deploydocs(;
        repo = "github.com/$base",
        devbranch = "main",
        devurl = "dev",
        versions = ["stable" => "v^", "dev" => "dev"],
        forcepush = true,
#       push_preview = true,
        # see https://$org.github.io/$repo.jl/previews/PR##
    )
end
