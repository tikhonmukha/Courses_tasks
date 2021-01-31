library(dplyr)
library(ggplot2)
library(GGally)
library(psych)

d <- cars

head(d)
tail(d)
summary(d)
describe(d)
ncol(d)
nrow(d)
str(d)

mean(d$speed)

d2 <- mutate(d, speed = 1.67 * speed, dist = 0.3 * dist, ratio = dist/speed)

qplot(data = d2, dist)
qplot(data = d2, dist, xlab = "Длина тормозного пути (м)", 
      ylab = "Количество машин", main = "Данные 1920х годов")

qplot(data = d2, speed, dist)

model <- lm(dist ~ speed, data = d2)
summary(model)

beta_hat <- model$coefficients
eps_hat <- model$residuals
y <- d2$dist
y_hat <- model$fitted.values
RSS <- deviance(model)
TSS <- sum((y-mean(y))^2)
ESS <- TSS-RSS
R2 <- ESS/TSS
cor(y,y_hat)^2

X <- model.matrix(model)

nd <- data.frame("speed"=c(40,60))
nd$dist <- predict(model, nd)

qplot(data = d2, speed, dist)+
  stat_smooth(method = "lm")

#################################################################################

t <- swiss
head(swiss)
str(swiss)
describe(t)

ggpairs(t)

model2 <- lm(data = t, Fertility ~ Agriculture+Education+Catholic)
report <- summary(model2)
model2$coefficients
model2$fitted.values
model2$residuals
deviance(model2)
report$r.squared

cor(t$Fertility, model2$fitted.values)^2

nd2 <- data.frame(Agriculture = 0.5, Catholic = 0.5, Education = 20)
nd2$Fertility <- predict(model2, nd2)
