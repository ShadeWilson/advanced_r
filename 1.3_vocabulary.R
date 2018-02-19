##### Advanced R #####
# By Hadley Wickham
# Section 1: FOUNDATIONS
# Chapter 3: Vocabulary

# BASICS ------------------------------------------------------------------

# The first functions to learn
# ?
# str

# Important operators and assignment
# %in%, match
# =, <-

# <<- : most useful in conjunction with closures to maintain state. 
# A closure is a function written by another function. Closures are so called because they enclose the environment of the parent function, and can access all variables and parameters in that function. This is useful because it allows us to have two levels of parameters. One level of parameters (the parent) controls how the function works. The other level (the child) does the work. The following example shows how can use this idea to generate a family of power functions. The parent function (power) creates child functions (square and cube) that actually do the hard work.
power <- function(exponent) {
  function(x) x ^ exponent
}

square <- power(2)
square(2) # -> [1] 4
square(4) # -> [1] 16

cube <- power(3)
cube(2) # -> [1] 8
cube(4) # -> [1] 64

#The ability to manage variables at two levels also makes it possible to maintain the state across function invocations by allowing a function to modify variables in the environment of its parent. Key to managing variables at different levels is the double arrow assignment operator  <<-. Unlike the usual single arrow assignment (<-) that always works on the current level, the double arrow operator can modify variables in parent levels.

#This makes it possible to maintain a counter that records how many times a function has been called, as the following example shows. Each time new_counter is run, it creates an environment, initialises the counter i in this environment, and then creates a new function.

new_counter <- function() {
  i <- 0
  function() {
    # do something useful, then ...
    i <<- i + 1
    i
  }
}

# The new function is a closure, and its environment is the enclosing environment. When the closures counter_one and counter_two are run, each one modifies the counter in its enclosing environment and then returns the current count.

counter_one <- new_counter()
counter_two <- new_counter()

counter_one() # -> [1] 1
counter_one() # -> [1] 2
counter_two() # -> [1] 1

#   $, [, [[, head, tail, 
# subset return subsets of vectors, matrices or data frames which meet conditions.
# rows where temp is greater than 0, two columns: ozone and temp
subset(airquality, Temp > 80, select = c(Ozone, Temp))

# with(data, expr)
# with is a generic function that evaluates expr in a local environment constructed from data
with(mtcars, mpg[cyl == 8  &  disp > 350])
# is the same as, but nicer than
mtcars$mpg[mtcars$cyl == 8  &  mtcars$disp > 350]

# assign
assign(j_root_name, j_root, envir = .GlobalEnv)
for(i in 1:6) { #-- Create objects  'r.1', 'r.2', ... 'r.6' --
  nam <- paste("r", i, sep = ".")
  assign(nam, 1:i)
}

# get
# Search by name for an object (get) or zero or more objects (mget).
get("%o%")


# Comparison --------------------------------------------------------------

# all.equal, identical
# all.equal(x, y) is a utility to compare R objects x and y testing ‘near equality’.
all.equal(pi, 355/113)
# not precise enough (default tol) > relative error
d45 <- pi*(1/4 + 1:10)
all.equal(tan(d45), rep(1, 10)) 

# identical: The safe and reliable way to test two objects for being exactly equal
identical(1, NULL) ## FALSE -- don't try this with ==
identical(1, 1.)   ## TRUE in R (both are stored as doubles)
identical(1, as.integer(1)) ## FALSE, stored as different types
identical(1L, as.integer(1)) ## TRUE, both are integers

# !=, ==, >, >=, <, <=
#   is.na
# complete.cases: 
# Return a logical vector indicating which cases are complete, i.e., have no missing values.
x <- airquality[, -1] # x is a regression design matrix
y <- airquality[,  1] # y is the corresponding response

stopifnot(complete.cases(y) != is.na(y))
ok <- complete.cases(x, y)
sum(!ok) # how many are not "ok" ?

# is.finite


# Basic math --------------------------------------------------------------

# *, +, -, /, ^, 
# %%: modulus,
5 %% 2 # 1
1093210 %% 10 # 0

# %/%: integer division
5 %/% 2 # 2
1093210 %/% 10 # 109321

#   abs, sign
sign(pi)    # == 1
sign(-2:3)  # -1 -1 0 1 1 1

# acos, asin, atan, atan2 (2 argument arc-tan)
# sin, cos, tan

# ceiling, floor, round, trunc, signif

# ceiling takes a single numeric argument x and returns a numeric vector containing the smallest integers
# not less than the corresponding elements of x.

