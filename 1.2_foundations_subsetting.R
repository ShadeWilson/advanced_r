##### Advanced R #####
# By Hadley Wickham
# Section 1: FOUNDATIONS
# Chapter 2: Subsetting

# DATA TYPES --------------------------------------------------------------

# start with [

## ATOMIC VECTORS
x <- c(2.1, 4.2, 3.3, 5.4)

# five things you can subset with:
# 1) Positive integers: return elements at specified positions
x[c(3, 1)]
x[order(x)]

# Duplicated indices yield duplicated values
x[c(1, 1)]

# Real numbers are silently truncated to integers
x[c(2.1, 2.9)]

# 2) Negative integers: omit elements at specified positions
x[-c(3, 1)]

# Note: can't mox positive and negative

# 3) Logical vectors: select elements where corresponding value is true
x[c(TRUE, TRUE, FALSE, FALSE)]
x[x > 3]

# if logical vector is shorter than subsetted vector, it will be recycled
x[c(TRUE, FALSE)]
# Equivalent to
x[c(TRUE, FALSE, TRUE, FALSE)]

# missing value in index always yields a missing value in output
x[c(TRUE, TRUE, NA, FALSE)]

# 4) Nothing: returns original vector. more useful for matrices, dfs, arrays
x[]

# 5) Zero: returns a zero-length vector. maybe useful for generating test data
x[0]

# If vector is named, can use character vectors
(y <- setNames(x, letters[1:4]))
y[c("d", "c", "a")]

# Like integer indices, you can repeat indices
y[c("a", "a", "a")]

# When subsetting with [ names are always matched exactly
z <- c(abc = 1, def = 2)
z[c("a", "d")]

# Subsetting in lists is the same as atomic vectors
# using [ always returns a list; 
# [[ and $ extract components

## MATRICES AND ARRAYS
# can subset in three ways:
# with multiple vectors, a single vector, with a matrix

# generalization of 1d subsetting
a <- matrix(1:9, nrow = 3)
colnames(a) <- c("A", "B", "C")
a[1:2, ]

a[c(TRUE, FALSE, TRUE), c("B", "A")]
a[0, -2]

# subset with a single vector
(vals <- outer(1:5, 1:5, FUN = "paste", sep = ","))
vals[c(4, 15)]

# can also subset with an int matrix (or char matrix if named)
select <- matrix(ncol = 2, byrow = TRUE, c(
  1, 1,
  3, 1,
  2, 4
))
vals[select]

## DATA FRAMES
# subset with a single vector they behave like lists
# subset with two vectors, they behave like matrices
df <- data.frame(x = 1:3, y = 3:1, z = letters[1:3])

df[df$x == 2, ]
df[c(1, 3), ]

# There are two ways to select columns from a data frame
# Like a list:
df[c("x", "z")]
# Like a matrix
df[, c("x", "z")]

# There's an important difference if you select a single 
# column: matrix subsetting simplifies by default, list 
# subsetting does not.
str(df["x"])
df[, "x"] # name is dropped, other attributes probs

# can use these subsetting operators for S3 objects,
# S4 have two additional: @ (equiv to $) and slot() (equiv to [[)

# Exercises
# 1
mtcars[mtcars$cyl == 4, ]
mtcars[-(1:4), ]
mtcars[mtcars$cyl <= 5, ]
mtcars[mtcars$cyl %in% c(4, 6), ]

# 2
x <- 1:5
x[NA] # logical vector that is recycled, returning NAs for all values
x[NA_real_] # NA_real_ is a number na so it only returns 

# 3
x <- outer(1:5, 1:5, FUN = "*")
x[upper.tri(x)] # returns triangle (peak 2nd row, grows by one each additional col)
# upper.tri returns a logical vector, true if in tri

# 4
mtcars[1:20] # returns col 1-20 (most of which dont exist so it fails)
mtcars[1:20, ] # returns row 1-20

# 5
x
y <- matrix(1:21, nrow = 3)
diag(y)

diagonals <- function(x) {
  cols <- ncol(x)
  rows <- nrow(x)
  
  if (cols < rows) {
    iterations <- cols
  } else {
    iterations <- rows
  }
  answer <- vector("double", length = iterations)
  
  for (i in 1:iterations) {
    answer[i] <- x[i, i]
  }
  answer
}

diagonals(y)

# 6
df[is.na(df)] <- 0

# SUBSETTING OPERATORS ----------------------------------------------------

# Two other subsetting operators: [[ and $ 
# [[ is similar to [, except it can only return a single value and it allows you to 
# pull pieces out of a list

# NEED [[ when working with lists because when [ is applied to a list it always returns a list.
# it never give the actual contents of the list

# “If list x is a train carrying objects, then x[[5]] is the object in car 5; x[4:6] is a train of cars 4-6.”

# Because it can only return a single value, you must use [[ with either a single
# positive integer or a string

