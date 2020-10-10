# struct to model a element

@tm1def mutable struct Element
    Name::Union{String,Nothing}
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
    tm1_get_json(
        api,
        "Dimensions/('" *
        dimension_name *
        "')/Hierarchies('" *
        hierarchy_name *
        " ')/Elements('" *
        element_name *
        " ')";
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
        "Dimensions/('" *
        dimension_name *
        "')/Hierarchies('" *
        hierarchy_name *
        " ')/Elements('" *
        element_name *
        " ')";
        options...,
    )
end
