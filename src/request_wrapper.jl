using HTTP

function get_request(url, headers)::String
    try
        response = HTTP.get(url)
        return String(response.body)
    catch e
        return "Something is borked: $e"
    end
    
end