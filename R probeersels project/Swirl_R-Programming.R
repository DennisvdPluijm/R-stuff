library(swirl)
#install_course("R Programming")
#install_course("Getting and Cleaning Data")

swirl()
# # helpful commands:
# skip()
# play() swirl will ignore what you do
# nxt() regain swirl's attention
# bye() saves and exits
# main() 
# info() displays options

## R Programming - 8: Logic
# (TRUE != FALSE) == TRUE -> TRUE
# & or &&: & to evaluate 'AND' across a vector, && only evaluates first member of vector
#   TRUE & c(TRUE, FALSE, FALSE) -> [1]  TRUE FALSE FALSE (left operand is recycled across every element in vector of right operand)
#   TRUE && c(TRUE, FALSE, FALSE) -> [1]  TRUE
# Similar for 'OR' operators | and ||
# First AND operators are evaluated before OR operators
# xor = exclusive or: only TRUE if exactly one element TRUE, o/wise FALSE
# useful: isTRUE(), identical(), which(), any(), all()
#   ints <- sample(10) - samples 10 integers from 1 to 10 without replacement
#   which(ints > 7) - finds indices of ints >7 (vector of size 3)