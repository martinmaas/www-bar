PROJECT: Raven
STATUS: projects
PERMALINK: 2011-raven
INMENU: Projects
SUBMENU: Raven
BLURB: The Raven project integrated circuits and architecture research to realize extreme energy efficiency in processor designs.  Leveraging RISC-V and the Rocket Chip, Raven silicon achieved 26.2 GFLOPS/W via a novel switched-capacitor DC-DC converter architecture.
------
The Raven project uses DVFS to achieve highly energy-efficient design points.
While many production multicore processors achieve coarse-grained power scaling via off-chip regulators, Raven chips employ fast, efficient switched-capacitor DC-DC converters on-chip that allow each voltage area to scale based on its own load.
The voltage output of switched-capacitor circuits often has a wide ripple; rather than attempting to filter this ripple, which would decrease conversion efficiency, a clock generator with a fast feedback loop dynamically tracks the ripple, ensuring that each voltage domain is operating at the optimal clock frequency from cycle to cycle.

For more details, see our [VLSI paper](http://bar.eecs.berkeley.edu/publications/2015-06-zimmer.html).