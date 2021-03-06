# ~/work/julia/Iban/docs$ julia  make.jl

push!(LOAD_PATH,"../src/")

using Iban
using Documenter

makedocs(
    sitename = "Iban.jl",
    modules = [Iban], 
    authors = "David Soroko"
)

# see: https://juliadocs.github.io/Documenter.jl/stable/lib/public/#Documenter.deploydocs
deploydocs(
    repo = "github.com/sorokod/Iban.jl.git"
)