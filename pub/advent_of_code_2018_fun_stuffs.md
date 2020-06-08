{{ add_sister }}

@def title = "Advent-of-Code 2018 Fun Stuffs using Julia"
@def disqus = true
@def page_id = "037f60"
@def rss = "Advent-of-Code 2018 Fun Stuffs using Julia"
@def rss_pubdate = Date(2019, 1, 22)

\blogtitle{Advent-of-Code 2018 Fun Stuffs using Julia}
\blogdate{Jan 22, 2019}

![Pic](/assets/pages/aoc2018/pic.png)

For several years, I have been itching to dive into the sea of programming around Christmas but I never really got hooked. I’m fortunate enough that my family does not get all that crazy about home decorations or buying/exchanging presents. I had never played the [Advent of Code](https://adventofcode.com/)(AoC) game before, but I do know that it is quite exhausting as one has to work through daily problems for 25 days in December.  Nonetheless, I expected it to be a rewarding exercise.  My solutions are available at my [AoC 2018 github repo](https://github.com/tk3369/AdventOfCode2018).

## Programming Language
The only way to get better at a programming language is to actually do some work with it. By December, I was totally attached to [Julia](https://julialang.org/) for almost 12 months already. The funny thing is that I could not really go back to any other language. I don’t really know why… maybe it’s due to the Julia’s conciseness or its highly productive environment. I just couldn’t get excited doing anything in Python, JavaScript, etc. Everything else looks like garbage after programming Julia for a while. (BTW, I have not done any survey but I think that’s probably true for many other Julia developers.)

## Good Engineers
I had an observation. Maybe it’s an obvious one.  There are some really good software engineers out there in the wild. The AoC is a timed game. To score even a single point, you must be the first 100 people submitting correct answer to a puzzle. In most cases, people on the leaderboard were turning in within the first 5-15 minutes. I also noticed that the good engineers just kept doing well over and over again. The same top coder always came up and stayed at the top of the leaderboard for a long time.

## The Puzzles
I really enjoyed the AoC puzzles. First of all, there is a storyline starting on Day 1 all the way until Day 25. The people who wrote the puzzles also wrote a holiday-themed story at the same time. Perhaps that’s why I sometimes took more time to read the puzzle than solving it.  It feels odd but occasionally I found myself staring at the puzzle description for 15 minutes before I started working on it.

All puzzles follow the same format. Given some input, perform some kind of logic that arrive at a single number or string as the answer. The problem can stretch a programmer’s design/coding skills in various ways, using different kinds of data structures or having to write efficient code or smart logic to solve a large-scale problem.

Some puzzles are really fun.  On Day 10, we start with a bunch of points of light in the sky and they are all moving in different direction at different speeds.  After some time, the lights would align perfectly and you can see a message.  I did the simulation and produced an animated PNG file using Plots.jl.  After cropping away the unnecessary frames, you can see the message being formed (at frame 15):

![day_10_animation](assets/pages/../../../../assets/pages/aoc2018/day10_anim.gif)

Some puzzles look like computer games. On Day 13, you’re given a railway map where multiple carts run along the track and may turn left, go straight, or turn right at a junction with a predictable logic. The problem is to find out how long it takes all carts to crash into each other eventually. Solving that puzzle is a joy because you are essentially writing a game simulation.  Here’s what a map looks like  The > and v symbols indicates where the cart is going.

![cart](../../assets/pages/aoc2018/cart.png)

I didn’t expect to build an interpreter in a timed programming contest. On Day 16, you are provided a set of assembly-like instructions and you have to implement an interpreter to run the instructions. The second part was even more intriguing. You basically have to figure out the mapping between operation code and machine code based on the program’s output.  To get a taste of the instruction set, take a look at my Julia implementation:

```julia
ops = [
    (:addr, (x, a, b, c) -> x[c+1] = x[a+1] + x[b+1]),
    (:addi, (x, a, i, c) -> x[c+1] = x[a+1] + i),
    (:mulr, (x, a, b, c) -> x[c+1] = x[a+1] * x[b+1]),
    (:muli, (x, a, i, c) -> x[c+1] = x[a+1] * i),
    (:banr, (x, a, b, c) -> x[c+1] = x[a+1] & x[b+1]),
    (:bani, (x, a, i, c) -> x[c+1] = x[a+1] & i),
    (:borr, (x, a, b, c) -> x[c+1] = x[a+1] | x[b+1]),
    (:bori, (x, a, i, c) -> x[c+1] = x[a+1] | i),
    (:setr, (x, a, z, c) -> x[c+1] = x[a+1]),
    (:seti, (x, i, z, c) -> x[c+1] = i),
    (:gtir, (x, i, b, c) -> x[c+1] = i > x[b+1] ? 1 : 0),
    (:gtri, (x, a, i, c) -> x[c+1] = x[a+1] > i ? 1 : 0),
    (:gtrr, (x, a, b, c) -> x[c+1] = x[a+1] > x[b+1] ? 1 : 0),
    (:eqir, (x, i, b, c) -> x[c+1] = i == x[b+1] ? 1 : 0),
    (:eqri, (x, a, i, c) -> x[c+1] = x[a+1] == i ? 1 : 0),
    (:eqrr, (x, a, b, c) -> x[c+1] = x[a+1] == x[b+1] ? 1 : 0)
]
```

The puzzles seemed to get harder each day. On Day 17, you have a 2-D map of clay buckets in various positions. The puzzle asks you to simulate pouring water from the top.  When a bucket is full, the water leaks to the ones below.  The buckets are of different shapes and sizes, thus the simulation logic gets a bit hairy.  To date, my code is still buggy and I haven’t come to the correct solution yet :-}

![bucket](../../assets/pages/aoc2018/buckets.png)

## Final Words

By Day 20, I was exhausted…  Every day, I had been spending over 1-3 hours working on the puzzles and only have few hours of sleep. In addition, I had a vacation planned before Christmas and so I had to stop playing. I hope I will have more time next year.

I really appreciate my family’s understanding when I was not able to spend much time with them before Christmas.  At least, I was able to get some help from my daughter one day when I figured out what do while explaining the puzzle to her.   Thank you, Karen.
