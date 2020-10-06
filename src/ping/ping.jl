@ghdef mutable struct TM1Ping
    url::Union{HTTP.URI, Nothing}
    odata_version::Union{String, Nothing}
end

#TM1Ping(id::AbstractString) = TM1Ping(Dict("id" => id))

namefield(gist::TM1Ping) = gist.id

###############
# API Methods #
###############

# creating #
#----------#

@api_default gist(api::TM1API, tm1pingobj::TM1Ping; options...) = gist(api::TM1API, name(tm1pingobj); options...)

@api_default function gist(api::TM1API, tm1pingobj, sha = ""; options...)
    !isempty(sha) && (sha = "/" * sha)
    result = gh_get_json(api, "/gists/$(name(tm1pingobj))$sha"; options...)
    g = TM1Ping(result)
end

@api_default function gists(api::TM1API, owner; options...)
    results, page_data = gh_get_paged_json(api, "/users/$(name(owner))/gists"; options...)
    map(TM1Ping, results), page_data
end

@api_default function gists(api::TM1API; options...)
    results, page_data = gh_get_paged_json(api, "/gists/public"; options...)
    return map(TM1Ping, results), page_data
end

# modifying #
#-----------#

@api_default create_gist(api::TM1API; options...) = TM1Ping(gh_post_json(api, "/gists"; options...))
@api_default edit_gist(api::TM1API, gist; options...) = TM1Ping(gh_patch_json(api, "/gists/$(name(gist))"; options...))
@api_default delete_gist(api::TM1API, gist; options...) = gh_delete(api, "/gists/$(name(gist))"; options...)

# stars #
#------#

@api_default star_gist(api::TM1API, gist; options...) = gh_put(api, "/gists/$(name(gist))/star"; options...)
@api_default unstar_gist(api::TM1API, gist; options...) = gh_delete(api, "/gists/$(name(gist))/star"; options...)

@api_default function starred_gists(api::TM1API; options...)
    results, page_data = gh_get_paged_json(api, "/gists/starred"; options...)
    return map(TM1Ping, results), page_data
end

# forks #
#-------#

@api_default create_tm1pingfork(api::TM1API, gist::TM1Ping; options...) = TM1Ping(gh_post_json(api, "/gists/$(name(gist))/forks"; options...))

@api_default function tm1pingforks(api::TM1API, gist; options...)
    results, page_data = gh_get_paged_json(api, "/gists/$(name(gist))/forks"; options...)
    return map(TM1Ping, results), page_data
end
