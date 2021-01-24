# MIRTio.jl
https://github.com/JeffFessler/MIRTio.jl

[![Build Status][action-img]][action-url]
[![Build Status][pkgeval-img]][pkgeval-url]
[![Codecov.io][codecov-img]][codecov-url]
[![Coveralls][coveralls-img]][coveralls-url]

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

Currently tested with Julia 1.5,
but may work with earlier versions too.

<!-- URLs -->
[action-img]: https://github.com/JeffFessler/MIRTio.jl/workflows/Unit%20test/badge.svg
[action-url]: https://github.com/JeffFessler/MIRTio.jl/actions
[pkgeval-img]: https://juliaci.github.io/NanosoldierReports/pkgeval_badges/I/ImageDraw.svg
[pkgeval-url]: https://juliaci.github.io/NanosoldierReports/pkgeval_badges/report.html
[travis-img]: https://travis-ci.org/JeffFessler/MIRTio.jl.svg?branch=master
[travis-url]: https://travis-ci.org/JeffFessler/MIRTio.jl
