# hdf5utils.jl

using MIRTio: h5_get_keys, h5_get_attributes, h5_get_ismrmrd
using MIRTio: h5_get_ESC, h5_get_RSS, h5_get_kspace
using HDF5: h5open, h5read, attributes
using Test: @test

filename = tempname()

hdr = "ismrm header test"
T = Float32
dims = (3,4,5)
esc = rand(T, dims)
rss = rand(T, dims)
ksp = complex.(rand(T, dims), rand(T, dims))
h5open(filename, "w") do file
    write(file, "ismrmrd_header", hdr)
    write(file, "reconstruction_esc", esc)
    write(file, "reconstruction_rss", rss)
    write(file, "kspace", ksp)
    attributes(file)["kspace"] = "spiral"
end

@test hdr == h5read(filename, "ismrmrd_header")
@test rss == h5read(filename, "reconstruction_rss")
@test ksp == h5read(filename, "kspace")

pdims = x -> permutedims(x, 3:-1:1)
@test h5_get_keys(filename) isa Array{String}
@test h5_get_keys(filename)[2] == "kspace"
@test h5_get_attributes(filename) isa Dict
@test h5_get_ismrmrd(filename) == hdr
@test h5_get_ESC(filename ; T) == pdims(esc)
@test h5_get_RSS(filename ; T) == pdims(rss)
@test h5_get_kspace(filename ; T=ComplexF32) == pdims(ksp)

#=
h5open(filename, "r") do fid
#   @test h5_getcomplextype(fid["kspace"]) == ComplexF32
    @test eltype(fid["kspace"]) == ComplexF32
end
=#
