# struct to model a cube

@tm1def mutable struct Cube
    Name::Union{String,Nothing}
    Rules::Union{String,Nothing}
    LastSchemaUpdate::Union{Dates.DateTime,Nothing}
    LastDataUpdate::Union{Dates.DateTime,Nothing}
    Attributes::Union{Dict,Nothing}
    Dimensions::Union{Vector,Nothing}
    Views::Union{Vector,Nothing}
    ViewAttributes::Union{Vector,Nothing}
    PrivateViews::Union{Vector,Nothing}
    Annotations::Union{Vector,Nothing}
    LocalizedAttributes::Union{Vector,Nothing}
end

Cube(name::AbstractString) = Cube(Dict("Name" => name))

namefield(cube::Cube) = cube.Name

# functions for endpoints

@api_default function cubes_all(api::TM1API; options...)
    result, page_data = tm1_get_paged_json(api, "Cubes"; options...)
    # not sure why this doesn't work...
    # map(Cube, get(result, "value", [])), page_data
end

@api_default function cubes_all_model(api::TM1API; options...)
    result, page_data = tm1_get_paged_json(api, "ModelCubes()"; options...)
end

@api_default function cubes_all_control(api::TM1API; options...)
    result, page_data = tm1_get_paged_json(api, "ControlCubes()"; options...)
end

@api_default function cube_by_name(api::TM1API, cube_name::AbstractString; options...)
    tm1_get_json(api, "Cubes('" * cube_name * " ')"; options...)
end

@api_default function cube_delete(api::TM1API, cube_name::AbstractString; options...)
    tm1_delete(api, "Cubes('" * cube_name * "')"; options...)
end

@api_default function cube_create(api::TM1API, cube_name::AbstractString; options...)
    tm1_put(api, "Cubes('" * cube_name * "')"; options...)
end
