Being a hobbyist Haskell programmer, I have heard the term "monad" a *lot*. In my experience playing with Haskell I have used monads plenty of times, however, it was not until recently that I have come to a digestible understanding of what they really are.

# Think Method Chaining
Some of the prominent phrases which I hear being used to describe monads are "they're ways to fake state" and "they are really just a form of method chaining." Although, in my (perhaps nieve) understanding of monads, both of these statements are true, the latter has been far more *useful* in helping me arrive at a useful understanding of "the m word." So I encourage anyone who may be struggling with the definition of a monad to do the same: *think method chaining*.

# Method Chaining You Say?
Yes method chaining. In the object oriented world this may mean something like this:
```
someObject.someMethod(1)
          .otherMethod("Pizza")
          .finalMethod()
```
So, in OOP, the objects returned by each of these methods would encapsulate state. Now, in Haskell, there is not really a concept of state, things are what they are. The sequential mutilation of objects is not something Haskell supports naturally, so it uses the monad as a slick way to sort of "fake state."

# What It Looks Like
*Disclaimer: this is my current understand of Haskellian monads, and not the similar but slightly different, mathematically definition of monads*

To build a monad, two main functions are necessary as well as a monadic type. First I'll discuss a monadic type.

# Monadic Type
A monad's type can be whatever it needs to be. Perhaps one of the most famous ones in the Haskell world it the `Maybe` monad, which is defined simply as:
```
data Maybe a = Nothing | Just a
```
`Maybe` is one of the most beautiful aspects of Haskell. It is very similar to `null` or `nil` in other languages, but what makes it different is the fact that (as I understand it) in Haskell's pure, functional model, `Maybe` cannot go unhandled or pop up in unexpected places. In my mind, it is a kind of a neat and precise example of a monadic type.

# The `return` Function
Another thing a monad needs is a `return` function whose signature looks like:
```
return :: a -> m a
```
`return` is simply a function whose purpose is to construct the monadic type. Pretty simple, eh? So for `Maybe`, this might be as simple as:
```
return n = Just n
```

# The Bind Function
The other function needed by a monad, the function that truly brings out the magic, is the bind function which is usually denoted as `(>>=)` in the Haskell world. In the OOP example above, the bind function is kind of like the periods in between the different calls, but oh so much more magical. Bind's signature looks like:
```
(>>=) :: m a -> (a -> m b) -> m b
```
So, let's break this down.

The first thing that bind takes is a monadic type. So, this could be something as simple as `Just 5` or whatever monadic type you are operating on. The second parameter is a function that takes the type boxed by the first parameter (the monadic type) and returns a monadic type boxing `b` (which could be the same type as `a` but by no means *must* be). In the end, bind returns another monadic type, as returned by the middle parameter.

All in all, this seems like a lot to swallow, and, uh, what does this have to do with method chaining or our `return` function?

Remember, bind is really one of those strange infix operators, so if I may make some simplifications, it kind of looks like:
```
a thing >>= function that returns another thing
```
In this simplification, "thing" is substituted for "monadic type" to make bind easier to swallow. The point is, all this whole mess does is return another monadic type! So, there's nothing keeping me from implementing another bind operator (or reusing the same one, if applicable) like such:
```
a thing >>= function that returns another thing >>= function that returns yet another thing ...
```
See what I mean about this being like the "period between" in that above OOP example? All bind really does is take some value (wrapped in a monad) and apply some function to it, and re-wrap the output!

`return` is pretty cool because a lot of the time it comes at the end of all the binding (wow, a return at the end? Sounds like some other paradigms out there). `return` is really the end game, the termination of the "chaining."

# Parting Words
In conclusion, I hope I have shed some light on what can be a very difficult topic to understand. If you would like to learn more, the Haskell community has a [great article on monads]{http://www.haskell.org/haskellwiki/All_About_Monads} also there are some really awesome answers to the question of "what is a monad" on [SO]{http://stackoverflow.com/questions/44965/what-is-a-monad}.
