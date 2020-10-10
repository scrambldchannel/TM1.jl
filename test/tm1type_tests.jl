# This file tests various TM1Type constructors. To test for proper Nullable
# handling, most fields have been removed from the JSON samples used below.
# Sample fields were selected in order to cover the full range of type behavior,
# e.g. if the TM1Type has a few Union{Dates.DateTime, Nothing} fields, at least one
# of those fields should be present in the JSON sample.


@testset "Cube" begin
    cube_json_string = JSON.parse("""
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
                                  """)

    dim_1 = JSON.parse("""
                      {
                        "Name": "Dim 1",
                        "UniqueName": "[Dim 1]",
                        "Attributes": {
                          "Caption": "Dim 1"
                        }
                      }
    """)

    dim_2 = JSON.parse("""
                      {
                        "Name": "Dim 2",
                        "UniqueName": "[Dim 2]",
                        "Attributes": {
                          "Caption": "Dim 2"
                        }
                      }
    """)

    attributes = Dict("Caption" => "Test")

    cube_result = Cube(
        "Test",
        "SKIPCHECK;\n\n#['test_dim':'test1'] = N: 1;",
        Dates.DateTime("2020-10-09T06:15:58.169"),
        Dates.DateTime("2020-10-09T06:15:58.169"),
        attributes,
        [Dimension(dim_1), Dimension(dim_2)],
        nothing,
        nothing,
        nothing,
        nothing,
        nothing,
    )

    @test cube_result.Name == "Test"
    @test cube_result.Rules == "SKIPCHECK;\n\n#['test_dim':'test1'] = N: 1;"
    @test cube_result.Dimensions isa Vector
    @test name(cube_result) == "Test"

    cube_single_arg_constructor = Cube("Another Test")
    @test name(cube_single_arg_constructor) == "Another Test"

    cube_json = Cube(cube_json_string)

    @test name(cube_json) == name(cube_result)
    @test cube_json == cube_result

    cube_as_dict = Cube(Dict(
        "LastDataUpdate" => "2020-10-09T17:30:34.063Z",
        "Rules" => nothing,
        "Attributes" => Dict{String,Any}("Caption" => "}Capabilities"),
        "LastSchemaUpdate" => "2020-10-09T17:30:34.063Z",
        "DrillthroughRules" => nothing,
        "Name" => "}Capabilities",
        "@odata.etag" => "W/\"98079d38abe094b7ecaaf37b3519525df0abb891\"",
    ))

    @test name(cube_as_dict) == "}Capabilities"


end

@testset "Dimension" begin

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


@testset "Process" begin

    # need expanding
    process_result = Process("Proc 1")
    @test process_result.Name == "Proc 1"
    @test name(process_result) == "Proc 1"

    proc_2 = JSON.parse("""
    {
      "Name": "Proc 2"
    }
    """)

    @test name(Process(proc_2)) == "Proc 2"
    @test Dimension(proc_2) != process_result

end


@testset "Hierarchy" begin

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
