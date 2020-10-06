module TM1

#########
# Using #
#########

using Dates
using Base64

import HTTP,
       JSON,
       MbedTLS,
       Sockets
       
########
# init #
########

# potentially set some high level constants Here

#############
# Utilities #
#############

include("utils/requests.jl")
include("utils/TM1Type.jl")
include("utils/auth.jl")

# export -------

export # auth.jl
       authenticate

export # requests.jl
       rate_limit

########
# Ping #
########

include("ping/ping.jl")

export # ping.jl
       ping

end #Module