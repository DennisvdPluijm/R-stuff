library(swirl)
swirl()

## Getting and Cleaning Data - 1: Manipulating Data with dplyr
# dply supplies 5 verbs: select(), filter(), arrange(), mutate(), summarize()
mydf <- read.csv(path2csv, stringsAsFactors = FALSE)
dim(mydf)
head(mydf)
library(dplyr)
packageVersion("dplyr")
cran <- tbl_df(mydf)
rm(mydf)
cran
select(cran, ip_id, package, country)
select(cran, r_arch:country)
select(cran, country:r_arch)
select(cran, -time)
select(cran, -(X:size))
filter(cran, package == "swirl")
filter(cran, r_version == "3.1.1", country == "US")
filter(cran, r_version <= "3.0.2", country == "IN")
filter(cran, r_os == "linux-gnu" & size > 100500) # equivalent to:
filter(cran, r_os == "linux-gnu", size > 100500)
filter(cran, !is.na(r_version))
cran2 <- select(cran, size:ip_id)
arrange(cran2, ip_id) #sort rows by ip_id in ascending order
arrange(cran2, desc(ip_id))
arrange(cran2, package, ip_id)
arrange(cran2, country, desc(r_version), ip_id)
cran3 <- select(cran, ip_id, package, size)
cran3
mutate(cran3, size_mb = size / 2^20)
mutate(cran3, size_mb = size / 2^20, size_gb = size_mb / 2^10)
mutate(cran3, correct_size = size + 1000)
summarize(cran, avg_bytes = mean(size))

## Getting and Cleaning Data - 2: Grouping and Chaining with dplyr
cran <- as_tibble(mydf) # equivalent to:
cran <- tbl_df(mydf) # deprecated
rm(mydf) # or:
rm("mydf")
cran
by_package <- group_by(cran, package)
by_package # tbl still looks the same, but any operation will be applied to the grouped data (e.g. per package)
summarize(by_package, avg_bytes = mean(size)) # or simply: 
summarize(by_package, mean(size))
pack_sum <- summarize(by_package,
                      count = n(),
                      unique = n_distinct(ip_id),
                      countries = n_distinct(country),
                      avg_bytes = mean(size))
pack_sum
quantile(pack_sum$count, probs = 0.99)
top_counts <- filter(pack_sum, count > 679)
top_counts
View(top_counts)
top_counts_sorted <- arrange(top_counts, desc(count))
View(top_counts_sorted)
quantile(pack_sum$unique, probs = 0.99)
top_unique <- filter(pack_sum, unique > 465)
View(top_unique)
top_unique_sorted <- arrange(top_unique, desc(unique))
#same approach using chaining (piping)
result3 <-
  cran %>%
  group_by(package) %>%
  summarize(count = n(),
            unique = n_distinct(ip_id),
            countries = n_distinct(country),
            avg_bytes = mean(size)
  ) %>%
  filter(countries > 60) %>%
  arrange(desc(countries), avg_bytes)
print(result3)
cran %>%
  select(ip_id, country, package, size) %>%
  mutate(size_mb = size / 2^20) %>%
  filter(size_mb <= 0.5) %>%
  arrange(desc(size_mb)) %>%
  print

## Getting and Cleaning Data - 3: Tidying Data with tidyr
library(tidyr)
# 1. create key-value pairs from a column that has values as headers, not variable names. e.g male/female
students
gather(students, sex, count, -grade)
# 2. multiple variables stored in one column: e.g. both sex and class
students2
res <- gather(students2, sex_class, count, -grade) # step 1
res
separate(res, sex_class, c("sex", "class")) # step 2: tries to separate on non-alphanumeric values
# using pipes:
students2 %>%
  gather(sex_class , count, -grade) %>%
  separate(sex_class , c("sex", "class")) %>%
  print
# 3. variables stored in both rows and columns
library(readr)
students3 %>%
  gather(class, grade, class1:class5, na.rm = TRUE) %>% # step 1: create a class variabke
  spread(test , grade) %>% # step 2: spread values in test column to its own variable containing the grades
  mutate(class = parse_number(class)) %>%  # parse "class1/2/.." values to "1/2/.." using readr
  print
# 4. multiple observational units stored in same table (e.g. repeated id, name, sex)
# split into two separate tables, with id as primary key to connect the two tables
student_info <- students4 %>%
  select(id, name, sex) %>%
  unique %>%
  print
gradebook <- students4 %>%
  select(id, class, midterm, final) %>%
  print
# 5. single observational unit stored in multiple tables
# add new variable 'status' to retain information from both tables
passed <- mutate(passed, status = "passed")
failed <- mutate(failed, status = "failed")
# join tables together using bind_rows
bind_rows(passed, failed)
# Everything together
# 'sat' contains columns "score_range" and read/math/write_male/fem/total" with #students as values for each combination
sat %>%
  select(-contains("total")) %>%  # 'total' can be always be recreated from male+female
  gather(part_sex, count, -score_range) %>%
  separate(part_sex, c("part", "sex")) %>%
  group_by(part, sex) %>%
  mutate(total = sum(count),
         prop = sprintf("%1.2f%%",count/total*100)) %>%
  arrange(desc(count)) %>%  # cannot arrange on prop, since it is changed to chr by sprintf
  print
