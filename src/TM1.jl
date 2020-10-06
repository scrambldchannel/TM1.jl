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

export # requests.jl
       rate_limit

# start including my code

include("ping/ping.jl")

export # ping.jl
       ping

end #Module