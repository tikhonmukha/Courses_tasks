library(dplyr)
library(tidyr)
library(stringr)
library(magrittr)
library(ggplot2)
library(ggrepel)

#Importing data

categories <- tibble(read.csv2("UED_categories.csv", encoding = "UTF-8", stringsAsFactors = T))
category_views <- tibble(read.csv2("UED_category-views.csv", encoding = "UTF-8", stringsAsFactors = T))
item_views <- tibble(read.csv2("UED_item-views.csv", encoding = "UTF-8", stringsAsFactors = T))
product_categories <- tibble(read.csv2("UED_product-categories.csv", encoding = "UTF-8", stringsAsFactors = T))
products <- tibble(read.csv2("UED_products.csv", encoding = "UTF-8", stringsAsFactors = T))
purchases <- tibble(read.csv2("UED_purchases.csv", encoding = "UTF-8", stringsAsFactors = T))

#Products ABC-analysis

ABC_data <- purchases %>% 
  left_join(., products, by = "product_id") %>%
  select(product_id, name, totalcents) %>%
  group_by(product_id, name) %>% 
  summarise(value_sales = sum(totalcents, na.rm = T)) %>% 
  filter(!is.na(value_sales)) %>% 
  arrange(desc(value_sales)) %>%
  ungroup() %>% 
  mutate(value_share = round(value_sales/sum(value_sales)*100,2),
         cum_value_share = cumsum(value_share),
         ABC_group = case_when(cum_value_share <= 80 ~ "A",
                            cum_value_share > 80 & cum_value_share <= 95 ~ "B",
                            cum_value_share > 95 ~ "C") %>% factor())

table(ABC_data$ABC_group)
levels(purchases$eventdate)

#Products XYZ-analysis

XYZ_data <- purchases %>% 
  left_join(., products, by = "product_id") %>% 
  select(eventdate, product_id, name, totalcents) %>%
  mutate(year_month = as.Date(eventdate, format("%Y-%m-%d"))) %>% 
  filter(year_month > "2015-08-31" & year_month < "2016-06-01") %>% 
  mutate(year_month = format(year_month, "%Y-%m") %>% factor()) %>% 
  select(2:5) %>% 
  group_by(year_month, product_id, name) %>% 
  summarise(value_sales = sum(totalcents)) %>% 
  pivot_wider(c("product_id", "name"), names_from = "year_month", values_from = "value_sales")
 
XYZ_data$value_sales <- apply(XYZ_data[,3:10], 1, function(x) sum(x, na.rm = T))

XYZ_data %<>%
  arrange(desc(value_sales))

XYZ_data[is.na(XYZ_data)] <- 0

XYZ_data$variation <- round((apply(XYZ_data[,3:10], 1, sd)/apply(XYZ_data[,3:10], 1, mean))*100,2)

XYZ_data %<>%  
  mutate(XYZ_group = case_when(variation <= 10 ~ 'X',
                               variation > 10 & variation <= 25 ~ 'Y',
                               variation > 25 ~ 'Z') %>% factor)
table(XYZ_data$XYZ_group)

#Products FMR-analysis

FMR_data <- purchases %>% 
  left_join(., products, by = "product_id") %>%
  select(product_id, name) %>%
  group_by(product_id, name) %>% 
  summarise(total_sales = n()) %>% 
  filter(!is.na(total_sales)) %>% 
  arrange(desc(total_sales)) %>%
  ungroup() %>% 
  mutate(sales_share = round(total_sales/sum(total_sales)*100,2),
         cum_sales_share = cumsum(sales_share),
         FMR_group = case_when(cum_sales_share <= 80 ~ "F",
                               cum_sales_share > 80 & cum_sales_share <= 95 ~ "M",
                               cum_sales_share > 95 ~ "R") %>% factor())

table(FMR_data$FMR_group)

#Joining the results of ABC and XYZ analysis - ABCXYZ-analysis

ABCXYZ_data <- 
  ABC_data %>% 
  left_join(., XYZ_data %>% select(product_id, XYZ_group), by = 'product_id') %>% 
  select(product_id, name, value_sales, value_share, ABC_group, XYZ_group) %>% 
  mutate(ABCXYZ_group = str_c(ABC_group, XYZ_group, sep = "") %>% factor)

