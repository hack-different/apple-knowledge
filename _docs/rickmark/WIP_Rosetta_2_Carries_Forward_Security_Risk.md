# WIP: Rosetta 2 Carries Forward Security Risk

# Outline
- Intel Binaries lack pointer tagging and signing, and this data cannot be added to the binaries translated as it lacks sufficient metadata (LLVM metadata).
- Apple has signed binaries at platform level trust and this entitlement is carried forward
    - Imagine launching `LoginWindow` under Rosetta with DYLB shims
- 

