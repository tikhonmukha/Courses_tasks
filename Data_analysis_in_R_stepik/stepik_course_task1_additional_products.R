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

#Most popular categories by purchases

categories_purchases <- purchases %>% 
  left_join(., product_categories, by = "product_id") %>% 
  left_join(., categories, by = "category_id") %>% 
  select(name) %>% 
  group_by(name) %>% 
  count() %>% 
  arrange(desc(n)) %>% 
  head(25)

ggplot(data = categories_purchases, aes(x = reorder(name,-n), y = n, fill = n))+
  geom_col()+
  geom_text(aes(label = n), size = 4, hjust = 0.5, vjust = 1, colour = "white")+
  scale_y_continuous(limits = c(0, 250))+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5), 
        axis.text.x = element_text(angle = 45, size = rel(0.85), hjust = 1, vjust = 1),
        legend.position = "none", axis.title.x = element_blank())+
  labs(title = "Top-25 categories by purchases number", y = "Number of purchases")

#Most popular categories by views

categories_views <- category_views %>% 
  left_join(., categories, by = "category_id") %>% 
  select(name) %>% 
  group_by(name) %>% 
  count() %>% 
  arrange(desc(n)) %>% 
  head(25)

ggplot(data = categories_views, aes(x = reorder(name,-n), y = n, fill = n))+
  geom_col()+
  geom_text(aes(label = n), size = 4, hjust = 0.5, vjust = 1, colour = "white")+
  scale_y_continuous(limits = c(0, 1000))+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5), 
        axis.text.x = element_text(angle = 45, size = rel(0.85), hjust = 1, vjust = 1),
        legend.position = "none", axis.title.x = element_blank())+
  labs(title = "Top-25 categories by views number", y = "Number of views")

#Correlation between purchases and views and covertation from views to purchases

purchases_views_cor <- categories_purchases %>% 
  left_join(., categories_views, by = "name") %>% 
  rename("tot_purchases" = "n.x", "tot_views" = "n.y") %>% 
  mutate(convert_into_purchase = round(tot_purchases/tot_views, digits = 2)) %>% 
  arrange(desc(convert_into_purchase)) %>% 
  filter(convert_into_purchase != is.na(convert_into_purchase))

cor.test(x = purchases_views_cor$tot_views, y = purchases_views_cor$tot_purchases, method = "spearman")

ggplot(data = purchases_views_cor, aes(x = tot_views, y = tot_purchases))+
  geom_point(data = purchases_views_cor, aes(size = convert_into_purchase, color = convert_into_purchase))+
  geom_smooth(method = "lm")+
  scale_y_continuous(limits = c(0, 1000))+
  scale_x_continuous(limits = c(0, 1000))+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5), legend.position = "bottom")+
  labs(title = "Correlation between categories views and purchases", x = "Number of views", y = "Number of purchases")

ggplot(data = purchases_views_cor, aes(x = reorder(name,-convert_into_purchase), y = convert_into_purchase, fill = convert_into_purchase))+
  geom_col(na.rm = T)+
  geom_text(aes(label = convert_into_purchase), size = 4, hjust = 0.5, vjust = 1, colour = "white")+
  scale_y_continuous(limits = c(0, 1))+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5), 
        axis.text.x = element_text(angle = 45, size = rel(0.9), hjust = 1, vjust = 1),
        legend.position = "none", axis.title.x = element_blank())+
  labs(title = "Convertation from views to purchases", y = "Convertation value")

#Additional products by purchases

products_with_category <- left_join(products, product_categories, by = "product_id")
purchases_with_category <- left_join(purchases, product_categories, by = "product_id")

orders_data_total <- purchases_with_category %>% 
  group_by(ordernumber) %>% 
  summarise(total_products = n(),
            unique_categories = category_id %>% unique %>% length,
            unique_products = product_id %>% unique %>% length)

ggplot(data = orders_data_total, aes(x = unique_products))+
  geom_histogram(binwidth = 1, fill = "blue", colour = "black")+
  scale_x_continuous(breaks = seq(0,15,by=1))+
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5))+
  labs(title = "Unique products number per order", x = "", y = "Number of orders")

