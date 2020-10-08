using TM1
using Test

@testset "TM1.jl" begin

    # Simple example test
    simple_auth = TM1.UsernamePassAuth("admin", "apple")
    @test simple_auth.username == "admin"
    @test simple_auth.password == "apple"

end
