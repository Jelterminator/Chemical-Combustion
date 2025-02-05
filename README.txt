Hello,

This is the repository for my bachelor thesis project, where I will be simulating combustion reactions.

All code is in Julia.

First I wrote a model with 5 species of molecule and 1 chemical reaction: 1 step mechanism.ipynb

Second I wrote a model with 7 species of molecule and 4 chemical reactions, of which two are reversible: 4 step mechanism.ipynb

Third added a variable T to the 1 step mechanism: 1 step variable T.ipynb

Next I wrote a library of functions for using the Chemkin Thermdat database to compute some thermodynamic factors: Chemkin.ipynb

Then I added these two the 1 step and 4 step mechanisms: 1 step thermodynamics.ipynb & 4 step thermodynamics.ipynb