orders_data_more_than_1 <- orders_data_total %>% 
  filter(total_products > 1)

ggplot(data = orders_data_more_than_1, aes(x = unique_categories))+
  geom_histogram(binwidth = 1, fill = "blue", colour = "black")+
  scale_x_continuous(breaks = seq(0,15,by=1))+
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5))+
  labs(title = "Unique categories number in orders with many purchases (more than 1)", x = "", y = "Number of orders")

unique_orders <- orders_data_more_than_1 %>% 
  filter(unique_categories > 1) %>%
  .$ordernumber

unique_categories <- purchases_with_category %>% 
  filter(ordernumber %in% unique_orders) %>%
  .$category_id %>% 
  unique %>% 
  sort

categories_matrix <-
  matrix(
    0, nrow = unique_categories %>% length, ncol = unique_categories %>% length, dimnames = list(unique_categories, unique_categories)
  )

for (x in unique_orders) {
  categories_list <-
    purchases_with_category %>% filter(ordernumber == x) %>% .$category_id %>% as.character %>% sort
  categories_matrix[categories_list[1], categories_list[c(2:length(categories_list))]] %<>% `+`(1)
}

diag(categories_matrix) <- 0

df <- which(categories_matrix > 1, arr.ind = TRUE) %>% as.data.frame

df %<>% mutate(count = mapply(function(i,j) categories_matrix[i,j], row, col)) %>% arrange(count %>% desc)

df$row <-
  sapply(df$row, function(x)
    categories$name[categories$category_id == unique_categories[x]])

df$col <-
  sapply(df$col, function(x)
    categories$name[categories$category_id == unique_categories[x]])

df

#Products that always were buy with other products (complementary products)

ind_categories_numbers <- purchases_with_category %>% 
  filter(ordernumber %in% (orders_data_total %>% 
                             filter(unique_categories == 1) %>% 
                             .$ordernumber)) %>% 
  .$category_id %>% 
  unique %>% 
  sort #checking out for categories numbers what were buy without additional products

categories$name[categories$category_id %in% ind_categories_numbers & 
                  categories$category_id %in% purchases_with_category$category_id] %>% head(10) #independent categories names

categories$name[!(categories$category_id %in% ind_categories_numbers) & 
                  categories$category_id %in% purchases_with_category$category_id] %>% head(10) #categories what always were buy with additional products

unique_purchase <- purchases_with_category %>% 
  distinct(ordernumber, category_id, .keep_all = TRUE)

unique_purchase <- unique_purchase %>% 
  group_by(ordernumber) %>% 
  mutate(num_of_categories = n()) %>% 
  ungroup %>% 
  group_by(category_id) %>% 
  mutate(tot_by_category = n(),
         if_unique_num = sum(num_of_categories == 1),
         if_unique = sum(num_of_categories == 1)/tot_by_category) %>% 
  ungroup #finding for each category: how much times the category was the only (unique) in check, how much times the category was in check with and without other products, category uniqueness coefficient

unique_categories_df <- categories %>% 
  select(category_id, name) %>% 
  left_join(., unique_purchase %>% 
              select(category_id, if_unique, if_unique_num, tot_by_category) %>% 
              distinct(category_id, .keep_all = TRUE), by = "category_id") %>% 
  filter(!is.na(if_unique)) %>% 
  arrange(desc(tot_by_category)) #selecting for each category its id, name, uniqueness coefficient, number of purchases of only the category (only without other categories in check), number of purchases total (with or without other categories in check)

#Combining the results of joint and unique purchases

df$row_occurence <- sapply(df$row, function(x) {
  unique_categories_df$if_unique[unique_categories_df$name == x]
})

df$col_occurence <- sapply(df$col, function(x) {
  unique_categories_df$if_unique[unique_categories_df$name == x]
})

