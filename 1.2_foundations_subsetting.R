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

