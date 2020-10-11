# struct to model a hierarchy

@tm1def mutable struct Hierarchy
  Name::Union{String,Nothing}
  Edges::Union{Vector,Nothing}
  Elements::Union{Vector{Element},Nothing}
  ElementAttributes::Union{Vector,Nothing}
  Subset::Union{Vector,Nothing}
  DefaultMember::Union{Vector,Nothing}
  Attributes::Union{Dict,Nothing}
  # There are other fields returned but not sure they're interesting
end

Hierarchy(name::AbstractString) = Hierarchy(Dict("Name" => name))

namefield(hierarchy::Hierarchy) = hierarchy.Name

# functions for endpoints

@api_default function get_hierarchy(
  api::TM1API,
  dimension_name::AbstractString,
  hierarchy_name::AbstractString;
  options...,
)
  # need to check whether these are the right params
  params = Dict("\$expand" => "Edges,Elements,ElementAttributes,Subsets,DefaultMember")
  result = tm1_get_json(
    api,
    "Dimensions('" * dimension_name * "')/Hierarchies('" * hierarchy_name * "')";
    params = params,
    options...,
  )
  Hierarchy(result)
end

@api_default function delete_hierarchy(
  api::TM1API,
  dimension_name::AbstractString,
  hierarchy_name::AbstractString;
  options...,
)

  tm1_delete(
    api,
    "Dimensions('" * dimension_name * "')/Hierarchies('" * hierarchy_name * "')";
    options...,
  )
end
