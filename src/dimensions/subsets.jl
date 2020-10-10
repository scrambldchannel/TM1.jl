# struct to model a subset

@tm1def mutable struct Subset
    Name::Union{String,Nothing}
end

Subset(name::AbstractString) = Subset(Dict("Name" => name))

namefield(subset::Subset) = subset.Name

# functions for endpoints

@api_default function get_subset(
    api::TM1API,
    dimension_name::AbstractString,
    subset_name::AbstractString;
    options...,
)
    tm1_get_json(
        api,
        "Dimensions/('" * dimension_name * "')/Hierarchies('" * subset_name * " ')";
        params = params,
        options...,
    )
end

@api_default function delete_subset(
    api::TM1API,
    dimension_name::AbstractString,
    subset_name::AbstractString;
    options...,
)

    tm1_delete(
        api,
        "Dimensions/('" * dimension_name * "')/Hierarchies('" * subset_name * " ')";
        options...,
    )
end
