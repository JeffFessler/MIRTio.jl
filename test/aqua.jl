using MIRTio: MIRTio
import Aqua
using Test: @testset

@testset "aqua" begin
    Aqua.test_all(MIRTio)
end
