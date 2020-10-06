# handles ssl and port type logic
function ping(ssl, host, port, api_version)

    endpoint = ""
    headers = ""
    body = ""
    
    response = get_request(ssl, host, port, api_version, endpoint, headers, body)
    return response

end
