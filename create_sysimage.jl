using PackageCompiler
using Pkg
using Pluto

nb = Pluto.load_notebook("statistical_genetics.jl")
mkpath("compile_env")
open("compile_env/Project.toml", "w") do f
    write(f, nb.nbpkg_ctx.env.project_file |> read |> String)
end
open("compile_env/Manifest.toml", "w") do f
    write(f, nb.nbpkg_ctx.env.manifest_file |> read |> String)
end

Pkg.activate("compile_env")
Pkg.instantiate()

create_sysimage(
    ["Random", "DataFrames", "CairoMakie", "GraphMakie", "Graphs", "CSV", "Distributions", "DelimitedFiles", "GLM", "TMLE", "MLJLinearModels", "MLJBase", "CategoricalArrays", "MLJTransforms", "EvoTrees", "KernelDensity", "Colors"],  # top-level packages your notebook uses
    sysimage_path = "pluto_sys.so",
    project = "compile_env",
    cpu_target = PackageCompiler.default_app_cpu_target()
    # precompile_execution_file = "statistical_genetics.jl",  # Pluto notebooks are valid plain Julia scripts too
)