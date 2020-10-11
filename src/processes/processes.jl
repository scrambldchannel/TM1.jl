@tm1def mutable struct Process
  Name::Union{String,Nothing}
  HasSecurityAccess::Union{Bool,Nothing}
  Attributes::Union{Dict,Nothing}
  Hierarchies::Union{Vector,Nothing}
  PrologProcedure::Union{String,Nothing}
  MetadataProcedure::Union{String,Nothing}
  DataProcedure::Union{String,Nothing}
  EpilogProcedure::Union{String,Nothing}
  # type declaration to possibly be replaced
  DataSource::Union{Dict,Nothing}
end

Process(name::AbstractString) = Process(Dict("Name" => name))

namefield(process::Process) = process.Name

@api_default function get_all_processes(api::TM1API; options...)
  result, page_data = tm1_get_paged_json(api, "Processes"; params = params, options...)
  map(Process, get(result, "value", [])), page_data
end

@api_default function get_process(api::TM1API, process_name::AbstractString; options...)
  result = tm1_get_json(api, "Processes('" * process_name * "')"; options...)
end

@api_default function delete_process(api::TM1API, process_name::AbstractString; options...)
  tm1_delete(api, "Processes('" * process_name * "')"; options...)
end
