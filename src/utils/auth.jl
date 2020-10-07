#######################
# Authorization Types #
#######################

abstract type Authorization end

# TODO: SecureString on 0.7
struct OAuth2 <: Authorization
    token::String
end

struct UsernamePassAuth <: Authorization
    username::String
    password::String
end

struct AnonymousAuth <: Authorization end

###############
# API Methods #
###############

@api_default function authenticate(api::TM1API, token::AbstractString; options...)
    auth = OAuth2(token)
    tm1_get(api, "/"; auth = auth, options...)
    return auth
end

@api_default function authenticate(api::TM1API, username::AbstractString, password::AbstractString; options...)
    auth = UsernamePassAuth(username, password)
    tm1_get(api, "/"; auth = auth, options...)
    return auth
end



#########################
# Header Authentication #
#########################

function authenticate_headers!(headers, auth::AnonymousAuth)
    headers
end

function authenticate_headers!(headers, auth::OAuth2)
    headers["Authorization"] = "token $(auth.token)"
    return headers
end

# I'm trying to get a PoC working with this but not sure how
function authenticate_headers!(headers, auth::UsernamePassAuth)
    headers["Authorization"] = "Basic $(base64encode(string(auth.username, ':', auth.password)))"
    return headers
end

###################
# Pretty Printing #
###################

function Base.show(io::IO, a::OAuth2)
    token_str = a.token[1:6] * repeat("*", length(a.token) - 6)
    print(io, "TM1.OAuth2($token_str)")
end
