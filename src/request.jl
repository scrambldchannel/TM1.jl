using HTTP
using JSON

function test_connect()
    response = HTTP.get("http://192.168.56.101:8015/api/v1/")
    return JSON.print(JSON.parse(response), 4)
end

