library(lubridate) #работа с датами

library(sandwich) #vcovHC, vcovHAC
library(lmtest) #тесты
library(car) #еще тесты
library(zoo) #временные ряды
library(xts) #еще ряды
library(ggplot2)
library(dplyr)
library(broom)

library(quantmod) #загрузка данных с finance.google.com
library(Quandl) #загрузка с Quandl.com
install.packages("rusquant", repos = "http://r-forge.r-project.org", type = "source")
library(rusquant) #загрузка с finam.ru
devtools::install_github("bdemeshev/sophisthse")
library(sophisthse) #загрузка с sophist.hse.ru

#Работа с датами 
x <- c("2012-04-15","2011-08-17")
y <- ymd(x)
y
y + days(20)
y - years(10)
day(y)
month(y)
year(y)
vignette("lubridate")

x <- rnorm(5)
y <- ymd("2014-01-01")+days(0:4)
ts <- zoo(x, order.by = y)

lag(ts, -3)
lag(ts, 1)
diff(ts)

ts2 <- zooreg(x, start = as.yearqtr("2014-01"), frequency = 4) #квартальные данные
ts2

ts3 <- zooreg(x, start = as.yearmon("2014-01"), frequency = 12) #месячные данные
ts3

#Базовые действия с временными рядами
data("Investment")
h <- Investment
help(Investment)

start(h)
end(h)
time(h)
str(h)
coredata(h) #данные без самих дат

dna <- Investment
dna[1,2] <- NA
dna[5,3] <- NA
dna
na.approx(dna) #заполнение NA значения средними от двух наблюдений между которыми лежит NA
na.locf(dna) #заполнение NA значения последним идущим перед NA значением

#Загрузка данных из внешних источников
a <- data.frame(sophisthse::sophisthse("POPNUM_Y"))
a

b <- Quandl::Quandl("FRED/GNP")
b

Sys.setlocale("LC_TIME","C")
getSymbols(Symbols = "AAPL", from = "2010-01-01", to = "2014-02-03",
           src = "yahoo")
head(AAPL)
tail(AAPL)

getSymbols(Symbols = "GAZP", from = "2011-01-02", to = "2014-09-09",
           src = "Finam")
head(GAZP)
tail(GAZP)

plot(GAZP)
autoplot(GAZP[,1:4])
autoplot(GAZP[,1:4], facets = NULL)
chartSeries(GAZP)

#Построение робастных доверительных интервалов
d <- as.zoo(Investment)
d <- na.omit(d)
autoplot(d[,1:2], facets = NULL)

model <- lm(RealInv ~ RealInt + RealGNP, data = d)

summary(model)
coeftest(model)
confint(model)

d_aug <- augment(model, as.data.frame(d))
glimpse(d_aug)
qplot(data = d_aug, lag(.resid), .resid)

vcov(model)
vcovHAC(model)

coeftest(model, vcov. = vcovHAC(model))
conftable <- coeftest(model, vcov. = vcovHAC(model))
ci <- data.frame(estimate = conftable[,1], se_ac = conftable[,2])
ci

ci <- mutate(ci, left_95 = estimate-1.96*se_ac, right_95 = estimate+1.96*se_ac)
ci

#Тесты на автокорреляцию
##Дарбина-Уотсона
dwt(model)
res <- dwt(model)
res$dw
res$p
res$r

##Бройша-Годфри
bgtest(model, order = 2)
res <- bgtest(model, order = 2)
res$statistic
res$p.value



#test
library(sandwich) 
library(lmtest) 
library(car) 
library(ggplot2)
library(dplyr)
library(broom)
library(Ecdat)

h <- Griliches
head(h)
str(h)

model <- lm(lw80 ~ age80 + iq + school80 + expr80, data = h)
vcov(model)
vcovHC(model, type = "HC3")
abs(vcov(model)[3,4]-vcovHC(model, type = "HC3")[3,4])
abs(-4.609680e-06-(-5.121232e-06))

vcovHC(model, type = "HC5")
vcovHC(model, type = "HC4m")
vcovHC(model, type = "HC3")
vcovHC(model, type = "HC1")

which.max(c(vcovHC(model, type = "HC5")[5,5], vcovHC(model, type = "HC4m")[5,5],
      vcovHC(model, type = "HC3")[5,5], vcovHC(model, type = "HC1")[5,5]))

bptest(model, data = h, varformula = ~ age80)

gqtest(model, order.by = ~age80, data = h, fraction = 0.2)

Solow
model2 <- lm(q ~ k + A, data = Solow)
vcov(model2)
vcovHAC(model2)
abs(vcov(model2)[2,2]-vcovHAC(model2)[2,2])

dwt(model2)

model3 <- lm(q ~ k, data = Solow)
bgtest(model3, order = 3)

library(Quandl)
library(quantmod)

Sys.setlocale("LC_TIME","C")
getSymbols(Symbols = "INTC", from = "2010-01-01", to = "2014-02-03",
           src = "yahoo")
plot(INTC$INTC.Close, main = "")

Sys.setlocale("LC_TIME","C")
getSymbols(Symbols = "GOOG", from = "2010-01-01", to = "2014-02-03",
           src = "yahoo")
plot(GOOG$GOOG.Close, main = "")

Sys.setlocale("LC_TIME","C")
getSymbols(Symbols = "AAPL", from = "2010-01-01", to = "2014-02-03",
           src = "yahoo")
plot(AAPL$AAPL.Close, main = "")

Sys.setlocale("LC_TIME","C")
getSymbols(Symbols = "MSFT", from = "2010-01-01", to = "2014-02-03",
           src = "yahoo")
plot(MSFT$MSFT.Close, main = "")



getSymbols(Symbols = "INTC", from = "2010-01-01", to = "2014-02-03",
           src = "yahoo")

cl <- INTC$INTC.Close
cl[,2]
zoo(cl, order.by = cl)
cl
model4 <- lm(cl ~ stats::lag(cl, 1) + stats::lag(cl, 2))
summary(model4)



#RLMS
library(rlms)
library(dplyr)
library(ggplot2)
library(sandwich)
library(lmtest)

h <- read.rlms("r22i_os_31.sav")
head(h)

h2 <- h %>% 
  select(rj13.2, rh6, rh5, r_diplom, status, rj1.1.1) %>% 
  mutate(age = 2013 - rh6) %>% 
  filter(status == 1 | status == 2) %>% 
  filter(rj1.1.1 == 1 | rj1.1.1 == 2 | is.na(rj1.1.1)) %>% 
  mutate(city = ifelse(status == 1, 0, 1),
         happy = ifelse(rj1.1.1 == 1, 1, 0),
         sex = ifelse(rh5 == 1, 1, 0),
         nso = case_when(
           r_diplom >= 1 & r_diplom <= 3 ~ 1,
           r_diplom > 3 ~ 0),
         zso = ifelse(r_diplom == 4, 1, 0),
         zsso = ifelse(r_diplom == 5, 1, 0),
         zvo = ifelse(r_diplom == 6, 1, 0))
head(h2)
tail(h2)

max(h2$age)

sum(ifelse(is.na(h2$rj13.2) == T, 1, 0))

h2 <- na.omit(h2)
h2

hist(h2$rj13.2)

qplot(data = h2, age) + facet_wrap(~ sex)
qplot(data = h2, rj13.2/1000) + facet_wrap(~ sex)

model <- lm(data = h2, rj13.2 ~ age + sex + zso + zsso + zvo + city + happy)
summ <- summary(model)
summ$fstatistic

vcovHC(model)
sqrt(vcovHC(model)[7,7])
#или
coeftest(model, vcov. = vcovHC(model))[7,2]