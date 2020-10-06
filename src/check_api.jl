using JSON

include("request_wrapper.jl")

# handles ssl and port type logic
function check_api(ssl, host, port, api_version)

    endpoint = ""
    headers = ""

    response = get_request(ssl, host, port, api_version, endpoint, headers)
    return response

end

function check_api_dict(ssl, host, port, api_version)

    endpoint = ""
    headers = ""

    response = check_api(ssl, host, port, api_version)
    return JSON.parse(String(response.body))

end

