PROJECT: Hurricane
STATUS: projects
PERMALINK: 2015-hurricane
INMENU: Projects
SUBMENU: Hurricane
BLURB: The Hurricane project aims to build the next generation of chips coming out of UC Berkeley.  These chips will be focused on power-efficient DSP, with the goal being to beat traditional DSP architectures in energy/op (like TI's TMS320xx67xx series) while maintaining the familiar programming enviornment availiable to traditional CPU-based systems.  Specifically this means booting a full Linux environment, maintaining cache coherence over the entire chip, and supporting existing programming models like OpenCL and pthreads.
------
The Hurricane project builds on existing research efforts from UC Berkeley: it
executes the RISC-V ISA, uses the Rocket scalar core to run application
software, and uses the Hwacha vector-fetch accelerator to efficiently compute
DLP-heavy kernels.

Hurricane focuses on building a full system that can feed the efficient compute
engines that are being developed in tandem at BAR.  The Hurricane design
includes VLS, a scratchpad-cache partioning scheme; per-core DMA engines, to
offload data movement between levels of the memory heirarchy; a spatially-aware
memory network, to avoid cache coherence whenever possible; and support for
specialized IO tiles to accelerate device interactions.

In addition to RTL design, the Hurricane project is the driver for UCB-BAR's
next generation of chips.  These chips build on the previous Raven designs, but
aim to add additional features for energy efficiency as well as extending the
chips to be closer to a real system -- specifically, the Hurricane chips will
have a full memory system, direct high-speed links to sensors, and be capable
of running as a stand-alone system.
