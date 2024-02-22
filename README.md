# NeuralPDE.jl Example

This repository contains an example Julia code that leverages NeuralPDE, DifferentialEquations, and Lux.jl to solve a system of differential equations with the NNODE algorithm. The differential equations involve complex numbers, and an issue was encountered with the NNODE algorithm, which does not support complex number types.

## Overview

The provided Julia code aims to solve a system of differential equations representing a physical system. The equations are defined in the `system_of_de!` function in the [`src/modified_code.jl`](src/modified_code.jl) file. The system parameters and initial conditions are specified in the `parameters` and `u0` arrays, respectively.

## Error Description

Upon attempting to use the NNODE algorithm with complex number types (`ComplexF64`), the following error is encountered:

```julia
ERROR: Complex number type (i.e. ComplexF32, or ComplexF64)
detected as the element type for the initial condition
with an algorithm that does not support complex numbers.
Please check that the initial condition type is correct.
If complex number support is needed, try different solvers
such as those from OrdinaryDiffEq.jl.
```

## Results

The code uses the NNODE algorithm to solve the system of differential equations with complex numbers. The results are then compared with the ground truth obtained using the Tsit5 solver.

```julia

plot(ground_truth.t, real.(ground_truth[1, :]), linecolor=:blue, legend=false)
plot!(ground_truth.t, real.(ground_truth[2, :]), linecolor=:blue)

plot!(sol.t, real.(sol[1, :]), linecolor=:red)
plot!(sol.t, real.(sol[2, :]), linecolor=:red)
```
