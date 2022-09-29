using TinyHugeNumbers
using Test

@testset "TinyHugeNumbers.jl" begin

    import TinyHugeNumbers: TinyNumber, HugeNumber

    struct ArbitraryFloatType <: AbstractFloat end 

    Base.eps(::Type{ ArbitraryFloatType }) = 0.1
    Base.convert(::Type{ ArbitraryFloatType }, ::Integer) = ArbitraryFloatType() # for testing
    
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

    for a in (1, 1.0, 0, 0.0, 1.0f0, 0.0f0, Int32(0), Int32(1), big"1", big"1.0", big"0", big"0.0")
        T = typeof(a)
        for v in [tiny, huge]
            V = typeof(v)

            for op in [+, -, *, /, >, >=, <, <=]
                @test @inferred op(a, v) == op(a, convert(promote_type(T, V), v))
                @test @inferred op(v, a) == op(convert(promote_type(T, V), v), a)

                @test @inferred op(a, v) == op(a, v)
                @test @inferred op(v, a) == op(v, a)
            end

            @test v <= (@inferred clamp(a, v, Inf)) <= Inf
            @test zero(a) <= (@inferred clamp(a, zero(a), v)) <= v

            for size in [3, 5]
                for array in [fill(a, (size,)), fill(a, (size, size))]
                    for op in [+, -, *, /, >, >=, <, <=]
                        @test @inferred op.(array, v) == op.(array, convert(promote_type(T, V), v))
                        @test @inferred op.(v, array) == op.(convert(promote_type(T, V), v), array)

                        @test @inferred op.(array, v) == op.(array, v)
                        @test @inferred op.(v, array) == op.(v, array)
                    end

                    @test @inferred clamp.(array, v, Inf) == clamp.(array, v, Inf)
                    @test @inferred clamp.(array, zero(array), v) == clamp.(array, zero(array), v)
                end
            end
        end
    end

end
