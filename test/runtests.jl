using TM1, JSON, HTTP, MbedTLS
using Dates, Test, Base64
using TM1: name

include("utils/auth_tests.jl")

include("dimensions/dimensions_tests.jl")
include("dimensions/hierarchies_tests.jl")
include("dimensions/elements_tests.jl")

include("cubes/cubes_tests.jl")
include("processes/processes_tests.jl")
include("cellsets/cellsets_tests.jl")
