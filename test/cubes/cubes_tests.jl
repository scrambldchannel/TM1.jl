@testset "Cubes" begin
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
