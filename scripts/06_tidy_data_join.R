# Data wrangling

library(tidyverse)


# 1. Tidy data -------------------------------------------------------------

# The same data can be stored in multiple ways

table1
table2
table3
table4a; table4b

# What makes data tidy?
# 1. Each variable is a separate column
# 2. Each observation is a separate row
# 3. Each value is a separate cell

# Practically: 
# 1. Each dataset should be in one tibble
# 2. Each variable should be in one column

# Of the four examples above, which can be considered tidy?

# Why is this useful?

# - Consistently tidy data helps apply general principles
#   when working with data
# - Tidyverse packages assume tidy data

# E.g., cases per 10,000 people
table1 %>%
  mutate(rate = cases / population * 10000)

# Or number of cases by year
table1 %>%
  count(year, wt = cases)

# Change over one year
ggplot(table1, aes(year, cases)) + 
  geom_line(aes(group = country), colour = "grey50") + 
  geom_point(aes(colour = country))

# How would you produce the same summaries and
# the same plot using table2 and table4a/4b?


# 1.1 Spreading and gathering -------------------------------------------

# Unfortunately data is often not stored in tidy format.
# Why?
# Many people don’t know about tidy data, and it’s not obvious
# Data structure often helps data entry, not analysis


# How do we convert data to tidy format?

# Step 1: Identify variables and observations

# Step 2: Two main issues:
# - data belonging to one variable may appear in several columns
# - one observation may be spread across multiple rows
# Usually only one of these is present at a time.

# These problems are solved by tidyr’s two core functions:
# pivot_longer() and pivot_wider()

# pivot_longer (making data longer): 
# when column names encode values of a variable

table4a

# Three important arguments:

# - Which columns contain values, not variables?
# - What is the variable whose values are encoded in the column names? (names_to)
# - What is the variable whose values are stored in the cells? (values_to)

table4a %>%
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")

# Columns are selected like in dplyr::select().


# Similarly for table4b, but now the cell values represent a different variable

table4b %>%
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")

# To combine the datasets into one tibble, use left_join()

tidy4a <- table4a %>%
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "cases")
tidy4b <- table4b %>%
  pivot_longer(c(`1999`, `2000`), names_to = "year", values_to = "population")
left_join(tidy4a, tidy4b)


# We will discuss joins later!

# pivot_wider (making data wider): 
# when a column contains variable names

table2

# Now two things matter:
# - Which column contains variable names? (names_from)
# - Which column contains the values? (values_from)

table2 %>%
  pivot_wider(names_from = type, values_from = count)

# pivot_longer: wide → long
# pivot_wider: long → wide


# 1.1.1 Practice - pivot_longer and pivot_wider  --------------------------------------

# 1) Make the preg data tidy!

preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)


# 2) Why are pivot_wider and pivot_longer not perfectly symmetric? 

stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)
stocks %>%
  pivot_wider(names_from = year, values_from = return) %>%
  pivot_longer(`2015`:`2016`, names_to = "year", values_to = "return")

# 3) Why can’t this table be spread? What would you need to do to fix it?

people <- tribble(
  ~name,             ~key,    ~value, 
  #-----------------|--------|------
  "Phillip Woods",   "age",       45, 
  "Phillip Woods",   "height",   186, 
  "Phillip Woods",   "age",       50, 
  "Jessica Cordero", "age",       37, 
  "Jessica Cordero", "height",   156
)


# 1.2 Separation and uniting --------------------------------------------

# A column may contain values from more than one variable!

table3

# This is what separate() is for:

table3 %>%
  separate(rate, into = c("cases", "population"))

# separate() detects non‑alphanumeric characters as separators.
# You can also specify the separator:

table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/")

# Oops! Numbers became character
# - because they were character in the original,
# and separate() does not change column type by default
# convert=TRUE: attempts to convert to a better type after splitting

table3 %>%
    separate(rate, into = c("cases", "population"), convert = TRUE)

# sep can also take integers specifying positions:

table3 %>%
    separate(year, into = c("century", "year"), sep = 2)

# Not very useful here, but sometimes handy!

