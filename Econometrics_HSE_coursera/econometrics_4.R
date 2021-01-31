library(lmtest)
library(ggplot2)
library(dplyr)
library(psych)
library(car)
library(glmnet)
library(HSAUR)

#доверительные интервалы при мультиколлинераности
h <- cars
qplot(data = h, speed, dist)
model <- lm(dist ~ speed, data = h)
summary(model)

h <- mutate(h, speed2 = speed^2, speed3 = speed^3)
model_mk <- lm(dist ~ speed + speed2 + speed3, data = h)
summary(model_mk)

vif(model_mk)

x0 <- model.matrix(data = h, dist ~ 0 + speed + speed2 + speed3)
head(x0)

cor(x0)

nd <- data.frame(speed = 10, speed2 = 100, speed3 = 1000)

predict(model, newdata = nd, interval = "prediction")
predict(model_mk, newdata = nd, interval = "prediction")

confint(model)
confint(model_mk)

#Ridge и LASSO регрессия
y <- h$dist
x0 <- model.matrix(data = h, dist ~ 0 + speed + speed2 + speed3)

lambdas <- seq(50,0.1,length=30)
m_lasso <- glmnet(x0, y, alpha = 1, lambda = lambdas) #lasso

plot(m_lasso, xvar = "lambda", label = T)
plot(m_lasso, xvar = "dev", label = T)
plot(m_lasso, xvar = "norm", label = T)

coef(m_lasso, s = c(0.1, 1))

m_rr <- glmnet(x0, y, alpha = 0, lambda = lambdas) #ridge

#кросс-валидация - выбор оптимального лямбда
cv <- cv.glmnet(x0, y, alpha = 1)
plot(cv)

cv$lambda.min
cv$lambda.1se

coef(cv, s = "lambda.1se")

#Метод главных компонент PCA
h <- heptathlon

glimpse(h)
h <- select(h, -score)
describe(h)

cor(h)

h.pca <- prcomp(h, scale. = T)
pca1 <- h.pca$x[,1]
v1 <- h.pca$rotation[,1]

head(pca1)
summary(h.pca)

cor(heptathlon$score, pca1)
plot(h.pca)
biplot(h.pca, xlim=c(-1,1))

#test

x <- data.frame(x1 = c(1,2,0,2), x2 = c(3,0,6,0), x3 = c(2,1,3,0))
x
cor(x)

h <- airquality
summary(h)
qplot(data = h, Ozone, Solar.R)
model <- lm(Ozone ~ Solar.R + Wind + Temp, data = h)
vif(model)

h <- na.omit(h)
y <- h$Ozone
x0 <- model.matrix(data = h, Ozone ~ 0 + Solar.R + Wind + Temp)

lambdas <- seq(50,0.1,length=30)
m_lasso <- glmnet(x0, y, alpha = 1, lambda = lambdas)
coef(m_lasso, s = 1)

m_rr <- glmnet(x0, y, alpha = 0, lambda = lambdas)
coef(m_lasso, s = 2)

h.pca <- prcomp(x0, scale. = T)
pca1 <- h.pca$x[,1]
pca2 <- h.pca$x[,2]
pca3 <- h.pca$x[,3]

qplot(h.pca$x[,1], h.pca$x[,2])
summary(h.pca)
biplot(h.pca)
