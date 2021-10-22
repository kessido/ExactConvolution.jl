# ExactConvolution

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://kessido.github.io/ExactConvolution.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://kessido.github.io/ExactConvolution.jl/dev)
[![Build Status](https://github.com/kessido/ExactConvolution.jl/workflows/CI/badge.svg)](https://github.com/kessido/ExactConvolution.jl/actions)
[![Coverage](https://codecov.io/gh/kessido/ExactConvolution.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/kessido/ExactConvolution.jl)

This package is intended for computing exact convolutions of integers vectors.

It is essentialy a wrapper over GMP's BigInt multiplications, and as such it is very efficient. Convolutions of two Int64 arrays of length 10^5 can take about 60ms, or 120ms if negative values are presented.

For integers that floating point computations might be sufficient exact for, please use [DSP.jl](https://github.com/JuliaDSP/DSP.jl), which for some cases can be 10x faster.

# Installation
```julia
pkg> add ExactConvolution
```
Or, equivalently, via `Pkg` API:
```julia
julia> import Pkg; Pkg.add("ExactConvolution")
```

# Usage 
```julia
julia> using ExactConvolution

julia> exact_conv(Int16, [1,2], [4,5,6])
4-element Vector{Int16}:
  4
 13
 16
 12

julia> exact_conv(BigInt, [big"2"^80, big"5"^42], [4,5,6])
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

julia> using BenchmarkTools

julia> rand_array(bits) = rand(0:2^bits, 10^5);

julia> arr1,arr2 = rand_array(20),rand_array(20);

julia> @btime exact_conv(Int64, arr1, arr2);
  64.988 ms (600085 allocations: 27.98 MiB)

julia> using DSP

julia> @btime conv(arr1, arr2);
  5.548 ms (94 allocations: 10.69 MiB)
```
