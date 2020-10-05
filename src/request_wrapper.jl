using HTTP

function get_request(url, headers)::String
    try
        response = HTTP.get(url)
        return String(response.body)
    catch e
        return "Something is borked: $e"
    end
    
end

function post_request(url, data, headers)
    response = HTTP.get("http://192.168.56.101:8015/api/v1/")
    return response
end