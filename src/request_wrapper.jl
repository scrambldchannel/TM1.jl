using HTTP

function check_api_new()
    response = HTTP.get("http://192.168.56.101:8015/api/v1/")
    return response
end
