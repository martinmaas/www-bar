PROJECT: MIDAS
SHOWPROJECTNAME: false
STATUS: projects
PERMALINK: 2015-midas
INMENU: Projects
SUBMENU: MIDAS
BLURB: MIDAS &mdash; Modeling Infrastructure for Debugging and Simulation &mdash; is a heterogenous-host platform framework for fast, cycle accurate-simulation of digital systems ranging from single-chip multiprocessors and accelerators to models of warehouse-scale computers such as FireBox.
------

MIDAS builds off the work of the RAMP and DIABLO projects in its aims to
support simulation of arbitarily large digital systems (ranging
from a single-chip multi-cores and accelerators to a warehouse-scale computers
like FireBox) on a host platform consisting of an mixture of FPGAs and multi-core CPUs.
We refer to the design being simulated as the target, and the platform
performing the simulation as the host.

## Project Goals

Three major goals of the MIDAS project are:

1.  Enable simulation of arbitarily large digital systems at speeds reaching those of direct FPGA emulation
    We want to run the target workload and complete benchmarks on implemented designs.
2.  Reduce the engineering effort required to host a simulation.
    RAMP and DIABLO, in additional to inhereting many of the challenges of using FPGAs for emulation, require hand written models that are difficult to implement.
3.  Provide a standard debug API, that abstracts the underlying host-platform architecture.
    Users should be able to write against an API without knowing a priori how it is being hosted.



To achieve the goal of fast cycle-accurate simulation it is necessary to
support designs that span multiple FPGAs and CPUs. FAME[] describes a number of
abstractions that ameliorate many of the traditional challenges of directly
emulating a design[], these were used extensively in RAMP and DIABLO, and will
form the basis of MIDAS.

While RAMP and DIABLO produced fast simulators, they were difficult to use,
requiring manual descriptions of these FAME models, which are often more difficult to
write than conventional RTL. MIDAS aims to reduce this effort by, first and like RAMP,
formalizing how components of the design communicate on the host-platform. This
will permit interoperability between C models running on an multi-core and RTL
models running on FPGAs. A secondly, by providing mechanisms to automatically
generate models from an RTL implementation. For example, using FIRRTL passes to
take RTL emit host-decoupled (FAME-xx1) and/or multi-threaded (FAME-1xx) RTL models.

Finally, we define a standard debug API, that every model presents to the
framework, regardless of how it is being hosted. This will enable system level
visability over the state of the target design, and allow the reconfiguration
of the simulation without lengthy recompilations. Here we can again use FIRRTL
to inject debugging structures, such as scan-chains, and add instrumentation
like performance counters, automatically, or with little user specification. Through
this API MIDAS will support other simulation tools being developed by the group,
notably, STROBER.

## How it works, from ten thousand feet.

Users give a description of the their system that divides it into pieces that
will be mapped to different componenets of the host platform. The framework emits the required
interfacing to support simulation channels between the regions of the
design. Portions of the design can be described abstractly with C models or
concretely with a RTL implementation. This allows the designer to concretize
only that which is necessary to get a sufficient simulation fidelity without
sacrificing performance. For instance, the pipeline and inner-most caches could
modelled at the RTL level, but the outer-most cache and off-chip memory system,
could be replaced with a soft-core managed latency pipe, that uses the FPGA's
memory system (~2-8GB) as a cache for a larger backing store managed by a multi-core
machine (size of disk!).

Custom FIRRTL passes map the target design, performing platform specific
optimizations, and injecting additional debug and instrumenting logic.



## Contributors

- David Biancolin
- Jack Keonig
- Donggyu Kim
