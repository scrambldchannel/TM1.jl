
@testset "Hierarchies" begin

  # need expanding
  hierarchy_result = Hierarchy("Hierarchy 1")
  @test hierarchy_result.Name == "Hierarchy 1"
  @test name(hierarchy_result) == "Hierarchy 1"

  hierarchy_2 = JSON.parse("""
  {
    "Name": "Hierarchy 2"
  }
  """)

  @test name(Hierarchy(hierarchy_2)) == "Hierarchy 2"
  @test Hierarchy(hierarchy_2) != hierarchy_result

end
