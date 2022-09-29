# TinyHugeNumbers

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://bvdmitri.github.io/TinyHugeNumbers.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://bvdmitri.github.io/TinyHugeNumbers.jl/dev/)
[![Build Status](https://github.com/bvdmitri/TinyHugeNumbers.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/bvdmitri/TinyHugeNumbers.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/bvdmitri/TinyHugeNumbers.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/bvdmitri/TinyHugeNumbers.jl)
[![PkgEval](https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/T/TinyHugeNumbers.svg)](https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/report.html)

The `TinyHugeNumbers` package exports `tiny` and `huge` objects to represent tiny and huge numbers. These objects aren't really numbers and behave differently depending on the context. They do support any operation that is defined for Real numbers. For more info see Julia's documentation about promotion.

`tiny` represents a (wow!) tiny number that can be used in a various computations without unnecessary type promotions.

`tiny` is defined as:
- `1.0f-6` for `Float32`
- `1e-12` for `Float64`
- `big"1e-24"` for `BigFloat`
- `10 * eps(F)` for an arbitrary type `F <: AbstractFloat`

```julia
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

`huge` represents a (wow!) huge number that can be used in a various computations without unnecessary type promotions.

`huge` is defined as:
- `1.0f+6` for `Float32`
- `1e+12` for `Float64`
- `big"1e+24"` for `BigFloat`
- `inv(tiny(F))` for an arbitrary type `F <: AbstractFloat`

```julia 
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
