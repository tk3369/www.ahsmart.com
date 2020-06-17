@def title = "The meaning of functions in Julia"
@def disqus = true
@def page_id = "0c5a7087"
@def rss = "The meaning of functions in Julia"
@def rss_pubdate = Date(2020, 6, 17)

\blogtitle{The meaning of functions in Julia}
\blogdate{Jun 17, 2020}

When I first learned about the Julia programming language, there were a few things that 
gave me the "wat" moments. One of those surprises involves functions naming. 

Interestingly, my naive question triggered [over 200 follow-up posts 
in the Julia Discourse forum](https://discourse.julialang.org/t/function-name-conflict-adl-function-merging/10335).
**200!** That's one of my best record for motivating fellow developers! 😄

## What is the issue?

Let's first take a look at a very simple example.
Suppose that I have a `CalendarApp` module that contains the following code:

```julia
using Dates

struct Meeting
    subject::String
    start_time::DateTime
    end_time::DateTime
end
```

Then, I want to create a function that calculates the length of a
meeting. Super simple, right?  Let's go for it:

```julia
length(m::Meeting) = Hour(m.end_time - m.start_time)
```

When I code, I like a REPL-based development workflow so I can test new code quickly:

```julia-repl
julia> covid_meeting = Meeting("COVID Response Committee",
                               DateTime(2020, 6, 14, 8, 0, 0),
                               DateTime(2020, 6, 14, 10, 0, 0))
Meeting("COVID Response Committee", 2020-06-14T08:00:00, 2020-06-14T10:00:00)

julia> println(length(covid_meeting))
2 hours
```

So far so good! Now, try to use `length` function to determine the length of an array.

```julia-repl
julia> length([1,2,3])
ERROR: MethodError: no method matching length(::Array{Int64,1})
You may have intended to import Base.length
Closest candidates are:
  length(::Meeting) at REPL[3]:1
```

**_Wat!_**  That's right. Here we go the exact "wat" moment. What happened to the regular `length`
function? 

## 😵 There are two length functions!

The answer is quite simple.  There are actually two `length` functions around.  One of them
is defined in `Base` module for which everyone is familiar with, and the other one is just 
defined above.

Here's my own `length` function:

```julia-repl
julia> length
length (generic function with 1 method)
```

Now, *restart the REPL* to clear things up and try again:

```julia-repl
julia> length([1,2,3])
3

julia> length
length (generic function with 81 methods)
```

Now, I am able to access the original `length` again. You may also notice that this
`length` function is attached to 81 methods.

So, how did that happen?  It seems that I might have hidden the original `length` function
by defining our own `length` function earlier.  Out of curiosity, I can define my own function 
again:

```julia-repl
julia> using Dates

julia> struct Meeting
           subject::String
           start_time::DateTime
           end_time::DateTime
       end

julia> length(m::Meeting) = Hour(m.end_time - m.start_time)
ERROR: error in method definition: function Base.length must be explicitly imported to be extended
```

Man, now it's doing the exact opposite!  It doesn't even let me define `length` function anymore!  
This is the second "wat" moment for the same problem.

## 🤔 Did I do anything wrong?

It might worth a quick discussion here about why I did what I did.  And, why I thought I was right.

First of all, I came from an object-oriented programming background.  To be more precise, I had many years of
experience developing in the Java language.

How would the same problem look in OOP?  Well, in the object-oriented world, there is probably some 
kind of Array class that defines a `length` method.  Then, I would just define a `Meeting` 
class with a `length` method.  When I call the method, there is no ambiguity.  For instance:

```java
my_array.length();        // invokes the length method defined in Array class
my_meeting.length();      // invokes the length method defined in Meeting class
```

These are just two different methods from two different classes. 

But wait... Didn't I just do the same thing in Julia?  If I look at the signature of my `length` function,
it accepts an argument of data type `Meeting`. So, why couldn't Julia just call my function when I pass
a `Meeting` object, and call the regular `length` function when I pass an array?

**Here is primary misconception.**

Multiple dispatch only work for a single function. What I have done above actually introduced a 
second `length` function, and that function is attached to a single method.

More precisely, the two `length` functions are defined in their own modules. Let me prefix with
their respective namespaces and the number of methods:

```julia
Base.length               # 81 methods
CalendarApp.length        # 1 method
```

## 🐛 Here's the easy fix...

As I want multiple dispatch to kick in, I just need to make sure that I define a new **method**
for the `Base.length` function rather than defining my own function.  This is also called
*extending function*.  There are two ways to archive that.

**Option 1**: prefix the function name with the module name

```julia
Base.length(m::Meeting) = Hour(m.end_time - m.start_time)
```

**Option 2**: import the length function before defining it

```julia
import Base: length

length(m::Meeting) = Hour(m.end_time - m.start_time)
```

Now, let's start a new REPL and try again:

```julia-repl
julia> using Dates

julia> struct Meeting
           subject::String
           start_time::DateTime
           end_time::DateTime
       end

julia> Base.length(m::Meeting) = Hour(m.end_time - m.start_time)

julia> length
length (generic function with 82 methods)
```

Alright, the `length` function now has 82 methods attached.
Let's confirm its functionality.

```julia-repl
julia> covid_meeting = Meeting("COVID Response Committee",
                               DateTime(2020, 6, 14, 8, 0, 0),
                               DateTime(2020, 6, 14, 10, 0, 0))
Meeting("COVID Response Committee", 2020-06-14T08:00:00, 2020-06-14T10:00:00)

julia> length(covid_meeting)
2 hours

julia> length([1,2,3])
3
```

**_Voila! Problem solved!_**

## 📌 Wait, why do I have to do that?

There is already a simple solution once I understand how multiple dispatch works in Julia.
So, how did I trigger 200+ follow-up posts in Discourse?

The main controversy is why I have to be explicit about extending `Base.length`.  Since
`Base.length` has a name of `length`, and `CalendarApp.length` has a name of `length`,
why wouldn't Julia just automatically merge them?

The whole thread of discussion in Discourse goes about how it can be _more convenient_
and _less confusing_ for _new Julia users_
when the functions can be merged automatically.  I will now argue (against my original
opinion in the Discourse thread) that it is a bad idea to do so.

**Here is the main reason.**

Just because two functions **have** the same name doesn't
imply that they **mean** the same thing.  Every function is designed to have a specific
meaning.  As most people write code in English, the meaning of `length` function is pretty
much aligned with what one commonly know what a length is.  

To be clear, I will just show the first definition from Dictionary.com:

> Length (Noun): the longest extent of anything as measured from end to end.

So, the length concept refers to a measurement. As with any kind of measurement, it means
that I should expect it to return a numerical value.  
Hence, when anyone calls the `length` function, a number is expected to be returned.
_This is literally an implicit contract._ 

Enforcing the same meaning for all `length` methods turns out to be a very useful thing.
Right off the bet, I can display a graphical user interface that shows a bar that represents
a measurement.  The same component works regardless of whether the object is an
array, a String, or a Meeting! 

**This is also the main reason why Julia packages interoperate so well with each other!**

As long as there is consistent names and meanings, we can build very powerful
abstraction and interfaces.  Then, everything just works with each other in harmony.
You don't buy it yet?  Just take a look at the
[various types of array implementations](https://github.com/JuliaArrays).  These arrays
can be used anywhere a regular array is accepted.

## 😈 Playing devil's advocate...

Now, what happens if I ignore the implicit contract and define the length of a meeting to be a string?
For instance:

```julia
function Base.length(m::Meeting) 
   if m.end_time - m.start_time > Hour(1)
       return "Long"
   else
       return "Short"
   end
end
```

Well, it's probably fine because `Meeting` is my own data type. 

However, it also means that I should not let anyone else use `Meeting`.  Why? That's because
another developer will probably get very confused to experience my `length` function returning a 
string rather than a number, and that could cause serious problems.

Remember the GUI component I talked about earlier? It's going to be so broken.

**Not keeping** a consistent meaning (implicit contract) for a function is a recipe for failure.
It severely limits the reusability of functions.

## 🤓 What if I really want to use the same function name for different purpose?

If I insist that my `length` function should return a string, then I really have two options.
First, I can define my own function and **not** extend from `Base.length`.  Second, I could
choose a different name for the function.

In the first scenario, I would be able to access both `length` functions.  The caveat is
that I will have to use `Base.length` and `CalendarApp.length` instead of the short form.
This is needed to remove the ambiguity about which function I'm referring to.

The best practice, however, is to avoid naming functions with the same name that has already
been used in Base.  Why? 

1. All of the exported Base functions are [automatically brought into every module](https://docs.julialang.org/en/v1/manual/modules/#Default-top-level-definitions-and-bare-modules-1) with the exception of baremodules. So, you will have a conflict just like how it was described at the beginning of this post.

2. If you develop packages, then you don't want your users to be confused about your function versus the one in Base.  

Because the Base module is standard library that everyone uses, it's probably not a good idea to define a function with the same name but different meaning.

## 🛰️ What if the dependent module isn't Base?

Now, suppose that I am using a different module rather than Base. As an example, I'm going to pick on one of my
favorite packages [Distributions.jl](https://github.com/JuliaStats/Distributions.jl).
A typical Julia user would do the following:

```julia
using Distributions
```

I do that, too, when I need to use it interactively.  However, if I need to use it in my app,
then I would want to import only the functions that I need into my namespace.  For example,
let's say I want to calculate the mean and mode of some random-generated data, I would do this:

```julia
using Distributions: mean, mode
```

**This is actually quite important!**

First, by bringing only known functions into my namespace, it reduces
the chance of function name collision. Just take a look at the 
[huge number of exported names](https://github.com/JuliaStats/Distributions.jl/blob/20c91d9efcc5f96913bf8e38be2e3fb14b21942b/src/Distributions.jl#L28-L254) 
by Distributions.jl.

Second, I'm making my code future-proof.  Let's say I have already defined a function named `dist` 
in my module. My code will still work even if Distribution.jl happens to define and export their own
`dist` in a future version.  So, I don't need to worry naming conflict because I only import 
`mean` and `mode` into my namespace.

## Final thoughts...

[Naming things is super important](/pub/naming-things-properly/). Besides choosing the right word,
it is also important to mean what you mean. 

Over the years, I have developed a habit to ensure writing code that means what I mean. 
And, it's actually super simple. **Just write documentations.** 

In Julia, I write a doc string for every function at the same time that I code that function.
Sometimes I change the function name to match my doc string.
At other times, I change the doc string to match my function name.

It is quite amazing how effective this can be. I encourage you to give that a try today!

Thank you for reading. 

*P.S.* For more tips in writing good code in Julia, consider picking up my book [Hands-on Design Patterns and Best Practices with Julia](https://www.amazon.com/gp/product/183864881X).

