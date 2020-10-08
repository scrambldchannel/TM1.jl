module TM1

using Dates
using Base64

import HTTP,
       JSON,
       MbedTLS,
       Sockets

# potentially set some high level constants Here

include("utils/requests.jl")
include("utils/TM1Type.jl")
include("utils/auth.jl")

export # auth.jl
       authenticate

#export # requests.jl - 

# simple utility, not needing authentication

include("ping/ping.jl")

export # ping.jl
       ping

# basic endpoints

include("dimensions/dimensions.jl")
include("cubes/cubes.jl")
include("processes/processes.jl")

export # cubes.jl
       cubes_all,
       cube_by_name

export # dimensions.jl
       dimensions_all,
       dimension_by_name

export # processes.jl
       processes_all,
       process_by_name
       
end #Module