#Функции
f <- function(x){
  res <- x^2
  return(res)
}

f(3)
f(-1)

fs <- function(x, stepen = 2){
  res <- x^stepen
  return(res)
}

fs(4)
fs(2, 5)

cars
d <- cars
d[1,2] <- NA
d[3,1] <- NA
d

is.na(d)
sum(is.na(d))

res <- sum(is.na(d))/nrow(d)/ncol(d)
res

na_perc <- function(d){
  if(!is.data.frame(d)) stop("d should be a data frame!")
  res <- sum(is.na(d))/nrow(d)/ncol(d)
  return(res)
}

na_perc(d)

#Циклы
for (i in 5:10){
  k <- i^2
  cat("i=",i," i^2=",k,"\n")
}

all_data <- NULL
for(fname in c("file01.csv","file02.csv")){
  temp <- read.csv(fname)
  all_data <- rbind(all_data, temp)
}
head(all_data)

#Гетероскедастичность
library(sandwich) #vcovHC, vcovHAC
library(lmtest) #tests
library(ggplot2)
library(dplyr)
library(car) #tests
library(broom) #manipulations

##Прежние оценки для сравнения
h <- read.table("flats_moscow.txt", header = T)
head(h)
tail(h)

qplot(data = h, x=totsp, y=price)

model <- lm(price ~ totsp, data = h)
summary(model)

coeftest(model)
confint(model)

vcov(model)

##Доверительные интервалы при гетероскедастичности
h <- augment(model,h)
glimpse(h)
qplot(data = h, totsp, abs(.resid))

vcov(model)
vcovHC(model)
vcovHC(model, type = "HC2")

coeftest(model)
coeftest(model, vcov. = vcovHC(model))

conftable <- coeftest(model, vcov. = vcovHC(model))
ci <- data.frame(estimate = conftable[,1], se_hc=conftable[,2])
ci
ci <- mutate(ci, left_ci=estimate-1.96*se_hc,
             right_ci=estimate+1.96*se_hc)#new confidence interval
ci
cofint(model)#old confidence interval

##Тесты на гетероскедастичность
bptest(model) #Breusch-Pagan test or White test
bptest(model, data = h, varformula = ~ totsp + I(totsp^2))
bptest(model, data = h, varformula = ~ poly(totsp,2))

gqtest(model, order.by = ~totsp, data = h, fraction = 0.2) #Goldfeld-Quandt test

qplot(data=h, log(totsp), log(price))

model2 <- lm(log(price) ~ log(totsp), data = h)
gqtest(model2, order.by = ~totsp, data = h, fraction = 0.2)

#test
df <- ChickWeight
head(df)
mean(df[df$Time == 10,1])

which.max(c(mean(df[df$Time == 21 & df$Diet == 1,1]),
mean(df[df$Time == 21 & df$Diet == 2,1]),
mean(df[df$Time == 21 & df$Diet == 3,1]),
mean(df[df$Time == 21 & df$Diet == 4,1])))

model <- lm(weight ~ Time + Diet, df)
summary(model)

d <- diamonds
qplot(data = d, log(price), color = cut)+facet_grid(~cut)

model1 <- lm(price ~ carat + table + x + y + z + depth, data = d)
s <- summary(model1)
s$df[2]

model2 <- lm(price ~ carat + table + x + y + depth, data = d)
confint(model2,level = 0.9)
help(diamonds)

library(Ecdat)
b <- BudgetFood
head(b)
model3 <- lm(wfood ~ totexp + size, data = b)
nd <- data.frame(totexp = 700000, size = 4)

predict(model3, newdata=nd, interval="prediction", level=0.9)


summary(model3)
reset(model3)

anyNA(b)
b1 <- na.omit(b)
model4.1 <- lm(wfood ~ totexp*sex + size*sex + sex, data = b1)
model4.2 <- lm(wfood ~ totexp + size, data = b1)
waldtest(model4.1, model4.2)

m <- mtcars
model5 <- lm(mpg ~ disp + hp + wt, data = m)
round(max(vif(model5)),2)

m1 <- na.omit(m)
y <- m1$mpg
x0 <- model.matrix(data = m1, y ~ 0 + disp + hp + wt)
h.pca <- prcomp(x0, scale. = T)
sqrt(sum(h.pca$x[,1]^2))
norm(h.pca$x[,1], type="2")

