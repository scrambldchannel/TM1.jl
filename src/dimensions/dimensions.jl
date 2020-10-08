@tm1def mutable struct Dimension
    Name::Union{String, Nothing}
    UniqueName::Union{String, Nothing}
    # fill in the rest later
end

Dimension(name::AbstractString) = Dimension(Dict("Name" => name))

namefield(dimension::Dimension) = dimension.Name

@api_default function dimensions_all(api::TM1API; options...)
    tm1_get_json(api, "Dimensions"; options...)
end

@api_default function dimensions_all_model(api::TM1API; options...)
    tm1_get_json(api, "ModelDimensions()"; options...)
end

@api_default function dimensions_all_control(api::TM1API; options...)
    tm1_get_json(api, "ControlDimensions()"; options...)
end

@api_default function dimension_by_name(api::TM1API, dimension_name::AbstractString; options...)
    tm1_get_json(api, "Dimensions('" * dimension_name * "')"; options...)
end

@api_default function dimension_delete(api::TM1API, dimension_name::AbstractString; options...)
    tm1_delete(api, "Dimensions('" * dimension_name * "')"; options...)
end
