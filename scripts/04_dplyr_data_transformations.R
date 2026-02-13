####  Transformations using the dplyr package


library(tidyverse)
library(nycflights13)


#### 0. Preparations and basics ----------------------------------------------

# Basics of dplyr syntax:

# Selecting rows based on their values: filter().
# Reordering rows: arrange().
# Selecting variables by name: select().
# Calculating new variables from existing ones: mutate().
# Computing a summary statistic from many values: summarise().

# Operations by groups: group_by().

# How they work: 
# First argument is always a data table 
# Next arguments: what to do with the data, which variables (without quotation marks)
# They always return a data table (data.frame)

# We will try out what dplyr can do on the flights data table:

flights
# Shorthand labels under variable names indicate variable types
# int - integer
# dbl - double = real number
# chr - character = strings
# dttm - date-time = date and time
# lgl - logical
# fctr - factor = categorical variable with fixed possible values
# date - date = date

# The console does not show all variables or all rows
# To inspect the data table more thoroughly:

View(flights)

#### 1. Filtering rows: filter()  --------------------------------

# 1st argument: data, next argument(s): filtering conditions

# Flights on Jan. 1:

filter(flights, month == 1, day == 1)

# dplyr functions never modify the input. 
# To save the result, we must assign it to a variable: 
# <- is the assignment symbol, in RStudio (Win): alt + "-" is the shortcut
# (More shortcuts: Tools / Keyboard shortcuts help)

jan1 <- filter(flights, month == 1, day == 1)

# Store and view the filtering result at the same time: 
# wrap the entire assignment in ()

(dec25 <- filter(flights, month == 12, day == 25))

# Comparisons using logical operators:
# < , > , <= , >= , != , ==

# Watch out! Logical comparison uses two equals signs!

filter(flights, month = 1)

# Anomalies when using == with decimals:

sqrt(2)^2 == 2
1/49 * 49 == 1

# The reason is finite precision in computers. 
# The problem can be avoided using near().

near(sqrt(2)^2, 2)
near(1 / 49 * 49, 1)

# Combining filtering conditions with logical operators:
# http://r4ds.had.co.nz/diagrams/transform-logical.png 
# & , | , ! , xor

filter(flights, month == 11 | month == 12 | month == 3 | month == 1)

# Listing multiple possible values more concisely (equivalent to above)
# (month value is an element of the vector-specified set)

nov_dec_mar_jan <- filter(flights, month %in% c(11, 12, 3, 1))


# Missing values (NA as "not available") complicate comparisons
# In most operations, if an NA is involved, the output is also NA

NA > 5
10 == NA
NA + 10
NA / 2

# The truly confusing part:

NA == NA


# In context it's easier to understand:
# Let x be Anna's age, which is unknown

x <- NA

# Let y be Béla's age, also unknown

y <- NA

# Are Anna and Béla the same age?

x == y

# We cannot know!


# Check whether a value is missing: is.na()

is.na(x)

# filter keeps only rows where the logical condition is TRUE
# rows where it is FALSE or NA are dropped
# If we want to keep rows with missing values, we must state it explicitly

# A mini example dataset
df <- tibble(x = c(1, NA, 3))
# It looks like this
df

# By default filter drops the NA
filter(df, x > 1)

# We must explicitly keep NA if desired
filter(df, is.na(x) | x > 1)


# 1.1 Practice - filter() ------------------------------------------------

# 1) Select all flights that
# a, arrived with at least 2 hours delay


# b, flew during summer (June, July, August)


# c, were more than 2 hours late, even though they departed on time


# d, departed from JFK airport but did not arrive in Miami (MIA)


# e, departed between midnight and 6 AM (including exactly midnight and 6 AM)


# 2) What is between() useful for? Could you simplify the above searches with it? 


# 3) How many flights have missing departure time (dep_time)?





#### 2. Sorting rows: arrange() ------------------------

arrange(flights, year, month, day)


# Descending order:

arrange(flights, desc(arr_delay))

# Missing values always go to the end:

df <- tibble(x = c(5, 2, NA))
df
arrange(df, x)
arrange(df, desc(x))



# 2.1 Practice - arrange() -----------------------------------------------

# Answer questions 1) and 2) using the sorted flights table!

# 1) Which flights had the longest delays? And which departed the earliest?


# 2) Which flights flew the farthest? And the shortest distances?


# 3) How could arrange() be used to bring missing values to the front? 



#### 3. Selecting variables: select() --------------------------------------

select(flights, year, month, day)

# Two variables, and those between them

select(flights, year:day)

# Dropping variables

select(flights, -(year:day))

# Useful helper functions https://dplyr.tidyverse.org/reference/select.html

# Variable name starts with
select(flights, starts_with("dep"))

# Variable name ends with
select(flights, ends_with("time"))

# Variable name contains
select(flights, contains("arr_") )


