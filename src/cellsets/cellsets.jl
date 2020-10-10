# struct to model a cellset

@tm1def mutable struct Cellset
    Name::Union{String,Nothing}
    Edges::Union{Vector,Nothing}
    Elements::Union{Vector,Nothing}
    ElementAttributes::Union{Vector,Nothing}
    Subset::Union{Vector,Nothing}
    DefaultMember::Union{Vector,Nothing}
end

Cellset(name::AbstractString) = Cellset(Dict("Name" => name))

namefield(cellset::Cellset) = cellset.Name

# functions for endpoints

@api_default function get_all_cellsets(api::TM1API, options...)
    params = Dict("\$expand" => "Cube,Axes,Cells")
    tm1_get_json(api, "Cellsets"; params = params, options...)
end



@api_default function get_cellset(api::TM1API, cellset_id::AbstractString; options...)
    params = Dict("\$expand" => "Cube,Axes,Cells")
    tm1_get_json(api, "Cellsets('" * cellset_id * "')"; params = params, options...)
end

@api_default function delete_cellset(api::TM1API, cellset_id::AbstractString; options...)

    tm1_delete(api, "Cellsets('" * cellset_id * "')"; options...)
end
