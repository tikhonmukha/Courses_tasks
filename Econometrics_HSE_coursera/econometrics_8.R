library(lubridate) #работа с датами
library(zoo) #временные ряды
library(xts) #еще ряды
library(dplyr)
library(ggplot2)
library(forecast)
library(quantmod)
library(sophisthse)

#Искусственно сгенерированные стационарные процессы
y <- arima.sim(n = 100, list(ar = 0.7))
plot(y)
forecast::Acf(y)
stats::acf(y)
forecast::Pacf(y)
stats::pacf(y)
tsdisplay(y) #все 3 графика для ряда

y <- arima.sim(n = 100, list(ma = -0.8))
tsdisplay(y)

y <- arima.sim(n = 100, list(ma = -0.8, ar = 0.5))
tsdisplay(y)

y <- arima.sim(n = 100, list(ma = -0.8, ar = -0.5))
tsdisplay(y)

#Искусственно сгенерированные нестационарные процессы
y <- arima.sim(n = 100, list(order = c(0,1,0)))
tsdisplay(y)

y <- arima.sim(n = 500, list(order = c(0,1,0)))
tsdisplay(y)

y <- seq(0, 10, length = 100) + arima.sim(n = 100, list(ar = 0.7))
tsdisplay(y)

y <- seq(0, 2, length = 100) + arima.sim(n = 100, list(ar = 0.7))
tsdisplay(y)

#Анализ уровня воды озера Гурон
y <- LakeHuron
tsdisplay(y)

mod_1 <- forecast::Arima(y, order = c(2,0,0))
mod_1 <- stats::arima(y, order = c(2,0,0)) #или так но так не будет BIC штрафа

mod_2 <- Arima(y, order = c(1,0,1))
summary(mod_1) #значения коэффициентов делить на стандартные ошибки se, если отличен от нуля то значим
summary(mod_2)

AIC(mod_1)
AIC(mod_2)

mod_3 <- Arima(y, order = c(2,0,1))
summary(mod_3)
AIC(mod_3)

prognoz <- forecast(mod_2, h = 5) #точечный проноз, 80% и 95% доверительные интервалы
prognoz

plot(prognoz)

mod_4 <- Arima(y, order = c(1,1,0))
AIC(mod_4)
prognoz_4 <- forecast(mod_4, h = 5)
plot(prognoz_4)

mod_a <- auto.arima(y) #без указания AR, MA и других параметров сгенерится модель с наименьшим AIC
summary(mod_a)
prognoz_a <- forecast(mod_a, h = 5)
plot(prognoz_a)

#Анализ стоимости акций гугл
Sys.setlocale("LC_TIME", "C")
getSymbols(Symbols = "GOOG", from = "2014-01-01", to = "2014-12-01")
head(GOOG)

y <- GOOG$GOOG.Close

tsdisplay(y) #случайное блуждание
dy <- diff(y) #поэтому ряд нужно преобразовать в стационарный, взяв не y, а разности, т.е. дельта y
tsdisplay(dy) #теперь ряд - белый шум, все ок

mod_1 <- Arima(y, order = c(0,1,0)) #для преобразованной при помощи дельт модели случайного блуждания все прогнозы будут представлять из себя последнее значение временного ряда
summary(mod_1)
prognoz_1 <- forecast(mod_1, h=20)
prognoz_1
plot(prognoz_1)

mod_a <- auto.arima(y)
summary(mod_a) #компьютер автоматически подбирает arima(0,1,0) с минимальным AIC

#Анализ численности населения России
y <- sophisthse("POPNUM_Y")
tsdisplay(y)

mod_1 <- Arima(y, order = c(1,1,0), include.drift = T) #ряд показывает некую тенденцию к убыванию, поэтому добавляем drift
summary(mod_1)

prognoz_1 <- forecast(mod_1, h = 5)
plot(prognoz_1)

#Анализ индекса потребительских цен
y <- as.ts(sophisthse("CPI_M_CHI"))
tsdisplay(y)

time(y)
ym <- as.ts(y[97:nrow(y),])
tsdisplay(ym) #сезонность

mod_1 <- Arima(ym, order = c(1,0,0), seasonal = c(1,0,0)) #модель с сезонностью, т.е. добавляются еще сезонные лаги по ar и ma частям
summary(mod_1) #добавляется коэффициент sar - сезонный
AIC(mod_1)
prognoz_1 <- forecast(mod_1, h = 12)
plot(prognoz_1)

mod_a <- auto.arima(ym)
summary(mod_a)
AIC(mod_a)
prognoz_a <- forecast(mod_a, h = 12)
plot(prognoz_a)

#test
y <- arima.sim(n = 100, list(order = c(1,1,1)))
tsdisplay(y)
y <- arima.sim(n = 100, list(ar = 0.7))

set.seed(40)
y <- arima.sim(n=100, list(ar=0.7))
tsdisplay(y)

set.seed(10)
y <- arima.sim(n=100, list(ar=0.7))
tsdisplay(y)

set.seed(20)
y <- arima.sim(n=100, list(ar=0.7))
tsdisplay(y)

