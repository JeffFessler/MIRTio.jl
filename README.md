# MIRTio.jl
https://github.com/JeffFessler/MIRTio.jl


File I/O routines for
[MIRT (Michigan Image Reconstruction Toolbox) in Julia](https://github.com/JeffFessler/MIRT.jl)

This code are isolated from the main MIRT.jl toolbox
because testing the functions
requires (often large) files
that are not part of the repo.

By such isolation,
the code coverage in MIRT.jl appears more favorable!

This software was developed at the
[University of Michigan](https://umich.edu/)
by
[Jeff Fessler](http://web.eecs.umich.edu/~fessler)
and his
[group](http://web.eecs.umich.edu/~fessler/group).

This code is a package dependency of MIRT.jl,
so most users will never clone this repo directly.
Installing MIRT using
by following the instructions at
https://github.com/JeffFessler/MIRT.jl
will automatically include this code
through the magic of Julia's package manager.
