{{ add_sister }}

@def title = "An Updated Analysis on 'Giving up on Julia' Blog Post"
@def disqus = true
@def page_id = "ffc045"
@def rss = "An updated analysis about Julia in response to the misleading 'Giving Up on Julia' blog post."

\blogtitle{An Updated Analysis on 'Giving Up on Julia' Blog Post}
\blogdate{Feb 4, 2018}

![Speed](/assets/pages/giving_up_julia/speed.jpg)
\textcss{blog-image-credit}{Photo by chuttersnap on Unsplash}

This [blog post from May 2016](http://zverovich.net/2016/05/13/giving-up-on-julia.html) introduced a lot of skepticism about the Julia programming language. As one can see from comments on the blog page as well as [recent discussions in the Julia Discourse forum](https://discourse.julialang.org/t/has-anyone-seen-this-blog/8684), it is not without controversy.

The purpose of this blog post is to debunk the myths and determine what truly be a concern…. or not. Most blogs are opinionated but I will try my best to be fair and point out differences here so people can judge according to their use cases.

All benchmarks below are performed using my MacBook Pro laptop (Intel i5-4258U CPU @ 2.40GHz) with Julia version 0.6.2 and Python 3.6.3 from Anaconda distribution.

## Complaints about Julia’s Microbenchmarks
The author cited several github issues with Julia’s benchmarks.

1. The C implementation of [parse_integer benchmark](https://github.com/JuliaLang/julia/issues/4662) was not coded in a performant/idiomatic fashion e.g. the use of strlen function. The core development team acknowledged the issue and quickly fixed the code (within 2 days) in October 2013.
2. The [Java implementation of various benchmarks](https://github.com/JuliaLang/julia/pull/14229) as well as [Octave](https://github.com/JuliaLang/julia/issues/13042) were questioned. After several rounds of discussions on GitHub, it boils down to the philosophy of the benchmarks – are we trying to understand how different language implementations perform for the same algorithms or are we trying to see how the best optimized code compares in these languages?

The benchmark page on Julia web site explains well:
> It is important to note that the benchmark codes are not written for absolute maximal performance (the fastest code to compute recursion_fibonacci(20) is the constant literal 6765). Instead, the benchmarks are written to test the performance of identical algorithms and code patterns implemented in each language.

### Few Words about Optimization

It is likely that one can optimize anything in any extendible language implementation and achieve great performance. In the case of Python, one can apply Cython, Numba, Numpy, and other techniques. This is the classic [two-language problem](two-language problem) as described by Stefan Karpinski.

The real questions are:

- How difficult and how much effort is required to optimize anything?
- Does optimization introduce additional complexity in code and hinders productivity?

## Performance of Hello World
The author was unimpressed with the run time of a simple hello world program. The inclusion of the startup time is clearly a confusing one-sided argument.

The question is – does it matter? Maybe, maybe not.

1. If you have a bunch of short-duration apps that only takes a second to run then a longer startup time could mean a lot to you.
2. If you have a large computation project that takes 30 minutes to process then the 0.5 second startup time means nothing. This should be the more common case for most business applications, let alone the numeric/scientific computing community.

## A Detour to the “How To Make Python Run As Fast As Julia” blog
The author indicated that there are ways to make Python faster as in the [How To Make Python Run As Fast As Julia](https://www.ibm.com/developerworks/community/blogs/jfp/entry/Python_Meets_Julia_Micro_Performance?lang=en) blog article. This choice of citing this source is clearly a shoutout of “hey, we Python developers already know how to make things fast and there’s no reason to switch to any other language.” Let’s take a quick detour and dive into that article.

### Fibonacci Benchmark
My test result shows that the speed of Cython-Typed is comparable to Julia.

Just a couple notes:

- The blog concluded with the benchmark results of 80 µs (Julia) vs 24 µs (Cython-Typed). I do not see such behavior. Perhaps the only explanation is that the time has changed and Julia has already gotten a lot better than before.
- The `fib` function was then optimized using a LRU cache.  From a benchmarking perspective, it would not be a fair comparison if the algorithm itself is changed. Hence, we will ignore those results here.
- The LRU-enhanced code was further optimized with Numba. For the same reason above, we will ignore those results.

**Python**
```python
 In [43]: def fib(n):
     ...:     if n<2:
     ...:         return n
     ...:     return fib(n-1)+fib(n-2)

 In [44]: %timeit fib(20)
 3.27 ms ± 48.3 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)
```

**Cython**
```python
In [48]: %%cython
    ...: def fib_cython(n):
    ...:     if n<2:
    ...:         return n
    ...:     return fib_cython(n-1)+fib_cython(n-2)

 In [51]: %timeit fib_cython(20)
 1.48 ms ± 329 µs per loop (mean ± std. dev. of 7 runs, 1000 loops each)
```

**Cython Typed**
```python
In [71]: %%cython
    ...: cpdef long fib_cython_type(long n):
    ...:     if n<2:
    ...:         return n
    ...:     return fib_cython_type(n-1)+fib_cython_type(n-2)

 In [72]: %timeit fib_cython_type(20)
 47.8 µs ± 182 ns per loop (mean ± std. dev. of 7 runs, 10000 loops each)
```

**Julia**
```julia
julia> fib(n) = n < 2 ? n : fib(n-1) + fib(n-2)
fib (generic function with 1 method)

julia> @btime fib(20)
 48.075 μs (0 allocations: 0 bytes)
```

### Quicksort

The author started converting the quick sort function to Cython and finally concluded that Numpy’s sort routine being the best.

- Micro benchmark algorithm – Julia (356 μs) vs Cython (1030 μs)
- Base sort function – Julia (233 μs) vs. Numpy (292 μs)

**Python**
```python
In [83]: def qsort1(a, lo, hi):
    ...:     i = lo
    ...:     j = hi
    ...:     while i < hi:
    ...:         pivot = a[(lo+hi) // 2]
    ...:         while i <= j:
    ...:             while a[i] < pivot:
    ...:                 i += 1
    ...:             while a[j] > pivot:
    ...:                 j -= 1
    ...:             if i <= j:
    ...:                 a[i], a[j] = a[j], a[i]
    ...:                 i += 1
    ...:                 j -= 1
    ...:         if lo < j:
    ...:             qsort1(a, lo, j)
    ...:         lo = i
    ...:         j = hi
    ...:     return a

 In [84]: %timeit qsort1(lst, 0, len(lst)-1)
 13.7 ms ± 140 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)
```

**Cython**
```python
In [100]: %%cython
        ...: cdef double[:] qsort2(double[:] a, long lo, long hi):
        ...:     cdef:
        ...:         long i, j
        ...:         double pivot
        ...:     i = lo
        ...:     j = hi
        ...:     while i < hi:
        ...:         pivot = a[(lo+hi) // 2]
        ...:         while i <= j:
        ...:             while a[i] < pivot:
        ...:                 i += 1
        ...:             while a[j] > pivot:
        ...:                 j -= 1
        ...:             if i <= j:
        ...:                 a[i], a[j] = a[j], a[i]
        ...:                 i += 1
        ...:                 j -= 1
        ...:         if lo < j:
        ...:             qsort2(a, lo, j)
        ...:         lo = i
        ...:         j = hi
        ...:     return a
        ...:
        ...: def qsort2_py(a, b, c):
        ...:     return qsort2(a, b, c)

In [105]: %timeit qsort2_py(np.random.rand(5000), 0, 4999)
1.03 ms ± 110 µs per loop (mean ± std. dev. of 7 runs, 1000 loops each)
```

**Numpy**
```python
In [61]: %timeit np.sort(lst)
 292 µs ± 4.9 µs per loop (mean ± std. dev. of 7 runs, 1000 loops each)
```

**Julia Microbenchmark**
```julia
julia> function qsort!(a,lo,hi)
            i, j = lo, hi
            while i < hi
                pivot = a[(lo+hi)>>>1]
                while i <= j
                    while a[i] < pivot; i += 1; end
                    while a[j] > pivot; j -= 1; end
                    if i <= j
                        a[i], a[j] = a[j], a[i]
                        i, j = i+1, j-1
                    end
                end
                if lo < j; qsort!(a,lo,j); end
                lo, j = i, hi
            end
            return a
        end;

julia> sortperf(n) = qsort!(rand(n), 1, n);

julia> @btime sortperf(5000)
    355.957 μs (2 allocations: 39.14 KiB)
```

**Julia Base.sort**
```julia
julia> @btime sort(rand(5000); alg=QuickSort)
233.293 μs (11 allocations: 78.66 KiB)
```

### Mandelbrot Set
My test results shows Numba (159 μs) vs. Julia (72 μs).

I was, however, a bit puzzled by Numba’s compilation error below and do not know how to get rid of it. Perhaps it has a material impact on performance as well.

**Numba**
```python
In [106]: @jit
        ...: def mandel_numba(z):
        ...:     maxiter = 80
        ...:     c = z
        ...:     for n in range(maxiter):
        ...:         if abs(z) > 2:
        ...:             return n
        ...:         z = z*z + c
        ...:     return maxiter

In [107]: @jit
        ...: def mandelperf_numba_mesh():
        ...:     width = 26
        ...:     height = 21
        ...:     r1 = np.linspace(-2.0, 0.5, width)
        ...:     r2 = np.linspace(-1.0, 1.0, height)
        ...:     mandel_set = np.empty((width,height), dtype=int)
        ...:     for i in range(width):
        ...:         for j in range(height):
        ...:             mandel_set[i,j] = mandel_numba(r1[i] + 1j*r2[j])
        ...:     return mandel_set

In [109]: %timeit mandelperf_numba_mesh()
:1: NumbaWarning: Function "mandelperf_numba_mesh" failed type inference: Invalid usage of Function() with parameters ((int64 x 2), dtype=Function(<class 'int'>))
    * parameterized
File "", line 7
[1] During: resolving callee type: Function()
[2] During: typing of call at  (7) @jit
:1: NumbaWarning: Function "mandelperf_numba_mesh" failed type inference: cannot determine Numba type of <class 'numba.dispatcher.LiftedLoop'>
File "", line 8 @jit
:1: NumbaWarning: Function "mandelperf_numba_mesh" was compiled in object mode without forceobj=True, but has lifted loops.
159 µs ± 7.55 µs per loop (mean ± std. dev. of 7 runs, 10000 loops each)
```

**Julia**
```julia
julia> function mandel(z)
            c = z
            maxiter = 80
            for n = 1:maxiter
                if myabs2(z) > 4
                    return n-1
                end
                z = z^2 + c
            end
            return maxiter
        end;

julia> mandelperf() = [ mandel(complex(r,i)) for i=-1.:.1:1., r=-2.0:.1:0.5 ];

julia> @btime mandelperf()
    72.942 μs (1 allocation: 4.44 KiB)
```

### Parse Int
Note that I removed the assertion statement as it appears to be unnecessary for this benchmark.  My test results shows:

- Original – Numpy (2340 μs) vs. Julia (176 μs)
- Random number generation outside loop – Cython (378 µs) vs Julia (176 μs).

**Numpy**
```python
In [112]: def parse_int1_numpy():
        ...:     for i in range(1,1000):
        ...:         n = np.random.randint(0,2**31-1)
        ...:         s = hex(n)
        ...:         m = int(s,16)

In [113]: %timeit parse_int1_numpy()
2.34 ms ± 80 µs per loop (mean ± std. dev. of 7 runs, 100 loops each)
```

**Julia**
```julia
julia> function parseintperf(t)
            local n, m
            for i=1:t
                n = rand(UInt32)
                s = hex(n)
                m = UInt32(parse(Int64,s,16))
            end
        end
parseintperf (generic function with 1 method)

julia> @btime parseintperf(1000)
    176.061 μs (2000 allocations: 93.75 KiB)
```

**Cython (random number generated outside loop)**
```python
In [116]: %%cython
        ...: import numpy as np
        ...: import cython
        ...:
        ...: @cython.boundscheck(False)
        ...: @cython.wraparound(False)
        ...: cpdef parse_int_vec_cython():
        ...:     cdef:
        ...:         long i,m
        ...:         long[:] n
        ...:     n = np.random.randint(0,2**31-1,1000)
        ...:     for i in range(1,1000):
        ...:         m = int(hex(n[i]),16)
        ...:

In [118]: %timeit parse_int_vec_cython()
378 µs ± 5.29 µs per loop (mean ± std. dev. of 7 runs, 1000 loops each)
```

**Julia (random number generated outside loop)**
```julia
julia> function parseintperf2(t)
            n = rand(UInt32, t)
            for i=1:t
                s = hex(n[i])
                m = UInt32(parse(Int64,s,16))
            end
        end;

julia> @btime parseintperf2(1000)
    176.053 μs (2003 allocations: 97.97 KiB)
```

Phew! Let’s come back to the original blog post.

## Language
The author had some criticism about the Julia language itself.

1. Unbalanced `end`'s. I consider this a non-issue but rather a personal taste/preference. Most languages have an ending mark for blocks. I don’t understand what unbalanced was referring to, however.
2. Use of `::`. I consider this a non-issue but rather a personal taste/preference as well.
3. Unorthodox choice of operators, punctuators and the syntax for multiline comments.  Julia’s [punctuations](https://docs.julialang.org/en/stable/stdlib/punctuation) do not seem to be very different from many programming languages.  This seems to be just another personal taste/preference issue.
4. One-based indexing. This is my favorite 🙂 There are two camps and both have merits. It really depends on your use cases and situations. As various people pointed out in the Discourse forum, there are packages (such as [OffsetArrays](https://github.com/JuliaArrays/OffsetArrays.jl) and [PermutedDimsArray](https://github.com/JuliaLang/julia/blob/master/base/permuteddimsarray.jl)) that one can use when zero-based indices are more natural. It is nice that we have choices.
5. Standard documentation system using Markdown.  I started coding Julia just few months ago and found the documentation system intuitive and easy. However, I think the author made a decent point, with more information in a [follow-up blog post](http://zverovich.net/2016/06/16/rst-vs-markdown.html).  It seems that [opinions are divided](https://news.ycombinator.com/item?id=13724592); in the case of Julia, the choice was made early on given several pain points using reST.   After doing all kinds of research ([here](https://eli.thegreenplace.net/2017/restructuredtext-vs-markdown-for-technical-documentation/), [here](http://ericholscher.com/blog/2016/mar/15/dont-use-markdown-for-technical-docs/), and [here](https://www.reddit.com/r/programming/comments/5z49vw/restructuredtext_vs_markdown_for_technical/#bottom-comments)), it appears to me that reStructuredText is more rigid and functional, while Markdown is easy to learn and use.

Bottomline – there is no right or wrong; we know developers never agree on one thing.  Luckily, developers always have a choice to make their own decisions.  I fully respect projects that select reStructuredText over Markdown, or vice versa.

## Safety
The author argued that it’s easy to generate segmentation fault in Julia when using `ccall`. I found it untrue with the current version of Julia. I was unable to make it seg fault with either incorrect library name or incorrect data type. I always receive a nice error message.

```julia
julia> val = ccall((:getenv, "libc.so.6"), Ptr{UInt8}, (Ptr{UInt8},), var)
 ERROR: error compiling anonymous: could not load library "libc.so.6"
 dlopen(libc.so.6.dylib, 1): image not found

julia> val = ccall((:getenv, "libc.dylib"), Ptr{UInt8}, (Ptr{UInt8},), 123)
 ERROR: MethodError: no method matching unsafe_convert(::Type{Ptr{UInt8}}, ::Int64)
 Closest candidates are:
 unsafe_convert(::Type{Ptr{UInt8}}, ::Symbol) at pointer.jl:35
 unsafe_convert(::Type{Ptr{UInt8}}, ::String) at pointer.jl:37
 unsafe_convert(::Type{T<:Ptr}, ::T<:Ptr) where T<:Ptr at essentials.jl:152 ...
```

## Printf/Sprintf
The author was unimpressed about the `@sprintf` and `@printf` macros that generate a large body of code.

It was probably true at the time but there are multiple solutions today. This is an area that is undergoing rapid innovations.  A couple of Julia packages address the problem e.g. [Formatting.jl](https://github.com/JuliaIO/Formatting.jl) and [StringLiterals.jl](https://github.com/JuliaString/StringLiterals.jl).

The code below generates only 63 lines of native code, compared to 500+ as the author claimed in the old days.

```julia
julia> @code_native Formatting.printfmt("{1:>4s} {2:.2f}", "abc", 12)
If I compile the C code below, I get 21 lines of assembly instructions.  I guess it’s hard to beat C.

void f(char *buffer, const char *a, double b) {
  sprintf(buffer, "this is a %s %g", a, b);
}
```

## Unit Testing
The author argues that unit testing libraries are limited in Julia:

The libraries for unit testing are also very basic, at least compared to the ones in C++ and Java. FactCheck is arguably the most popular choice but, apart from the weird API, it is quite limited and hardly developed any more.

While I was developing the [SASLib.jl](https://github.com/tk3369/SASLib.jl) package, I only use [Base.Test](https://docs.julialang.org/en/stable/stdlib/test/) and found it to be very user friendly and it does everything that I needed to do. The author mentioned the FactCheck package, which seems to be a reasonable add-on.  I have never used FactCheck before so I cannot provide additional insights here.

## Development
It is interesting that the author stated he considered contributing to the Julia project but did not like the fact that Julia runtime is built from several programming languages – C/C++, Lisp, and Julia.

I do not understand why that is such a big deal.  If I count how many lines of code in each language for Julia v0.6, this is what I get:

- Julia 175,147
- C/C++ 70,694
- Femtolisp 8,270

The code for C/C++ is pretty much required to have a base runtime of the Julia language. Then, a large majority of Julia is built using Julia itself. So we’re talking about 3.3% of the code base in [Femtolisp](https://github.com/JeffBezanson/femtolisp), a Scheme-like Lisp implementation.

```julia
julia> 8270 / (175147 + 70694 + 8270) * 100
3.2544832769931253
```

I had a recent experience in contributing a small change to the Julia project. The community members at the Discourse forum are very friendly, and the core development team is always there as well. If I want to contribute more, there’s very little barrier and I can get a lot of help easily.

Finally, the author cited a third party article about how “[Julia slowed down and got out of the radar](http://www.davideaversa.it/2015/12/the-most-promising-languages-of-2016/)“. I don’t know the environment in 2015 but given the fact that [Julia Computing just got seed funding in 2017](https://juliacomputing.com/press/2017/06/19/seed-funding.html), I am expecting it to speed up rather than slow down.  Time will tell if the momentum continues as Julia approaches 1.0 milestone.

I hope this blog article is useful for anyone evaluating Julia.

## Updates

*3-Feb-2018 8:00 PM PST* – clarified the reason for not including certain performance results from the other blog and added references to array & string formatting packages (feedbacks from Christopher Rackauckas & Scott Jones)

*4-Feb-2018 11:25 AM PST* – updated Julia project lines of code statistics based on release-0.6 branch; updated notes about Markdown vs. reStructuredText after doing more research.
