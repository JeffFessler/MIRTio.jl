#=
read_rdb_hdr.jl
based on
https://gitlab.com/fMRI/toppe/blob/master/+toppe/+utils/read_rdb_hdr.m

Matlab version is:
Copyright (c) 2012 by General Electric Company. All rights reserved.

2019-05-22 Julia version by Jeff Fessler
=#

export read_rdb_hdr

using Test: @test, @test_throws

include("rdb-26_002.jl") # rdb_hdr_26_002_def()


"""
    ht = read_rdb_hdr(fid::IOStream)

Read GE raw (RDB) header for MRI scans

Returns NamedTuple `ht` with header values accessible by `ht.key`
"""
function read_rdb_hdr(fid::IOStream)
	seek(fid, 0)
	rdbm_rev = read(fid, Float32) # raw header (RDBM) revision number

	if rdbm_rev == Float32(26.002)
	#	ht = read_rdb_hdr_26_002(fid)
		ht = header_read(fid, rdb_hdr_26_002_def())
		ht = header_string(ht)
	else
		throw("unknown RDBM rev $rdbm_rev")
	end

	(ht.rdbm_rev != rdbm_rev) &&
		throw("rev mismatch: $(ht.rdbm_rev) != $rdbm_rev")

	return ht
end


"""
    ht = read_rdb_hdr(file::String)
Read from `file`
"""
function read_rdb_hdr(file::String)
	return open(read_rdb_hdr, file)
end


"""
    read_rdb_hdr(:test)
self test, using a local pfile at UM
"""
function read_rdb_hdr(test::Symbol)
	!(test === :test) && throw("bad test $test")

	hd = rdb_hdr_26_002_def()
	ht = header_init(hd)
	@test ht isa NamedTuple

#= todo: commented out currently because of "setindex" issues in 1.3
=#
	tname = tempname()

	open(tname, "w") do fid
		header_write(fid, ht ; bytes = header_size(hd))
	end

	@test_throws String read_rdb_hdr(tname)

#	ht = setindex(ht, Float32(26.002), :rdbm_rev)
@show ht.rdbm_rev
	ht = merge(ht, [:rdbm_rev => Float32(26.002)])
@show ht.rdbm_rev

	hr = read_rdb_hdr(tname)
	@test hr isa NamedTuple
	@test hr[:rdbm_rev] isa Float32

	# UM-only test below here
	file = "/n/ir71/d3/fessler/fmri-data-michelle-L+S/P97792.7"
	isfile(file) && (@test read_rdb_hdr(file).dab[2] == 31)

	true
end
