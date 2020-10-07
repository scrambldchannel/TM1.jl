##############
# TM1 API #
##############

"""
Represents the API to interact with, either an actual TM1 instance,
or a mock API for testing purposes
"""
abstract type TM1API end

struct TM1WebAPI <: TM1API
    endpoint::HTTP.URI
end

const DEFAULT_API = TM1WebAPI(HTTP.URI("http://192.168.56.101:8015/api/v1/"))

using Base.Meta

"""
    @api_default function f(api, args...)
    ...
    end

For a method taking an `api` argument, add a new method without the `api` argument
that just calls the method with DEFAULT_API.
"""
macro api_default(func)
    call = func.args[1]
    has_kwargs = isexpr(call.args[2], :parameters)
    newcall = Expr(:call, call.args[1], (has_kwargs ?
        [Expr(:parameters, Expr(:..., :kwargs)); call.args[4:end]] : call.args[3:end])...)
    argnames = map(has_kwargs ? call.args[4:end] : call.args[3:end]) do expr
        isexpr(expr, :kw) && (expr = expr.args[1])
        isexpr(expr, Symbol("::")) && return expr.args[1]
        @assert isa(expr, Symbol)
        return expr
    end
    esc(Expr(:toplevel, :(Base.@__doc__ $func),
        Expr(:function, newcall, Expr(:block,
            :($(call.args[1])(DEFAULT_API, $(argnames...);kwargs...))
        ))))
end

####################
# Default API URIs #
####################

function api_uri(api::TM1WebAPI, path)
    merge(api.endpoint, path = api.endpoint.path * path)
end

function api_uri(api::TM1API, path)
    error("URI retrieval not implemented for this API type")
end

function tm1_request(api::TM1API, request_method, endpoint;
                        auth = AnonymousAuth(), handle_error = true,
                        headers = Dict(), params = Dict(), allowredirects = true)
    authenticate_headers!(headers, auth)
    params = tm12json(params)
    api_endpoint = api_uri(api, endpoint)
    _headers = convert(Dict{String, String}, headers)
    !haskey(_headers, "User-Agent") && (_headers["User-Agent"] = "TM1-jl")
    if request_method == HTTP.get
        r = request_method(merge(api_endpoint, query = params), _headers, redirect = allowredirects, status_exception = false, idle_timeout=20)
    else
        r = request_method(string(api_endpoint), _headers, JSON.json(params), redirect = allowredirects, status_exception = false, idle_timeout=20)
    end
    handle_error && handle_response_error(r)
    return r
end

tm1_get(api::TM1API, endpoint = ""; options...) = tm1_request(api, HTTP.get, endpoint; options...)
tm1_post(api::TM1API, endpoint = ""; options...) = tm1_request(api, HTTP.post, endpoint; options...)
tm1_put(api::TM1API, endpoint = ""; options...) = tm1_request(api, HTTP.put, endpoint; options...)
tm1_delete(api::TM1API, endpoint = ""; options...) = tm1_request(api, HTTP.delete, endpoint; options...)
tm1_patch(api::TM1API, endpoint = ""; options...) = tm1_request(api, HTTP.patch, endpoint; options...)

tm1_get_json(api::TM1API, endpoint = ""; options...) = JSON.parse(HTTP.payload(tm1_get(api, endpoint; options...), String))
tm1_post_json(api::TM1API, endpoint = ""; options...) = JSON.parse(HTTP.payload(tm1_post(api, endpoint; options...), String))
tm1_put_json(api::TM1API, endpoint = ""; options...) = JSON.parse(HTTP.payload(tm1_put(api, endpoint; options...), String))
tm1_delete_json(api::TM1API, endpoint = ""; options...) = JSON.parse(HTTP.payload(tm1_delete(api, endpoint; options...), String))
tm1_patch_json(api::TM1API, endpoint = ""; options...) = JSON.parse(HTTP.payload(tm1_patch(api, endpoint; options...), String))

#################
# Rate Limiting #
#################

@api_default rate_limit(api::TM1API; options...) = tm1_get_json(api, "/rate_limit"; options...)

##############
# Pagination #
##############

has_page_links(r) = HTTP.hasheader(r, "Link")
get_page_links(r) = split(HTTP.header(r, "Link",), ",")

function find_page_link(links, rel)
    relstr = "rel=\"$(rel)\""
    for i in 1:length(links)
        if occursin(relstr, links[i])
            return i
        end
    end
    return 0
end

extract_page_url(link) = match(r"<.*?>", link).match[2:end-1]

function tm1_paged_get(api, endpoint; page_limit = Inf, start_page = "", handle_error = true,
                          auth = AnonymousAuth(), headers = Dict(), params = Dict(), options...)
    authenticate_headers!(headers, auth)
    _headers = convert(Dict{String, String}, headers)
    !haskey(_headers, "User-Agent") && (_headers["User-Agent"] = "TM1-jl")
    if isempty(start_page)
        r = tm1_get(api, endpoint; handle_error = handle_error, headers = _headers, params = params, auth=auth, options...)
    else
        @assert isempty(params) "`start_page` kwarg is incompatible with `params` kwarg"
        r = HTTP.get(start_page, headers = _headers)
    end
    results = HTTP.Response[r]
    page_data = Dict{String, String}()
    if has_page_links(r)
        page_count = 1
        while page_count < page_limit
            links = get_page_links(r)
            next_index = find_page_link(links, "next")
            next_index == 0 && break
            r = HTTP.get(extract_page_url(links[next_index]), headers = _headers)
            handle_error && handle_response_error(r)
            push!(results, r)
            page_count += 1
        end
        links = get_page_links(r)
        for page in ("next", "last", "first", "prev")
            page_index = find_page_link(links, page)
            if page_index != 0
                page_data[page] = extract_page_url(links[page_index])
            end
        end
    end
    return results, page_data
end

# for APIs which return just a list
function tm1_get_paged_json(api, endpoint = ""; options...)
    results, page_data = tm1_paged_get(api, endpoint; options...)
    return mapreduce(r -> JSON.parse(HTTP.payload(r, String)), vcat, results), page_data
end

# for APIs which return a Dict(key => list, "total_count" => count)
function tm1_get_paged_json(api, endpoint, key; options...)
    results, page_data = tm1_paged_get(api, endpoint; options...)
    local total_count
    list = mapreduce(vcat, results) do r
        dict = JSON.parse(HTTP.payload(r, String))
        total_count = dict["total_count"]
        dict[key]
    end
    list, page_data, total_count
end

##################
# Error Handling #
##################

function handle_response_error(r::HTTP.Response)
    if r.status >= 400
        message, docs_url, errors = "", "", ""
        body = HTTP.payload(r, String)
        try
            data = JSON.parse(body)
            message = get(data, "message", "")
            docs_url = get(data, "documentation_url", "")
            errors = get(data, "errors", "")
        catch
        end
        error("Error found in TM1 reponse:\n",
              "\tStatus Code: $(r.status)\n",
              ((isempty(message) && isempty(errors)) ?
               ("\tBody: $body",) :
               ("\tMessage: $message\n",
                "\tDocs URL: $docs_url\n",
                "\tErrors: $errors"))...)
    end
end
