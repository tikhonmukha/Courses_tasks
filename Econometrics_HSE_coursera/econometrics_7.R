library(dplyr)
library(erer)
library(vcd)
library(ggplot2)
library(reshape2)
library(AUC)

#Графики для качественных переменных

t <- read.csv("titanic3.csv", stringsAsFactors = F)
glimpse(t)

t <- mutate(t, sex = as.factor(sex), pclass = as.factor(pclass),
            survived = as.factor(survived))

summary(t)

mosaic(data = t, ~ sex + pclass + survived, shade = T)

qplot(data = t, survived, age, geom = "violin")

qplot(data = t, survived, age, geom = "boxplot")

ggplot(data = t, aes(x = age))+
  geom_density(data = t, aes(fill = survived), position = position_stack(vjust = 0.5, reverse = F))

ggplot(data = t, aes(x = age))+
  geom_density(data = t, aes(fill = survived), position = position_fill(vjust = 0.5, reverse = F))

#Оценивание коэффициентов и прогнозирование скрытой переменной

m_logit <- glm(survived ~ sex + age + pclass + fare, data = t,
               family = "binomial"(link = "logit"), x = T)

m_probit <- glm(survived ~ sex + age + pclass + fare, data = t,
               family = "binomial"(link = "probit"), x = T)

summary(m_logit)
summary(m_probit)

vcov(m_logit)

newdata <- data.frame(age = seq(5, 100, length = 100),
                      sex = "male", pclass = "2nd",
                      fare = 100)
head(newdata)

pr_logit <- predict(m_logit, newdata, se=T)
newdata_pr <- cbind(newdata, pr_logit)
head(newdata_pr)

#Доверительный интервал для вероятности и LR тест
newdata_pr <- mutate(newdata_pr, prob = plogis(fit), 
                     left_ci = plogis(fit - 1.96 * se.fit),
                     right_ci = plogis(fit + 1.96 * se.fit))
head(newdata_pr)

qplot(data = newdata_pr, age, prob, geom = "line") +
  geom_ribbon(aes(ymin = left_ci, ymax = right_ci), alpha = 0.2)

t2 <- select(t, sex, age, pclass, survived, fare) %>% na.omit()
m_logit2 <- glm(survived ~ sex + age, data = t2,
               family = "binomial"(link = "logit"), x = T)
lrtest(m_logit, m_logit2)

#Предельные эффекты
maBina(m_logit) #предельные эффекты для усредненного пассажира
maBina(m_logit, x.mean = F) #усредненные по всем пассажирам предельные эффекты

m_ols <- lm(as.numeric(survived) ~ sex + age + pclass + fare, data = t) #неправильное применение МНК
summary(m_ols)
pr_ols <- predict(m_ols, newdata)
head(pr_ols)

#ROC кривая
pr_t <- predict(m_logit, t, se = T)
t <- cbind(t, pr_t)
t <- mutate(t, prob = plogis(fit))
select(t, age, survived, prob)

roc.data <- roc(t$prob, t$survived)
str(roc.data) #fpr - false positive rate, доля ошибочно классифицированных невыживших пассажиров
              #tpr - true positive rate, доля верно классифицированных выживших пассажиров

qplot(x = roc.data$cutoffs, y = roc.data$tpr, geom = "line")
qplot(x = roc.data$cutoffs, y = roc.data$fpr, geom = "line")

qplot(x = roc.data$fpr, y = roc.data$tpr, geom = "line")
plot(roc.data,colorize=TRUE)

#test
t <- read.csv("titanic3.csv", stringsAsFactors = F)
glimpse(t)

t <- mutate(t, sex = as.factor(sex), pclass = as.factor(pclass),
            survived = as.factor(survived))

m_logit <- glm(survived ~ age + sex + fare + sibsp + parch, data = t,
               family = "binomial"(link = "logit"), x = T)
summary(m_logit)

m_logit2 <- glm(survived ~ age + I(age^2) + sex + fare + sibsp, data = t,
               family = "binomial"(link = "logit"), x = T)
summary(m_logit2)
round(-(m_logit2$coefficients[2])/(2*(m_logit2$coefficients[3])),1)

m_logit3 <- glm(survived ~ age + I(age^2) + sex + fare + I(fare^2) + sibsp, data = t,
                family = "binomial"(link = "logit"), x = T)
confint(m_logit3)

m_logit4 <- glm(survived ~ age + I(age^2) + sex + fare + sibsp, data = t,
                family = "binomial"(link = "logit"), x = T)
test <- data.frame(age = 30, sex = as.factor("male"), fare = 200, sibsp = 2)
pr_logit <- predict(m_logit4, test, se=T)
test <- cbind(test, pr_logit)
head(test)
test <- mutate(test, prob = plogis(fit), 
                     left_ci = plogis(fit - 1.96 * se.fit),
                     right_ci = plogis(fit + 1.96 * se.fit))

m_logit5 <- glm(survived ~ age + I(age^2) + sex + fare + sibsp, data = t,
                family = "binomial"(link = "logit"), x = T)
test <- data.frame(age = 50, sex = as.factor("male"), fare = 200, sibsp = 2)
pr_logit <- predict(m_logit5, test, se=T)
test <- cbind(test, pr_logit)
head(test)
test <- mutate(test, prob = plogis(fit), 
               left_ci = plogis(fit - 1.96 * se.fit),
               right_ci = plogis(fit + 1.96 * se.fit))

m_logit6 <- glm(survived ~ age + I(age^2) + sex + fare + I(fare^2) + sibsp, data = t,
                family = "binomial"(link = "logit"), x = T)
summary(m_logit6)
maBina(m_logit6)

d <- select(t, age, sibsp, sex, fare, parch, survived)
d <- na.omit(d)
m_logit7 <- glm(survived ~ age + I(age^2) + sex + fare + I(fare^2) + sibsp, data = d,
                family = "binomial"(link = "logit"), x = T)
m_logit7.1 <- glm(survived ~ age + I(age^2) + sex + sibsp, data = d,
                family = "binomial"(link = "logit"), x = T)
lrtest(m_logit7, m_logit7.1)

d <- select(t, age, sibsp, sex, fare, survived) %>% na.omit()
m_logit8 <- glm(survived ~ age + I(age^2) + sex + fare + sibsp, data = d,
                family = "binomial"(link = "logit"), x = T)
pr_logit <- predict(m_logit8, d, se=T)
d <- cbind(d, pr_logit)
head(d)
d <- mutate(d, prob = plogis(fit))
d$survival <- ifelse(d$prob >= 0.65, 1, 0)
table(ifelse(d$survival == d$survived, "Yes", "No"))
813/(813+232)

d$probs<- predict(m_logit8, type="response")

table(d$survived, d$probs >= 0.65)

m_logit9 <- glm(survived ~ age + I(age^2) + sex + fare + sibsp, data = t,
                family = "binomial"(link = "logit"), x = T)
vcov(m_logit9)
