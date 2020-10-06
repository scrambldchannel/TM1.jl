# so need to write a function that uses the helper functions to send a get request to tm1 base url
# what is the @api_default doing? 
# we don't need a tm1ping objcect, just a simple get request
# need to look at how github.jl is invoked

@api_default function ping(api::TM1API; options...)
    print("frogger")
    tm1_get_json(api)
end