# Renaming variables: rename() (keeps all others)

rename(flights, tail_num = tailnum)

# We can rename while selecting:

select(flights, tail_num = tailnum)

# If we want to put some variables at the beginning and grab all others at once: everything()

select(flights, time_hour, air_time, everything())



# 3.1 Practice: select() -------------------------------------------------

# 1) Move to the front those columns of flights that contain delay-related 
# information! Then place those columns whose names contain "time"! 
# Remove airline, flight, tail number, and origin/destination columns!
# Try solving this in as many ways as possible! 


# 2) Select year, month, day from the flights table
# Rename them in the same step: year → ev, month → honap, day → nap!


# 3) Rename dep_time to indulas in one command while keeping all columns 
# in the original order!


# 4) Select the 2nd, 5th, and 11th columns of flights!
# Use select but NOT variable names!


# 5) Does this code give a surprising result? 
# What is the default behavior of helper functions regarding case sensitivity?
# How can it be changed? 

select(flights, contains("TIME"))

# 6) What is any_of() good for? Why is this vector useful with it? 

vars <- c("year", "month", "day", "dep_delay", "arr_delay", "evszam")


#### 4. Creating new variables: mutate() --------------------------------------

# Select a few columns to make console output clearer

flights_sml <- 
  select(
    flights, 
    year:day, 
    ends_with("delay"), 
    distance, 
    air_time
  )


# Creating new variables

mutate(
  flights_sml,
  gain = arr_delay - dep_delay,    # how much delay the plane gained en route
  speed = distance / air_time * 60 # average speed (miles per hour)
)


# Within one mutate you can refer to variables created earlier in the same mutate!

mutate(
  flights_sml,
  gain = arr_delay - dep_delay, # how much delay was accumulated en route
  hours = air_time / 60,        # how many hours the plane was in the air
  gain_per_hour = gain / hours  # hourly average delay increase
)


# transmute: return only the newly created variables

transmute(
  flights,
  gain = arr_delay - dep_delay,
  hours = air_time / 60,
  gain_per_hour = gain / hours
)


# Any vectorised function can be used inside mutate()
# (input is a vector, output is a vector of the same length)
# More: https://r4ds.had.co.nz/transform.html#add-new-variables-with-mutate 5.5.1

# Some useful examples

# A) arithmetic operators: + - * / ^ 
# - vectorised with recycling:
# if one parameter is shorter, it is automatically extended
# this is helpful for dividing by a constant, e.g. minutes / 60 
# or computing deviation from mean: y - mean(y)

# B) modular arithmetic

# integer division 

6 %/% 4

# modulo (remainder) 

6 %% 4

# C) logarithms log() log2() log10() 

# D) lead/lag

(x <- 1:10)
lag(x)
lead(x)

# Difference from previous element

x - lag(x)

# Does it differ from previous?

x != lag(x)

# E) cumulative and rolling aggregates (sum, product, min, max, mean)
# Cumulative sum and mean for example: 
x

cumsum(x)

cummean(x)

# Rolling aggregates in the RccpRoll package

# F) logical tests

# G) ranking, e.g.:

y <- c(1, 2, 2, NA, 3, 4)

min_rank(y)

min_rank(desc(y))

# 4.1 Practice: mutate() -------------------------------------------------


# 1) Recompute departure and arrival delays!
# Before that, think about whether the stored departure and arrival 
# times are in the correct format. Convert them if needed before computing!


# 2) Why do we get the following result?

1:3 + 1:10



#### 5. Summaries: summarise() ----------------------------

# summarise() takes a data table as input and returns a single row!

summarise(
  flights, 
  delay = mean(dep_delay, na.rm = TRUE)
)

# It is most useful with group_by()

by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

# What did group_by() do?

class(flights)
class(by_day)


## 5.1 Combining operations with the pipe (%>%) -------------------

# How is the average delay by destination related to the distance?
# Consider only destinations with data for more than 20 flights!
# Do not include Honolulu (HNL)!

by_dest <- group_by(flights, dest)

delay <- 
  summarise(
    by_dest,
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  )

delay <- filter(delay, count > 20, dest != "HNL")

ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

# This took 4 steps: grouping, summarising, filtering, plotting.
# Intermediate data tables are unnecessary, and naming things is tedious.
# It would be nice to skip them.

# That’s what the pipe %>% is for (CTRL + SHIFT + M in RStudio on Windows)

flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist  = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL") %>% 
  ggplot(mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)


# What does %>% do?
# x %>% f(y) = f(x, y)
# We can read it as “and then”: 
# group, AND THEN summarise, AND THEN filter, AND THEN plot

# Filtering missing data

# Why do we need na.rm = TRUE above?

flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

# Aggregation functions also return NA 
# when they encounter missing data

# In flights, missing delays refer to cancelled flights
# One approach is to drop these rows:

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month) %>% 
  summarise(mean = mean(dep_delay))

