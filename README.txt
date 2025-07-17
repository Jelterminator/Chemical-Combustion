Hello,

This is the repository for my bachelor thesis project, where I will be simulating combustion reactions.

All code is in Julia.

In skeletal reaction model I am loading .yaml files with chemical data for very large reaction mechanisms, tens of species and hundreds of reactions.

Implementing reactornetworks proved a lot of code suboptimal and incompatible with efficient methods. All parameters and variabeles are now cached and all functions accept variables of types abstract enough for automatic differentation. There are probably still too many allocations in chemistry.jl.
