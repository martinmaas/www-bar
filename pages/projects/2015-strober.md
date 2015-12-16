PROJECT: Strober: A Fast and Accurate Sample-Based Energy Simulation Framework for Arbitrary RTL
STATUS: projects
PERMALINK: 2015-strober
INMENU: Projects
SUBMENU: Strober
BLURB: The Strober project is motivated by the fact that fast and accurate energy evaluation of long-running applications on complex hardware designs is extremely difficult. By employing statistical sampling of full-system simulations, Strober can achieve four-orders-of-magnitude of speedup over commercial CAD tools with less than 5% errors with 99% confidence.  
------
Even though prototyping is the most accurate way to evaluate the energy efficiency of the target designs, its long-latency cycle prohibits exhaustive design space exploration. For this reason, analytic power modeling driven by microarchitectural software simulations is very popular among computer architects. However this methodology requires long simulation times to collect microarchitectural activities despite providing some intuition in early design phases. Moreover, the power models should be validated against RTL designs or real systems, which can be very difficult for non-traditional architectures including application-specific accelerators. On the other hand, we can estimate extremely accurate cycle-time, area, and energy efficiency if RTL implementations are ready using existing commercial CAD tools, but their simulation runtime is painfully slow.

Sample-based energy simulation ***accurately and quickly*** estimates performance and average power by obtaining random samples from fast simulations and replaying the sample snapshots on slow but detailed simulations. The [central limit theorem](https://en.wikipedia.org/wiki/Central_limit_theorem) states that ***the sampling error depends only on the sample size and the variance of execution, not on the length of execution.*** Thus, the longer we simulate the target designs, the more speedup we can achieve compared to the detailed-simulation-only approach.

![Overview of Sample-based Energy Simulation](images/projects/2015-strober-1.png)

Strober is an implementation of sample-based energy simulation developed in UC Berkeley. Strober is built upon [Chisel](https://chisel.eecs.berkeley.edu), taking advantage of hardware generators and custom transforms. Basically, Strober ***automatically*** generates token-based FPGA simulators from ***arbitrary RTL designs*** written in Chisel, thus minimizing the designers' manual effort. Strober also adds scan chains and trace buffers to read out the sample snapshots from the FGPA simulations.

FPGA simulation provides the performance estimation of the target design as well as the random sample of the simulation. The random sample snapshots are replayed on gate-level simulation for the average power estimation. Strober provides the replay testbench based on the Chisel tester, which minimizes designers' effort to replay the samples on gate-level simulation as well as the Chisel emulator and various RTL simulation.

![Strober Toolflow](images/projects/2015-strober-2.png)

Strober is successfully applied to various designs including [Rocket-chip](https://github.com/ucb-bar/rocket-chip) and [BOOM](https://github.com/ucb-bar/riscv-boom.git). We submitted a paper reporting the results and will open-source Strober soon.