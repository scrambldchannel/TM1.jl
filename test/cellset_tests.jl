@testset "Cellset" begin

    # need expanding
    cellset_result = Cellset("Cellset 1")
    @test cellset_result.Name == "Cellset 1"
    @test name(cellset_result) == "Cellset 1"

    cellset_2 = JSON.parse("""
    {
      "Name": "Cellset 2"
    }
    """)

    @test name(Cellset(cellset_2)) == "Cellset 2"
    @test Dimension(cellset_2) != cellset_result

end
