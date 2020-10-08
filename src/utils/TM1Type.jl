"""
    abstract type TM1 end

A `TM1Type` is a Julia type representation of a JSON object defined by the TM1
API. Generally:

 - The fields of these types should correspond to keys in the JSON object. In the event
   the JSON object has a "type" key, the corresponding field name used should be `typ`
   (since `type` is a reserved word in Julia).

 - The method `namefield` should be defined on every `TM1Type`. This method returns the
   type's identity in the form used for URI construction.

 - A TM1Type's field types should be Union{Nothing, T} of either: concrete types, a
   Vectors of concrete types, or Dicts.

"""
abstract type TM1Type end

"""
    @tm1def typeexpr

Define a new `TM1Type` specified by `typeexpr`, adding default constructors for
conversions from `Dict`s and keyword arguments.
"""

# this is a bit of a black box for me and I don't think it's working as it should as
# the constructors for the new types I've defined don't seem to work 

macro tm1def(expr)
    # a very simplified form of Base.@kwdef
    expr = macroexpand(__module__, expr) # to expand @static
    expr isa Expr && expr.head == :struct && expr.args[2] isa Symbol || error("Invalid usage of @tm1type")
    T = expr.args[2]
    expr.args[2] = :($T <: TM1Type)

    params_ex = Expr(:parameters)
    call_args = Any[]

    for ei in expr.args[3].args
        if ei isa Expr && ei.head == :(::)
            var = ei.args[1]
            S  = ei.args[2]
            push!(params_ex.args, Expr(:kw, var, nothing))
            push!(call_args, :($var === nothing ? $var : prune_tm1_value($var, unwrap_union_types($S))))
        end
    end
    quote
        Base.@__doc__($(esc(expr)))
        ($(esc(T)))($params_ex) = ($(esc(T)))($(call_args...))
        $(esc(T))(data::Dict) = json2tm1($T, data)
    end
end

function Base.:(==)(a::TM1Type, b::TM1Type)
    if typeof(a) != typeof(b)
        return false
    end

    for field in fieldnames(typeof(a))
        aval, bval = getfield(a, field), getfield(b, field)
        if (aval === nothing) == (bval === nothing)
            if aval !== nothing && aval != bval
                return false
            end
        else
            return false
        end
    end

    return true
end

# `namefield` is overloaded by various TM1Types to allow for more generic
# input to AP functions that require a name to construct URI paths via `name`
name(val) = val
name(t::TM1Type) = namefield(t)

########################################
# Converting JSON Dicts to TM1Types #
########################################

# Unwrap Union{Nothing, Foo} to just Foo
unwrap_union_types(T) = T
function unwrap_union_types(T::Union)
    if T.a == Nothing
        return T.b
    end
    return T.a
end

function extract_nullable(data::Dict, key, ::Type{T}) where {T}
    if haskey(data, key)
        val = data[key]
        if val !== nothing
            if T <: Vector
                V = eltype(T)
                return V[prune_tm1_value(v, unwrap_union_types(V)) for v in val]
            else
                return prune_tm1_value(val, unwrap_union_types(T))
            end
        end
    end
    return nothing
end

prune_tm1_value(val::T, ::Type{Any}) where {T} = val
prune_tm1_value(val::T, ::Type{T}) where {T} = val
prune_tm1_value(val, ::Type{T}) where {T} = T(val)
prune_tm1_value(val::AbstractString, ::Type{Dates.DateTime}) = Dates.DateTime(chopz(val))

# ISO 8601 allows for a trailing 'Z' to indicate that the given time is UTC.
# Julia's Dates.DateTime constructor doesn't support this, but TM1's time
# strings may (???) contain it. This method ensures that a string's trailing 'Z',
# if present, has been removed.
function chopz(str::AbstractString)
    if !(isempty(str)) && last(str) == 'Z'
        return chop(str)
    end
    return str
end

# Calling `json2tm1(::Type{T<:TM1Type}, data::Dict)` will parse the given
# dictionary into the type `T` with the expectation that the fieldnames of
# `T` are keys of `data`, and the corresponding values can be converted to the
# given field types.

@generated function json2tm1(::Type{T}, data::Dict) where {T<:TM1Type}
    types = unwrap_union_types.(collect(T.types))
    fields = fieldnames(T)
    args = Vector{Expr}(undef, length(fields))
    for i in eachindex(fields)
        field, T = fields[i], types[i]
        key = field == :typ ? "type" : string(field)
        args[i] = :(extract_nullable(data, $key, $T))
    end
    return :(T($(args...))::T)
end


#############################################
# Converting TM1Type Dicts to JSON Dicts #
#############################################

tm12json(val) = val
tm12json(uri::HTTP.URI) = string(uri)
tm12json(dt::Dates.DateTime) = string(dt) * "Z"
tm12json(v::Vector) = [tm12json(i) for i in v]

function tm12json(t::TM1Type)
    results = Dict()
    for field in fieldnames(typeof(t))
        val = getfield(t, field)
        if val !== nothing
            key = field == :typ ? "type" : string(field)
            results[key] = tm12json(val)
        end
    end
    return results
end

function tm12json(data::Dict{K}) where {K}
    results = Dict{K,Any}()
    for (key, val) in data
        results[key] = tm12json(val)
    end
    return results
end

###################
# Pretty Printing #
###################

function Base.show(io::IO, t::TM1Type)
    if get(io, :compact, false)
        uri_id = namefield(t)
        if uri_id === nothing
            print(io, typeof(t), "(…)")
        else
            print(io, typeof(t), "($(repr(uri_id)))")
        end
    else
        print(io, "$(typeof(t)) (all fields are Union{Nothing, T}):")
        for field in fieldnames(typeof(t))
            val = getfield(t, field)
            if !(val === nothing)
                println(io)
                print(io, "  $field: ")
                if isa(val, Vector)
                    print(io, typeof(val))
                else
                    show(IOContext(io, :compact => true), val)
                end
            end
        end
    end
end
