library(spikeslab)
library(ggplot2)
library(dplyr)
library(reshape2)
library(MCMCpack)
library(quantreg)
library(randomForest)
library(rattle)
library(caret)
library(rpart)

#Квантильная регрессия
f <- read.table("flats_moscow.txt", header = T, sep = "\t", dec = ".")
glimpse(f)

model_q01 <- quantreg::rq(data = f, price ~ totsp, tau = c(0.1,0.5,0.9))
summary(model_q01)

base <- qplot(data = f, totsp, price)
base
base_q <- base + geom_quantile(quantiles = 0.1)+
  geom_quantile(quantiles = 0.9)+
  geom_quantile(quantiles = 0.5)
base_q + aes(colour = factor(brick))

#Алгоритм случайного леса
in_sample <- caret::createDataPartition(f$price, p = 0.75, list = F) #разделение выборки на обучающую и тестовую
head(in_sample)

f_train <- f[in_sample, ]
f_test <- f[-in_sample, ]

model_lm <- lm(data = f_train, price ~ totsp + kitsp + livesp + brick) #стандартная линейная модель
model_rf <- randomForest(data = f_train, price ~ totsp + kitsp + livesp + brick) #случайный лес

y <- f_test$price
yhat_lm <- predict(model_lm, f_test)
yhat_rf <- predict(model_rf, f_test)

sum((y - yhat_lm)^2)
sum((y - yhat_rf)^2)

#Логит-модель: байесовский подход
bad <- data.frame(y=c(0,0,1), x=c(1,2,3))
bad

model_logit <- glm(data = bad, y~x, family = binomial(link = "logit"))
summary(model_logit)

##если априорно предполагается что бета ~ N(E=0, Var=50^2)
model_mcmc_logit <- MCMClogit(data = bad, y~x, b0 = 0, B0 = 1/50^2) #b0 - вектор средних
summary(model_mcmc_logit)

model_mcmc_logit <- MCMClogit(data = bad, y~x, b0 = 0, B0 = 1/10^2) #b0 - вектор средних
summary(model_mcmc_logit)

#Регрессия пик-плато: байесовский подход
h <- mutate(cars, speed=1.61*speed, dist=0.3*dist)
h$junk <- rnorm(nrow(h))
h <- mutate(h, speed2=speed^2)

model_lm <- lm(data = h, dist~speed+junk)
summary(model_lm)

model_ss <- spikeslab::spikeslab(data = h, dist~speed+junk, n.iter2 = 4000) #n.iter2 - кол-во апостериорных наблюдений, зависит от того, как быстро нужно получить результат
print(model_ss)
model_ss$summary #bma.scale - оценки кэфов в оригинальном масштабе

included_regressors <- melt(model_ss$model) #создаем df в котором для каждого значения выборки апостериорного распределения указано какие регрессоры туда включались
included_regressors
head(included_regressors)
sum(included_regressors$value == 1) / 4000 #какова вероятность того что регрессор speed влияет на dist
sum(included_regressors$value == 2) / 4000 #какова вероятность того что регрессор junk влияет на dist
nrow(h)


#test
library(lmtest)
library(sandwich)
library(dplyr)
library(ggplot2)
library(erer)
library(caret)
library(AER)

x <- data.frame(x1 = c(1,3,3,4), x2 = c(2,4,4,4), x3 = c(2,2,2,2))
x
cor(x)

f <- mtcars
model <- lm(data = f, mpg ~ hp + wt + am)
bptest(model, data = f, varformula = ~ hp + I(hp^2) + wt + I(wt^2))
gqtest(model, order.by = f$hp, data = f, fraction = 0.3)
which.min(c(vcovHC(model, type = "HC0")[3,2],
vcovHC(model, type = "HC3")[3,2],
vcovHC(model, type = "HC2")[3,2],
vcovHC(model, type = "HC1")[3,2]))

t <- read.csv("titanic3.csv", stringsAsFactors = F)
glimpse(t)
t <- mutate(t, sex = as.factor(sex), pclass = as.factor(pclass),
            survived = as.factor(survived))
summary(t)
m_probit <- glm(survived ~ age + age^2 + sex + pclass + sibsp, data = t,
                family = "binomial"(link = "probit"), x = T)
vcov(m_probit)
maBina(m_probit, x.mean = F)

set.seed(12)
y<-arima.sim(model = list (ar = c(0.1, 0.6), ma = -0.3), n=100)
x1<-rnorm(100, 15, 5)
x2<-runif(100, 45, 50)
model <- lm(y ~ x1 + x2)
coeftest(model, vcov. = vcovHAC(model))
bgtest(model, order = 3)
qplot(lag(model$residuals, 1), model$residuals)

set.seed(123)
y<-arima.sim(model = list(ar = c(0.5, 0.1), ma = c(0.3,0.2)), n = 100)
mod_1 <- forecast::Arima(y, order = c(0,1,2))
AIC(mod_1)
mod_2 <- forecast::Arima(y, order = c(1,1,0))
AIC(mod_2)
mod_3 <- forecast::Arima(y, order = c(1,1,2))
AIC(mod_3)
mod_4 <- forecast::Arima(y, order = c(1,1,1))
AIC(mod_4)
mod_fixed <- forecast::Arima(y, order = c(3,0,3), fixed = c(0,NA,NA,0,NA,NA,NA))
AIC(mod_fixed)

set.seed(42)
data("CollegeDistance")
anyNA(CollegeDistance)
df <- CollegeDistance
in_train <- caret::createDataPartition(y = df$wage, p = 0.9, list=F)
df_train <- df[in_train, ]
df_test <- df[-in_train, ]
model <- lm(data = df_train, wage ~ gender + ethnicity + unemp + education + region)
summary(model)
model_iv <- AER::ivreg(data = df_train, wage ~ gender+ ethnicity + unemp + education + region|region + gender + ethnicity + unemp + distance)
summary(model_iv)
pr <- predict(model_iv, df_test)
pr[1]
