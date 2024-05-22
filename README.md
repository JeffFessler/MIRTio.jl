# MIRTio.jl
https://github.com/JeffFessler/MIRTio.jl

[![action status][action-img]][action-url]
[![pkgeval status][pkgeval-img]][pkgeval-url]
[![codecov.io][codecov-img]][codecov-url]
[![license][license-img]][license-url]
[![docs-stable][docs-stable-img]][docs-stable-url]
[![docs-dev][docs-dev-img]][docs-dev-url]
[![Aqua QA][aqua-img]][aqua-url]
[![code-style][code-blue-img]][code-blue-url]
[![deps](https://juliahub.com/docs/MIRTio/deps.svg)](https://juliahub.com/ui/Packages/MIRTio)
[![version](https://juliahub.com/docs/MIRTio/version.svg)](https://juliahub.com/ui/Packages/MIRTio)
[![pkgeval](https://juliahub.com/docs/MIRTio/pkgeval.svg)](https://juliahub.com/ui/Packages/MIRTio)


File I/O routines for
[MIRT (Michigan Image Reconstruction Toolbox) in Julia](https://github.com/JeffFessler/MIRT.jl)

This code is isolated from the main MIRT.jl toolbox,
because complete tests of these functions
require large files
that are not part of the repo.

The primary functions exported are
for reading GE MRI k-space data:
* `loadpfile`
* `read_rdb_hdr`

Utility functions for reading and writing fixed-length structured headers,
which are common in legacy medical imaging formats,
are in `src/ge-mri/header.jl`,
such as `header_read` and `header_write`.

For reading MRI k-space data from GE's Raw Data Server, use
* `loadrds`

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
[group](http://web.eecs.umich.edu/~fessler/group)
and collaborators.

Currently tested with Julia 1.10,
but may work with earlier versions too.

<!-- URLs -->
[action-img]: https://github.com/JeffFessler/MIRTio.jl/workflows/CI/badge.svg
[action-url]: https://github.com/JeffFessler/MIRTio.jl/actions
[aqua-img]: https://img.shields.io/badge/Aqua.jl-%F0%9F%8C%A2-aqua.svg
[aqua-url]: https://github.com/JuliaTesting/Aqua.jl
[code-blue-img]: https://img.shields.io/badge/code%20style-blue-4495d1.svg
[code-blue-url]: https://github.com/invenia/BlueStyle
[codecov-img]: https://codecov.io/github/JeffFessler/MIRTio.jl/coverage.svg?branch=main
[codecov-url]: https://codecov.io/github/JeffFessler/MIRTio.jl?branch=main
[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://JeffFessler.github.io/MIRTio.jl/stable
[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://JeffFessler.github.io/MIRTio.jl/dev
[license-img]: http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat
[license-url]: LICENSE
[pkgeval-img]: https://juliaci.github.io/NanosoldierReports/pkgeval_badges/M/MIRTio.svg
[pkgeval-url]: https://juliaci.github.io/NanosoldierReports/pkgeval_badges/M/MIRTio.html
