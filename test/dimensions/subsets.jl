
@testset "Subsets" begin

    # need expanding
    subset_result = Subset("Subset 1")
    @test subset_result.Name == "Subset 1"
    @test name(subset_result) == "Subset 1"

    subset_2 = JSON.parse("""
    {
      "Name": "Subset 2"
    }
    """)

    @test name(Subset(subset_2)) == "Subset 2"
    @test Subset(subset_2) != subset_result

end
