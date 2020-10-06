using HTTP


function get_request(url, headers)
    try
        response = HTTP.get(url)
        return response
    catch e
        return "Something is borked, sorry: $e"
    end
    
end

function get_request(ssl, host, port, api_version, endpoint, headers)
    
    if ssl
        protocol = "https://"
    else
        protocol = "http://"
    end
    
    if port isa Int
        port = string(port)
    end

    url = protocol * host * ":" * port * "/api/v" * string(api_version) * "/" * endpoint 

    return get_request(url, headers)
    
end
