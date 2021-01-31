library(dplyr)
library(caret)
library(AER)
library(ggplot2)
library(sandwich)
library(ivpack)

#Деление выборки на обучающую и тестовую
h <- read.csv("flats_moscow.txt", header = T, sep = "\t", dec = ".")
glimpse(h)

in_train <- caret::createDataPartition(y = h$price, p = 0.75, list=F)
in_train

h_train <- h[in_train, ]
h_test <- h[-in_train, ]

nrow(h)
nrow(h_train)
nrow(h_test)

model_1 <- lm(data=h_train, log(price) ~ log(totsp)+log(kitsp)+log(livesp))
model_2 <- lm(data=h_train, log(price) ~ log(totsp)+brick)

y <- log(h_test$price)
y
y_hat_1 <- predict(model_1, h_test)
y_hat_1
y_hat_2 <- predict(model_2, h_test)
y_hat_2

sum((y-y_hat_1)^2)
sum((y-y_hat_2)^2)

#Двухшаговый МНК в парной регрессии
data("CigarettesSW")
h <- CigarettesSW
help("CigarettesSW")

h2 <- mutate(h, rprice = price/cpi, rincome = income/cpi/population,
             rtax = tax/cpi)
h3 <- filter(h2, year=="1995")

model_0 <- lm(data=h3, log(packs) ~ log(rprice))
summary(model_0)

##Двухшаговый МНК вручную
###шаг 1
st_1 <- lm(data=h3, log(rprice)~rtax)
h3$log_price_hat <- fitted(st_1)
###шаг 2
st_2 <- lm(data=h3, log(packs)~log_price_hat)
summary(st_2) #b2 можно интерпретировать как причинный коэффициент

##Автоматический двухшаговый МНК
model_iv <- AER::ivreg(data = h3, log(packs)~log(rprice)|rtax) #через слэш указывается инструментальная переменная
summary(model_iv)

memisc::mtable(model_0, st_2, model_iv, getSummary=c("sigma","R-squared","F","p","N"))

#Пара нюансов двухшагового МНК
coeftest(model_iv, vcov. = vcovHC) #робастные ст. ошибки

##наличие экзогенных регрессоров
model_iv_2 <- AER::ivreg(data = h3, 
                       log(packs)~log(rprice)+log(rincome)|log(rincome)+rtax) #если регрессор не коррелирован с ошибкой то его надо включить в обе части модели
coeftest(model_iv_2, vcov. = vcovHC)

##наличие нескольких инструментальных переменных
h3 <- mutate(h3, rtax2 = (taxs-tax)/cpi)
glimpse(h3)

model_iv_3 <- AER::ivreg(data = h3, 
                         log(packs)~log(rprice)+log(rincome)|log(rincome)+rtax+rtax2)
coeftest(model_iv_3, vcov. = vcovHC)

#test
h <- diamonds
set.seed(12345)
train_ind <- createDataPartition(h$price, p=0.8, list=FALSE)
h_train <- h[train_ind,]
h_test <- h[-train_ind,]

model_1 <- lm(data = h_train, log(price) ~ log(carat)+log(depth)+clarity)
summary(model_1)
pr <- exp(predict(model_1, h_test))
newdata_pr <- cbind(h_test, pr)
head(newdata_pr)
round(sum((newdata_pr$price-newdata_pr$pr)^2)/1000000000, digits = 0)

data(CollegeDistance)
df <- CollegeDistance
head(df)
model_iv <- AER::ivreg(data = df, 
                         wage~gender+ethnicity+unemp+education|gender+ethnicity+unemp+distance)
coeftest(model_iv, vcov. = vcovHC)