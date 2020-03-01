# MIRTio.jl
https://github.com/JeffFessler/MIRTio.jl

[![Build Status](https://travis-ci.org/JeffFessler/MIRTio.jl.svg?branch=master)](https://travis-ci.org/JeffFessler/MIRTio.jl)
[![codecov.io](http://codecov.io/github/JeffFessler/MIRTio.jl/coverage.svg?branch=master)](http://codecov.io/github/JeffFessler/MIRTio.jl?branch=master)

File I/O routines for
[MIRT (Michigan Image Reconstruction Toolbox) in Julia](https://github.com/JeffFessler/MIRT.jl)

This code is isolated from the main MIRT.jl toolbox,
because complete tests of these functions
require large files
that are not part of the repo.

The primary functions exported are for reading GE MRI kspace data:
* `loadpfile`
* `read_rdb_hdr`

Utility functions for reading and writing fixed-length structured headers,
which are common in legacy medical imaging formats,
are in `src/ge-mri/header.jl`,
such as `header_read` and `header_write`.

This software was developed at the
[University of Michigan](https://umich.edu/)
by
[Jeff Fessler](http://web.eecs.umich.edu/~fessler)
and his
[group](http://web.eecs.umich.edu/~fessler/group).

This code is a package dependency of
[MIRT.jl](https://github.com/JeffFessler/MIRT.jl)
so most users will never clone this repo directly.
Installing MIRT
by following the instructions at
https://github.com/JeffFessler/MIRT.jl
will automatically include this code
through the magic of Julia's package manager.

Tested with Julia 1.0.5, 1.3, 1.4, and should work with 1.1, 1.2.
