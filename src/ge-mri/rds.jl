export loadrds

"""
    dat = loadrds(fid::IOStream, frame::Int, frsize::Int, ncoil::Int; 
                  ptsize::Int = 2)

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
- `ptsize::Int`
  Either 2 (real/complex value stored as Int16; default)
  or 4 (Int32)
  
out
- `dat::Array{Complex{Int16/Int32}}` `[frsize, ncoil]`

"""
function loadrds(fid::IOStream, frame::Int, frsize::Int, ncoil::Int; 
    ptsize::Int = 2,
)

    if ptsize == 2
        d = Array{Complex{Int16}}(undef, frsize*ncoil) # one readout
    else
        d = Array{Complex{Int32}}(undef, frsize*ncoil)
    end

    seek(fid, 2*ptsize*(frame-1)*frsize*ncoil)

    read!(fid, d)

    reshape(d, frsize, ncoil)
end

"""
    dat = loadrds(fid::IOStream, frames, frsize::Int, ncoil::Int;
                  ptsize::Int = 2)

Read multiple frames. Here, `frames` is an Int vector/array/range.

out
- `dat::Array{Complex{Int16/Int32}}` `[frsize, ncoil, length(frames)]`
"""
function loadrds(fid::IOStream, frames, frsize::Int, ncoil::Int;
    ptsize::Int = 2,
)
    if ptsize == 2
        d = Array{Complex{Int16}}(undef, frsize, ncoil, length(frames)) 
    else
        d = Array{Complex{Int32}}(undef, frsize, ncoil, length(frames))
    end

    for i in 1:length(frames)
        d[:, :, i] = loadrds(fid, frames[i], frsize, ncoil; ptsize = ptsize);
    end

    return d
end