df %<>% mutate(
  main_category = ifelse(row_occurence >= col_occurence, row, col),
  additional_category = ifelse(row_occurence < col_occurence, row, col),
  additional_category_occurence =
    ifelse(row_occurence < col_occurence, row_occurence, col_occurence),
  main_cat_occurence =
    ifelse(row_occurence >= col_occurence, row_occurence, col_occurence)
)

#Additional products by views

categories_by_views <- category_views %>% 
  group_by(externalsessionid) %>% 
  summarise(total = n(), unique_categories = category_id %>% unique %>% length) #looking for total and unique categories number in each session

categories_by_views_morethan1 <- categories_by_views %>% 
  filter(total > 1) #finding sessions with more than one viewed category

ggplot(data = categories_by_views_morethan1, aes(x = unique_categories))+
  geom_histogram(binwidth = 1)+
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5))+
  labs(title = "Количество просмотренных категорий за сессию", x = "Количество категорий", y = "Частота")

#Categories joint appearance per session

unique_categories_views_list <- category_views$category_id %>% 
  unique() %>% 
  sort()

unique_sessionid_list <- category_views$externalsessionid %>% 
  unique() %>% 
  sort()

views_matrix <- matrix(0, nrow = unique_categories_views_list %>% length, 
                       ncol = unique_categories_views_list %>% length, 
                       dimnames = list(unique_categories_views_list, unique_categories_views_list))

for(x in unique_sessionid_list){
  categories_list <- category_views %>% 
    filter(externalsessionid == x) %>% 
    .$category_id %>% 
    as.character %>% 
    sort
  if(categories_list %>% length > 1)
    views_matrix[categories_list[1], categories_list[c(2:length(categories_list))]] %<>% `+`(1)
}

diag(views_matrix) <- 0

df_views <- which(views_matrix > 1, arr.ind = TRUE) %>% as.data.frame

df_views %<>% mutate(
  total = mapply(function(i,j) views_matrix[i,j], row, col)
) %>% arrange(total %>% desc)

df_views$row_name <- sapply(df_views$row, function(x) categories$name[categories$category_id == unique_categories_views_list[x]])
df_views$col_name <- sapply(df_views$col, function(x) categories$name[categories$category_id == unique_categories_views_list[x]])

head(df_views)

#Searching for how much times each category was unique per view

unique_views <- category_views %>% 
  group_by(category_id) %>% 
  mutate(categories_num_of_view = n()) %>% 
  ungroup %>% 
  group_by(externalsessionid) %>% 
  mutate(tot_by_category = n(),
         if_unique_num = sum(categories_num_of_view == 1),
         if_unique = sum(categories_num_of_view == 1)/tot_by_category) %>% 
  ungroup #finding for each category: how much times the category was the only (unique) in a view, how much times the category was in a view with and without other products, category uniqueness coefficient

unique_categories_by_views_df <- categories %>% 
  select(category_id, name) %>% 
  left_join(., unique_views %>% 
              select(category_id, if_unique, if_unique_num, tot_by_category) %>% 
              distinct(category_id, .keep_all = TRUE), by = "category_id") %>% 
  filter(!is.na(if_unique)) %>% 
  arrange(desc(tot_by_category)) #selecting for each category its id, name, uniqueness coefficient, number of views of only the category (only without other categories in check), number of views total (with or without other categories in check)

df_views$row_occurence <- sapply(df_views$row, function(x) {
  unique_categories_by_views_df$if_unique[unique_categories_by_views_df$category_id == unique_categories_views_list[x]]
})

df_views$col_occurence <- sapply(df_views$col, function(x) {
  unique_categories_by_views_df$if_unique[unique_categories_by_views_df$category_id == unique_categories_views_list[x]]
})

df_views %<>% mutate(
  main_category = ifelse(row_occurence >= col_occurence, row_name, col_name),
  additional_category = ifelse(row_occurence < col_occurence, row_name, col_name),
  additional_category_occurence =
    ifelse(row_occurence < col_occurence, row_occurence, col_occurence),
  main_cat_occurence =
    ifelse(row_occurence >= col_occurence, row_occurence, col_occurence)
)

df_views_final <- df_views %>% 
  select(main_category, additional_category, total) %>% 
  arrange(desc(total))