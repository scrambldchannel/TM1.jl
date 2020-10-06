using HTTP

include("request_wrapper.jl")

# handles ssl and port type logic
function check_api(ssl, host, port, api_version)

    endpoint = ""
    headers = ""
    
    response = get_request(ssl, host, port, api_version, endpoint, headers)
    return response

end