# unite(): combine multiple columns into one

table5

table5 %>%
  unite(new, century, year)

# Default separator: _
# If you don’t want a separator:

table5 %>%
    unite(new, century, year, sep="")


# 1.2.1 Practice - separate and unite ------------------------------

# 1) What do the extra and fill arguments of separate() do?

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
  separate(x, c("one", "two", "three"))


tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
  separate(x, c("one", "two", "three"))



#  -----------------------------------------------------

# Missing data can appear in two ways:
# - Explicit: marked with NA (presence of missingness)
# - Implicit: simply not present in the data (absence of presence)

# Where are these in the example?

stocks <- tibble(
    year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
    qtr    = c(   1,    2,    3,    4,    2,    3,    4),
    return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)

# A different arrangement can make all missing values explicit

stocks %>%
    pivot_wider(names_from = year, values_from = return)

# If explicit missing values are not interesting, we can make them implicit

stocks %>%
  pivot_wider(names_from = year, values_from = return) %>%
  pivot_longer(
    cols = c(`2015`, `2016`), 
    names_to = "year", 
    values_to = "return", 
    values_drop_na = TRUE
  )

# We can make implicit missing data explicit using complete()

stocks %>%
    complete(year, qtr)

# One more important thing:
# “Missing data” may also be “forgotten data entry”

treatment <- tribble(
    ~ person,           ~ treatment, ~response,
    "Derrick Whitmore", 1,           7,
    NA,                 2,           10,
    NA,                 3,           9,
    "Katherine Burke",  1,           4
)

# In such cases use fill()!

treatment %>%
    fill(person)

# It fills missing values going downward using the last non‑missing value
# ("last observation carried forward")

# fill() .direction argument:

treatment %>%
  fill(person, .direction = "up")


# More about tidy data: www.jstatsoft.org/v59/i10/paper 
# About non‑tidy formats: https://simplystatistics.org/2016/02/17/non-tidy-data/ 


# 2. Joining data tables ------------------------------------------------

library(nycflights13)

# Our data often lives in multiple tables.
# Example: logs + experiment results + questionnaires. 

# nycflights13 contains several tibbles:
airlines
airports
planes
weather

# How are these tables related?
# http://r4ds.had.co.nz/diagrams/relational-nycflights.png

# Tables are connected using “keys”
# Key: a variable (or set of variables)
# that uniquely identifies an observation
# 
# Primary key: 
#   uniquely identifies an observation within a table
#   e.g., planes$tailnum
# Foreign key: 
#   uniquely identifies an observation in another table
#   e.g., flights$tailnum 
# 
# A variable may be both!
# 
# A primary key together with a foreign key 
# define a relationship.

# If we identify a primary key,
# we should check if it is truly unique.
# Does it accidentally refer to multiple observations?

planes %>%
    count(tailnum) %>%
    filter(n > 1)

weather %>%
    count(year, month, day, hour, origin) %>%
    filter(n > 1)

# Sometimes a table has no primary key at all!
# Is flight number / plane ID + date a primary key in flights? 






# In such cases it’s good practice to add a row number 
# (surrogate key)

stocks %>%
  mutate(
    rownumm = row_number()
  )


# 2.1 Mutating joins -------------------------------------------------------

# Matches observations based on keys, then 
# copies variables from one table to the other

# Use a narrower table for clarity:

flights2 <- flights %>%
    select(year:day, hour, origin, dest, tailnum, carrier)

flights2

# Example: add airline full name (from airlines table) 
# to the flights2 table:

flights2 %>%
    select(-origin, -dest) %>%
    left_join(airlines, by = "carrier")

# We could do the same with mutate,
# but it’s less clear and more complicated with many variables

flights2 %>%
  select(-origin, -dest) %>%
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

# We demonstrate join basics on simple example tables:

x <- tribble(
    ~name, ~age,
    "Anna", "20",
    "Béla", "30",
    "Csaba", "40"
)

y <- tribble(
    ~name, ~has_cats,
    "Anna", 0,
    "Béla", 4,
    "Dávid", 1
)

