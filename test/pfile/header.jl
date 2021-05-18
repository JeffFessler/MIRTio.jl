# header.jl

using Test: @test, @inferred

using MIRTio: header_read, header_write
using MIRTio: header_example, header_init, header_size, header_string

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
