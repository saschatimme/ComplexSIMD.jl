using ComplexSIMD
using Base.Test
using StaticArrays
using SIMD
using BenchmarkTools

a = @SVector rand(Complex128, 4)
b = @SVector rand(Complex128, 4)

d0, d1 = ComplexSIMD.cmul(a, b)

@btime ComplexSIMD.cmul($a, $b)

function naive(x, y)
    x .* y
end

@btime naive($a, $b)

@code_native ComplexSIMD.cmul(a, b)

# write your own tests here
@test 1 == 2
