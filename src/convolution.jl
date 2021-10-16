### convolution.jl
#
# Copyright (C) 2021 Ido Kessler.
#
# Keywords: exact integer convolution
#
# This file is a part of ExactConvolution.jl.
#
# License is MIT.
#
### Commentary:
#
# This file contains implementation of convolutions using bigints multiplication. 
#
### Code:

export exact_conv

include("conversion.jl")

"""
    exact_conv([T,] a, b)

Convolve arrays of integers `a` and `b`, and return the resulting array.

``exact_conv(a,b)[k] = ∑_{i+j=k} a[i] \cdot b[j]``

# Notes:
    - T must be sufficient to support the result.
    - Using negative values in `a` and `b` is 
      supported but discouraged for runtime reasons.

# Examples
```jldoctest
julia> using ExactConvolution
julia> exact_conv(Int32, [1,2], [4,5,6])
4-element Vector{Int32}:
  4
 13
 16
 12
```
"""
function exact_conv end

exact_conv(a, b) = exact_conv(Int64, a, b)

function exact_conv(
    ::Type{T},
    a::AbstractArray{T1},
    b::AbstractArray{T2},
) where {T<:Integer,T1<:Integer,T2<:Integer}
    function make_positive(::Type{T}, v) where {T}
        min_v = min(minimum(v), 0) |> T
        return min_v, (min_v == 0 ? v : (v .- min_v))
    end

    min_a, a_pos = make_positive(T, a)
    min_b, b_pos = make_positive(T, b)

    res = positive_exact_conv(T, a_pos, b_pos)

    # handle the added -min_a * (b[...] - min_b) 
    handle_negatives!(T, res, -min_a, b_pos)
    # handle the added -min_b * a[...]
    handle_negatives!(T, res, -min_b, a)

    res
end

# Only accept positive values
function positive_exact_conv(::Type{T}, a, b)::Vector{T} where {T<:Integer}
    nbits(x) = ndigits(x; base = 2)
    max_bits = nbits ∘ maximum

    lg2_max_mult = max_bits(a) + max_bits(b)
    lg2_max_len = [a, b] .|> length |> minimum |> nbits
    nb = lg2_max_mult + lg2_max_len
    nb = 5 * ceil(Int, nb // 5)

    big_a = array2bigint(a, nb)
    big_b = array2bigint(b, nb)
    ab = big_a * big_b
    n = length(a) + length(b) - 1
    bigint2array(T, ab, n, nb)
end

function handle_negatives!(::Type{T}, res, v1_added, v2_pos)::Nothing where {T}
    v1_added == 0 && return
    # min_v1 * v2_[i:j] was added
    n, n2 = length(res), length(v2_pos)

    v1_added = T(v1_added)
    extra = T(0)
    # v2[i] only participate in the conv from index i
    for (i, v) ∈ zip(1:n2, v2_pos)
        extra += v * v1_added
        res[i] -= extra
    end
    res[n2+1:end] .-= extra

    removed_extra = T(0)
    # v2[end-i] only participate in the conv upto index end-i
    for (i, v) ∈ zip(n-n2+1:n, v2_pos)
        res[i] += removed_extra
        removed_extra += v * v1_added
    end
    return
end
