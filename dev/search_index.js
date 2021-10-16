var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = ExactConvolution","category":"page"},{"location":"#ExactConvolution","page":"Home","title":"ExactConvolution","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"ExactConvolution","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [ExactConvolution]","category":"page"},{"location":"#ExactConvolution.ExactConvolution","page":"Home","title":"ExactConvolution.ExactConvolution","text":"ExactConvolution\n\nImplement efficient exact integer convolution using BigInt's multiplication.\n\n\n\n\n\n","category":"module"},{"location":"#ExactConvolution.exact_conv","page":"Home","title":"ExactConvolution.exact_conv","text":"exact_conv([T,] a, b)\n\nConvolve arrays of integers a and b, and return the resulting array.\n\nexact_conv(ab)k = sum_i+j=k ai cdot bj\n\nNotes:\n\nThe implementation uses GMP's BigInt multiplication as the underling DSP engine (FFT for big enough inputs). \nT must be sufficient to support the result.\nUsing negative values in a and b is supported but discouraged for runtime reasons.\n\nExamples\n\njulia> exact_conv(Int32, [1,2], [4,5,6])\n4-element Vector{Int32}:\n  4\n 13\n 16\n 12\n\n\n\n\n\n","category":"function"}]
}
