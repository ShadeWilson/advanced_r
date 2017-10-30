##### Advanced R #####
# By Hadley Wickham
# Section 1: FOUNDATIONS
# Chapter 1: Data Structures
library(tidyverse)

# R's base data structures can be arranged by their dimentionality:
#     Homogenous              Heterogeneous
#     ----------              -------------
# 1d: Atomic vector           List
# 2d: Matrix                  Data frame
# nd: Array

# Note: R has no scalars
# str() is best way to understadn what a data structure is made of


# VECTORS -----------------------------------------------------------------

# come in two flavors: atomic and list
# three properties:
# 1) type, typeof()
# 2) length, length()
# 3) Attributes, attributes(): additional arbitrary metadata

# Note: is.vector() doesn't test if an object is actually a vector, it returns true if
# object is a vector with no attributes other than name.
# Use is.atomic(x) || is.list(x) to test if it is actually a vector
is.true.vector <- function(x) {
  is.atomic(x) || is.list(x)
}

## ATOMIC VECTORS

# four types of common atomic vectors: logical, integer, double (numeric), character
# two rare types: complex and raw

# usually create with c()
dbl_var <- c(1, 2.5, 4.5)
# With the L suffix, you get an integer rather than a double
int_var <- c(1L, 6L, 10L)
# Use TRUE and FALSE (or T and F) to create logical vectors
log_var <- c(TRUE, FALSE, T, F)
chr_var <- c("these are", "some strings")

# atomic vectors are always flat, even if you nest c()s
c(1, c(2, c(3, 4)))
c(1, 2, 3, 4)

# NA is normally logical vector of length 1, can coerce into different type inside c()
# or can specify with NA_real_ (double), NA_integer_ (int), NA_character_

## TYPES AND TESTS
# determine type with typeof() or more specifically with an is functions
int_var <- c(1L, 6L, 10L)
typeof(int_var)
is.integer(int_var)
is.atomic(int_var)

## COERCION

# All elements of an atomic vector must be the same type, so when you attempt to combine different
# types they will be coerced to the most flexible type. 
# Types from least to most flexible are: logical, integer, double, and character.
str(c("a", 1))

## LISTS

# elements of a list can be of any type
x <- list(1:3, "a", c(TRUE, FALSE, TRUE), c(2.3, 5.9))
str(x)

# c() will combine several lists into 1. If given a combo of atomic vectors and lists, c()
# will coerce vector to lists before combining them
x <- list(list(1, 2), c(3, 4))
y <- c(list(1, 2), c(3, 4))
str(x)
str(y)

# can test of lists with is.list()
# coerce to lists wiht as.ist()
# can turn a list to atomic vector with unlist() (coerced to same type)
is.list(mtcars)

x <- tribble(
  ~a,   ~b,
  "a", "b",
  "c", "d",
  "e", "f"
)

x <- x %>% mutate(comb = paste(a, b, sep = "-"))
unlist(stringr::str_split(x$comb, "-"))


## Exercises

c(1, FALSE)
c("a", 1)
c(list(1), "a")
c(TRUE, 1L)
  

# ATTRIBUTES --------------------------------------------------------------

# can be thought of as a names list
# can be accesse individually with attr() or all at once with attributes()
y <- 1:10
attr(y, "my_attribute") <- "This is a vector"
attr(y, "my_attribute")
attributes(y)
str(attributes(y))

# structure() returns a new object with modified attributes
structure(1:10, my_attribute = "This is a vector", name = "x")

# By default, most attributes are lost when modifying a vector
attributes(y)
attributes(y[1])
attributes(sum(y))

# The only attributes not lost are the three most important:
# Names, a char vector giving each element a name, names()
# Dimensions, used to turn vectors into matrices and arrays
# Class, used to implement the S3 object system

# each of these atttributes has a specific accessor function to get/set values
# names(), dim(), class() --- not attr(x, "names"), etc

## NAMES

# can name a vector three ways:
# 1) When creating it:
x <- c(a = 1, b = 2, c = 3)
# 2) by modifying an existing vector in place: 
x <- 1:3
names(x) <- c("a", "b", "c")
# 3) By creating a modified copy of a vector:
x <- setNames(1:3, c("a", "b", "c"))

