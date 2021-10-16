### conversion.jl
#
# Copyright (C) 2021 Ido Kessler.
#
# Keywords: conversion array to bigint
#
# This file is a part of ExactConvolution.jl.
#
# License is MIT.
#
### Commentary:
#
# This file contains implementation of conversion between Arrays to BigInt 
#
### Code:

export array2bigint, bigint2array

function array2bigint(arr::Vector{T}, num_bits_per_item::Int) where {T<:Integer}
    @assert all(>=(0), arr)

    @assert num_bits_per_item % 5 == 0
    num_char_per_items = num_bits_per_item ÷ 5

    n = length(arr)
    buffer = Base.StringVector(n * num_char_per_items + 1)
    buffer .= 0x30 # '0' = 0x30
    buffer[end] = 0 # zero-termination

    function write_number(end_idx, v)::Nothing
        while v != 0
            a = (v & UInt8(2^5 - 1))
            a += 0x30 + (a > 9) * 0x27 # 0-9 = 0x30-0x39, 'a' = 0x61
            buffer[end_idx] = a
            v >>= 5
            end_idx -= 1
        end
    end

    write_number.(num_char_per_items .* (n:-1:1), arr)
    res = BigInt(0)
    GC.@preserve buffer Base.GMP.MPZ.set_str!(res, pointer(buffer), 32)
    res
end


function bigint2array(::Type{T}, bi::BigInt, n::Int, num_bits_per_item::Int)::Vector{T} where {T <: Integer}
    @assert num_bits_per_item % 5 == 0
    num_char_per_item = num_bits_per_item ÷ 5

    buffer = Base.StringVector(n * num_char_per_item + 1)
    buffer .= 0x30
    buffer[end] = 0

    nd = ndigits(bi, base = 32)
    @assert nd <= n * num_char_per_item

    n_zeros = n * num_char_per_item - nd
    GC.@preserve buffer Base.GMP.MPZ.get_str!(pointer(buffer) + n_zeros, 32, bi)

    function read_number(end_idx)::T
        v = BigInt(0)
        prev = buffer[end_idx+1]
        buffer[end_idx+1] = 0 # zero-termination
        start_idx = end_idx - num_char_per_item
        GC.@preserve buffer Base.GMP.MPZ.set_str!(v, pointer(buffer) + start_idx, 32)
        buffer[end_idx+1] = prev
        return v
    end

    arr = Vector{T}(undef, n)
	# read_number might change the one next to it. 
    arr[1:2:end] .= read_number.(num_char_per_item .* (n:-2:1))
    arr[2:2:end] .= read_number.(num_char_per_item .* (n-1:-2:1))
    arr
end
