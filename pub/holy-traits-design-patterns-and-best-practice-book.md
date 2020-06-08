{{ add_sister }}

@def title = "Holy Traits Pattern (book excerpt)"
@def disqus = true
@def page_id = "b79e28"
@def rss = "Holy Traits Pattern contains an excerpt from the book Hands-on Design Patterns and Best Practices with Julia, published by Packt Publishing in January 2020."
@def rss_pubdate = Date(2020, 1, 22)

\blogtitle{Holy Traits Pattern (book excerpt)}
\blogdate{Jan 22, 2020}

\lazyimagestyled{Book cover}{/assets/pages/design_patterns_book/bookcover_200px.jpg}{img-right}
This blog post contains an excerpt from my book [Hands-on Design Patterns and Best Practices with Julia](https://www.amazon.com/Hands-Design-Patterns-Julia-comprehensive-ebook/dp/B07SHV9PVV), published by Packt Publishing in January 2020.  This is my first book, and I have spent months of my weekend time to do the research and write about various patterns pioneered by other expert Julia programmers.  I also feel honored to have Stefan Karpinski write forewords for the book.

If you like the content below, you can support me by buying the book (ISBN: 183864881X), telling your buddies about the book, or even just sending me a note via the official JuliaLang Slack. In addition, any constructive criticism are pleasantly welcomed.  *After all, life is a continuous learning process.*

The Holy Traits pattern is one that I found most interesting with the Julia language as it fully leverages the [multiple dispatch](https://www.youtube.com/watch?v=kc9HwsxE1OY&t=2m18s) feature.  **_Happy reading!_**

**Table of Contents**

\toc

##  Introduction

The holy traits pattern has an interesting name. Some people also call it the **Tim Holy Traits Trick (THTT)**. The pattern is named after [Tim Holy](https://github.com/timholy), who is a long-time contributor to the Julia language and ecosystem.

What are **traits**? In a nutshell, a trait corresponds to the behavior of an object. For example, birds and butterflies can fly, so they both have the *CanFly* trait. Dolphins and turtles can swim, so they both have the *CanSwim* trait. A duck can fly and swim, so it has both the *CanFly* and *CanSwim* traits. Traits are typically binary – you either exhibit the trait or not – although that is not strictly necessary.

Why do we want traits? Traits can be used as a formal contract about how a data type can be used. For example, if an object has the *CanFly* trait, then we would be quite confident that the object has some kind of `fly` method defined. Likewise, if an object has the *CanSwim* trait, then we can probably call some kind of `swim` function.

Let's get back to programming. The Julia language doesn't have any built-in support for traits. However, the language is versatile enough for developers to use traits with the help of the multiple dispatch system. In this section, we will look into how this can be done with the special technique known as **holy traits**.

## Exploring the personal asset management use case

When designing reusable software, we often create abstractions as data types and associate behaviors with them. One way to model behaviors is to leverage a type hierarchy. Following the [Liskov Substitution Principle](https://en.wikipedia.org/wiki/Liskov_substitution_principle), we should be able to substitute a type with a subtype when a function is called.

Let's take a look at the type hierarchy for managing personal assets.

\lazyimage{Personal Asset Type Hierarchy}{/assets/pages/design_patterns_book/abstract_type_hier4.png}

We can define a function called `value` for determining the value of any asset. Such a function can be applied to all the types in the `Asset` hierarchy if we assume that all the asset types have some kind of monetary value attached to them. Following that line of thought, we can say that almost every asset exhibits the *HasValue* trait.

Sometimes, behaviors can only be applied to certain types in the hierarchy. For example, what if we want to define a `trade` function that only works with liquid investments? In that case, we would define trade functions for `Investment` and `Cash` but not for `House` and `Apartments`.

> A liquid investment refers to a security instrument that can be traded easily in the open market. The investor can quickly convert a liquid instrument into cash and vice versa. In general, most investors would like a portion of their investment to be liquid in the case of an emergency. Investments that are not liquid are called illiquid.

Programmatically, how do we know which asset types are liquid? One way is to check the type of the object against a list of types that represent liquid investments. Suppose that we have an array of assets and need to find out which one can be traded quickly for cash. In this situation, the code may look something like this:

```julia
function show_tradable_assets(assets::Vector{Asset})
    for asset in assets
        if asset isa Investment || asset isa Cash
            println("Yes, I can trade ", asset)
        else
            println("Sorry, ", asset, " is not tradable")
        end
    end
end
```

The if-condition in the preceding code is a bit ugly, even in this toy example. If we have more types in the condition, then it gets worse. Of course, we can create a union type to make it a little better:

```julia
const LiquidInvestments = Union{Investment, Cash}

function show_tradable_assets(assets::Vector{Asset})
    for asset in assets
        if asset isa LiquidInvestments
            println("Yes, I can trade ", asset)
        else
            println("Sorry, ", asset, " is not tradable")
        end
    end
end
```

There are still a few issues with this approach:

1. The union type has to be updated whenever we add a new liquid asset type. This kind of maintenance is bad from a design perspective because the programmer must remember to update this union type whenever a new type is added to the system.

2. This union type is not available for extension. If other developers want to reuse our trading library, then they may want to add new asset types. However, they cannot change our definition of the union type because they do not own the source code.

3. The if-then-else logic may be repeated in many places in our source, whenever we need to do things differently for liquid and illiquid assets.

These problems can be solved using the **holy traits** pattern.

## Implementing the Holy Traits pattern

To illustrate the concept of this pattern, we will start looking into the following personal asset data types:

```julia
abstract type Asset end

abstract type Property <: Asset end
abstract type Investment <: Asset end
abstract type Cash <: Asset end

abstract type House <: Property end
abstract type Apartment <: Property end

abstract type FixedIncome <: Investment end
abstract type Equity <: Investment end
```

The `Asset` type is at the top of the hierarchy and has the `Property`, `Investment`, and `Cash` subtypes. At the next level, `House` and `Apartment` are subtypes of `Property`, while `FixedIncome` and `Equity` are subtypes of `Investment`.

Now, let's define some concrete types:

```julia
struct Residence <: House
   location
end

struct Stock <: Equity
    symbol
    name
end

struct TreasuryBill <: FixedIncome
    cusip
end

struct Money <: Cash
    currency
    amount
end
```

What do we have here? Let's take a look at these data types in more details:

- A `Residence` is a house that someone lives in and has a location.

- A `Stock` is an equity investment, which is identified by a trading symbol and the name of the company.

- A `TreasuryBill` is a short-term government-issued form of security in the United States, and it is identified with a standard identifier called CUSIP.

- `Money` is just cash, and we want to store the currency and respective amount here.

Note that we have not annotated the types for the fields because they aren't important for illustrating the trait concept here.

## Defining the trait type

When it comes to investments, we can distinguish between ones that can be sold for cash easily in the open market and ones that take considerably more effort and time to convert into cash. Things that can easily be converted into cash within several days are known as being **liquid**, while the hard-to-sell ones are known as being **illiquid**. For example, stocks are liquid while a residence is not.

The first thing we want to do is define the traits themselves:

```julia
abstract type LiquidityStyle end
struct IsLiquid <: LiquidityStyle end
struct IsIlliquid <: LiquidityStyle end
```

**_Traits are nothing but regular data types in Julia!_** The overall concept of the `LiquidityStyle` trait is just an abstract type. The specific traits, `IsLiquid` and `IsIlliquid`, are coded as concrete types without any fields.

## Identifying traits

The next step is to assign data types to these traits. Conveniently, Julia allows us to bulk-assign traits to an entire subtype tree using the `<:` operator in the function signature:

```julia
# Default behavior is illiquid
LiquidityStyle(::Type) = IsIlliquid()

# Cash is always liquid
LiquidityStyle(::Type{<:Cash}) = IsLiquid()

# Any subtype of Investment is liquid
LiquidityStyle(::Type{<:Investment}) = IsLiquid()
```

There is no standard naming convention for traits, but my research seems to indicate that package authors tend to use either "Style" or "Trait" as the suffix for trait types.

Let's take a look at how we can interpret these three lines of code:

- We have chosen to make all the types illiquid by default. Note that we could have done this the other way round and made everything liquid by default. This decision is arbitrary and depends on the specific use case.

- We have chosen to make all the subtypes of `Cash` liquid, which includes the concrete `Money` type. The notation of `::Type{<:Cash}` indicates all the subtypes of `Cash`.

- We have chosen to make all the subtypes of `Investment` liquid. This includes all the subtypes of `FixedIncome` and `Equity`, which covers `Stock` in this example.


## Implementing trait behavior

Now that we can tell which types are liquid and which are not, we can define methods that take objects with those traits. First, let's do something really simple:

```julia
# The thing is tradable if it is liquid
tradable(x::T) where {T} = tradable(LiquidityStyle(T), x)
tradable(::IsLiquid, x) = true
tradable(::IsIlliquid, x) = false
```

In Julia, types are first-class citizens. The `tradable(x::T) where {T}` signature captures the type of argument as `T`. Since we have already defined the `LiquidityStyle` function, we can derive whether the passed argument exhibits the `IsLiquid` or `IsIlliquid` trait. So, the first `tradable` method simply takes the return value of `LiquidityStyle(T)` and passes it as the first argument for the other two `tradable` methods. This simple example demonstrates the dispatch effect.

> You might be wondering why we don't take `::Type{<: Asset}` as an argument for the default trait function. Doing so makes it more restrictive as the default value would only be available for types that are defined under the Asset type hierarchy. This may or may not be desirable, depending on how the trait is used. Either way should be fine.

Now, let's look at a more interesting function that exploits the same trait. Since liquid assets are easily tradable in the market, we should be able to discover their market price quickly as well. For stocks, we may call a pricing service from the stock exchange. For cash, the market price is just the currency amount. Let's see how this is coded:

```julia
# The thing has a market price if it is liquid

marketprice(x::T) where {T} = marketprice(LiquidityStyle(T), x)

marketprice(::IsLiquid, x) =
    error("Please implement pricing function for", typeof(x))

marketprice(::IsIlliquid, x) =
    error("Price for illiquid asset $x is not available.")
```

The code's structure is the same as the tradable function. One method is used to determine the trait, while the other two methods implement different behaviors for the liquid and illiquid instruments. Here, both `marketprice` functions just raise an exception by calling the `error` function. Of course, that's not what we really want. What we should really have is a specific pricing function for the `Stock` and `Money` types. OK, let's do just that:

```
# Sample pricing functions for Money and Stock
marketprice(x::Money) = x.amount
marketprice(x::Stock) = rand(200:250)
```

Here, the `marketprice` method for the `Money` type just returns the amount. This is quite a simplification since, in practice, we may calculate the amount in the local currency (for example, US Dollars) from the currency and amount. As for `Stock`, we just return a random number for the purpose of testing. In reality, we would have attached this function to a stock pricing service.

For illustration purposes, we have developed the following test functions:
```julia
function trait_test_cash()
    cash = Money("USD", 100.00)
    @show tradable(cash)
    @show marketprice(cash)
end

function trait_test_stock()
    aapl = Stock("AAPL", "Apple, Inc.")
    @show tradable(aapl)
    @show marketprice(aapl)
end

function trait_test_residence()
    try
        home = Residence("Los Angeles")
        @show tradable(home) # returns false
        @show marketprice(home) # exception is raised
    catch ex
        println(ex)
    end
    return true
end

function trait_test_bond()
    try
        bill = TreasuryBill("123456789")
        @show tradable(bill)
        @show marketprice(bill) # exception is raised
    catch ex
        println(ex)
    end
    return true
end
```

Here's the result from the Julia REPL:

\lazyimage{Test Results}{/assets/pages/design_patterns_book/holytest1.png}

*Perfect!* The `tradable` function has correctly identified that cash, stock, and bond are liquid and that residence is illiquid. For cash and stocks, the `marketprice` function was able to return a value, as expected. Because residence is not liquid, an error was raised. Finally, while treasury bills are liquid, an error was raised because the `marketprice` function has not yet been defined for the instrument.

## Using traits with a different type of hierarchy

The best part of the holy trait pattern is that we can use it with any object, even when its type belongs to a different type hierarchy. Let's explore the case of literature, where we may define its own type hierarchy as follows:

```julia
abstract type Literature end

struct Book <: Literature
    name
end
```

Now, we can make it obey the `LiquidityStyle` trait, as follows:

```julia
# assign trait
LiquidityStyle(::Type{Book}) = IsLiquid()

# sample pricing function
marketprice(b::Book) = 10.0
```

Now, we can trade books, just like other tradable assets.

## Reviewing some common usages

The holy traits pattern is commonly used in open source packages. Let's take a look at some examples.

### Example 1: Base IteratorSize

The Julia Base library uses traits quite extensively. An example of such a trait
is `Base.IteratorSize`. Its definition can be found from the file generator.jl:

```julia
abstract type IteratorSize end
struct SizeUnknown <: IteratorSize end
struct HasLength <: IteratorSize end
struct HasShape{N} <: IteratorSize end
struct IsInfinite <: IteratorSize end
```

This trait is slightly different from what we have learned about so far because it is not binary. The `IteratorSize` trait can be `SizeUnknown`, `HasLength`, `HasShape{N}`, or `IsInfinite`. The `IteratorSize` function is defined as follows:

```julia
"""
    IteratorSize(itertype::Type) -> IteratorSize
"""
IteratorSize(x) = IteratorSize(typeof(x))
IteratorSize(::Type) = HasLength() # HasLength is the default
IteratorSize(::Type{<:AbstractArray{<:Any,N}}) where {N} = HasShape{N}()
IteratorSize(::Type{Generator{I,F}}) where {I,F} = IteratorSize(I)
IteratorSize(::Type{Any}) = SizeUnknown()
```

Let's focus on the `IsInfinite` trait since it looks quite interesting. A few functions have been defined in `Base.Iterators` that generate infinite sequences. For example, the `Iterators.repeated` function can be used to generate the same value forever, and we can use the `Iterators.take` function to pick up the values from the sequence. Let's see how this works:

\lazyimage{Iterators.repeated function}{/assets/pages/design_patterns_book/iter_repeated.png}

If you look at the source code, you'll see that `Repeated` is the type of the iterator and that it is assigned the `IteratorSize` trait with `IsInfinite`:

```julia
IteratorSize(::Type{<:Repeated}) = IsInfinite()
```

We can quickly test it out like so:

\lazyimage{Iterators.repeated function}{/assets/pages/design_patterns_book/iter_size_repeated.png}

It is infinite just as we expected! But how is this trait utilized? To find out how, we can look into the `BitArray` from the Base library, which is a space-efficient boolean array implementation. Its constructor function can take any iterable object, such as an array:

\lazyimage{BitArray Constructor}{/assets/pages/design_patterns_book/bitarray.png}

Perhaps it isn't hard to understand that the constructor can't really work with something that is infinite in nature! Therefore, the implementation of the `BitArray` constructor has to take that into account. Because we can dispatch based upon the `IteratorSize` trait, the constructor of `BitArray` happily throws an exception when such an iterator is passed:

```julia
BitArray(itr) = gen_bitarray(IteratorSize(itr), itr)

gen_bitarray(::IsInfinite, itr) =
    throw(ArgumentError("infinite-size iterable used in BitArray constructor"))
```

To see it in action, we can call the `BitArray` constructor with the `Repeated` iterator, like so:

\lazyimage{BitArray repeated}{/assets/pages/design_patterns_book/bitarray_repeated.png}

### Example 2: AbstractPlotting ConversionTrait

[AbstractPlotting.jl](https:/​/​github.​com/​JuliaPlots/AbstractPlotting.​jl) is an abstract plotting library that is part of the [Makie](https://github.com/JuliaPlots/Makie.jl) plotting system. Let's take a look at a trait that's related to data conversion:

```julia
abstract type ConversionTrait end

struct NoConversion <: ConversionTrait end
struct PointBased <: ConversionTrait end
struct SurfaceLike <: ConversionTrait end

# By default, there is no conversion trait for any object
conversion_trait(::Type) = NoConversion()
conversion_trait(::Type{<: XYBased}) = PointBased()
conversion_trait(::Type{<: Union{Surface, Heatmap, Image}}) = SurfaceLike()
```

It defines a `ConversionTrait` that can be used for the `convert_arguments` function. As it stands, the conversion logic can be applied to three different scenarios:

1. No conversion. This is handled by the default trait type of `NoConversion`.

2. `PointBased` conversion.

3. `SurfaceLike` conversion.

By default, the `convert_arguments` function just returns the arguments untouched when conversion is not required:

```julia
# Do not convert anything if there is no conversion trait
convert_arguments(::NoConversion, args...) = args
```

Then, various `convert_arguments` functions are defined. Here is the function for 2D plotting:

```julia
"""
    convert_arguments(P, x, y)::(Vector)

Takes vectors `x` and `y` and turns it into a vector of 2D points of
the values from `x` and `y`. `P` is the plot Type (it is optional).
"""
convert_arguments(::PointBased, x::RealVector, y::RealVector) = (Point2f0.(x, y),)
```

## Using the SimpleTraits.jl package

The [SimpleTraits.jl](https://github.com/mauro3/SimpleTraits.jl) package may be used to make programming traits a little easier.  Let's try to redo the `LiquidityStyle` example using SimpleTraits. First, define a trait called `IsLiquid`, as follows:

```julia
@traitdef IsLiquid{T}
```

The syntax may look a little awkward since the `T` seems to be doing nothing, but it's actually required. The next thing is to assign types to this trait:

```julia
@traitimpl IsLiquid{Cash}
@traitimpl IsLiquid{Investment}
```

Then, a special syntax with four colons can be used to define functions that take objects exhibiting the trait:

```julia
@traitfn marketprice(x::::IsLiquid) =
    error("Please implement pricing function for ", typeof(x))

@traitfn marketprice(x::::(!IsLiquid)) =
    error("Price for illiquid asset $x is not available.")
```

The positive case has the argument annotated with `x::::IsLiquid`, while the negative case has the argument annotated with `x::::(!IsLiquid)`. Note that the parentheses is required so that it can be parsed correctly. Now, we can test it:

\lazyimage{SimpleTraits}{/assets/pages/design_patterns_book/traiterrors.png}

As expected, both default implementations throw an error. Now, we can implement the pricing function for `Stock` and quickly test again:

\lazyimage{SimpleTraits}{/assets/pages/design_patterns_book/traitworking.png}

_Looks great!_ As we can see, the SimpleTrait.jl package simplifies the process of creating traits.

In summary, using traits can make your code more extendable. We must keep in mind, however, that it takes some effort to design proper traits. Documentation is also important so that anyone who wants to extend the code can understand how to utilize the predefined traits.
