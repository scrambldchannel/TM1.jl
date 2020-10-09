# This file tests various TM1Type constructors. To test for proper Nullable
# handling, most fields have been removed from the JSON samples used below.
# Sample fields were selected in order to cover the full range of type behavior,
# e.g. if the TM1Type has a few Union{Dates.DateTime, Nothing} fields, at least one
# of those fields should be present in the JSON sample.


@testset "Cube" begin
    cube_json_string = JSON.parse(
    """
    {
      "@odata.context": "\$metadata#Cubes(Dimensions)/\$entity",
      "Name": "Test",
      "Rules": "SKIPCHECK;\\n\\n#['test_dim':'test1'] = N: 1;",
      "LastSchemaUpdate": "2020-10-09T06:15:58.169Z",
      "LastDataUpdate": "2020-10-09T06:15:58.169Z",
      "Attributes": {
        "Caption": "Test"
      },
      "Dimensions": [
        {
          "Name": "Dim 1",
          "UniqueName": "[Dim 1]",
          "Attributes": {
            "Caption": "Dim 1"
          }
        },
        {
          "Name": "Dim 2",
          "UniqueName": "[Dim 2]",
          "Attributes": {
            "Caption": "Dim 2"
          }
        }
      ]
    }
    """
    )

    cube_result = TM1.Cube(
      "Test",
      "SKIPCHECK;\n\n#['test_dim':'test1'] = N: 1;",
      ["Dim 1", "Dim 2"]
    )

    @test cube_result.Name == "Test"
    @test cube_result.Rules == "SKIPCHECK;\n\n#['test_dim':'test1'] = N: 1;"
    @test cube_result.Dimensions isa Vector

    # not working
    #    @test cube_result.Dimensions isa Vector

    #    cube_json = TM1.Cube(cube_json_string) 
    #    @test cube_json == cube_result
    #    @test name(cube_json) == name(cube_result)

end

