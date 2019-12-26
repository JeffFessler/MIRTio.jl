# test/runtests.jl

using MIRTio
using Test: @test, detect_ambiguities

@test header_test(:test)
@test read_rdb_hdr(:test)
@test h5_get_test(:test)
@test loadpfile(:test)

@test length(detect_ambiguities(MIRTio)) == 0
