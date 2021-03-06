const Maybe{T} = Union{T,Nothing}

"""
    ValidationException

Thrown when parameters to generate an IBAN fail validation. Reports the problematic value
and the matching BBAN attribute

## Example
```julia
julia> iban_random(CountryCode = "GR", BankCode = "xxx")
ERROR: ValidationException value: "xxx"
invalid characters [Iban.BankCode]  
```
"""
struct ValidationException <: Exception 
    val::Maybe{AbstractString}
    msg::AbstractString
end

Base.showerror(io::IO, ex::ValidationException) =
    print(io, """ValidationException value: "$(ex.val)"\n$(ex.msg)""")


ensure(condition, val, msg) =
    if !condition throw(ValidationException(val, msg)) end

