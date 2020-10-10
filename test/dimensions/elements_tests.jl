@testset "Elements" begin

    element_result = Element("El 1")
    @test element_result.Name == "El 1"
    @test name(element_result) == "El 1"

    el_2 = JSON.parse("""
    {
      "Name": "El 2",
      "UniqueName": "[El 2]",
      "Attributes": {
        "Caption": "El 2"
      }
    }
""")

    @test name(Element(el_2)) == "El 2"
    @test Element(el_2) != element_result

end
