#=
read_rdb_hdr.jl
based on
https://gitlab.com/fMRI/toppe/blob/master/+toppe/+utils/read_rdb_hdr.m

Matlab version is:
Copyright (c) 2012 by General Electric Company. All rights reserved.

2019-05-22 Julia version by Jeff Fessler
=#

export read_rdb_hdr

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

	if (ht.rdbm_rev != rdbm_rev)
		throw("rev mismatch: $(ht.rdbm_rev) != $rdbm_rev")
	end

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
	file = "/n/ir71/d3/fessler/fmri-data-michelle-L+S/P97792.7"
	if isfile(file)
		return read_rdb_hdr(file).dab[2] == 31
	else
		@warn("non-UM testing is vacuous")
	end
	true
end