a <- list(a = 1, b = 2)
a[[1]]
a[["a"]]

# If you do supply a vector it indexes recursively
b <- list(a = list(b = list(c = list(d = 1))))
b[[c("a", "b", "c", "d")]]
typeof(b[["a"]])

# Same as
# subseting the vector b with a with b with c with d
b[["a"]][["b"]][["c"]][["d"]]

# Data frames are lists of columns, so you can use [[  to extract a column from data frames
mtcars[[1]]
mtcars[["cyl"]]

## SIMPLIFYING VS PRESERVING SUBSETTING

# Simplifying: returns the simplest possible data structure and usually gives you what you want
# Preserving: keeps the structure the same, generally better for programming bc the 
# result will always be the same type.

# omitting drop = FALSE when subsetting matrices and dfs is a common source of errors

# Vector
x[[1]] # simplifying
x[1]   # preserving

# list
x[[1]] # simplifying
x[1]   # preserving

# Factor
x[1:4, drop = T] # simplifying
x[1:4]           # preserving

# Array
x[1, ]; x[, 1]                     # simplifying
x[1, , drop = F]; x[, 1, drop = F] # preserving

# Data frame
x[, 1]; x[[1]]         # simplifying
x[, 1, drop = F]; x[1] # preserving

# Preserving is the same for all data types: the output is the same as the input.
# Simplifying differs for different data types:

# Atomic: removes names
x <- c(a = 1, b = 2)
x[1]   # preserve
x[[1]] # simplify. names are dropped

# List: returns the object inside the list, not a single element list
y <- list(a = 1, b = 2)
str(y[1])
str(y[[1]])

# Factor: drops any unused levels
z <- factor(c("a", "b"))
z[1]
z[1, drop = TRUE]

# Matrix or array: if any of the dimensions has length 1, drops that dimension
a <- matrix(1:4, nrow = 2)
a[1, , drop = FALSE]
a[1, ]

# Data frame: if output is a single column, returns a vector instead of a data frame
df <- data.frame(a = 1:2, b = 1:2)
str(df[1])                   # df
str(df[, "a", drop = FALSE]) # still df
str(df[, "a"])               # simplified!

## $

# $ is the shorthand operatorwhere x$y == x[["y", exact = FALSE]]
# common mistake: try to use $ when you have the name of a column stored in a var
var <- "cyl"
# Doesn't work - mtcars$var translated to mtcars[["var"]]
mtcars$var

# Instead use [[
mtcars[[var]]

# There’s one important difference between $ and [[. $ does partial matching:
x <- list(abc = 1)
x$a == x$abc # TRUE!
x[["a"]]     # NULL


## MISSING/OUT OF BOUNDS INDICES 

# [ and [[ differ slightly in their behavior when the index is out of bounds (OOB)
x <- 1:4
str(x[5])   # get NA_real_ back
str(x[[5]]) # error
str(x[NA_real_])
str(x[NULL])

# Exercises
# 1
mod <- lm(mpg ~ wt, data = mtcars)
resids <- mod[["residuals"]]

summary <- summary(mod)
summary$r.squared

# SUBSETTING AND ASSIGNMENT -----------------------------------------------

# All subsetting operators can be combined with assignment to modify selected 
# values of the input vector.
x <- 1:5
x[c(1, 2)] <- 2:3
x

# The length of the LHS needs to match the RHS
x[-1] <- 4:1
x

# Note that there's no checking for duplicate indices
x[c(1, 1)] <- 2:3 # switches 2 in for position 1, and then overwrites to 3 
x

# You can't combine integer indices with NA
x[c(1, NA)] <- c(1, 2)

# But you can combine logical indices with NA
# (where they're treated as false).
x[c(T, F, NA)] <- 1 # replaces first position with 1 (bc its true), then recycled and replaces
x                   # position 4 with 1

# This is mostly useful when conditionally modifying vectors
df <- data.frame(a = c(1, 10, NA))
df$a[df$a < 5] <- 0
df$a

# Subsetting with nothing along with assignment can be useful bc it preserves the original object
# class and structure
mtcars[] <- lapply(mtcars, as.integer) # mtcars remains a df
mtcars <- lapply(mtcars, as.integer)   # mtcars now becomes a list

# With lists, you can use subsetting, assignment, and NULL to remove components from a list
# To add a literal NULL to a list, use [ and list(NULL):
x <- list(a = 1, b = 2)
x[["b"]] <- NULL
str(x) # the b part of list is dropped

y <- list(a = 1)
y["b"] <- list(NULL)
str(y) # b is added to list

# APPLICATIONS ------------------------------------------------------------

# LOOKUP TABLES: character subsetting

# character matching provides a powerful way to make look up tables
x <- c("m", "f", "u", "f", "f", "m", "m")
lookup <- c(m = "Male", f = "Female", u = NA)
lookup[x]
unname(lookup[x]) # converts named vector to just the values! Drops names

# Or with fewer output values
c(m = "Known", f = "Known", u = "Unknown")[x]

# MATCHING and MERGING by HAND
grades <- c(1, 2, 2, 3, 1)

info <- data.frame(
  grade = 3:1,
  desc = c("Excellent", "Good", "Poor"),
  fail = c(F, F, T)
)

# want to duplicate the info table so that we have a row for each value in grades
# can either use match() and integer subsetting or rownames() and chaacter subsetting
grades

# Using match
id <- match(grades, info$grade)
info[id, ]

# Using rownames
rownames(info) <- info$grade
info[as.character(grades), ]

## RANDOM SAMPLES/BOOTSTRAPPING (integer subset)

# You can use integer indices to perform random sampling or bootstrapping of a vector 
# or data frame. sample() generates a vector of indices, then subsetting to access the values:
df <- data.frame(x = rep(1:3, each = 2), y = 6:1, z = letters[1:6])

# Set seed for reproducibility
set.seed(10)

# Randomly reorder
df[sample(nrow(df)), ]

# Select 3 random rows
df[sample(nrow(df), 3), ]

# Select 6 bootstrap replicates
df[sample(nrow(df), 6, rep = T), ] # can duplicate and index

## ORDERING (integer subsetting)

# order() takes a vector as input, returns an int vector
x <- c("b", "c", "a")
order(x)
x[order(x)]

# can specify additional args like decreasing = TRUE and na.last = NA to remove NAs (default they
# go on end)

# Randomly reorder df
df2 <- df[sample(nrow(df)), 3:1]
df2

df2[order(df2$x), ]      # orders the column x
df2[, order(names(df2))] # orders col names

## EXPANDING AGGREGATED COUNTS (integer subsetting)

# rep() and integer subetting make it easy to uncollapse data by subsetting with a repeated row
# index
df <- data.frame(x = c(2, 4, 1), y = c(9, 11, 6), n = c(3, 5, 1))
rep(1:nrow(df), df$n)
df[rep(1:nrow(df), df$n), ]

## REMOVING COLS FROM A DF (character subsetting)

# Two ways: 
# set individual cols to NULL
df <- data.frame(x = 1:3, y = 3:1, z = letters[1:3])
df$z <- NULL

# or can subset only the cols you want
df <- data.frame(x = 1:3, y = 3:1, z = letters[1:3])
df[c("x", "y")]

# If you know the columns you don’t want, use set operations to work out which colums to keep:

df[setdiff(names(df), "z")]

## SELECTING ROWS BASED ON A CONDITION (logical subsetting)
rm(mtcars)
mtcars[mtcars$gear == 5, ]
mtcars[mtcars$gear == 5 & mtcars$cyl == 4, ]

# Remember to use the vector boolean operators & and |, 
# not the short-circuiting scalar operators && and ||
# which are more useful inside if statements

# !(X & Y) is the same as !X | !Y
# !(X | Y) is the same as !X & !Y

# subset() a specialised shorthand function for subsetting data frames
subset(mtcars, gear == 5)
subset(mtcars, gear == 5 & cyl == 4)

## BOOLENA ALGEBRA vs. SETS (logical and integer subsetting)

# using set operations is more effective when:
# 1) you want to find the first (or last) TRUE
# 2) you have very few trues and very many falses, a set representation may be faster and require
# less storages

# which() allows you to convert a boolean representation to an integer representation
x <- sample(10) < 4
which(x)

unwhich <- function(x, n) {
  out <- rep_len(FALSE, n)
  out[x] <- TRUE
  out
}

unwhich(which(x), 10)

(x1 <- 1:10 %% 2 == 0)
(x2 <- which(x1))

(y1 <- 1:10 %% 5 == 0)
(y2 <- which(y1))



# X & Y <-> intersect(x, y)
x1 & y1
intersect(x2, y2)

# X | Y <-> union(x, y)
x1 | y1
union(x2, y2)

# X & !Y <-> setdiff(x, y)
x1 & !y1
setdiff(x2, y2)

# xor(X, Y) <-> setdiff(union(x, y), intersect(x, y))
xor(x1, y1)
setdiff(union(x2, y2), intersect(x2, y2)) # only nums that appear in one

# Exercises
# 1
df
df[sample(nrow(df)), sample(nrow(df))]

# 2
m <- sample(nrow(mtcars), 1)
mtcars[sample(nrow(mtcars), m), ]

first_row <- sample(nrow(mtcars), 1)
final_row <- first_row + m
rows <- first_row:final_row

rows[rows > nrow(mtcars)] <- rows[rows > nrow(mtcars)] - nrow(mtcars)

rows
  
mtcars[rows, ]

# 3
df <- df[3:1]
df[, order(colnames(df))]
