using Iban
using Test

# shell> cd /Users/xor/work/julia/Iban
#  pkg> activate .
# test
# or:
# Pkg.test("Iban", test_args=["test_iban_from_string", "test_countries", "test_iban", "test_iban_random"])

active_tests = lowercase.(ARGS)

function addtest(fname)
    key = lowercase(splitext(fname)[1])
    if isempty(active_tests) || key in active_tests
        include(fname)
    end
end


addtest("test_countries.jl")
addtest("test_iban_from_string.jl")
addtest("test_iban.jl")
addtest("test_iban_random.jl")
