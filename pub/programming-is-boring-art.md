@def title = "Programming is boring art"
@def disqus = true
@def page_id = "76abe3"
@def rss = "Programming is boring art"

\blogtitle{Programming is boring art}
\blogdate{May 30, 2020}


Wow, there is a lot to unpack here.  Boring?  Art?

I said it’s boring because you keep writing code that looks like blocks and blocks of text having the same shape.  Assignments, conditionals, loops, functions, etc.  I can pull out the best, the most intelligent code on this planet and put that side by side with another dumb piece of code that someone just wrote for fun.  And they look the same from afar.  

How boring is it to produce something of the same shape over and over again.  And yet, believe it or not, I’ve been doing that for almost 30 years… both professionally and as a hobby.  So there is something interesting that keeps dragging me into doing this.

Call it engineering, or whatever you want, but I would consider programming an art. The practice of writing good code requires not just discipline but a different way of logical reasoning that leads to a different world of beauty.

_Let me explain._

Everyone knows how to write simple programs that look like linear, step-by-step recipes. That is not what I’m talking about. Practical problems require something more complex. To solve real-world problems, software engineers have to think differently.  I shall repeat - think differently.

The secret sauce is abstraction, or so-called generalization. Real good engineers pull themselves out of the practical terms and think deeper with the more general terms.

## An example: website health checks

Let’s say I want to write a program that makes a request to a web site and alerts someone if the website is down.  The function can simply be written as follows in the [Julia language](https://julialang.org/):

```julia
function check(url)
    response = HTTP.get(url)
    if response.status != 200 then
        email("someone@somewhere.com", "something is wrong")
    end
end
```

There is nothing wrong with this function.  Really.  It does exactly what it should do with the least amount of code.  In fact, this is probably what I want to deploy in production as well.

_But, it is inflexible._

It is inflexible because it does one thing, and it’s only doing that one thing and nothing else.  In other words, it is too rigid.  You may wonder, what else do you want, dude?  

Just think about that for a little bit.  It is not hard to see the following potential problems:
* The HTTP request only uses the `GET` method without any query parameter.  What if I want to use the `POST` method?  What if I need to pass some kind of id as part of the query parameters in the URL?
* The code checks the HTTP status against `200` to see if it was successful. What if I want to handle the other [2xx response codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#2xx_Success) as well?
* The logic for alerting somenoe is hard-coded to send an email.  What if I want to send the alert to a chat platform such as Slack or Zulip?

## Generalizing the solution

A skillful programmer looks at the problem and says, hey, why don't we build an abstraction layer to make it more flexible? Let’s walk through the refactoring process below.

What we will do is to maintain the structure/logic of the code and abstract away the rest of the code as more general functions:

```julia
function check(url, recipient, message)
    response = fetch(url)
    if !is_successful(response)
        alert(recipient, message)
    end
end
```

The `fetch` function hits the URL and returns some kind of response object.  The `is_successful` function analyzes the response object and decides if it was successful or not.  Finally, the `alert` function notifies someone about the problem.  

These functions are pure abstractions because there is no need to know how they do their job.  It’s the same thing as great employees.  You don’t need to tell them how to get the job done.  They just know and get the job done.

Coming back to the example, the `alert` function may send an email, log an event to a database, page the support person, or ask Siri to wake you up!   You know what I mean. The point is that the `check` function contains the same logic no matter what these little functions do!

## But, hey, each of these little functions still does one thing, right?

Great question.  Indeed, that’s exactly what it does at the moment.  Let's do a little more.  Primarily, we can give the function some context.  The first step is to recognize that we need an abstract concept "Fetcher", or something that knows how to fetch data. Logically, such concept can be coded as an abstract type: 

```julia
abstract type AbstractFetcher end
```

Then, fetching something via HTTP and checking the result is just one of the many possible implementations:

```julia
struct HTTPFetcher <: AbstractFetcher end

fetch(::HTTPFetcher, url) = HTTP.get(url)

function is_successful(::HTTPFetcher, response) 
    return response.status === 200
end
```

Likewise, we can set up the "notifier" abstract concept the same way.  

```julia
"""
A notifier knows how to notify someone.
"""
abstract type AbstractNotifier end

"""
Send a notification alert message.
"""
function alert end
```

Note that the `alert` function has no body.  The purpose of having an empty function 
is to define what the interface looks like and attach a doc string for documentation purpose.

Just for fun, we will implement both an `EmailNotifier` and `SlackNotifier` here:

```julia
struct EmailNotifier <: AbstractNotifier 
    recipient::String
end

function alert(notifier::EmailNotifier, message)
    SMTP.send(notifier.recipient, message)
end

struct SlackNotifier <: AbstractNotifier 
    channel::String
end

function alert(notifier::SlackNotifier, message)
    Slack.send(notifier.channel, message)
end
```

_>>> Note: SMTP and Slack are "made-up" packages for illustration purpose only.
They do not exist._

Finally, the `check` function just need to accept a fetcher and a notifier
object.

```julia
function check(url, fetcher::AbstractFetcher, notifier::AbstractNotifier)
    response = fetch(fetcher, url)
    if !is_successful(fetcher, response)
        alert(notifier, "$url is down")
    end
end
```

Just having these few abstractions opens up a lot of possibilities.  Why?  Let’s suppose that you have 3 different kinds of fetchers and 3 kinds of notifiers.  Now, you can easily compose 3 x 3 = 9 different kinds of health checks.

## A word of caution...
 
Please beware that _abstraction is a double-edged sword._

**Too much abstraction can hurt.**  In the above example, there is only a single level of abstraction.  When one looks at the code, it is still pretty easy to understand and comprehend.  However, if there are multiple layers of abstraction, then it becomes very difficult to reason about the code.  Look no further than [Fizz Buzz Enterprise Edition](https://github.com/EnterpriseQualityCoding/FizzBuzzEnterpriseEdition) for an extreme illustration of over-engineering.

Note that the example above is used illustrate the power of abstraction. **_The programmer must make good judgments about whether a function needs to be generalized or not._**  Generally, good judgement comes with experience and practice.

## Final words…

As you can see, it is quite simple to uplift your code to a new level. The use of abstract type is a quick and easy way to build these abstractions.  Note that there are other paradigms - for example, traits.  I will save that for a future post.  If you cannot wait, head over to the [BinaryTraits.jl ](https://github.com/tk3369/BinaryTraits.jl) project repo for a quick peek of what's brewing at the moment.

Programming can be fun.  It does not have to be boring.  At this point, I guess I will retract my initial claim.  While my code may look boring from afar, when I look closer, I see a beautiful thing.

Enjoy your programming life.  It's a *fun* art!

## Updates

- *May 30, 2020 5:30 PM PST:*  Corrected several typos and added some note about proper judgement for real work.
