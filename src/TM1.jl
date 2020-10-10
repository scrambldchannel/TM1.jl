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

export Cube,
    get_all_cubes, get_all_control_cubes, get_all_model_cubes, delete_cube, create_cube

export Dimension,
    get_all_dimensions, get_all_model_dimensions, get_all_control_dimensions, get_dimension

export Process, get_all_processes, delete_process

end #Module