table(ABCXYZ_data$ABC_group, ABCXYZ_data$XYZ_group)

#Joining the results of ABC and FMR analysis - ABCFMR-analysis

ABCFMR_data <- 
  ABC_data %>% 
  left_join(., FMR_data %>% select(product_id, FMR_group), by = 'product_id') %>% 
  select(product_id, name, value_sales, value_share, ABC_group, FMR_group) %>% 
  mutate(ABCFMR_group = str_c(ABC_group, FMR_group, sep = "") %>% factor)

table(ABCFMR_data$ABC_group, ABCFMR_data$FMR_group)

#Customers segmentation by purchases

##Customers segmentation with ABC-analysis

ABC_customers <- purchases %>% 
  select(externalsessionid, totalcents) %>%
  group_by(externalsessionid) %>% 
  summarise(value_sales = sum(totalcents, na.rm = T)) %>% 
  filter(!is.na(value_sales)) %>% 
  arrange(desc(value_sales)) %>%
  ungroup() %>% 
  mutate(value_share = round(value_sales/sum(value_sales)*100,2),
         cum_value_share = cumsum(value_share),
         ABC_group = case_when(cum_value_share <= 80 ~ "A",
                               cum_value_share > 80 & cum_value_share <= 95 ~ "B",
                               cum_value_share > 95 ~ "C") %>% factor())

table(ABC_customers$ABC_group)

##Clients segmentation with RFM-analysis

RFM_data <- purchases %>% 
  select(externalsessionid, eventdate, totalcents) %>% 
  mutate(eventdate = as.Date(as.character(eventdate), format = "%Y-%m-%d")) %>% 
  group_by(externalsessionid) %>% 
  mutate(last_purchase = max(eventdate)) %>% 
  summarise(tot_spendings = sum(totalcents), tot_purchases = n(), last_purchase = last_purchase) %>% 
  mutate(externalsessionid = factor(externalsessionid)) %>% 
  ungroup() %>%
  distinct(externalsessionid, .keep_all = T) %>% 
  arrange(last_purchase) %>% 
  mutate(last_purchase_days = as.integer(as.Date("2016-06-17") - last_purchase)) %>% 
  mutate(recency = factor(case_when(last_purchase_days < quantile(last_purchase_days, 0.33) ~ 3,
                             last_purchase_days >= quantile(last_purchase_days, 0.33) & last_purchase_days < quantile(last_purchase_days, 0.67) ~ 2,
                             last_purchase_days >= quantile(last_purchase_days, 0.67) ~ 1)),
         frequency = factor(case_when(tot_purchases <= quantile(tot_purchases, 0.33) ~ 3,
                                      tot_purchases > quantile(tot_purchases, 0.33) & tot_purchases < quantile(tot_purchases, 0.95) ~ 2,
                                      tot_purchases >= quantile(tot_purchases, 0.95) ~ 1)),
         monetary = factor(case_when(tot_spendings < quantile(tot_spendings, 0.33) ~ 3,
                                     tot_spendings >= quantile(tot_spendings, 0.33) & tot_spendings < quantile(tot_spendings, 0.67) ~ 2,
                                     tot_spendings >= quantile(tot_spendings, 0.67) ~ 1))) %>% 
  mutate(RFM_group = factor(str_c(recency, frequency, monetary, sep = "")))

table(RFM_data$recency, RFM_data$frequency, RFM_data$monetary, dnn = c('recency', 'frequency', 'monetary'))

table(RFM_data$RFM_group, ABC_customers$ABC_group, dnn = c('RFM groups', 'ABC groups')) # A111 - most important customers group

recency.labs <- c('Recency lvl1', 'Recency lvl2', 'Recency lvl3')
names(recency.labs) <- c("1", "2", "3")

frequency.labs <- c('Frequency lvl1', 'Frequency lvl2', 'Frequency lvl3')
names(frequency.labs) <- c("1", "2", "3")

