@def title = "Naming things properly"
@def disqus = true
@def page_id = "9de6100d"
@def rss = "Discuss how to name things properly in programming."

\blogtitle{Naming things properly}
\blogdate{Jun 8, 2020}

![naming things](/assets/pages/naming-things-properly/unsplash.jpg)
\textcss{blog-image-credit}{Photo by Amador Loureiro on Unsplash}

Perhaps it is not news to everyone that there are [two hard things in Computer Science](https://www.martinfowler.com/bliki/TwoHardThings.html).  In my last post, I explained why I felt [programming is not boring](/pub/programming-is-boring-art/) because there is some art in doing it[^1].  I will not spend any time here arguing whether naming things is an art or not. Instead, I will just go straight into how to name things properly.  All the examples below uses the [Julia language](https://julialang.org/).

To me, it is extremely important to write code that is readable and easy to understand. If I write it properly, my colleagues will be able to read it, support it, and enhance it going forward. If I write it badly, I may even curse at myself in the future.

I will not cover naming conventions such as `CamelCase` or `snake_case`, as they are fairly well documented and understood. Rather, I will focus more about the semantics. 

## As our journey begins...

What are the things that we need to give names to? In Julia, the main things are modules, data types, functions, constants and variables.  The very first decision is to choose between using a verb, a noun, or an adjective.  

This is actually not too difficult.  A reasonable approach is to adopt the following convention:

| Thing               | Choice of Word    |
| :------------------ | :---------------- |
| Modules             | Noun              |
| Data types          | Noun or Adjective |
| Functions           | Noun or Verb      |
| Constants/Variables | Noun              |

### Modules

A good module name typically encompasses a group of concepts and functionalities provided by the module. It needs to be broad enough to cover all functionalities but specific enough to distinguish itself from other modules.  

For example, I have a `CircularList` module that provides an implementation of a circular linked list.  I do not name it as `LinkedList`, nor would I name it as `List`, for those are too broad of a concept.

Sometimes you want to think bigger and name the module a little broader than what is currently implemented.  I think it is appropriate as long as there is a plan to develop the package further, and it does not cause any confusion for any user of the package.  But, it should not miss the mark.

Additional guidance can be found at the [package naming guidelines](https://julialang.github.io/Pkg.jl/v1/creating-packages/#Package-naming-guidelines-1) documentation.

### Data Types

Data types are used to represent either abstract concepts (abstract types) or concrete data structures (concrete types).  That's why using nouns would be appropriate. In the case that data types represent behavior or traits, it is appropriate to use adjective such as `Iterable` and `Pretty`.

A general rule of thumb is to come up with names that are not too long.  I would say any name that is composed of more than three words is [code smell](https://en.wikipedia.org/wiki/Code_smell).  So, `ProductCatalog` is perfectly fine and even `ElectronicProductCatalog` is acceptable but `ElectronicDepartmentProductCatalog` would be too long.  Why is it bad?  It is because long names are harder to read and spelling mistake are hard to find, causing headaches during debugging.

### Functions

For functions, when should I use verbs? And when should I use nouns? 

There is no hard-and-fast rule. Based upon my experience, I have developed an intuition to make these kinds of judgment.  Let me illustrate my thought process with an example.

#### How a noun looks better than a verb...

Let's say I am working on an e-commerce site and I have a `Product` data type. I want to define a function that determines the price of the product based upon the current market condition. I can think of two names - `current_price` and `calculate_price`.

Now, consider the code below:

```julia
for product in products
    if current_price(product) in price_range
        add(search_result, product)
    end
end
```

Does it look better or worse if I choose `calculate_price` instead?  I would say worse.  The reason why `current_price` looks better is that it's easier to read.  I can read the code as *"if current price of the product is in the price range, then..."* When I use `current_price`, I'm emphasizing the thing that is being returned from the function rather than how it does its job.

At this point, one may argue that the issue can be resolved with a temporary variable:

```julia
for product in products
    price = calculate_price(product)
    if price in price_range
        add(search_result, product)
    end
end
```

That's true but it limits the way you write code, so I can't say it's optimal.

#### How a verb looks better than a noun...

Next, let's consider the case that I need a new function that find the best price of the product using  several different pricing algorithms. So, the pricing function needs to take an algorithm argument.  The function now reads:

```julia
"Return the current price of the product calculated using the specified algorithm."
current_price(product::Product, algorithm::Algorithm)
```

At this point, the code starts to feel just a little more awkward to read than before. I may lean towards using a verb instead:

```julia
"Calculate the price of the product using the specified algorithm."
calculate_price(product::Product, algorithm::Algorithm)
```

Using a verb makes it more natural when you need to emphasize the action being taken to get the job done.  In this example, the use of `calculate` goes together with the argument `algorithm` quite well.

**So, my point is, what do you want to emphasize when calling the function. Is it the thing that it returns, or the process that it goes through?**

You should be able to make a better decision when you can answer the above question.

### Constants/Variables

I believe the best code should be readable. More often than not, I have heard from other programming experts about using meaningful words for all variables in the code. *Religiously.* I can agree to that most of the time, until the verbosity kicks in and kills readability.

I can think of two examples where it makes sense to use terse names.

#### Doing Math

The first case is code that performs heavy-lifting mathematical calculations. It is usually more natural to use math symbols then English words. Julia has [full support of Unicode](https://docs.julialang.org/en/v1/manual/unicode-input/) and this is an area where it shines.  Here's an example from my [BoxCoxTrans.jl](https://github.com/tk3369/BoxCoxTrans.jl) package:

```julia
function transform(𝐱, λ; α = 0, scaled = false, kwargs...) 
    if α != 0
        𝐱 .+= α
    end
    any(𝐱 .<= 0) && throw(DomainError("Data must be positive and ideally greater than 1.  You may specify α argument(shift). "))
    if scaled
        gm = geomean(𝐱)
        @. λ ≈ 0 ? gm * log(𝐱) : (𝐱 ^ λ - 1) / (λ * gm ^ (λ - 1))
    else
        @. λ ≈ 0 ? log(𝐱) : (𝐱 ^ λ - 1) / λ
    end
end
```

At current state, the code looks fairly clean and maybe even resembles the formula found in a math research paper. By contrast, it would look very ugly if I have to replace all symbols with names like `alpha`, `lambda`, and `time_series`.

#### Indexing arrays

The second case relates to the argument about naming indexing variables such as `index`. I generally oppose this idea. For simple code, it does not matter. For something more complex, it goes against you and hurts readability.

Consider this code that I found from the [LinearAlgebra](https://github.com/JuliaLang/julia/tree/master/stdlib/LinearAlgebra) package:

```julia
## Swap rows i and j and columns i and j in X
function rcswap!(i::Integer, j::Integer, X::StridedMatrix{<:Number})
    for k = 1:size(X,1)
        X[k,i], X[k,j] = X[k,j], X[k,i]
    end
    for k = 1:size(X,2)
        X[i,k], X[j,k] = X[j,k], X[i,k]
    end
end
```

Let's just do an exercise and see how it looks if we replace those short variable names with the more meaningful and longer version:

```julia
function rcswap!(index1::Integer, index2::Integer, matrix::StridedMatrix{<:Number})
    for position = 1:size(matrix,1)
        matrix[position,index1], matrix[position,index2] = 
            matrix[position,index2], matrix[position,index1]
    end
    for position = 1:size(matrix,2)
        matrix[index1,position], matrix[index2,position] = 
            matrix[index2,position], matrix[index1,position]
    end
end
```

If the purpose of using longer variable names is to improve readability, then this is doing more harm than good.

By contrast, using single-letter variable names is not too bad. In fact, it is quite common that single-letter variable names are used for indexing arrays in any programming language tutorials (e.g. [python](https://wiki.python.org/moin/ForLoop), [java](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/for.html), [javascript](https://www.w3schools.com/js/js_loop_for.asp), and [rust](https://doc.rust-lang.org/1.7.0/book/loops.html#for)). 

In addition, whenever I read code, my brain already translates them to read like `index`.  Really, there is no difference between `i`, `j`, `k` and `index`. _They all look the same to me._

## Wrapping up...

Is naming things actually difficult?  **_Definitely, maybe._**  

You may think that I always name things properly?  *Wrong!*  I am definitely not perfect. Having written a book and a couple of blog posts, I have come to realize that writing code is no difference than writing in general. You must keep revising (refactoring) to make it right.

I do believe that practice makes perfect.  I would encourage you to ask someone else to read your code and give you feedback. 

*P.S.* For more tips in writing good code in Julia, consider picking up my book [Hands-on Design Patterns and Best Practices with Julia](https://www.amazon.com/gp/product/183864881X).

## Footnotes

[^1] There were quite a bit of interesting discussions about [art vs. technique](https://news.ycombinator.com/item?id=23365642) from Hacker News.