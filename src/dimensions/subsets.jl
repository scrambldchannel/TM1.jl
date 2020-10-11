# struct to model a subset

@tm1def mutable struct Subset
  Name::Union{String,Nothing}
  UniqueName::Union{String,Nothing}
  Expression::Union{String,Nothing}
  Attributes::Union{Dict,Nothing}
  Alias::Union{String,Nothing}
  Hierarchy::Union{Hierarchy,Nothing}
  Elements::Union{Vector{Element},Nothing}
end

Subset(name::AbstractString) = Subset(Dict("Name" => name))

namefield(subset::Subset) = subset.Name

# functions for endpoints

@api_default function get_subset(
  api::TM1API,
  dimension_name::AbstractString,
  hierarchy_name::AbstractString,
  subset_name::AbstractString,
  private::Bool = false;
  options...,
)
  subset_type = subset_type_string(private)

  # exact parameters to pass need review 
  params = Dict("\$expand" => "Hierarchy(\$select=Dimension,Name),Elements(\$select=Name)")

  tm1_get_json(
    api,
    "Dimensions('" *
    dimension_name *
    "')/Hierarchies('" *
    hierarchy_name *
    "')/" *
    subset_type *
    "('" *
    subset_name *
    "')";
    params = params,
    options...,
  )
end

@api_default function delete_subset(
  api::TM1API,
  dimension_name::AbstractString,
  hierarchy_name::AbstractString,
  subset_name::AbstractString,
  private::Bool = false;
  options...,
)
  subset_type = subset_type_string(private)

  tm1_delete(
    api,
    "Dimensions('" *
    dimension_name *
    "')/Hierarchies('" *
    hierarchy_name *
    "')/" *
    subset_type *
    "('" *
    subset_name *
    "')";
    options...,
  )
end

function subset_type_string(private::Bool)
  if private
    subset_type = "PrivateSubsets"
  else
    subset_type = "Subsets"
  end
  return subset_type
end
