library(readxl)
library(dplyr)
customers <- read_excel("C:/Users/miqui/OneDrive/CSU Classes/Consulting/SQL Joins/joins example.xlsx", 
                        sheet = "Customers")
orders <- read_excel("C:/Users/miqui/OneDrive/CSU Classes/Consulting/SQL Joins/joins example.xlsx", 
                     sheet = "Orders")

names(customers)
names(orders)

"Inner Join:"
inner <- inner_join(x = customers, y = orders, by = c("customer_id"))
inner %>% select(first_name, last_name, order_date, amount)

"Left Join:"
left <- left_join(x = customers, y = orders, by = c("customer_id"))
left %>% select(first_name, last_name, order_date, amount)

# or

merge(customers, orders, by="customer_id", all=customers)

"Right Join:"
right <- right_join(x=customers, y=orders, by=c("customer_id"))
right %>% select(first_name, last_name, order_date, amount)

"Full Join:"
outer <- merge(customers, orders, by = "customer_id", all = TRUE) 
# or
outer <- full_join(customers, orders, by="customer_id")
outer %>% select(first_name, last_name, order_date, amount, order_id)
