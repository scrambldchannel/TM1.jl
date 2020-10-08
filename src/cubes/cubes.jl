@api_default function cubes_all(api::TM1API; options...)
    tm1_get_json(api, "Cubes"; options...)
end

@api_default function cube_by_name(api::TM1API, cube_name::AbstractString; options...)
    tm1_get_json(api, "Cubes('" * cube_name * " ')"; options...)
end

@api_default function cube_delete(api::TM1API, cube_name::AbstractString; options...)
    tm1_delete(api, "Cubes('" * cube_name * "')"; options...)
end
