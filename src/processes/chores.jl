@tm1def mutable struct Chore
  Name::Union{String,Nothing}
end

Chore(name::AbstractString) = Chore(Dict("Name" => name))

namefield(chore::Chore) = chore.Name

@api_default function get_all_chorees(api::TM1API; options...)
  result, page_data = tm1_get_paged_json(api, "Chores"; options...)
  map(Chore, get(result, "value", [])), page_data
end

@api_default function get_chore(api::TM1API, chore_name::AbstractString; options...)
  result = tm1_get_json(api, "Chores('" * chore_name * "')"; options...)
end

@api_default function delete_chore(api::TM1API, chore_name::AbstractString; options...)
  tm1_delete(api, "Chores('" * chore_name * "')"; options...)
end