ggplot(data = RFM_data, aes(y = tot_spendings, fill = monetary))+
  geom_boxplot()+
  scale_fill_discrete(name = 'Monetary level')+
  facet_grid(recency ~ frequency, labeller = 
               labeller(recency = recency.labs, frequency = frequency.labs))+
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_blank(), 
        legend.position = 'bottom')+
  labs(title = 'Customers total spendings distribution by RFM', y = 'Total spendings by customer')

##What items does every RFM-group usually buy?

RFM_ABCFMR_data <- RFM_data %>% 
  left_join(., purchases %>% mutate(externalsessionid = externalsessionid %>% factor), by = 'externalsessionid') %>% 
  select(externalsessionid, product_id, RFM_group) %>% 
  left_join(., ABCFMR_data, by = 'product_id') %>% 
  select(externalsessionid, product_id, RFM_group, ABCFMR_group)

table(RFM_ABCFMR_data$RFM_group, RFM_ABCFMR_data$ABCFMR_group, dnn = c('RFM groups', 'ABCFMR groups'))

#Customers segmentation by views

customers_data <- item_views %>% 
  left_join(., purchases, by = c('externalsessionid', 'product_id')) %>% 
  filter(!is.na(product_id)) %>% 
  mutate(purchase = ifelse(is.na(ordernumber), 0, 1) %>% factor)

##Checking out for the difference in view duration between customers who have bought some item and not

summary(customers_data$duration) #let's remove outliers

customers_data %<>% filter(duration < quantile(customers_data$duration, 0.9))

summary(customers_data$duration)

ggplot(customers_data, aes(x = duration))+
  geom_histogram()+
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5))+
  labs(title = 'Distribution of items view duration')

purchase.labs <- c('Not purchase', 'Purchase')
names(purchase.labs) <- c("0", "1")

ggplot(customers_data, aes(x = duration, fill = purchase))+
  geom_histogram()+
  facet_wrap(~ purchase, labeller = labeller(purchase = purchase.labs))+
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5), legend.position = 'none')+
  labs(title = 'Distribution of items view duration between customers who have bought some item and not')

ggplot(data = customers_data)+
  geom_qq(aes(sample = duration))+
  theme_minimal()+
  theme(legend.position = "none", plot.title = element_text(hjust = 0.5))+
  labs(title = "Duration QQ-plot", x = "Theoretical quantilles", y = "Duration")

ggplot(data = customers_data)+
  geom_qq(aes(sample = duration))+
  facet_wrap(~ purchase, labeller = labeller(purchase = purchase.labs))+
  theme_minimal()+
  theme(legend.position = "none", plot.title = element_text(hjust = 0.5))+
  labs(title = "Duration QQ-plot divided by customers who have bought some item and not", x = "Theoretical quantilles", y = "Duration")

ggplot(customers_data, aes(x = purchase, y = duration, fill = purchase))+
  geom_boxplot()+
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5), legend.position = 'none')+
  labs(title = 'Difference between purchased and not purchased itmes by view duration')

summary(customers_data$duration[customers_data$purchase == '0'])
summary(customers_data$duration[customers_data$purchase == '1'])

nortest::ad.test(customers_data$duration)
nortest::ad.test(customers_data$duration[customers_data$purchase == '0'])
nortest::ad.test(customers_data$duration[customers_data$purchase == '1'])

car::leveneTest(data = customers_data, duration ~ purchase)

wilcox.test(data = customers_data, duration ~ purchase) #there is statistically significant difference between groups

##Checking out for the correlation between view duration and purchase sum

ggplot(customers_data %>% filter(purchase == '1'), aes(x = totalcents))+
  geom_histogram()+
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5))+
  labs(title = 'Distribution of customers spendings')

ggplot(customers_data %>% filter(purchase == '1'), aes(x = duration, y = totalcents))+
  geom_point()+
  geom_smooth(method = 'lm')+
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5))+
  labs(title = 'Correlation between view duration and total spendings')

nortest::ad.test(customers_data$totalcents)

cor.test(customers_data$duration[customers_data$purchase == '1'], 
         customers_data$totalcents[customers_data$purchase == '1'], method = 'spearman') #no correlation between view duration and purchase sum

cor.test(customers_data$duration[customers_data$purchase == '1'], 
         customers_data$totalcents[customers_data$purchase == '1'], method = 'kendall') #no correlation between view duration and purchase sum
