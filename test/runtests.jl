using TinyHugeNumbers, Aqua, Test

Aqua.test_all(TinyHugeNumbers, deps_compat=(; check_extras=false, check_weakdeps=true))

import TinyHugeNumbers: TinyNumber, HugeNumber

struct ArbitraryFloatType <: AbstractFloat end

@testset "TinyHugeNumbers.jl" begin
    
    Base.eps(::Type{ArbitraryFloatType}) = 0.1
    Base.convert(::Type{ArbitraryFloatType}, ::Integer) = ArbitraryFloatType() # for testing

    @test repr(tiny) == "tiny"
    @test repr(huge) == "huge"

    @test typeof(tiny) === TinyNumber
    @test typeof(huge) === HugeNumber

    @test convert(Float32, tiny) === 1.0f-6
    @test convert(Float64, tiny) === 1e-12
    @test convert(BigFloat, tiny) == big"1e-24"
    @test convert(ArbitraryFloatType, tiny) === 10 * eps(ArbitraryFloatType)

    @test tiny(Float32) === 1.0f-6
    @test tiny(Float64) === 1e-12
    @test tiny(BigFloat) == big"1e-24"
    @test tiny(ArbitraryFloatType) === 10 * eps(ArbitraryFloatType)

    # `convert(T, 1)` here returns an instance of type `T`
    @test tiny(convert(Float32, 1)) === 1.0f-6
    @test tiny(convert(Float64, 1)) === 1e-12
    @test tiny(convert(BigFloat, 1)) == big"1e-24"
    @test tiny(convert(ArbitraryFloatType, 1)) === 10 * eps(ArbitraryFloatType)

    @test Float32(tiny) === 1.0f-6
    @test Float64(tiny) === 1e-12
    @test BigFloat(tiny) == big"1e-24"
    @test ArbitraryFloatType(tiny) === 10 * eps(ArbitraryFloatType)

    @test convert(Float32, huge) === 1.0f+6
    @test convert(Float64, huge) === 1e+12
    @test convert(BigFloat, huge) == big"1e+24"
    @test convert(ArbitraryFloatType, huge) === inv(10 * eps(ArbitraryFloatType))

    @test huge(Float32) === 1.0f+6
    @test huge(Float64) === 1e+12
    @test huge(BigFloat) == big"1e+24"
    @test huge(ArbitraryFloatType) === inv(10 * eps(ArbitraryFloatType))

    # `convert(T, 1)` here returns an instance of type `T`
    @test huge(convert(Float32, 1)) === 1.0f+6
    @test huge(convert(Float64, 1)) === 1e+12
    @test huge(convert(BigFloat, 1)) == big"1e+24"
    @test huge(convert(ArbitraryFloatType, 1)) === inv(10 * eps(ArbitraryFloatType))

    @test Float32(huge) === 1.0f+6
    @test Float64(huge) === 1e+12
    @test BigFloat(huge) == big"1e+24"
    @test ArbitraryFloatType(huge) === inv(10 * eps(ArbitraryFloatType))

    @test @inferred clamp(1.0f0, tiny, huge) == 1.0f0
    @test @inferred clamp(0.0f0, tiny, huge) == 1.0f-6
    @test @inferred clamp(1.0f13, tiny, huge) == 1.0f+6

    @test @inferred clamp(1.0, tiny, huge) == 1.0
    @test @inferred clamp(0.0, tiny, huge) == 1e-12
    @test @inferred clamp(1e13, tiny, huge) == 1e12

    @test @inferred clamp(big"1.0", tiny, huge) == big"1.0"
    @test @inferred clamp(big"0.0", tiny, huge) == big"1e-24"
    @test @inferred clamp(big"1e25", tiny, huge) == big"1e+24"

    for T in (Float64, Float32, BigFloat, ArbitraryFloatType)
        @test @inferred(promote_type(T, TinyNumber, HugeNumber)) == T
        @test @inferred(promote_type(T, HugeNumber, TinyNumber)) == T
    end

    for a in (1, 1.0, 0, 0.0, 1.0f0, 0.0f0, Int32(0), Int32(1), big"1", big"1.0", big"0", big"0.0")
        T = typeof(a)
        for v in Real[tiny, huge]
            V = typeof(v)

            for op in [+, -, *, /, >, >=, <, <=]
                # lines below already wrap `op(a, v)` / `op(v, a)` in `@inferred` *and*
                # check the value against the promoted-through-a-real-float expected
                @test @inferred op(a, v) == op(a, convert(promote_type(T, V), v))
                @test @inferred op(v, a) == op(convert(promote_type(T, V), v), a)
            end

            @test v <= (@inferred clamp(a, v, Inf)) <= Inf
            @test zero(a) <= (@inferred clamp(a, zero(a), v)) <= v

            for size in [3, 5]
                for array in [fill(a, (size,)), fill(a, (size, size))]
                    for op in [+, -, *, /, >, >=, <, <=]
                        @test @inferred op.(array, v) == op.(array, convert(promote_type(T, V), v))
                        @test @inferred op.(v, array) == op.(convert(promote_type(T, V), v), array)
                    end

                    # `@inferred` needs a plain call expression, not broadcast syntax `f.(x)`,
                    # so spell the broadcast as `broadcast(clamp, ...)` to infer the array result.
                    # The `Inf` upper bound is a `Float64`, so it participates in `clamp`'s
                    # promotion — the expected must convert `v` through `promote_type(T, V, Float64)`.
                    @test @inferred(broadcast(clamp, array, v, Inf)) == clamp.(array, convert(promote_type(T, V, typeof(Inf)), v), Inf)
                    @test @inferred(broadcast(clamp, array, zero(array), v)) == clamp.(array, zero(array), convert(promote_type(T, V), v))
                end
            end
        end
    end

