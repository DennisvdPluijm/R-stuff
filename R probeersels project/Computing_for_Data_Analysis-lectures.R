# lapply: loop over a list, apply/evaluate function on each element, return a list, 
# sapply: same as lapply, but tries to simplify result,
# apply:  apply a function over the margins of an array,
# tapply: apply a function over subsets of a vector,
# mapply: multivariate (matrix) version of lapply
# also useful: split
x <- 1:4
y <- lapply(x, runif, min = 0, max = 10) # runif: list of uniform distributed elements with length x, with opt args min,max
print(y)
lapply(y, mean)  # always a list
sapply(y, mean)  # returns a vector in this case
# use lapply together with anonymous functions, e.g. extract first column of two matrices of different sizes
x <- list(a = matrix(1:4, 2, 2), b = matrix(1:6, 3, 2))
lapply(x, function(extract) extract[,1])  # function has no name (outside lapply)

# apply: most often used to apply (anonymous) function to rows or columns of a matrix; not really faster than writing a loop, but in one line
x <- matrix(rnorm(200), 20, 10)
apply(x, 2, mean) # mean for each column, collapse rows
apply(x, 1, sum)  # sum for each row
# equivalent shortcut, faster functions:
#rowSums(x), rowMeans(), colSums(), colMeans()
apply(x, 1, quantile, probs = c(0.05, 0.95))  # 5/95% of the rows

# tapply: statistics per group of numeric vectors
x <- c(rnorm(10), runif(10), rnorm(10,1))
f <- gl(3,10) # will serve as index vector, to define groups/subsets of x
tapply(x, f, mean)  # simplified by default, like sapply
tapply(x, f, mean, simplify = FALSE)
tapply(x, f, range)  # group ranges

# split: takes a vector, split into groups by a (list of) factor; and then e.g. use lapply on the groups
split(x, f)  # similar to groups tapply example 
# equivalent to tapply(x, f, mean):
sapply(split(x, f), mean)  #not simplified: lapply(split(x, f), mean)
library(datasets)
head(airquality)
s <- split(airquality, airquality$Month)
sapply(s, function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind", "Temp")], na.rm = T))

# mapply: multivariate (matrix) version of lapply/sapply, in parallel
# instead of a loop: to apply multiple sets of arguments for a single function
list(rep(1, 4), rep(2, 3), rep(3, 2), rep(4, 1)) # or, with mapply:
mapply(rep, 1:4, 4:1) # two arguments for the rep function
# useful to vectorize a function
mapply(rnorm, n=5, mean=0:4, sd=1:5, SIMPLIFY = F)


# debugging & other stuff
invisible(x <- 5) # return, but don't print an object. Useful in functions
#primary debugging tools:
traceback() # prints function call stack after an error
debug()     # flags a function for debug mode, step through execution line by line, at start of function
browser()   # suspend execution of a function at where it's called (inside), puts function in debug mode
trace()     # allows to insert debugging code (e.g. browser) into a function
recover()   # modify error handling to browse the function call stack
# examples
lm(z ~ a + b)
traceback() # lm calls 7 functions before error
debug(lm)
lm(z ~ a + b) # first prints entire function, then opens browser (hit Enter or type 'n' for next execution)
options(error = recover)  # set for current R session
read.csv("filethatdoesntexist") # will give a menu to investigate the function environment

# simulation
set.seed(42)
rnorm(10) # for every distribution function, there are d(ensity), r(andom), p(robability cumulative distr) and q(uantile) functions
rpois(10, 1)
rbinom(10, 1, 0.5)
sample(1:10, 4)
sample(letters, 5)
sample(1:10)  #permutation, 1 to 10 in random order
sample(1:10, replace = TRUE) #sample w/replacement

#plotting
# graphics (plot, hist, boxplot, ...), 
# lattice (Trellis graphics: xyplot, bwplot, levelplot, ...; based on grid package), 
# grDevices (export to PDF, PNG, PostScript, ..; to launch/export to a graphics device)
# base plotting: a lot of optional parameters --> ?par