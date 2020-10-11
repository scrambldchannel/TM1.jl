@tm1def mutable struct Dimension
  Name::Union{String,Nothing}
  UniqueName::Union{String,Nothing}
  Attributes::Union{Dict,Nothing}
  AllLeavesHierarchyName::Union{String,Nothing}
  Hierarchies::Union{Vector{Hierarchy},Nothing}
end

Dimension(name::AbstractString) = Dimension(Dict("Name" => name))

namefield(dimension::Dimension) = dimension.Name

@api_default function get_all_dimensions(api::TM1API; options...)
  params = Dict("\$expand" => "Hierarchies")
  result, page_data = tm1_get_paged_json(api, "Dimensions"; params = params, options...)
  map(Dimension, get(result, "value", [])), page_data
end

@api_default function get_all_model_dimensions(api::TM1API; options...)
  params = Dict("\$expand" => "Hierarchies")
  result, page_data =
    tm1_get_paged_json(api, "ModelDimensions()"; params = params, options...)
  map(Dimension, get(result, "value", [])), page_data
end

@api_default function get_all_control_dimensions(api::TM1API; options...)
  params = Dict("\$expand" => "Hierarchies")
  result, page_data =
    tm1_get_paged_json(api, "ControlDimensions()"; params = params, options...)
  map(Dimension, get(result, "value", [])), page_data
end

@api_default function get_dimension(api::TM1API, dimension_name::AbstractString; options...)
  params = Dict("\$expand" => "Hierarchies(\$expand=*)")
  result = tm1_get_json(api, "Dimensions('" * dimension_name * "')"; options...)
  Dimension(result)
end

@api_default function delete_dimension(
  api::TM1API,
  dimension_name::AbstractString;
  options...,
)
  # not sure what to return here
  tm1_delete(api, "Dimensions('" * dimension_name * "')"; options...)
end
