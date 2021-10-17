# ExactConvolution

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://kessido.github.io/ExactConvolution.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://kessido.github.io/ExactConvolution.jl/dev)
[![Build Status](https://github.com/kessido/ExactConvolution.jl/workflows/CI/badge.svg)](https://github.com/kessido/ExactConvolution.jl/actions)
[![Coverage](https://codecov.io/gh/kessido/ExactConvolution.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/kessido/ExactConvolution.jl)

This package is intended for computing exact convolutions of integers vectors.

It is essentialy a wrapper over GMP's BigInt multiplications, and as such it is very efficient. Convolutions of two Int64 arrays of length 10^5 can take about 90ms, or 180ms if negative values are presented.

For convolutions of integers that floating point computations might be sufficient exact for, it is recommended using [DSP.jl](https://github.com/JuliaDSP/DSP.jl) which can be for some cases 10x fasters.

# Installation

# Usage 
```julia
julia> using ExactConvolution
julia> exact_conv(Int16, [1,2], [4,5,6])
4-element Vector{Int16}:
  4
 13
 16
 12
julia> julia> exact_conv(BigInt, [big"2"^80, big"5"^42], [4,5,6])
4-element Vector{BigInt}:
       4835703278458516698824704
  909500746402026311060912593380
 1136875630771077985168847065181
 1364242052659392356872558593750
julia> exact_conv(Int128, [big"2"^80, big"5"^42], [4,5,6])
4-element Vector{Int128}:
       4835703278458516698824704
  909500746402026311060912593380
 1136875630771077985168847065181
 1364242052659392356872558593750
 julia> exact_conv(Int8, [1,-2], [4,5,6])
4-element Vector{Int8}:
   4
  -3
  -4
 -12
 ```
 
# Documentation
