var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = MIRTio","category":"page"},{"location":"#MIRTio.jl-Documentation","page":"Home","title":"MIRTio.jl Documentation","text":"","category":"section"},{"location":"#Contents","page":"Home","title":"Contents","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"#Overview","page":"Home","title":"Overview","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"File I/O routines useful for the Michigan Image Reconstruction Toolbox (MIRT)","category":"page"},{"location":"#Index","page":"Home","title":"Index","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"#Functions","page":"Home","title":"Functions","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Modules = [MIRTio]","category":"page"},{"location":"#MIRTio.MIRTio","page":"Home","title":"MIRTio.MIRTio","text":"MIRTio I/O routines for Michigan Image Reconstruction Toolbox (MIRT)\n\n\n\n\n\n","category":"module"},{"location":"#MIRTio.h5_get_ESC-Tuple{String}","page":"Home","title":"MIRTio.h5_get_ESC","text":"esc = h5_get_ESC(filename::String; T::DataType = ComplexF32)\n\nReturn Array of ESC (emulated single coil) data from file.\n\nHDF5.jl reads the data differently than Python's h5py. This is significant because the fastMRI paper says that the datasets have certain dimensionality, but the dimensions are permuted in Julia compared to Python, hence the calls to permutedims in the following functions.\n\n\n\n\n\n","category":"method"},{"location":"#MIRTio.h5_get_RSS-Tuple{String}","page":"Home","title":"MIRTio.h5_get_RSS","text":"rss = h5_get_RSS(filename::String; T::DataType = ComplexF32)\n\nReturn Array of RSS (root sum of squares) data from file.\n\n\n\n\n\n","category":"method"},{"location":"#MIRTio.h5_get_attributes-Tuple{String}","page":"Home","title":"MIRTio.h5_get_attributes","text":"attr = h5_get_attributes(filename::String)\n\nGet attributes attr from file.  Returns a Dict\n\n\n\n\n\n","category":"method"},{"location":"#MIRTio.h5_get_ismrmrd-Tuple{String}","page":"Home","title":"MIRTio.h5_get_ismrmrd","text":"hdr = h5_get_ismrmrd(filename::String)\n\nGet ISMRM header data from file.  Returns a ?\n\n\n\n\n\n","category":"method"},{"location":"#MIRTio.h5_get_keys-Tuple{String}","page":"Home","title":"MIRTio.h5_get_keys","text":"keys = h5_get_keys(filename::String)\n\nGet keys from file using keys(). Returns an Array{String}\n\n\n\n\n\n","category":"method"},{"location":"#MIRTio.h5_get_kspace-Tuple{String}","page":"Home","title":"MIRTio.h5_get_kspace","text":"kspace = h5_get_kspace(filename::String; T::DataType = ComplexF32))\n\nReturn Array of kspace data from file.\n\n\n\n\n\n","category":"method"},{"location":"#MIRTio.header_example-Tuple{}","page":"Home","title":"MIRTio.header_example","text":"hd = header_example()\n\nReturn example of header description\n\nout\n\nhd header definition array (N × 3)\n\n\n\n\n\n","category":"method"},{"location":"#MIRTio.header_init-Tuple{Matrix{Any}}","page":"Home","title":"MIRTio.header_init","text":"ht = header_init(hd::Matrix{Any})\n\nReturn named tuple initialized with arbitrary values for testing\n\nin\n\nhd header definition array (N × 3), e.g., from header_example()\n\nout\n\nht::NamedTuple\n\n\n\n\n\n","category":"method"},{"location":"#MIRTio.header_read-Tuple{IOStream, Matrix{Any}}","page":"Home","title":"MIRTio.header_read","text":"ht = header_read(fid::IOStream, hd::Matrix{Any} ; seek0::Bool)\n\nRead header from scan file\n\nin\n\nfid::IOStream from open(file, \"r\")\nhd header definition array (N × 3), e.g., from header_example()\n\noption\n\nseek0::Bool seek to 0 location in file first? default true\n\nout\n\nht::NamedTuple with header values, accessed by ht.key\n\n\n\n\n\n","category":"method"},{"location":"#MIRTio.header_size-Tuple{Matrix{Any}}","page":"Home","title":"MIRTio.header_size","text":"bytes = header_size(hd::Matrix{Any})\n\nreturn total size of header in bytes\n\nin\n\nhd header definition array (N × 3), e.g., from header_example()\n\nout = bytes::Int\n\n\n\n\n\n","category":"method"},{"location":"#MIRTio.header_string-Tuple{NamedTuple}","page":"Home","title":"MIRTio.header_string","text":"ht = header_string(ht::NamedTuple ; strip::Bool)\n\nConvert each Array{Cuchar} to String in NamedTuple\n\nin\n\nht::NamedTuple from header_init() or header_read()\n\noption\n\nstrip::Bool strip tail white space characters from strings? default false\n\nout\n\nht::NamedTuple\n\n\n\n\n\n","category":"method"},{"location":"#MIRTio.header_write-Tuple{IOStream, NamedTuple}","page":"Home","title":"MIRTio.header_write","text":"header_write(fid::IOStream, ht::NamedTuple)\n\nWrite header to fid\n\nin\n\nfid::IOStream from open(file, \"w\")\nht::NamedTuple from header_init() or header_read()\n\n\n\n\n\n","category":"method"},{"location":"#MIRTio.loadpfile-Tuple{IOStream}","page":"Home","title":"MIRTio.loadpfile","text":"(dat, rdb_hdr) = loadpfile(fid::IOStream ; ...)\n\nLoad data for one or more echoes from GE MRI scan Pfile.\n\nin\n\nfid::IOStream\n\noption\n\ncoils::AbstractVector{Int}\n\nonly get data for these coils; default: all coils\n\nechoes::AbstractVector{Int}\n\nonly get data for these echoes; default: all echoes\n\nslices::AbstractVector{Int}\n\nonly get data for these slices; default: 2:nslices (NB!)  because first slice (dabslice=0 slot) may contain corrupt data.\n\nviews::AbstractVector{Int}\n\nonly get data for these views; default: all views\n\nquiet::Bool non-verbosity, default false\n\nout\n\ndat::Array{Complex{Int16}} [ndat, ncoil, nslice, necho, nview]\nrdb_hdr::NamedTuple header information\n\nTo save memory the output type is complex-valued Int16.\n\n\n\n\n\n","category":"method"},{"location":"#MIRTio.loadpfile-Tuple{String, Integer}","page":"Home","title":"MIRTio.loadpfile","text":"(dat, rdb_hdr) = loadpfile(file, echo::Integer ; ...)\n\nLoad a single echo from file.\n\n\n\n\n\n","category":"method"},{"location":"#MIRTio.loadpfile-Tuple{String}","page":"Home","title":"MIRTio.loadpfile","text":"(dat, rdb_hdr) = loadpfile(file::String ; ...)\n\nLoad from file.\n\n\n\n\n\n","category":"method"},{"location":"#MIRTio.rdb_hdr_26_002_def-Tuple{}","page":"Home","title":"MIRTio.rdb_hdr_26_002_def","text":"hd = rdb_hdr_26_002_def()\n\nReturn array [Symbol Int DataType] ? × 3 used in header_read()\n\n\n\n\n\n","category":"method"},{"location":"#MIRTio.read_rdb_hdr-Tuple{IOStream}","page":"Home","title":"MIRTio.read_rdb_hdr","text":"ht = read_rdb_hdr(fid::IOStream)\n\nRead GE raw (RDB) header for MRI scans\n\nReturns NamedTuple ht with header values accessible by ht.key\n\n\n\n\n\n","category":"method"},{"location":"#MIRTio.read_rdb_hdr-Tuple{String}","page":"Home","title":"MIRTio.read_rdb_hdr","text":"ht = read_rdb_hdr(file::String)\n\nRead from file\n\n\n\n\n\n","category":"method"}]
}
