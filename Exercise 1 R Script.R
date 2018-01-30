library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(dummies)

df <- read.csv('refine_original.csv')
print(df)

df <- rename(df, product_code_number = 'Product.code...number')

#1: Clean up brand names to be: philips, akzo, van houten, unileve#

df %>% group_by(company) %>% n_groups()
df %>% select(company) %>% distinct

df <- mutate(df, company = tolower(company))

print(df)

df %>% group_by(company) %>% n_groups()
df %>% select(company) %>% distinct

df <- mutate(df, company = gsub("phillips|fillips|phlips|phllips|phillps", "philips", company))
df <- mutate(df, company = gsub("akz0|ak zo", "akzo", company))
df <- mutate(df, company = gsub("unilver", "unilever", company))

df %>% group_by(company) %>% n_groups()
df %>% select(company) %>% distinct

print(df)

#2: Separate product code and number: add two new columns called product_code and product_number#

df <- separate(df, product_code_number, c("product_code", "number"), sep = "-")

print(df)

#Add product categories: Smartphone, TV, Laptop, Tablet"#

df <- mutate(df, product_category = product_code)

print(df)

df <- mutate(df, product_category = gsub("p", "smartphone", product_category))
df <- mutate(df, product_category = gsub("v", "tv", product_category))
df <- mutate(df, product_category = gsub("x", "laptop", product_category))
df <- mutate(df, product_category = gsub("q", "tablet", product_category))

print(df)

#4: Add full address for geocoding#

df <- transform(df, full_address=paste(address, city, country, sep=","))

print(df)

#5: Create dummy variables for company and product category#

df <- cbind(df, dummy(df$product_category, sep = "_"))
df <- cbind(df, dummy(df$product_category, sep = "_"))

print(df)

write_csv(df, 'refine_clean.csv')