using HTTP

function check_api(url)
    response = HTTP.get(url)
    return response
end

# Example of overloading

# assumes v1
function check_api(ssl, host, port)
    response = check_api(ssl, host, port, 1)
    return response
end

# handles ssl and port type logic
function check_api(ssl, host, port, api_version)
    if ssl
        protocol = "https://"
    else
        protocol = "http://"
    end

    if port isa Int
        port = string(port)
    end

    response = check_api(protocol * host * ":" * port * "/api/v" * string(api_version) * "/")    
    return response
end
