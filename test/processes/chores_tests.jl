@testset "Chores" begin

  # need expanding
  chore_result = Process("chore 1")
  @test chore_result.Name == "chore 1"
  @test name(chore_result) == "chore 1"

  chore_2 = JSON.parse("""
  {
    "Name": "chore 2"
  }
  """)

  @test name(Chore(chore_2)) == "chore 2"
  @test Chore(chore_2) != chore_result

end
