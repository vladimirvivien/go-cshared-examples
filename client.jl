# The code is written for Julia v0.6 and later.
# https://github.com/JuliaLang/julia

struct GoSlice
    arr::Ptr{Void}
    len::Int64
    cap::Int64
end
GoSlice(a::Vector, cap=10) = GoSlice(pointer(a), length(a), cap)

struct GoStr
    p::Ptr{Cchar}
    len::Int64
end
GoStr(s::String) = GoStr(pointer(s), length(s))

const libawesome = "awesome.so"

Add(x,y) = ccall((:Add, libawesome), Int,(Int,Int), x,y)
Cosine(x) = ccall((:Cosine, libawesome), Float64, (Float64,), x)
function Sort(vals)
    ccall((:Sort, libawesome), Void, (GoSlice,), GoSlice(vals))
    return vals # for convenience
end
Log(msg) = ccall((:Log, libawesome), Int, (GoStr,), GoStr(msg))

for ex in [:(Add(12, 9)),:(Cosine(1)), :(Sort([77,12,5,99,28,23]))]
    println("awesome.$ex = $(eval(ex))")
end
Log("Hello from Julia!")

#=
> julia client.jl
awesome.Add(12, 9) = 21
awesome.Cosine(1) = 0.5403023058681398
awesome.Sort([77, 12, 5, 99, 28, 23]) = [5, 12, 23, 28, 77, 99]
Hello from Julia!
=#