end

@testset "Ordering between `tiny` and `huge`" begin
    # regression test for https://github.com/ReactiveBayes/TinyHugeNumbers.jl/issues/7
    @test tiny < huge
    @test !(huge < tiny)
    @test huge > tiny
    @test !(tiny > huge)

    @test tiny <= huge
    @test huge >= tiny
    @test !(huge <= tiny)
    @test !(tiny >= huge)

    @test isless(tiny, huge)
    @test !isless(huge, tiny)

    @test !(tiny == huge)
    @test !(huge == tiny)

    # reflexive same-type comparisons
    @test tiny == tiny
    @test huge == huge
    @test !(tiny < tiny)
    @test !(huge < huge)
    @test tiny <= tiny
    @test huge >= huge
    @test !isless(tiny, tiny)
    @test !isless(huge, huge)

    # `min`/`max`/`extrema` must not throw and must pick the right sentinel
    @test min(tiny, huge) === tiny
    @test min(huge, tiny) === tiny
    @test max(tiny, huge) === huge
    @test max(huge, tiny) === huge
    @test min(tiny, tiny) === tiny
    @test max(huge, huge) === huge

    for F in (Float32, Float64, BigFloat)
        @test extrema([one(F), tiny(F), huge(F)]) == (tiny(F), huge(F))
    end

    # storing both sentinels in one container must still throw (design is unchanged)
    @static if VERSION >= v"1.10"
        @test_throws "Cannot convert `tiny` to `huge`" [tiny, huge]
    else
        @test_throws ErrorException [tiny, huge]
    end
end

@testset "ForwardDiff.jl compatibility" begin
    import ForwardDiff

    f(x) = clamp(x, tiny, huge)

    @test @inferred(ForwardDiff.derivative(f, 1.0)) === 1.0
    @test @inferred(ForwardDiff.derivative(f, 2.0)) === 1.0
    @test @inferred(ForwardDiff.derivative(f, 0.0)) === 0.0
    @test @inferred(ForwardDiff.derivative(f, huge + 1.0)) === 0.0
    @test @inferred(ForwardDiff.derivative(f, tiny - 1.0)) === 0.0

    g(x) = clamp(x^2, tiny, huge)

    @test @inferred(ForwardDiff.derivative(g, 1.0)) === 2.0
    @test @inferred(ForwardDiff.derivative(g, 2.0)) === 4.0
    @test @inferred(ForwardDiff.derivative(g, 0.0)) === 0.0
    @test @inferred(ForwardDiff.derivative(g, huge + 1.0)) === 0.0
    @test @inferred(ForwardDiff.derivative(g, tiny - 1.0)) === 2(tiny - 1.0)
end

@testset "Storing `tiny` and `huge` in arrays" begin
    @static if VERSION >= v"1.10"
        @test_throws "Cannot convert `tiny` to `huge`" [tiny, huge]
        @test_throws "Cannot convert `huge` to `tiny`" [huge, tiny]
    else
        @test_throws ErrorException [tiny, huge]
        @test_throws ErrorException [huge, tiny]
    end

    for a in (1.0, 0.0, 1.0f0, 0.0f0, big"1.0", big"0.0")
        @test [a, tiny, huge] == [a, tiny(a), huge(a)]
        @test [tiny, a, huge] == [tiny(a), a, huge(a)]
        @test [tiny, huge, a] == [tiny(a), huge(a), a]

        @test [a, huge, tiny] == [a, huge(a), tiny(a)]
        @test [huge, a, tiny] == [huge(a), a, tiny(a)]
        @test [huge, tiny, a] == [huge(a), tiny(a), a]
    end
end
