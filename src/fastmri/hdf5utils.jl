#=
hdf5utils.jl
Utilities for reading HDF5 data files for the 2019 fastMRI challenge.
Code by Steven Whitaker
Documentation by Jeff Fessler
2020-01-24 update to HDF5 v0.15.2
=#

export h5_get_keys, h5_get_attributes, h5_get_ismrmrd
export h5_get_ESC, h5_get_RSS, h5_get_kspace

using HDF5: h5open, h5read, attributes
import HDF5 # readmmap (non-public!?)


"""
    keys = h5_get_keys(filename::String)
Get `keys` from file using `keys()`.
Returns an `Array{String}`
"""
function h5_get_keys(filename::String)
    return h5open(filename, "r") do file
        keys(file)
    end
end


"""
    attr = h5_get_attributes(filename::String)
Get attributes `attr` from file.  Returns a `Dict`
"""
function h5_get_attributes(filename::String)
    return h5open(filename, "r") do file
        a = attributes(file)
        attr = Dict{String,Any}()
        for s in keys(a)
            attr[s] = read(a[s])
        end
        attr
    end
end


"""
    hdr = h5_get_ismrmrd(filename::String)
Get ISMRM header data from file.  Returns a `?`
"""
function h5_get_ismrmrd(filename::String)
    return h5read(filename, "ismrmrd_header")
end


"""
    esc = h5_get_ESC(filename::String; T::Type = ComplexF32)
Return `Array` of ESC (emulated single coil) data from file.

HDF5.jl reads the data differently than Python's h5py.
This is significant because the fastMRI paper
says that the datasets have certain dimensionality,
but the dimensions are permuted in Julia compared to Python,
hence the calls to `permutedims` in the following functions.
"""
function h5_get_ESC(
    filename::String;
    T::Type{<:Complex{<:AbstractFloat}} = ComplexF32,
)
    data = T.(h5read(filename, "reconstruction_esc"))
    return permutedims(data, ndims(data):-1:1)
end


"""
    rss = h5_get_RSS(filename::String; T::Type = ComplexF32)
Return `Array` of RSS (root sum of squares) data from file.
"""
function h5_get_RSS(
    filename::String;
    T::Type{<:Number} = Float32,
)
    data = T.(h5read(filename, "reconstruction_rss"))
    return permutedims(data, ndims(data):-1:1)
end


"""
    kspace = h5_get_kspace(filename::String; T::Type = ComplexF32))
Return `Array` of kspace data from file.
"""
function h5_get_kspace(
    filename::String;
    T::Type{<:Complex{<:AbstractFloat}} = ComplexF32,
)
    data = h5open(filename, "r") do file
        T = eltype(file["kspace"])
        HDF5.readmmap(file["kspace"], T)
    end
    return permutedims(T.(data), ndims(data):-1:1)
end


#=
Copied (basically) from
https://github.com/MagneticParticleImaging/MPIFiles.jl/blob/79711bf7af389f9e2dd4b0370e64040e5da1e193/src/Utils.jl#L33

superseded by eltype()
function h5_getcomplextype(dataset)
    T = HDF5.get_jl_type(
            HDF5.Datatype(
                HDF5.h5t_get_member_type(
                    datatype(dataset).id,
                    0,
                )
            )
        )
    return Complex{T}
end
=#
