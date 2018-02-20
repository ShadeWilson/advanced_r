##### Advanced R #####
# By Hadley Wickham
# Section 1: FOUNDATIONS
# Chapter 5: Functions


# Function components -----------------------------------------------------

# all R functions have three parts: the body, the formals (list of args), and the environment
# when you print a function it shows you these three components 
f <- function(x) x^2
f

formals(f)
body(f)
environment(f)

# The assignment forms of body(), formals(), and environment() can also be used to modify functions.
# functions can also contain any number of attributes

# PRIMITIVE FUNCTIONS
# one exception to the rule of 3 components: primitive functions like sum(), which call C code
# directly with .Primitive() and contain no R code
sum
formals(sum)
body(sum)
environment(sum)

# primitive functions are only found in the base packages

# Exercises

# 1
is.function(sum)
is.primitive(sum)

# 2
objs <- mget(ls("package:base"), inherits = TRUE)
funs <- Filter(is.function, objs)

# which base function has the most args?
num_args <- lapply(funs, function(x) length(formals(x)))
num_args <- sort(unlist(num_args), decreasing = TRUE) # scan has 22 arguments

# how many have 0 args?
length(num_args[num_args == 0]) # 226 have 0 args
num_args[num_args == 0] # +, -, /, *, is.*, and primitive I think

# only primitive
funs <- Filter(is.primitive, objs)

# printing a functin doesnt show the environment when it was created in the global env

# Lexical scoping ---------------------------------------------------------

# R has two types of scoping:
# lexical scoping, implemented automatically at the language level
# dynamic scoping, used in select functions to save typing during interactive analysis

# There are four basic principles behind R’s implementation of lexical scoping:
# 1) name masking
# 2) functions vs. variables
# 3) fresh start
# 4) dynamic lookup

# NAME MASKING
f <- function() {
  x <- 1
  y <- 2
  c(x, y)
}
f()
rm(f)

# if a name isn't defined inside a function, R will look one level up
x <- 2
g <- function() {
  y <- 1
  c(x, y)
}
g()
rm(x, g)

# same rules apply if a function is defined within another function
x <- 1
h <- function() {
  y <- 2
  i <- function() {
    z <- 3
    c(x, y, z)
  }
  i()
}
h()
rm(x, h)

# same rules apply to closures, functions created by other functions
j <- function(x) {
  y <- 2
  function() {
    c(x, y)
  }
}
k <- j(1)
k()
rm(j, k)

# FUNCTIONS VS VARIABLES
# finding functions works the same as finding variables
l <- function(x) x + 1
m <- function() {
  l <- function(x) x * 2
  l(10)
}
m()
rm(l, m)

# for functions, If you are using a name in a context where it’s obvious that you want a 
# function (e.g., f(3)), R will ignore objects that are not functions while it is searching
# best to avoid overlapping names tho
n <- function(x) x / 2
o <- function() {
  n <- 10
  n(n)
}
o()

rm(n, o)

# A FRESH START
# every time a function is called, a new environment is created to host execution
# function has no idea of what happened last time it was ran
j <- function() {
  if (!exists("a")) {
    a <- 1
  } else {
    a <- a + 1
  }
  a
}
j()
rm(j)

# DYNAMIC LOOKUP
# R looksfor values when the function is run, not when it's created
f <- function() x
x <- 15
f()
x <- 20
f()

# generally want to avoid this behavior! can be problematic and you may not realize at first
f <- function() x + 1
codetools::findGlobals(f) # find external dependencies

# can also manually change the environment
environment(f) <- emptyenv()
f()

# this doesn't work bc R uses lexical scoping to find EVERYTHING, including the + operator
# never possible to make a function entirely self-contained

# can use this idea to do some ill-advised things
# can overwrite the standard operators with your own alternatives
# This will introduce a particularly pernicious bug: 10% of the time, 
# 1 will be added to any numeric calculation inside parentheses
`(` <- function(e1) {
  if (is.numeric(e1) && runif(1) < 0.1) {
    e1 + 1
  } else {
    e1
  }
}
replicate(50, (1 + 2))
rm("(")

# this would make additions multiplications instead!
`+` <- function(e1, e2) e1 * e2
3 + 5
rm(`+`)

# Exercises
c <- 10
c(c = c)

f <- function(x) {
  f <- function(x) {
    f <- function(x) {
      x ^ 2
    }
    f(x) + 1
  }
  f(x) * 2
}
f(10)













