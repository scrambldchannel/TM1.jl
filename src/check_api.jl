using HTTP

function check_api(host, port)
    response = HTTP.get("http://" * host * ":" * port * "/api/v1/")
    return response
end

# example of function overloading
function check_api(host, port)
    response = HTTP.get("http://" * host * ":" * string(port) * "/api/v1/")
    return response
end
