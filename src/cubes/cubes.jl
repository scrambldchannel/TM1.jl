# Trying to write a function that returns a list of cubes from the cubes endpoint

@api_default function list_all_cubes(api::TM1API; options...)
    return tm1_get_json(api, "cubes")
end
