#=
pfile.jl
read GE MRI k-space data from .p file
based on https://gitlab.com/fMRI/toppe/+toppe/+utils/loadpfile.m

(c) 2016 The Regents of the University of Michigan
Jon-Fredrik Nielsen, jfnielse@umich.edu

Comments from Matlab version at
https://gitlab.com/fMRI/toppe/+toppe/+utils/loadpfile.m

This file was derived from part of the TOPPE development environment
for platform-independent MR pulse programming.

TOPPE is free software: you can redistribute it and/or modify
it under the terms of the GNU Library General Public License as published by
the Free Software Foundation version 2.0 of the License.

TOPPE is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU Library General Public License for more details.

You should have received a copy of the GNU Library General Public License
along with TOPPE.
If not, see <http://www.gnu.org/licenses/old-licenses/lgpl-2.0.html>.

2019-05-22 Julia version by Jeff Fessler
=#

export loadpfile

# using MIRTio: read_rdb_hdr, header_init, header_size, header_string, header_write


"""
    (dat, rdb_hdr) = loadpfile(fid::IOStream ; ...)

Load data for one or more echoes from GE MRI scan Pfile.

in
- `fid::IOStream`

option
- `coils::AbstractVector{Int}`
 only get data for these coils; default: all coils
- `echoes::AbstractVector{Int}`
 only get data for these echoes; default: all echoes
- `slices::AbstractVector{Int}`
 only get data for these slices; default: `2:nslices` (NB!)
 because first slice (dabslice=0 slot) may contain corrupt data.
- `views::AbstractVector{Int}`
 only get data for these views; default: all views
- `quiet::Bool` non-verbosity, default `false`

out
- `dat::Array{Complex{Int16}}` `[ndat, ncoil, nslice, necho, nview]`
- `rdb_hdr::NamedTuple` header information

To save memory the output type is complex-valued Int16.
"""
function loadpfile(
    fid::IOStream;
    filesize::Int = 0,
    coils::AbstractVector{Int} = Int[],
    echoes::AbstractVector{Int} = Int[],
    slices::AbstractVector{Int} = Int[],
    views::AbstractVector{Int} = Int[],
    quiet::Bool = false,
)

    rdb_hdr = read_rdb_hdr(fid) # read header

    # Header parameters
    ndat = Int(rdb_hdr.frame_size)
    nslices = rdb_hdr.nslices
    ptsize = rdb_hdr.point_size # 2: data stored in short int format, int16)
    ptsize != 2 && # 4 (extended precision) unsupported here
        throw("ptsize = $ptsize unsupported")
    nechoes = rdb_hdr.nechoes
    nviews = rdb_hdr.nframes
    ncoils = rdb_hdr.dab[2] - rdb_hdr.dab[1] + 1

    # Calculate size of data chunks
    # See pfilestruct.jpg, and rhrawsize calculation in .e file.
    # number of data points per 'echo' loaddab slot. Includes baseline (0) view:
    # Apparent file data order is: [ndat, nview, necho, nslice, ncoil]
    echores = ndat * (nviews + 1)
    sliceres = nechoes * echores # number of data points per 'slice'
    coilres = nslices * sliceres # number of data points per receive coil

    # This size should match the Pfile size exactly:
    pfilesize =
        rdb_hdr.off_data + 2 * ptsize * ncoils * nslices * nechoes * (nviews + 1) * ndat

    # File size check
    (filesize != 0) &&
        (pfilesize != filesize) &&
        throw("Expected $(pfilesize/1e6) MB but see $(filesize/1e6) MB file")

    # Check if second view is empty
    # This happens when there's only one view, but the scanner sets nviews = 2
    if nviews == 2
        # Seek to view slice 2, echo 1, view 2, coil 1:
        seek(fid, rdb_hdr.off_data + (2 * ptsize * (sliceres + 2 * ndat)))
        view2tmp = Array{Int16}(undef, 2 * ndat)
        view2tmp = read!(fid, view2tmp)
        if all(view2tmp .== Int16(0))
            nviews = 1 # set nviews to 1 so we don't read in all the empty data
            !quiet && @warn("View 2 appears to be empty, only loading view 1.")
        end
    end

    # Determine which portions to load
    # NB: default is to skip first slice (sometimes contains corrupted data)
    isempty(coils) && (coils = 1:ncoils)
    isempty(echoes) && (echoes = 1:nechoes)
    isempty(slices) && (slices = 2:nslices)
    isempty(views) && (views = 1:nviews)

    # output dimensions:
    dims = (ndat, length(coils), length(slices), length(echoes), length(views))

    # Warn if output size will exceed system memory.
    # Exceeding free RAM may cause a system freeze due to attempted mem swap
    memneeded = 4 * prod(dims) # 4 bytes per complex value because Int16
    memfree = Sys.total_memory() # system total memory
    mempercentuse = 100 * memneeded / memfree
    (mempercentuse > 100) &&
        @warn("Loading data ($(memneeded/1e9) GB) may exceed available RAM and freeze system")
    # fprintf('Press enter to continue anyway...');
    # input('');
    (mempercentuse > 90) && # Warn if we will we use 90% of memory
        @warn("Loading data ($(memneeded/1e9) GB) will use $mempercentuse % of your available RAM. Proceed with caution!")

    !quiet && (@info("ndat = $ndat, memory = $(memneeded/1e9) GB"))
    !quiet && (@info("dims = $dims"))
    !quiet && (@info("slices $(slices[1]):$(slices[end]) / $nslices"))
    !quiet && (@info("echoes $(echoes[1]):$(echoes[end]) / $nechoes"))
    !quiet && (@info("views $(views[1]):$(views[end]) / $nviews"))
    !quiet && (@info("coils $(coils[1]):$(coils[end]) / $ncoils"))

    # Read data from file
    # Julia stores complex data as real1,imag1, real2,imag2, ... unlike matlab!
    # This simplifies the IO here!
    data = Array{Complex{Int16}}(undef, dims)
    dtmp = Array{Complex{Int16}}(undef, ndat) # one readout
    # !quiet && textprogressbar('Loading data: ')
    for icoil in coils
        !quiet && (@show icoil)
        # !quiet && textprogressbar(icoil/ncoils*100)
        for islice in slices
            for iecho in echoes
                for iview in views
                    # !quiet && (@info "icoil=$icoil islice=$islice iecho=$iecho iview=$iview")
                    offsetres =
                        (icoil - 1) * coilres +
                        (islice - 1) * sliceres +
                        (iecho - 1) * echores +
                        iview * ndat
                    offsetbytes = 2 * ptsize * offsetres
                    seek(fid, rdb_hdr.off_data + offsetbytes)
                    read!(fid, dtmp)
                    data[
                        :,
                        icoil-coils[1]+1,
                        islice-slices[1]+1,
                        iecho-echoes[1]+1,
                        iview-views[1]+1,
                    ] .= dtmp
                end
            end
        end
    end

    # !quiet && textprogressbar(' done.')

    return (data, rdb_hdr)
end


"""
    (dat, rdb_hdr) = loadpfile(file::String ; ...)

Load from `file`.
"""
function loadpfile(file::String; kwargs...)
    open(file, "r") do fid
        return loadpfile(fid; filesize = filesize(file), kwargs...)
    end
end


"""
    (dat, rdb_hdr) = loadpfile(file, echo::Integer ; ...)

Load a single echo from `file`.
"""
function loadpfile(pfile::String, echo::Integer; kwarg...)
    return loadpfile(pfile, echoes = [echo]; kwarg...)
end
