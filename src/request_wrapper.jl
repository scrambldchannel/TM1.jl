using HTTP

function get_request(url, data, headers)
    response = HTTP.get("http://192.168.56.101:8015/api/v1/")
    return response
end

# overloading is a thing
function get_request(url, headers)
    response = HTTP.get("http://192.168.56.101:8015/api/v1/")
    return response
end


function post_request(url, data, headers)
    response = HTTP.get("http://192.168.56.101:8015/api/v1/")
    return response
end