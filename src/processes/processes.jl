@api_default function processes_all(api::TM1API; options...)
    tm1_get_json(api, "Processes"; options...)
end

@api_default function process_by_name(api::TM1API, process_name::AbstractString; options...)
    tm1_get_json(api, "Processes('" * process_name * "')"; options...)
end

@api_default function process_delete(api::TM1API, process_name::AbstractString; options...)
    tm1_delete(api, "Processes('" * process_name * "')"; options...)
end
