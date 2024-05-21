export loadrds

"""
    dat = loadrds(fid::IOStream, frame::Int, frsize::Int, ncoil::Int; 
                  T::Type{<:Union{Int16,Int32}} = Int16)

Load one shot (frame) from MRI data file created with GE's Raw Data Server.

in
- `fid::IOStream`
  File handle
- `frame::Int`
  Shot/frame number
- `frsize::Int`
  Number of data points in each readout (per coil)
- `ncoil::Int`
  Number of receive coils

option
- `T::Type{<:Union{Int16,Int32}} = Int16` for the base type of (complex) data loaded
  
out
- `dat::Array{Complex{T}}` `[frsize, ncoil]`

"""
function loadrds(fid::IOStream, frame::Int, frsize::Int, ncoil::Int; 
    T::Type{<:Union{Int16,Int32}} = Int16,
)

    d = Array{Complex{T}}(undef, frsize, ncoil) # one readout

    seek(fid, 2*sizeof(T)*(frame-1)*frsize*ncoil)

    read!(fid, vec(d))

    return d
end

"""
    dat = loadrds(fid::IOStream, frames, frsize::Int, ncoil::Int;
                  T::Type{<:Union{Int16,Int32}} = Int16)

Read multiple frames. Here, `frames` is an Int vector/array/range.

out
- `dat::Array{Complex{T}}` `[frsize, ncoil, length(frames)]`
"""
function loadrds(fid::IOStream, frames::AbstractArray{<:Int}, frsize::Int, ncoil::Int;
    T::Type{<:Union{Int16,Int32}} = Int16,
)
    d = stack([loadrds(fid, frame, frsize, ncoil; T) for frame in frames])

    return d
end