# In aggregation, it is important to know how many observations the summary is based on
# Useful: n() or count non-missing values with sum(!is.na(x))

# Let's examine average departure delay by airplane tail number!

delays <- 
  not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)

# There are planes with ~5 hours average departure delay!

# Always check sample size in aggregations:
# How many observations were used?

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

# Typical pattern: as sample size increases, summary statistics vary less
# Always record sample size: n() or sum(!is.na())

# Filter out averages based on few observations, then plot

delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

# Aggregation and logical indexing together:

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0]) # average positive delay
  )


## 5.2 Useful functions for descriptive statistics -----------------

# Central tendency: mean, median

# Variation

?sd
?IQR

not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))

# Range

?min
quantile(1:6, probs = 0.33)
?max

# Find first and last departure times for each day!

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first = min(dep_time),
    last = max(dep_time)
  )

# Position: first(), nth(x, 2), last()

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first_dep = first(dep_time), 
    last_dep = last(dep_time)
  )

# This is extended by filtering by rank
# Here each observation remains a separate row

not_cancelled %>% 
  group_by(year, month, day) %>% 
  # Rank departure times within each day
  mutate(r = min_rank(dep_time)) %>% 
  # Keep rows with smallest and largest rank each day
  filter(r %in% range(r)) %>% 
  select(year:day, dep_time, r)

# Counts

?n # number of cases
?n_distinct # number of unique cases


# Which destination is served by the most airlines?

not_cancelled %>% 
  group_by(dest) %>% 
  summarise(carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers))

# Quick counts – how many flights flew to each destination?

not_cancelled %>% 
  count(dest)

# Weighted counts – how many miles were flown to each destination in total?

not_cancelled %>% 
  count(dest, wt = distance)

# Number and proportion of cases meeting a condition, e.g.:  
# How many flights departed before 5:00 each day?

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(n_early = sum(dep_time < 500))

# What happened? 
# When giving logical values to numeric functions, 
# TRUE = 1 and FALSE = 0

# What percentage of flights each month departed after 20:00?




# Grouping by multiple variables

daily <- group_by(flights, year, month, day)

# Multiple summarise steps gradually collapse the data table

(per_day   <- summarise(daily, flights = n())) # now grouped only by year and month

(per_month <- summarise(per_day, flights = sum(flights))) # now grouped only by year

(per_year  <- summarise(per_month, flights = sum(flights))) 


# Removing grouping

daily %>% 
  ungroup() %>%             # grouping removed
  summarise(flights = n())  # total number of flights


# 5.3 Practice: summarise() ----------------------------------------------


# 1) Reproduce the following results WITHOUT using count()!

not_cancelled %>% 
  count(dest)


not_cancelled %>%
  count(tailnum, wt = distance)


# 2) Why is identifying cancelled flights using (is.na(dep_delay) | is.na(arr_delay)) 
# not optimal? 


# 3) Look at the number of cancelled flights by day of month.
# Do you see any patterns? 
# Is cancellation rate related to average delay?



# 4) Which airline (carrier) delays the most? 
# Can we separate the effect of bad airports vs. bad airlines?
# Why / why not?
# (Hint: flights %>% group_by(carrier, dest) %>% summarise(n()))



# 6. Advanced dplyr ------------------------------------------------------------


# 6.1 Transforming multiple columns concisely ----

# http://dplyr.tidyverse.org/reference/summarise_all.html 


# 1) On all columns:

iris %>% 
  group_by(Species) %>% 
  summarise_all(median)

# Multiple summaries at once:

# a) list of functions

iris %>% 
  group_by(Species) %>% 
  summarise_all(list("Med" = median, "M" = mean))

# b) names of functions given as character vector

iris %>% 
  group_by(Species) %>% 
  summarise_all(c("median", "mean"))


# 2) Conditional:

# Compute mean for all numeric (double) columns

flights %>% 
  summarise_if(is.double, mean, na.rm = TRUE)

# Convert character columns to factors

flights %>% 
  mutate_if(is.character, as.factor)

# 3) Based on column names:

# a) using vars() (select helpers work!)

flights %>%
  summarise_at(vars(dep_time:arr_time), max, na.rm = T)

flights %>% 
  summarise_at(vars(ends_with("delay")), mean, na.rm = TRUE)

# b) specifying a character vector

flights %>% 
  summarise_at(c("arr_delay", "dep_delay"), mean, na.rm = TRUE)


# 6.2 Operations and filters with grouping ----

# Find the 3 most delayed flights each day:

flights_sml %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 4)


# Identify groups exceeding a threshold
# e.g., only popular destinations:

popular_dests <- 
  flights %>% 
  group_by(dest) %>% 
  filter(n() > 3000)

popular_dests

# Standardization and within-group measures

popular_dests %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay)