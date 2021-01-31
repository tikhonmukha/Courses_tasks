library(memisc)
library(dplyr)
library(psych)
library(lmtest)
library(sjPlot)
library(sgof)
library(ggplot2)
library(foreign)
library(car)
library(hexbin)
library(devtools)

devtools::install_github("bdemeshev/rlms")
library(rlms)

#Работа со случайными величинами
##Генерируем случайные величины
z <- rnorm(100, mean = 5, sd = 3) 

qplot(z)

##Построим функцию плотности
x <- seq(-10,15,by=0.5)
y <- dnorm(x, mean = 5, sd = 3)
qplot(x,y,geom = "line")

##P(Z<3)=F(3)
pnorm(3, mean = 5, sd = 3)

##P(Z in [4;9]) - P(Z<9)-P(Z>4)
pnorm(9, mean = 5, sd = 3) - pnorm(4, mean = 5, sd = 3)

##P(Z<a)=0.7 a?
qnorm(0.7, mean = 5, sd = 3)

##chisq, t, f
rchisq, dchisq, pchisq, qchisq
rt, dt, pt, qt
rf, df, pf, qf

#Проверка гипотез о коэффициентах
##множественная регрессия, проверка гипотез

h <- swiss
glimpse(h)

model <- lm(Fertility ~ Catholic+Agriculture+Examination, data = h)
summary(model)

coeftest(model)
confint(model,level = 5)
sjp.lm(model)

##проверка гипотезы b_cath = b_agri
model_aux <- lm(Fertility ~ Catholic+I(Catholic+Agriculture)+Examination,
                data = h)
summary(model_aux)

linearHypothesis(model, "Catholic-Agriculture=0")


#Стандартизированные коэффициенты и эксперимент с ложно-значимыми регрессорами
##Стандартизированные коэффициенты
h_st <- mutate_each(h, scale)
model_st <- lm(Fertility ~ Catholic+Agriculture+Examination, data = h_st)
summary(model_st)

##искусственный эксперимент
D <- matrix(nrow = 100, rnorm(100*41, mean = 0, sd = 1))
df <- data.frame(D)
glimpse(df)

model_pusto <- lm(X1 ~ ., data = df)
summary(model_pusto)

##Сравнить несколько моделей
model2 <- lm(Fertility ~ Catholic+Agriculture, data = h)
compar_12 <- mtable(model,model2)

#RLMS
h <- read.rlms("r21i_os_31.sav")
head(h)
saveRDS(h, "r21i_os_31.RDS")

h2 <- select(h, qm1, qm2, qh6, qh5)
describe(h2)

h3 <- rename(h2, ves=qm1, rost=qm2, sex=qh5, b_year=qh6)
h3 <- mutate(h3, vozrast=2012-b_year)
describe(h3)

table(h3$sex)

h4 <- filter(h3, sex==1)

qplot(data=h4, rost, ves)

ggplot(data=h3, aes(x = rost, y =ves))+
  geom_point(aes(colour=as.factor(sex)),na.rm = T)

qplot(data=h4, ves)



##############################################################

pnorm(9, mean = 7, sd = 2)


data <- diamonds
table(data$cut)

model <- glm(price ~ carat, data = data)
summa <- summary(model)
summa$coefficients

model2 <- glm(price ~ carat+x+y+z, data = data)
summary(model2)

model3 <- glm(price ~ carat+y+x, data = data)
summary(model3)
confint(model3, level = 0.9)
