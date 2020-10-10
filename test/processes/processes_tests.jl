@testset "Processes" begin

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
    @test Process(proc_2) != process_result

end
