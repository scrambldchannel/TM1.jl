module TM1

using Dates
using Base64

import HTTP, JSON, MbedTLS, Sockets

# potentially set some high level constants Here

include("utils/requests.jl")
include("utils/TM1Type.jl")
include("utils/auth.jl")

export authenticate

#export # requests.jl - 

# simple utility, not needing authentication

include("ping/ping.jl")

export ping

# basic endpoints

include("dimensions/dimensions.jl")
include("cubes/cubes.jl")
include("processes/processes.jl")

export cubes_all, cubes_all_model, cubes_all_control, cube_by_name, cube_delete

export dimensions_all,
    dimensions_all_model, dimensions_all_control, dimension_by_name, dimension_delete

export processes_all, process_by_name, process_delete

end #Module
