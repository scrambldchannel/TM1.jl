module TM1

#########
# Using #
#########

# Here I am just going to use these two modules until I see a realise to do something more complicated
using HTTP
using JSON

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


include("connection.jl")
include("ping.jl")

export # ping.jl
       ping

export # connection.jl
       get_connection