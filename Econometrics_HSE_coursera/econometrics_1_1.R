library(dplyr)
library(ggplot2)
library(GGally)
library(psych)



x <- c(23,15,46,NA)
z <- c(5,6,NA,8)

mean(x, na.rm = T)
mean(z, na.rm = T)

sum(x, na.rm = T)
sum(z, na.rm = T)

d <- data.frame(rost = x, ves = z)
na.omit(d)


d[4,1]
d[3,1]

d[2,]
d[,2]

d$rost
d$ves

my_list <- list(a=7,b=10:20,table=d)

my_list$a
my_list$b
my_list$table
d$rost

my_list[[2]]

# Ура!





