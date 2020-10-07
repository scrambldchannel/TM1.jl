# so need to write a function that uses the helper functions to send a get request to tm1 base url

@api_default function ping(api::TM1API; options...)
    tm1_get_json(api)
end
