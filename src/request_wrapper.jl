using HTTP

function get_request(ssl, host, port, headers, api_version)::String
    try
        url = "http://" * host * ":" * port * 
        response = HTTP.get(url)
        return String(response.body)
    catch e
        return "Something is borked: $e"
    end
    
end

# example of function overloading
function get_request(url, headers)::String
    try
        response = HTTP.get(url)
        return String(response.body)
    catch e
        return "Something is borked: $e"
    end
    
end
 