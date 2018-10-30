## Root finding

export gsl_root_fsolver_bisection
export gsl_root_fsolver_brent
export gsl_root_fsolver_falsepos
export gsl_root_fdfsolver_newton
export gsl_root_fdfsolver_secant
export gsl_root_fdfsolver_steffenson

global gsl_root_fsolver_bisection
global gsl_root_fsolver_brent
global gsl_root_fsolver_falsepos
global gsl_root_fdfsolver_newton
global gsl_root_fdfsolver_secant
global gsl_root_fdfsolver_steffenson

function init_rootfinders()
    # Load pointers to root finding algorithms
    
    global gsl_root_fsolver_bisection
    global gsl_root_fsolver_brent
    global gsl_root_fsolver_falsepos
    global gsl_root_fdfsolver_newton
    global gsl_root_fdfsolver_secant
    global gsl_root_fdfsolver_steffenson
    
    gsl_root_fsolver_bisection = unsafe_load(cglobal(
        (:gsl_root_fsolver_bisection, libgsl), Ptr{gsl_root_fsolver_type}), 1)

    gsl_root_fsolver_brent = unsafe_load(cglobal(
        (:gsl_root_fsolver_brent, libgsl), Ptr{gsl_root_fsolver_type}), 1)

    gsl_root_fsolver_falsepos = unsafe_load(cglobal(
        (:gsl_root_fsolver_falsepos, libgsl), Ptr{gsl_root_fsolver_type}), 1)

    gsl_root_fdfsolver_newton = unsafe_load(cglobal(
        (:gsl_root_fdfsolver_newton, libgsl), Ptr{gsl_root_fsolver_type}), 1)

    gsl_root_fdfsolver_secant = unsafe_load(cglobal(
        (:gsl_root_fdfsolver_secant, libgsl), Ptr{gsl_root_fsolver_type}), 1)

    gsl_root_fdfsolver_steffenson = unsafe_load(cglobal(
        (:gsl_root_fdfsolver_steffenson, libgsl), Ptr{gsl_root_fsolver_type}), 1)
end

# Macros for easier creation of gsl_function and gsl_function_fdf structs
export @gsl_function, @gsl_function_fdf
macro gsl_function(f)
    return :(
        gsl_function( @cfunction($f, Cdouble, (Cdouble, Ptr{Cvoid})),
                      0 )
    )
end
macro gsl_function_fdf(f, df, fdf)
    return :(
        gsl_function_fdf( @cfunction( $f,   Cdouble, (Cdouble, Ptr{Cvoid})),
                          @cfunction( $df,  Cdouble, (Cdouble, Ptr{Cvoid})),
                          @cfunction( $fdf, Cvoid, (Cdouble, Ptr{Cvoid}, Ptr{Cdouble}, Ptr{Cdouble})),
                          0 )
    )
end

## Hypergeometric function wrappers from original GSL.jl
#(c) 2013 Jiahao Chen <jiahao@mit.edu>
export hypergeom, hypergeom_e
function hypergeom(a, b, x)
    n = length(a), length(b)
    if n == (0, 0)
        exp(x)
    elseif n == (0, 1)
        gsl_sf_hyperg_0F1(b[1], x)
    elseif n == (1, 1)
        gsl_sf_hyperg_1F1(a[1], b[1], x)
    elseif n == (2, 0)
        gsl_sf_hyperg_2F0(a[1], a[2], x)
    elseif n == (2, 1)
        gsl_sf_hyperg_2F1(a[1], a[2], b[1], x)
    else
        error("hypergeometric function of order $n is not implemented")
    end
end
function hypergeom_e(a, b, x)
    n = length(a), length(b)
    if n == (0, 0)
        sf_exp_err_e(x,0.0)
    elseif n == (0, 1)
        sf_hyperg_0F1_e(b[1], x)
    elseif n == (1, 1)
        sf_hyperg_1F1_e(a[1], b[1], x)
    elseif n == (2, 0)
        sf_hyperg_2F0_e(a[1], a[2], x)
    elseif n == (2, 1)
        sf_hyperg_2F1_e(a[1], a[2], b[1], x)
    else
        error("hypergeometric function of order $n is not implemented")
    end
end

