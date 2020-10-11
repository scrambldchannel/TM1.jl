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

@api_default function get_all_cubes(api::TM1API; options...)
  # can maybe change these to allow specification of custom parameters
  # and only use the ones below if nothing specified
  params = Dict("\$expand" => "Dimensions,Views")
  result, page_data = tm1_get_paged_json(api, "Cubes"; params = params, options...)
  map(Cube, get(result, "value", [])), page_data
end

@api_default function get_all_model_cubes(api::TM1API; options...)
  params = Dict("\$expand" => "Dimensions,Views")
  result, page_data = tm1_get_paged_json(api, "ModelCubes()"; params = params, options...)
  map(Cube, get(result, "value", [])), page_data
end

@api_default function get_all_control_cubes(api::TM1API; options...)
  params = Dict("\$expand" => "Dimensions,Views")
  result, page_data = tm1_get_paged_json(api, "ControlCubes()"; params = params, options...)
  map(Cube, get(result, "value", [])), page_data
end

@api_default function get_cube(api::TM1API, cube_name::AbstractString; options...)
  params = Dict("\$expand" => "Dimensions,Views")
  tm1_get_json(api, "Cubes('" * cube_name * " ')"; params = params, options...)
end

@api_default function delete_cube(api::TM1API, cube_name::AbstractString; options...)
  tm1_delete(api, "Cubes('" * cube_name * "')"; options...)
end

# is this the best way to achieve this? 
@api_default function delete_cube(api::TM1API, cube::Cube; options...)
  delete_cube(api, name(cube); options...)
end

@api_default function create_cube(api::TM1API, cube::Cube; options...)
  # not working, not entirely sure this is how it should work
  # getting a weird odata error that doesn't help much
  tm1_put(api, "Cubes"; params = cube, options...)
end
