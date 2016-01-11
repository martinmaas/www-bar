PROJECT: FIRRTL: A Flexible Intermediate Representation for RTL
STATUS: projects
PERMALINK: 2015-firrtl
INMENU: Projects
SUBMENU: FIRRTL
BLURB: The FIRRTL project is motivated by the success of Chisel [Chisel](https://chisel.eecs.berkeley.edu) and has two parts: 1) a specification of the formalized elaborated graph that the Chisel DSL produces, prior to any simplification, and 2) a library of micro-passes that are used to simplify, transform, or specialize arbitrary FIRRTL graphs.

------

The ideas for FIRRTL originated from a different UC Berkeley project, Chisel, which embeds a hardware description language in Scala and is used to write highly-parameterized circuit design generators.
Users manipulate circuit components using Scala functions, encode their interfaces into custom Scala types, and use Scala's object-orientation to write their own circuit libraries.
All of these features enabled expressive, reliable and type-safe generators that improved RTL design productivity and robustness.

Unfortunately, Chisel's internal representation and compiler was poorly designed.
Many design decisions made error checking complicated or impossible; many Chisel abstractions have unintutive or buggy side-effects; no concrete syntax for IR, made it difficult to debug the Chisel compiler.

As a consequence, Chisel needed to be redesigned from its ground up to standardize its IR and semantics, modularize its compilation process for robustness, and cleanly separate its front-end (Chisel + Scala), internal representation (FIRRTL), and backends.

In the new version of Chisel, a lightweight front-end generates an elaborated hardware FIRRTL graph, which can include complex features like vector types, bundle types, and when statements.
Then, a series of micro-passes accept a graph and return a new transformed graph - each graph is immutable and there are no side-effects between passes.
Once the graph is simplified by rewriting complex features with simpler features, the graph is used to emit corresponding structural Verilog.
