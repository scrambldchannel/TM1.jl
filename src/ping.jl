using JSON

include("request_wrapper.jl")

# handles ssl and port type logic
function ping(ssl, host, port, api_version)

    endpoint = ""
    headers = ""
    body = ""
    
    response = get_request(ssl, host, port, api_version, endpoint, headers, body)
    return response

end

function ping(connection, api_version)

    endpoint = ""
    headers = ""
    body = ""

    response = get_request(connection.ssl, connection.host, connection.port, api_version, endpoint, headers, body)
    return response

end

function ping(connection)

    endpoint = ""
    headers = ""

    response = ping(connection, 1)
    return response

end