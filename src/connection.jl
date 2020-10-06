struct TM1Connection
    ssl::Bool #  whether using ssl
    host::Str # address of TM1 instance
    port::Int # port number
    user::Str # name of the user
    password::Str 
end

function get_connection(ssl, host, port, user, password)
    # create dummy connection
    tm1 = TM1Connection(ssl, host, port, user, password)
    return 0
end
