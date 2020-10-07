@api_default function cubes_all(api::TM1API; options...)
    tm1_get_json(api, "Cubes"; options...)
end


