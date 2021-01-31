library(memisc)
library(lmtest)
library(ggplot2)
library(dplyr)
library(foreign)
library(vcd)
library(devtools)
library(hexbin)
library(pander)
library(sjPlot)
library(knitr)

h <- diamonds
glimpse(h)

qplot(data = h, carat, price)
bg <- qplot(data = h, log(carat), log(price))
bg + geom_hex()

f <- read.csv("flats_moscow.txt", header = T, sep = "\t", dec = ".")
glimpse(f)
summary(lm(price ~ livesp, data = f))
qplot(data = f, totsp, price)
str(f)
qplot(data = f, log(totsp), log(price))

mosaic(data = f, ~walk+brick+floor, shade = T)

f <- mutate_each(f, factor, walk, brick, floor, code)
glimpse(f)

qplot(data = f, log(price))
qplot(data = f, log(price), fill = brick)
qplot(data = f, log(price), fill = brick, geom = "density")
g2 <- qplot(data = f, log(price), fill = brick, geom = "density", alpha = 0.5)

g2 + facet_grid(walk ~ floor)
g2 + facet_grid(~ floor)

model_0 <- lm(log(price) ~ log(totsp), data = f)
model_1 <- lm(log(price) ~ log(totsp)+brick, data = f)
model_2 <- lm(log(price) ~ log(totsp)+brick+brick:log(totsp), data = f)

summary(model_0)
summary(model_1)
summary(model_2)
mtable(model_2)

model_2b <- lm(log(price) ~ brick*log(totsp), data = f)
mtable(model_2, model_2b)

plot_model(model_2)

#Построение прогнозов в R
nw <- data.frame(totsp=c(60,60), brick=factor(c(1,0)))
nw

exp(predict(model_2, newdata = nw))

exp(predict(model_2, newdata = nw, interval = "confidence"))

exp(predict(model_2, newdata = nw, interval = "prediction"))

waldtest(model_0, model_1) #модель 0 отвергается
waldtest(model_1, model_2) #модель 1 отвергается
waldtest(model_0, model_2) #модель 0 отвергается

gg0 <- qplot(data = f, log(totsp), log(price))
gg0 + stat_smooth(method = "lm")
gg0 + stat_smooth(method = "lm") + facet_grid(~ walk)
gg0 + aes(col = brick) + stat_smooth(method = "lm") + facet_grid(~ walk)

f$nonbrick <- memisc::recode(f$brick, 1 <- 0, 0 <- 1)
glimpse(f)
model_wrong <- lm(log(price)~log(totsp)+brick+nonbrick, data = f) #если включить неправильную факторную переменную
summary(model_wrong)

mtable(model_0, model_1, model_2)

resettest(model_2) #тест Рамсея
reset(model_2) #тоже он

#ТЕСТ

df <- diamonds
str(df)

summary(lm(log(price) ~ carat, data = df))
summary(lm(price ~ log(carat) + y, data = df))
summary(lm(price ~ carat, data = df))
model_z <- lm(price ~ carat, data = df)
model_y <- lm(price ~ carat + x, data = df)
model_x <- glm(price ~ carat + depth + cut, data = df)
summary(model_z)
summary(model_y)
summary(model_x)
mtable(model_z, model_y, model_x)
deviance(model_z)
deviance(model_x)
reset(model_z)

qplot(data = df, log(price), fill = cut, geom = "density", alpha = 0.5) + facet_wrap(~ cut)
qplot(data=df, log(carat), log(price), color = clarity) + facet_wrap(~cut) 
