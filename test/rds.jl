# test/rds.jl
# test load data file from GE's Raw Data Server, using random data

using Test: @test, @testset, @test_throws
using MIRTio: loadrds

T = Int16
ncoil = 3
frsize = 10
frames = 1:5
data = rand(Complex{T}, frsize, ncoil, length(frames))

tname = tempname()

open(tname, "w") do fid
    write(fid, data)
end

open(tname, "r") do fid
    tmp = loadrds(fid, frames, frsize, ncoil)
    @test tmp == data
end
