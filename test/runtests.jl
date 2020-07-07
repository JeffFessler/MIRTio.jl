# test/runtests.jl

using MIRTio
using Test: @test, @testset, detect_ambiguities

@testset "pfile/header" begin
    include("pfile/header.jl")
end

@testset "read_rdb_hdr" begin
    include("pfile/read_rdb_hdr.jl")
end

@testset "hdf5utils" begin
    include("fastmri/hdf5utils.jl")
end

@testset "pfile/pfile" begin
    include("pfile/pfile.jl")
end

@test length(detect_ambiguities(MIRTio)) == 0
