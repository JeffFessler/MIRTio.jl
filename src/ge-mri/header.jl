#=
header.jl

Many legacy medical imaging data files have a structured "header" at the top
that contains scan information.
This code is designed to read such scan headers.

2019-12-23 Jeff Fessler
=#

export header_read, header_write
export header_init, header_size, header_string, header_test

using Test: @test, @inferred


"""
    hd = header_example()

Return example of header description

out
- `hd` header definition array (N × 3)
"""
function header_example()
	hd = [
		:date 10 Cuchar;
		:age 1 Int32;
		:height 1 Float32;
		:other 3 UInt16;
	]
	return (hd, 24)
end


"""
    ht = header_init(hd::Matrix{Any})

Return named tuple initialized with arbitrary values for testing

in
- `hd` header definition array (N × 3), e.g., from `header_example()`

out
- `ht::NamedTuple`
"""
function header_init(hd::Matrix{Any})
	nset = size(hd,1)
	vals = Array{Any}(undef, nset)
	cset = Cuchar.(97:122) # a:z in ascii
	for i = 1:nset
		row = hd[i,:]
		n = row[2]
		T = row[3]
		Tr = T == Cuchar ? cset : T
		vals[i] = n > 1 ? rand(Tr, n) : rand(Tr)
	end
	return ( ; zip(hd[:,1], vals)... ) # NamedTuple
end


"""
    bytes = header_size(hd::Matrix{Any})
return total size of header in bytes

in
- `hd` header definition array (N × 3), e.g., from `header_example()`

out
= `bytes::Int`
"""
function header_size(hd::Matrix{Any})
	nset = size(hd,1)
	total = Int(0)
	for i = 1:nset
		row = hd[i,:]
		T = row[3]
		total += row[2] * sizeof(T)
	end
	return total
end


"""
    header_write(fid::IOStream, ht::NamedTuple)

Write header to `fid`

in
- `fid::IOStream` from open(file, "w")
- `ht::NamedTuple` from `header_init()` or `header_read()`
"""
function header_write(fid::IOStream, ht::NamedTuple ; bytes::Int = 0)
	tmp = write(fid, values(ht)...)
	bytes > 0 && bytes != tmp && throw("bytes written mismatch")
	nothing
end


"""
    ht = header_read(fid::IOStream, hd::Matrix{Any} ; seek0::Bool)

Read header from scan file

in
- `fid::IOStream` from open(file, "r")
- `hd` header definition array (N × 3), e.g., from `header_example()`

option
- `seek0::Bool` seek to `0` location in file first? default `true`

out
- `ht::NamedTuple` with header values, accessed by ht.key
"""
function header_read(fid::IOStream, hd::Matrix{Any} ; seek0::Bool = true)
	size(hd,2) != 3 && throw("bad hd size")

	seek0 && seek(fid, 0)

	nset = size(hd,1)
	vals = Array{Any}(undef, nset)
	for i = 1:nset
		row = hd[i,:]
		n = row[2]
		T = row[3]
		if n == 1
			vals[i] = read(fid, T)
		else
			data = Array{T}(undef, n)
			read!(fid, data)
			vals[i] = data
		end
	end
	return ( ; zip(hd[:,1], vals)... ) # NamedTuple
end


"""
    ht = header_string(ht::NamedTuple ; strip::Bool)

Convert each `Array{Cuchar}` to `String` in NamedTuple

in
- `ht::NamedTuple` from `header_init()` or `header_read()`

option
- `strip::Bool` strip tail white space characters from strings? default `false`

out
- `ht::NamedTuple`
"""
function header_string(ht::NamedTuple ; strip::Bool = false)
	npair = length(ht)
	vals = Array{Any}(undef, npair)
	for (i,key) in enumerate(keys(ht))
		val = ht[key]
		if val isa Array{Cuchar}
			val = String(val)
			val = strip ? rstrip(val) : val
		end
		vals[i] = val
	end
	return ( ; zip(keys(ht), vals)... ) # NamedTuple
end


"""
    header_test(:test)
self test
"""
function header_test(test::Symbol)
	test != :test && throw("bad test $test")

	hd, hs = header_example()
	@test header_size(hd) == hs
	ht = header_init(hd) # random data for testing

	tname = tempname()
	open(tname, "w") do fid
		header_write(fid, ht ; bytes = header_size(hd))
	end

	open(tname, "r") do fid
		hr = header_read(fid, hd ; seek0 = true)
		@test hr == ht
		hu = header_string(hr)
		@test hu isa NamedTuple
		@test hu.date isa String
		@test all([hu[i] == ht[i] for i=2:length(hu)])
	end

	true
end

# header_test(:test)
