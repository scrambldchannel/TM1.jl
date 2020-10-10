@api_default function get_all_processes(api::TM1API; options...)
    tm1_get_json(api, "Processes"; options...)
end

@api_default function get_process(api::TM1API, process_name::AbstractString; options...)
    tm1_get_json(api, "Processes('" * process_name * "')"; options...)
end

@api_default function delete_process(api::TM1API, process_name::AbstractString; options...)
    tm1_delete(api, "Processes('" * process_name * "')"; options...)
end
