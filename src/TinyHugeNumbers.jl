module TinyHugeNumbers

export tiny, huge 

import Base: show, convert, promote_rule

"""
See [`tiny`](@ref)
"""
struct TinyNumber <: Real end

Base.show(io::IO, ::TinyNumber) = print(io, "tiny")

Base.convert(::Type{F}, ::TinyNumber) where {F <: AbstractFloat} = 10eps(F)
Base.convert(::Type{Float32}, ::TinyNumber)  = 1.0f-6
Base.convert(::Type{Float64}, ::TinyNumber)  = 1e-12
Base.convert(::Type{BigFloat}, ::TinyNumber) = big"1e-24"

Base.promote_rule(::Type{TinyNumber}, ::Type{I}) where {I <: Integer}       = promote_rule(TinyNumber, promote_type(I, Float64))
Base.promote_rule(::Type{TinyNumber}, ::Type{F}) where {F <: AbstractFloat} = F

(::Type{T})(::TinyNumber) where {T <: AbstractFloat} = convert(T, tiny)

(::TinyNumber)(::Type{ T }) where {T} = convert(T, TinyNumber())
(::TinyNumber)(something)             = convert(typeof(something), TinyNumber())

"""
    tiny

`tiny` represents a (wow!) tiny number that can be used in a various computations without unnecessary type promotions.

`tiny` is defined as:
- `1.0f-6` for `Float32`
- `1e-12` for `Float64`
- `big"1e-24"` for `BigFloat`
- `10 * eps(F)` for an arbitrary type `F <: AbstractFloat`

# Example
```jldoctest 
julia> tiny
tiny

julia> 1 + tiny
1.000000000001

julia> tiny + 1
1.000000000001

julia> 1f0 + tiny
1.000001f0

julia> big"1.0" + tiny
1.000000000000000000000001

julia> big"1" + tiny
1.000000000000000000000001
```

See also: [`huge`](@ref)
"""
const tiny = TinyNumber()

## ------------------------------------------------------------------------------------ ##

"""
See [`huge`](@ref)
"""
struct HugeNumber <: Real end

Base.show(io::IO, ::HugeNumber) = print(io, "huge")

Base.convert(::Type{F}, ::HugeNumber) where {F <: AbstractFloat} = inv(tiny(F))
Base.convert(::Type{Float32}, ::HugeNumber)  = 1.0f+6
Base.convert(::Type{Float64}, ::HugeNumber)  = 1e+12
Base.convert(::Type{BigFloat}, ::HugeNumber) = big"1e+24"

Base.promote_rule(::Type{HugeNumber}, ::Type{I}) where {I <: Integer}       = promote_rule(HugeNumber, promote_type(I, Float64))
Base.promote_rule(::Type{HugeNumber}, ::Type{F}) where {F <: AbstractFloat} = F

(::Type{T})(::HugeNumber) where {T <: AbstractFloat} = convert(T, huge)

(::HugeNumber)(::Type{ T }) where {T} = convert(T, HugeNumber())
(::HugeNumber)(something)             = convert(typeof(something), HugeNumber())

"""
    huge

`huge` represents a (wow!) huge number that can be used in a various computations without unnecessary type promotions.

`huge` is defined as:
- `1.0f+6` for `Float32`
- `1e+12` for `Float64`
- `big"1e+24"` for `BigFloat`
- `inv(tiny(F))` for an arbitrary type `F <: AbstractFloat`

# Example
```jldoctest 
julia> huge
huge

julia> 1 + huge
1.000000000001e12

julia> huge + 1
1.000000000001e12

julia> 1f0 + huge
1.000001f6

julia> big"1.0" + huge
1.000000000000000000000001e+24

julia> big"1" + huge
1.000000000000000000000001e+24
```

See also: [`tiny`](@ref)
"""
const huge = HugeNumber()

## ------------------------------------------------------------------------------------ ##

Base.promote_type(::Type{T}, ::Type{TinyNumber}, ::Type{HugeNumber}) where {T} =
    promote_type(promote_type(T, TinyNumber), HugeNumber)
Base.promote_type(::Type{T}, ::Type{HugeNumber}, ::Type{TinyNumber}) where {T} =
    promote_type(promote_type(T, HugeNumber), TinyNumber)

end
