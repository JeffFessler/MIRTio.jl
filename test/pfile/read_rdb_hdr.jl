# read_rdb_hdr.jl

using Test: @test, @testset, @test_throws
using MIRTio: header_write
using MIRTio: rdb_hdr_26_002_def, read_rdb_hdr
using MIRTio: header_init, header_size, header_string, header_write


# random data self test

hd = rdb_hdr_26_002_def()
ht = header_init(hd) # random header values
@test ht isa NamedTuple

tname = tempname()

open(tname, "w") do fid
	header_write(fid, ht ; bytes = header_size(hd))
end

# intentionally fail due to random :rdbm_rev
@test_throws String read_rdb_hdr(tname)

# now set :rdbm_rev so that read test passes
ht = merge(ht, [:rdbm_rev => Float32(26.002)]) # instead of setindex

open(tname, "w") do fid
	header_write(fid, ht ; bytes = header_size(hd))
end

hr = read_rdb_hdr(tname)
@test hr isa NamedTuple
@test hr[:rdbm_rev] isa Float32
@test hr == header_string(ht)


# self test using a local pfile at UM
# UM-only test below here

file = "/n/ir71/d3/fessler/fmri-data-michelle-L+S/P97792.7"
isfile(file) && (@test read_rdb_hdr(file).dab[2] == 31)
