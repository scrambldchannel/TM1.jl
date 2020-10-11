@testset "Dimensions" begin

  dimension_result = Dimension("Dim 1")
  @test dimension_result.Name == "Dim 1"
  @test name(dimension_result) == "Dim 1"

  dim_2 = JSON.parse("""
    {
      "Name": "Dim 2",
      "UniqueName": "[Dim 2]",
      "Attributes": {
        "Caption": "Dim 2"
      }
    }
""")

  @test name(Dimension(dim_2)) == "Dim 2"
  @test Dimension(dim_2) != dimension_result

end
