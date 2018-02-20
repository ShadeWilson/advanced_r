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