# Names dont have to be unique however they should be to be useful in subsetting
# If some names are missing when vector is created, the names will be set to empty strings
# If you modify the vector in place by setting some, names() will return NA (NA_character_) for
# the missing ones. If all names are missing, names() returns NULL
y <- c(a = 1, 2, 3)
names(y)

v <- c(1, 2, 3)
names(v) <- c('a')
names(v)

z <- c(1, 2, 3)
names(z)

# You can create a new vector without names using unname() 
# or remove names in place with names(x) <- NULL

## FACTORS

# used to store categorical data 
# factors are built on top of integer vectors using two attributes:
# 1) class, "factor",
# 2) levels, which defines the set of allowed values

x <- factor(c("a", "b", "b", "a"))
x

class(x)

# You can't use values that are not in the levels
x[2] <- "c"

# NB: you can't combine factors
c(factor("a"), factor("b"))

# useful when you have a set number of types of obs, even if data set doesnt have them all
sex_char <- c("m", "m", "m")
sex_factor <- factor(sex_char, levels = c("m", "f"))

table(sex_char)
table(sex_factor)

# Sometimes a nonfactor column is read in as a factor
# caused by a non-numeric value in the column
# need to coerce the col from factor to char and then to int/double
# and THEN check for NAs

# better to avoid this in data parsing:
# using na.strings in read.csv() is a good start

# most file reading programs in R read in char vectors automatically as factors
# use stringsAsFactors = FALSE

# factors look like char vectors but are really integers

# Care treating factors as charactersQ
# gsub() and grep() convert factors to strings
# c() uses the underlying integer values

# best to explicitly convert to character vectors if need to work with strings

# Exercises
# 1
structure(1:5, comment = "my attribute")
# 2
# it reorganizes based on new levels
f1 <- factor(letters)
levels(f1) <- rev(levels(f1))
# 3
# reverses the array, but the original levels of the factors is the same
f2 <- rev(factor(letters))

# levels are reversed, but the vector keeps original order
f3 <- factor(letters, levels = rev(letters))

# MATRICES AND ARRAYS -----------------------------------------------------

# adding a dim attribute to an atomic vector allows it to act like a multidimentional array
# matrix is a special case of array (has 2 dimentions
# matrix(), array()
# use the assignment form dim()

# Two scalar arguments to specify rows and columns
a <- matrix(1:6, ncol = 3, nrow = 2)
# One vector argument to describe all dimensions
b <- array(1:12, c(2, 3, 2))

# You can also modify an object in place by setting dim()
c <- 1:6
dim(c) <- c(3, 2)

dim(c) <- c(2, 3)
c

# length() and names() have higher dimentional generalizations
# length: nrow(), ncol() for matrices, dim() for arrays
# names: rownames(), colnames() for matrices and dimnames() for arrays
length(a)
nrow(a)
ncol(a)

rownames(a) <- c("A", "B")
colnames(a) <- c("a", "b", "c")
a

length(b)
dim(b)
dimnames(b) <- list(c("one", "two"), c("a", "b", "c"), c("A", "B"))
b

# c() generalizes to cbind() and rbind() for matrices
# and to abind() for arrays
# transpose a matrix with t()

# test: is.matrix(), is.array() 

# Exercises
# 1
b <- c(1:10)
dim(b)
# returns NULL

# 3
x1 <- array(1:5, c(1, 1, 5))
x2 <- array(1:5, c(1, 5, 1))
x3 <- array(1:5, c(5, 1, 1))

# DATA FRAMES -------------------------------------------------------------

# under the hood, a date frame is a list of equal-length vectors
# shares propreties of both matrices and lists

# create with data.frame()
# default turns strings to factors, so use stringsAsFactors = FALSE
df <- data.frame(
  x = 1:3,
  y = c("a", "b", "c"),
  stringsAsFactors = FALSE)
str(df)

## TESTING AND COERCION
# bc data.frame is an S3 class its type reflects the underlying vector used to bulld it
# class() to check for df
typeof(df)

# coerce with as.data.frame()

## SPECIAL COLUMNS
df <- data.frame(x = 1:3)
df$y <- list(1:2, 1:3, 1:4)
df

# fails bc it tries to put each list element in its own column
data.frame(x = 1:3, y = list(1:2, 1:3, 1:4))

# a workaround is I()
# causes data.frame() to treat the list as one unit
dfl <- data.frame(x = 1:3, y = I(list(1:2, 1:3, 1:4)))
str(dfl)

dfl[2, "y"]







