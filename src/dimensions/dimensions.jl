@api_default function dimensions_all(api::TM1API; options...)
    tm1_get_json(api, "Dimensions"; options...)
end


