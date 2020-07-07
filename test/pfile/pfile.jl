# pfile.jl

using Test: @test
using MIRTio: header_write
using MIRTio: loadpfile, rdb_hdr_26_002_def
using MIRTio: header_init, header_size, header_string

hd = rdb_hdr_26_002_def()
ht = header_init(hd) # random header values
hs = header_size(hd)

necho = 2
nslice = 7
nview = 64
ndat = 100
ncoil = 5
ht = merge(ht, [:rdbm_rev => Float32(26.002)]) # instead of setindex
ht = merge(ht, [:frame_size => UInt16(ndat)])
ht = merge(ht, [:nslices => UInt16(nslice)])
ht = merge(ht, [:point_size => Int16(2)])
ht = merge(ht, [:nechoes => Int16(necho)])
ht = merge(ht, [:nframes => Int16(nview)])
dab = zeros(Int16,8)
dab[2] = Int16(ncoil-1)
#@show dab
ht = merge(ht, [:dab => dab])
ht = merge(ht, [:off_data => Int32(hs)])

tname = tempname()
open(tname, "w") do fid
	header_write(fid, ht)
end

# Apparent file data order is: [ndat, nview, necho, nslice, ncoil]
fdat = rand(Complex{Int16}, ndat, nview+1, necho, nslice, ncoil) # rand test data
open(tname, "a") do fid
	write(fid, fdat)
end

(odat, hr) = loadpfile(tname ; quiet=true) # load and verify
@test hr == header_string(ht)
pdat = permutedims(odat, [1, 5, 4, 3, 2])
#=
@show size(fdat)
@show size(odat)
@show size(pdat)
@test pdat == fdat[:, 2:end, :, 2:end, :] # skip 1st view and slice
=#

iecho = 2
(dat1, _) = loadpfile(tname, iecho ; quiet=true)
pdat = permutedims(dat1, [1, 5, 4, 3, 2])
gdat = fdat[:, 2:end, [iecho], 2:end, :] # skip 1st view and slice
#=
@show size(fdat)
@show size(dat1)
@show size(pdat)
@show size(gdat)
=#
@test pdat == gdat

nview = 2 # test special case
ht = merge(ht, [:nframes => Int16(nview)])
fdat = zeros(Complex{Int16}, ndat, nview+1, necho, nslice, ncoil)
open(tname, "w") do fid
	header_write(fid, ht)
	write(fid, fdat)
end
loadpfile(tname ; quiet=true)
rm(tname)
