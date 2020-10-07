@api_default function processes_all(api::TM1API; options...)
    tm1_get_json(api, "Processes"; options...)
end


