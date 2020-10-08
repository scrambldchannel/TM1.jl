# struct to model a cube

@tm1def mutable struct Cube
    # have used capital letters here to mirror what the server uses
    # not sure if that makes sense though
    Name::Union{String, Nothing}
    Rules::Union{String, Nothing}
    Dimensions::Union{Vector{Dimension}, Nothing}
    # do I want to include all this? 
    Views::Union{String, Nothing} 
    ViewAttributes::Union{String, Nothing}
    PrivateViews::Union{String, Nothing}
    Annotations::Union{String, Nothing}
    LocalizedAttributes::Union{String, Nothing}
end

# this doesn't seem to work, not sure why, similar thing works for dimension
Cube(name::AbstractString) = Cube(Dict("Name" => name))

namefield(cube::Cube) = cube.Name

# functions for endpoints

@api_default function cubes_all(api::TM1API; options...)
    # maybe we should return an array of cube objects?
    tm1_get_json(api, "Cubes"; options...)
end

@api_default function cubes_all_model(api::TM1API; options...)
    tm1_get_json(api, "ModelCubes()"; options...)
end

@api_default function cubes_all_control(api::TM1API; options...)
    tm1_get_json(api, "ControlCubes()"; options...)
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
