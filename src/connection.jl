function get_connection(ssl, host, port, user, password)
    # create dummy connection
    tm1 = TM1Connection(ssl, host, port, user, password)
    return tm1
end

struct TM1Connection
    ssl::Bool #  whether using ssl
    host::String # address of TM1 instance
    port::Int # port number
    user::String # name of the user
    password::String # password of user, obviously this needs to be secured somehow
end
