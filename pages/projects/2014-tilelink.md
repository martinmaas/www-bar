PROJECT: TileLink
SHOWPROJECTNAME: false
STATUS: projects
PERMALINK: 2014-tileLink
INMENU: Projects
SUBMENU: TileLink
BLURB: TileLink is a protocol designed to be a substrate for cache coherence transactions implementing a particular cache coherence policy within an on-chip memory hierarchy. Its purpose is to orthogonalize the design of the on-chip network and the implementation of the cache controllers from the design of the coherence protocol itself. Any cache coherence protocol that conforms to TileLink's transaction structure can be used interchangeably with the physical networks and cache controllers we provide as part of the Rocket Chip Genereator.
------

TileLink is roughly analogous to the data link layer in the IP network protocol
stack, but exposes some details of the physical link necessary for efficient
controller implementation. It also codifies some transaction types that are
common to all protocols, particularly the transactions servicing memory
accesses made by agents that do not themselves have caches with coherence
policy metadata.

An overview of the TileLink Protocol is available
[here](https://docs.google.com/document/d/1Iczcjigc-LUi8QmDPwnAu1kH4Rrt6Kqi1_EUaCrfrk8/pub).
with associated CoherencePolicy documentation [here](https://docs.google.com/document/d/1vBPgrlvuLmvCB33dVb1wr3xc9f8uOrNzZ9AFMGHeSkg/pub).
ScalaDoc for the library that implements TileLink using Chisel is available
[here](http://ucb-bar.github.io/uncore/latest/api/).
