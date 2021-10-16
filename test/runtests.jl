using ExactConvolution
using Test

function naive_array2bigint(arr, num_bits::Int)
	@assert all(>=(0), arr)
	ans = BigInt(0)
	for i ∈ reverse(arr)
		ans <<= num_bits
		ans |= i
	end
	ans
end

function random_input(;len=300, bits=24, max_bits=100)
	l = rand(1:len)
	arr = rand(0:2^bits-1, l)
	num_bits = rand(bits+1:max_bits)
	while num_bits%5!=0
		num_bits+=1
	end
	return arr,num_bits
end


@testset "Array->BigInt" begin
    function test_input(arr, num_bits)
		r1 = ExactConvolution.array2bigint(arr, num_bits)
		r2 = naive_array2bigint(arr, num_bits)
		@test r1==r2
	end
    for _ ∈ 1:100000
		test_input(random_input(len=3, bits=3, max_bits=4)...)
	end

	for _ ∈ 1:100000
		test_input(random_input(len=5, bits=10, max_bits=20)...)
	end

	for _ ∈ 1:1000
		test_input(random_input()...)
	end
end

@testset "BigInt->Array" begin
    function run_bigint2array(arr, num_bits)
        bi = naive_array2bigint(arr, num_bits)
        bigint2array(BigInt, bi, length(arr), num_bits)
    end

    function test_input(arr, num_bits)
		arr2 = run_bigint2array(arr, num_bits)
		@test arr == arr2
	end
	
	for _ ∈ 1:1000
		test_input(random_input(len=5, bits=3, max_bits=6)...)
	end

	for _ ∈ 1:1000
		test_input(random_input()...)
	end	
end

function naive_conv(a, b)
    n = length(a) + length(b) - 1
    arr = zeros(BigInt, n)
    for (i, v1) ∈ enumerate(a), (j, v2) ∈ enumerate(b)
        arr[i+j-1] += big(v1) * v2
    end
    arr
end

function random_inputs_conv(;len=300, bits=20, has_neg=true)
	rand_array() = begin
		l = rand(1:len)
		arr = rand(0:(2^bits-1), l)
		rand(false:has_neg) && (arr .-= (2^(bits-1)))
		arr
	end
	rand_array(),rand_array()
end

@testset "Exact Convolutions" begin
    function test_input(arr1, arr2)
		r1 = exact_conv(arr1,arr2)
		r2 = naive_conv(arr1,arr2)
		@test r1==r2 
	end
	
	for _ ∈ 1:100000
		test_input(random_inputs_conv(len=5, bits=5, has_neg=false)...)
	end
	
	for _ ∈ 1:100000
		test_input(random_inputs_conv(len=5, bits=5)...)
	end

	for _ ∈ 1:1000
		test_input(random_inputs_conv()...)
	end
end