# floor takes a single numeric argument x and returns a numeric vector containing the largest integers not
# greater than the corresponding elements of x.
# 
# trunc takes a single numeric argument x and returns a numeric vector containing the integers formed by
# truncating the values in x toward 0.
# 
# round rounds the values in its first argument to the specified number of decimal places (default 0).
# 
# signif rounds the values in its first argument to the specified number of significant digits.

nums <- .5 + -2:4 # -1.5 -0.5  0.5  1.5  2.5  3.5  4.5
ceiling(nums)     # -1  0  1  2  3  4  5
floor(nums)       # -2 -1  0  1  2  3  4
trunc(nums)       # -1  0  0  1  2  3  4
round(nums)       # -2  0  0  2  2  4  4

# exp, log, log10, log2, sqrt
# 
# max, min, prod, sum
# cummax, cummin, cumprod, cumsum, diff
cumsum(1:10) # 1  3  6 10 15 21 28 36 45 55
cumprod(1:10) # 1       2       6      24     120     720    5040   40320  362880 3628800
cummin(c(3:1, 2:0, 4:2)) # 3 2 1 1 1 0 0 0 0
cummax(c(3:1, 2:0, 4:2)) # 3 3 3 3 3 3 4 4 4

# pmax, pmin: Returns the (regular or parallel) maxima and minima of the input values.
min(5:1, pi)  # -> one number
pmin(5:1, pi) # -> 5  numbers

# range
# mean, median, cor, sd, var
# rle: Run Length Encoding
# Compute the lengths and values of runs of equal values in a vector -- or the reverse operation
x <- rev(rep(6:10, 1:5))
rle(x)
## lengths [1:5]  5 4 3 2 1
## values  [1:5] 10 9 8 7 6


# Functions to do with functions ------------------------------------------

# function
# missing
# missing can be used to test whether a value was specified as an argument to a function.
myplot <- function(x, y) {
  if(missing(y)) {
    y <- x
    x <- 1:length(y)
  }
  plot(x, y)
}

myplot(rep(1:5, 1:5))

# on.exit: useful for resetting graphical params or performng other cleanup actions
# The advantage of on.exit is that is gets called when the function exits, 
# regardless of whether or not an error was thrown
read_chars <- function(file_name) {
  conn <- file(file_name, "r")
  on.exit(close(conn))
  readChar(conn, file.info(file_name)$size)
}

tmp <- tempfile()
cat(letters, file = tmp, sep = "")
read_chars(tmp)

# return, invisible


# Logical & sets ----------------------------------------------------------

# &, |, !, xor
# Apply an exclusive-or check across two vectors using xor
# isTRUE for logical vector of length 1
xor(TRUE, TRUE) # FALSE: only one can be true in exclusive or check
xor(1, 0)       # TRUE, coercible to logical
xor(c(TRUE, TRUE, FALSE, FALSE), # FALSE TRUE TRUE FALSE, compares index 1 of each vector, then 2, etc
    c(TRUE, FALSE, TRUE, FALSE))

# isTRUE will only return TRUE when its argument is exactly TRUE
isTRUE(1)
isTRUE(TRUE)
isTRUE(FALSE)
isTRUE(list(TRUE))

# all: Given a set of logical vectors, are all of the values true?
range(x <- sort(round(stats::rnorm(10) - 1.2, 1)))
if(all(x < 0)) cat("all x values are negative\n")

# any: Given a set of logical vectors, is at least one of the values true?
range(x <- sort(round(stats::rnorm(10) - 1.2, 1)))
if(any(x < 0)) cat("x contains negative values\n")

# intersect, union, setdiff, setequal
# which

# Vectors and matrices
# c, matrix
# # automatic coercion rules character > numeric > logical
# length, dim, ncol, nrow
# cbind, rbind
# names, colnames, rownames
# t: matrix transpose
# diag
# sweep
# as.matrix, data.matrix

# Making vectors
# c
# rep, rep_len
# seq, seq_len, seq_along
# rev
# sample
# choose, factorial, combn
factorial<- function(n) {
  if (n >= 0 & n < 2) {
    return(n)
  } else {
    return(n * factorial(n - 1))
  }
}

factorial(7)

# (is/as).(character/numeric/logical/...)

# Lists & data.frames
# list, unlist
l.ex <- list(a = list(1:5, LETTERS[1:5]), b = "Z", c = NA)
unlist(l.ex, recursive = FALSE)
unlist(l.ex, recursive = TRUE)

# data.frame, as.data.frame
# split
# expand.grid

# Control flow
# if, &&, || (short circuiting)
# for, while
# next, break
# switch
# ifelse

# Apply & friends
# lapply, sapply, vapply
lapply(1:5, function(x) rep("HA ", x))
# apply
# tapply
# replicate
