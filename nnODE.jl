using NeuralPDE
using DifferentialEquations
using Plots
using Lux, Random

function system_of_de!(du, u, p, t)
    Ω_max, Δ, γ, Γ = p
    
    Ω = min(Ω_max, Ω_max * t / 145)

    du[1] =  im * Ω * (u[3] - u[4]) + Γ * u[2]
    du[2] = -im * Ω * (u[3] - u[4]) - Γ * u[2]
    du[3] = -(γ + im * Δ) * u[3] - im * Ω * (u[2] - u[1])
    du[4] = conj(du[3])

    return nothing
end

u0 = zeros(ComplexF64, 4)
u0[1] = 1
time_span = (0.0, 7.0)

parameters = [100.0, 0.0, 1.0/2.0, 1.0]

problem = ODEProblem(system_of_de!, u0, time_span, parameters)

# the NNODE PART 

rng = Random.default_rng()
Random.seed!(rng, 0)
chain = Chain(Dense(1, 5, σ), Dense(5, 1))
ps, st = Lux.setup(rng, chain) |> Lux.f64


using OptimizationOptimisers

opt = Adam(0.1)
alg = NNODE(chain, opt, init_params = ps)

sol = solve(problem, alg, verbose = true, maxiters = 2000, saveat = 0.01)
#--------------------------------------

#checking the result!

ground_truth  = solve(problem, Tsit5(), saveat = 0.01)    

plot(ground_truth.t, real.(ground_truth[1, :]), linecolor=:blue, legend = false)
plot!(ground_truth.t, real.(ground_truth[2, :]), linecolor=:blue)

plot!(sol.t, real.(sol[1, :]), linecolor=:red)
plot!(sol.t, real.(sol[2, :]), linecolor=:red)

