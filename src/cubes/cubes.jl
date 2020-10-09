# struct to model a cube

@tm1def mutable struct Cube
    Name::Union{String,Nothing}
    Rules::Union{String,Nothing}
    LastSchemaUpdate::Union{Dates.DateTime,Nothing}
    LastDataUpdate::Union{Dates.DateTime,Nothing}
    Attributes::Union{Dict,Nothing}
    Dimensions::Union{Vector{Dimension},Nothing}
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
    # can maybe change these to allow specification of custom parameters
    # and only use the ones below if nothing specified
    params = Dict("\$expand" => "Dimensions,Views")
    result, page_data = tm1_get_paged_json(api, "Cubes"; params = params, options...)
    map(Cube, get(result, "value", [])), page_data
end

@api_default function cubes_all_model(api::TM1API; options...)
    params = Dict("\$expand" => "Dimensions,Views")
    result, page_data = tm1_get_paged_json(api, "ModelCubes()"; params = params, options...)
    map(Cube, get(result, "value", [])), page_data
end

@api_default function cubes_all_control(api::TM1API; options...)
    params = Dict("\$expand" => "Dimensions,Views")
    result, page_data =
        tm1_get_paged_json(api, "ControlCubes()"; params = params, options...)
    map(Cube, get(result, "value", [])), page_data
end

@api_default function cube_by_name(api::TM1API, cube_name::AbstractString; options...)
    params = Dict("\$expand" => "Dimensions,Views")
    tm1_get_json(api, "Cubes('" * cube_name * " ')"; params = params, options...)
end

@api_default function cube_delete(api::TM1API, cube_name::AbstractString; options...)
    tm1_delete(api, "Cubes('" * cube_name * "')"; options...)
end

# is this the best way to achieve this? 
@api_default function cube_delete(api::TM1API, cube::Cube; options...)
    cube_delete(api, name(cube); options...)
end
