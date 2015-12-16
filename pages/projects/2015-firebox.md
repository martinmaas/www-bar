PROJECT: FireBox
STATUS: projects
PERMALINK: 2015-firebox
INMENU: Projects
SUBMENU: FireBox
BLURB: The FireBox project aims to develop a system architecture for third-generation Warehouse-Scale Computers (WSCs). Firebox scales up to a ~1 MegaWatt WSC containing up to 10,000 compute nodes and up to an Exabyte (2^60 Bytes) of non-volatile memory connected via a low-latency, high-bandwidth optical switch. The FireBox project will produce custom SoCs and network infastructure, as both silicon prototypes and scalable distributed simulation tools.
------
The complete FireBox design contains petabytes of flash storage, large quantities of bulk DRAM, as well as high-bandwidth on-package DRAM. Each FireBox node contains a custom System-on-a-Chip (SoC) with combinations of application processors, vector machines, and custom hardware accelerators. Fast SoC network interfaces reduce the software overhead of communicating between application services and high-radix network backplane switches connected by Terabit/sec optical fibers reduce the network's contribution to tail latency. The very large non-volatile store directly supports in-memory databases, and pervasive encryption ensures that data is always protected in transit and in storage. These system characteristics raise a number of novel questions in programming environments, operating systems, and hardware design.
