ccl
===

**ccl** (Computation and Control Language) is a small embedded
interpreted language used by the
[gro](https://github.com/klavinslab/gro) bacterial-colony simulator
to express per-cell programs, world setup, and reactive rules. It is
implemented in C++ with a flex/bison parser, and ships as a static
library — applications link `libccl.a` and call `readOrganismProgram`
from `ccl.h` to load and evaluate `.gro` source.

Building a standalone library
---

```bash
brew install cmake bison flex m4         # macOS
# or: sudo apt install cmake bison flex   # Debian/Ubuntu

cmake -S . -B build
cmake --build build -j
# → build/libccl.a
```

On macOS, the CMake config auto-detects Homebrew's keg-only `bison`,
`flex`, and `m4`. Apple's stock `/usr/bin/bison` is too old (2.3, 2008)
and flex 2.6 silently produces an empty lexer with the system `m4`.
