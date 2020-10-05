module JuliaTM1

using HTTP

export connect

function connect()
    response = make_API_call("http://192.168.56.101:8015/api/v1/")
    return JSON.print(JSON.parse(response), 4)
end
    
end