z <- tribble(
    ~name, ~favourite_colour,
    "Anna", "blue",
    "Béla", "red",
    "Zsuzsi", "gray"
)

# Inner join
# Keeps only matching observations in both tables

x %>%
    inner_join(y, by = "name")

# Outer join
# Keeps an observation if it appears in at least one table
# http://r4ds.had.co.nz/diagrams/join-outer.png 

# left_join(): retains all rows from the left table

x %>%
    left_join(y,  by = "name") 

# right_join(): retains all rows from the right table

x %>%
    right_join(y, by = "name") 

# full_join(): retains all rows from both tables

x %>%
    full_join(y, by = "name")

# Venn diagram of join types: http://r4ds.had.co.nz/diagrams/join-venn.png 

# What happens if keys do not uniquely identify observations?

# A) Duplicated in one table, unique in the other
# e.g., storing extra info in a separate table
# one-to-many relationship (flights–airports)

x <- tribble(
    ~name, ~lunch_today,
    "Anna", "potatoes",
    "Béla", "pumpkins",
    "Béla", "goulash",
    "Anna", "sandwich"
)

y <- tribble(
    ~name, ~uni,
    "Anna", "BME",
    "Béla", "ELTE"
)

left_join(x, y, by = "name")

# B) Duplicated in both tables:
# this is usually an error, because the key is not primary in either table.
# Joining will create all combinations

x <- tribble(
    ~name, ~age,
    "Anna", "20",
    "Béla", "30",
    "Béla", "50",
    "Csaba", "40"
)

y <- tribble(
    ~name, ~weight,
    "Anna",  "60",
    "Béla",  "80",
    "Béla",  "100",
    "Csaba", "90"
)

left_join(x, y, by = "name")

# Specifying keys in *_join() via by argument

# A) Default: by=NULL. Uses all common variables (natural join)

flights2 %>%
    left_join(weather)

# B) Character vector
# E.g. year exists in both tibble, but they don’t mean the same!

flights2 %>%
    left_join(planes, by = "tailnum")

# C) Named character vector: c("a" = "b")

# Join destination coordinates:

flights2 %>%
    left_join(airports, c("dest" = "faa"))

# Join origin coordinates:

flights2 %>%
  left_join(airports, c("origin" = "faa"))


# 2.1.1 Practice - mutating join -----------------------------------------

# 1) Is there a relationship between an airplane’s age and its delays?




# 2) Which aspects of weather relate to departure delays?


  

# 2.2 Filtering joins ------------------------------------------------------

# Same logic as mutating joins,
# but affect only rows, not columns

# semi_join(x, y) – keep rows of x with a match in y

# anti_join(x, y) – drop rows of x with a match in y

# What are the ten most frequent destinations?

top_dest <- flights %>%
  count(dest, sort = TRUE) %>%
  head(10)
top_dest

# Which flights went to these destinations?

# We could use filter:

flights %>%
  filter(dest %in% top_dest$dest)

# Harder with multiple variables 
# (e.g., find top 10 days with highest average delay),
# so semi_join is better:

flights %>%
  semi_join(top_dest)

# anti_join helps inspect non‑matches

# Which flights have no matching record in planes?

flights %>%
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = TRUE)


# 2.2.1 Practice - filtering join ----------------------------------------

# 1) Filter flights to keep only flights by aircraft
# that have flown at least 100 trips!



# 2) Identify the 48 hours of the year with the longest delays.
# Join with weather. Do you see patterns?



# 2.3 Set operations ---------------------------------------------------------

# Also useful for comparing tables
# They operate on whole rows
# They assume both tables have the same variables
# Observations are treated as sets

# Intersection, union, and set difference. Example data:

df1 <- tribble(
  ~x, ~y,
  1,  1,
  2,  1
)

df2 <- tribble(
  ~x, ~y,
  1,  1,
  1,  2
)

# Intersection: rows present in both

intersect(df1, df2)

# Union: rows in either or both tables

union(df1, df2)

# Set difference: rows in first table but not second

setdiff(df1, df2)

setdiff(df2, df1)
