# struct to model a element

@tm1def mutable struct Element
  Name::Union{String,Nothing}
  UniqueName::Union{String,Nothing}
  Index::Union{Integer,Nothing}
  # not sure what type to use here
  Type::Union{String,Nothing}
  # not sure what type to use here either so am just going to skip this field
  #Hierarchy::Union{String,Nothing}
  Edges::Union{Vector,Nothing}
  Level::Union{Integer,Nothing}
  Attributes::Union{Dict,Nothing}
  Parents::Union{Vector{Element},Nothing}
  Components::Union{Vector{Element},Nothing}
  LocalizedAttributes::Union{Vector{Dict},Nothing}
end

Element(name::AbstractString) = Element(Dict("Name" => name))

namefield(element::Element) = element.Name

# functions for endpoints

@api_default function get_element(
  api::TM1API,
  dimension_name::AbstractString,
  hierarchy_name::AbstractString,
  element_name::AbstractString;
  options...,
)
  params = Dict("\$expand" => "*")

  tm1_get_json(
    api,
    "Dimensions('" *
    dimension_name *
    "')/Hierarchies('" *
    hierarchy_name *
    "')/Elements('" *
    element_name *
    "')";
    params = params,
    options...,
  )

end

@api_default function delete_element(
  api::TM1API,
  dimension_name::AbstractString,
  hierarchy_name::AbstractString,
  element_name::AbstractString;
  options...,
)

  tm1_delete(
    api,
    "Dimensions('" *
    dimension_name *
    "')/Hierarchies('" *
    hierarchy_name *
    " ')/Elements('" *
    element_name *
    "')";
    options...,
  )
end
