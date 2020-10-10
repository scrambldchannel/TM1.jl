#!/usr/bin/env bash

julia --color=yes -e 'using Pkg; VERSION >= v"1.5-" && !isdir(joinpath(DEPOT_PATH[1], "registries", "General")) && Pkg.Registry.add("General")'
julia --color=yes --check-bounds=yes --inline=yes --project -e 'using Pkg; Pkg.test(coverage=false)'
