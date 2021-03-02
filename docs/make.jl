# ~/work/julia/Iban/docs$ julia  make.jl

push!(LOAD_PATH,"../src/")

using Iban
using Documenter

makedocs(
    modules = [Iban], 
    sitename = "Iban.jl",
    authors = "unknown"
)