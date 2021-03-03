const Maybe{T} = Union{T,Nothing}

struct ValidationException <: Exception 
    val::Maybe{AbstractString}
    msg::AbstractString
end

Base.showerror(io::IO, ex::ValidationException) =
    print(io, """ValidationException value: "$(ex.val)"\n$(ex.msg)""")


ensure(condition, val, msg) =
    if !condition throw(ValidationException(val, msg)) end

