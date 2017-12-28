module ComplexSIMD

    import StaticArrays: SVector
    using SIMD

    function cmul(A::SVector{4, Complex128}, B::SVector{4, Complex128})

        realA, imagA = vec2realimag(A)
        realB, imagB = vec2realimag(B)

        real, imag = cmul_vecs(realA, imagA, realB, realB)

        # realimag2vec(real, imag)
    end

    function cmul_mixed(realA, imagA, B::SVector{4, Complex128})

        #realA, imagA = vec2realimag(A)
        realB, imagB = vec2realimag(B)

        real, imag = cmul_vecs(realA, imagA, realB, realB)

        # realimag2vec(real, imag)
    end

    @inline function cmul_vecs(realA::Vec{4, Float64}, imagA::Vec{4, Float64}, realB::Vec{4, Float64}, imagB::Vec{4, Float64})
        imagprod = imagA * imagB
        # rAiB = realA * imagB
        rBiA = realB * imagA

        real = fma(realA, realB, -imagprod)
        imag = fma(realA, imagB, rBiA)

        real, imag
    end


    @inline function vec2realimag(A::SVector{4, Complex128})
        realmask = (0, 4, 2, 6)
        imagmask = (1, 5, 3, 7)
        @inbounds A0 = Vec{4, Float64}((A[1].re, A[1].im, A[2].re, A[2].im))
        @inbounds A2 = Vec{4, Float64}((A[3].re, A[3].im, A[4].re, A[4].im))
        realA = shufflevector(A0, A2, Val{realmask})
        imagA = shufflevector(A0, A2, Val{imagmask})

        realA, imagA
    end

    @inline function realimag2vec(real::Vec{4, Float64}, imag::Vec{4, Float64})
        pack_dist0 = (0, 4, 2, 6)
        pack_dist2 = (1, 5, 3, 7)

        dist0 = shufflevector(real, imag, Val{pack_dist0})
        dist2 = shufflevector(real, imag, Val{pack_dist2})

        dist0, dist2
    end

# package code goes here
end # module
