const Maybe{T} = Union{T,Nothing}


ensure(condition, val, msg) =
    if !condition throw(DomainError("value: $val", msg)) end