set.seed(30)
y <- arima.sim(n=100, list(ar=0.7))
tsdisplay(y)


set.seed(2)
y <- arima.sim(n=100, list(ar=0.99))
tsdisplay(y)
t_1 <- c(1:100)
t_2 <- t_1^2
t_3 <- t_1^3
d <- data.frame(y = y, t1 = t_1, t2 = t_2, t3 = t_3)
model <- lm(data = d, y ~ t1 + t2 + t3)
res <- summary(model)
res$fstatistic


set.seed(10)
y <- arima.sim(n=100, list(ar=0.5))
tsdisplay(y)
mod_1 <- Arima(y, order = c(0,0,3))
summary(mod_1)


y <- as.ts(sophisthse("HHI_Q_I"))
ym <- window(y[,1],end=c(2014,4))
tsdisplay(y)
str(y)

mod_1 <- Arima(ym, order = c(3,0,0))
AIC(mod_1)

mod_2 <- Arima(ym, order = c(1,1,0))
AIC(mod_2)

mod_3 <- Arima(ym, order = c(1,0,0))
AIC(mod_3)

mod_4 <- Arima(ym, order = c(2,0,0))
AIC(mod_4)


y <- as.ts(sophisthse("HHI_Q_I"))
ym <- window(y[,1],start=c(2008,1),end=c(2014,4))
stats::AIC(auto.arima(ym))

y <- as.ts(sophisthse("HHI_Q_I"))
ym <- window(y[,1],end=c(2014,4))
mod_1 <- Arima(ym, order = c(2,1,0))
prognoz_1 <- forecast(mod_1, h = 3)

data <- as.ts(y[1:86,1])
data_na <- as.ts(y[1:83,1])
mod1 <- Arima(data_na, order = c(1,1,3))
prognoz1 <- forecast(mod1, h = 3)
summary(prognoz1)
mse1 <- ((data[84]-prognoz1$mean[1])^2 + (data[85]-prognoz1$mean[2])^2 +
  (data[86]-prognoz1$mean[3])^2)/3
mse1

mod2 <- Arima(data_na, order = c(2,1,2))
prognoz2 <- forecast(mod2, h = 3)
summary(prognoz)
mse2 <- ((data[84]-prognoz2$mean[1])^2 + (data[85]-prognoz2$mean[2])^2 +
          (data[86]-prognoz2$mean[3])^2)/3
mse2

mod3 <- Arima(data_na, order = c(1,1,2))
prognoz3 <- forecast(mod3, h = 3)
summary(prognoz3)
mse3 <- ((data[84]-prognoz3$mean[1])^2 + (data[85]-prognoz3$mean[2])^2 +
          (data[86]-prognoz3$mean[3])^2)/3
mse3

mod4 <- Arima(data_na, order = c(0,1,0))
prognoz4 <- forecast(mod4, h = 3)
summary(prognoz4)
mse4 <- ((data[84]-prognoz4$mean[1])^2 + (data[85]-prognoz4$mean[2])^2 +
          (data[86]-prognoz4$mean[3])^2)/3
mse4


y <- as.ts(sophisthse("HHI_Q_I"))
ym <- window(y[,1],end=c(2014,4))
mod_1 <- Arima(ym, order = c(1,1,1), seasonal = c(1,0,0))
AIC(mod_1)


y <- as.ts(sophisthse("HHI_Q_I"))
ym <- window(y[,1],end=c(2014,4))
dummy <- seq(0, 0, length = 89)
dummy[62:69] <- 1
mod_1 <- Arima(ym, order = c(1,1,2), xreg = dummy)
summary(mod_1)


set.seed(50)
y1 <- arima.sim(n=100,list(ar=0.7))
plot(y1,type="l",axes=F,ylab="variable Y")
rect(20,-1000,25,1000,col="#FFCCEE",border="#FFCCEE")
rect(70,-1000,80,1000,col="#FFCCEE",border="#FFCCEE")
par(new=TRUE)
plot(y1,type="l",ylab="")

set.seed(10)
y1 <- arima.sim(n=100,list(ar=0.7))
plot(y1,type="p",axes=T,ylab="variable Y")
rect(20,-1000,25,1000,col="#FFCCEE",border="#FFCCEE")
rect(70,-1000,80,1000,col="#FFCCEE",border="#FFCCEE")
par(new=TRUE)
plot(y1,type="l",ylab="")

set.seed(70)
y1 <- arima.sim(n=100,list(ar=0.7))
plot(y1,type="l",axes=T,ylab="variable Y")
rect(20,-1000,25,1000,col="#FFCCEE",border="#FFCCEE")
rect(70,0,80,1000,col="#FFCCEE",border="#FFCCEE")
par(new=TRUE)
plot(y1,type="l",ylab="")

set.seed(30)
y1 <- arima.sim(n=100,list(ar=0.7))
plot(y1,type="l",axes=T,ylab="variable Y")
rect(20,-1000,25,1000,col="#FFCCEE",border="#FFCCEE")
rect(70,-1000,80,1000,col="#FFCCEE",border="#FFCCEE")
par(new=TRUE)
plot(y1,type="l",ylab="")
