using HTTP

function check_api(host, port)
    response = HTTP.get("http://" * host * ":" * port * "/api/v1/")
    return response
end
