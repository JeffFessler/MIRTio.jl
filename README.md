# MIRTio.jl
https://github.com/JeffFessler/MIRTio.jl

[![action status][action-img]][action-url]
[![pkgeval status][pkgeval-img]][pkgeval-url]
[![codecov.io][codecov-img]][codecov-url]
[![coveralls][coveralls-img]][coveralls-url]

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

Also included are utilities for reading the HDF5 formatted
raw MRI kspace data
in the
[fastMRI](https://fastmri.org/)
image reconstruction challenge.

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

Currently tested with Julia 1.5,
but may work with earlier versions too.

<!-- URLs -->
[action-img]: https://github.com/JeffFessler/MIRTio.jl/workflows/Unit%20test/badge.svg
[action-url]: https://github.com/JeffFessler/MIRTio.jl/actions
[pkgeval-img]: https://juliaci.github.io/NanosoldierReports/pkgeval_badges/M/MIRTio.svg
[pkgeval-url]: https://juliaci.github.io/NanosoldierReports/pkgeval_badges/M/MIRTio.html
[codecov-img]: https://codecov.io/github/JeffFessler/MIRTio.jl/coverage.svg?branch=master
[codecov-url]: https://codecov.io/github/JeffFessler/MIRTio.jl?branch=master
[coveralls-img]: https://coveralls.io/repos/JeffFessler/MIRTio.jl/badge.svg?branch=master
[coveralls-url]: https://coveralls.io/github/JeffFessler/MIRTio.jl?branch=master
