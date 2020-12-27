#=
read_rdb_hdr.jl
based on
https://gitlab.com/fMRI/toppe/blob/master/+toppe/+utils/read_rdb_hdr.m

Matlab version is:
Copyright (c) 2012 by General Electric Company. All rights reserved.

2019-05-22 Julia version by Jeff Fessler
=#

export read_rdb_hdr

# using MIRTio: header_*, rdb_hdr_26_002_def


"""
    ht = read_rdb_hdr(fid::IOStream)

Read GE raw (RDB) header for MRI scans

Returns NamedTuple `ht` with header values accessible by `ht.key`
"""
function read_rdb_hdr(fid::IOStream)
    seek(fid, 0)
    rdbm_rev = read(fid, Float32) # raw header (RDBM) revision number

    if rdbm_rev == Float32(26.002)
        hd = rdb_hdr_26_002_def()
        ht = header_read(fid, hd)
        ht = header_string(ht) # convert Array{Cuchar} to String
    else
        throw("unknown RDBM rev $rdbm_rev")
    end

    (ht.rdbm_rev != rdbm_rev) && throw("rev mismatch: $(ht.rdbm_rev) != $rdbm_rev")

    return ht
end


"""
    ht = read_rdb_hdr(file::String)
Read from `file`
"""
function read_rdb_hdr(file::String)
    return open(read_rdb_hdr, file)
end
