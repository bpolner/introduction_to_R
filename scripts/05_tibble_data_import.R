# The tibble. Reading and writing files.

library(tidyverse)



# 1. The tibble ----------------------------------------------------------------


# You can work with them using the tibble package – which is also included in the tidyverse meta‑package 

# From data.frame to tibble:

iris
class(iris)

as_tibble(iris)

# From vectors to tibble

tibble(
  x = 1:5, 
  y = 1, 
  z = x ^ 2 + y
)

# Single-length inputs are automatically recycled / y in the example
# You can reference variables created earlier in the same call / z in the example

# In a tibble, variable names can be invalid R variable names
# You can reference them using backticks ` ` (Hungarian keyboard: Alt Gr + 7)

tb <- tibble(
  `:)` = "smile", 
  ` ` = "space",
  `2000` = "number"
)

tb

# Transposed data entry with the tribble() function:
# this is very convenient when you want to define a small data table in code.
# Column names are provided with formulas ( ~ <name> ), 
# and values are listed comma‑separated

tribble(
  ~x, ~y, ~z,
  #--/--/---- more readable if we put a comment line under the header
  "a", 2, 3.6,
  "b", 1, 8.5
)

# Printing a tibble to the console: by default 10 rows, 
# and as many columns as fit the console width
# the type of each column is shown under its name

mpg

# Controlling the number of displayed rows and the printed width:

print(mpg, n = 20, width = 100)

# We can modify the defaults as well

# If there are more than m rows, print n rows

# options(tibble.print_max = n, tibble.print_min = m)

# Always print all rows:

options(dplyr.print_min = Inf)

# Always print all columns, regardless of console width: 

options(tibble.width = Inf)

# More options:

package?tibble
?print.tbl

# View in RStudio:
View(mpg)

# How can we extract a single variable?

df <- tibble(
  x = runif(5),
  y = rnorm(5)
)

# $ – by name only

df$x

# [[]] – by name (string!) or by position

df[["x"]]

df[[1]]

# If we want to use it inside a pipe, use the . placeholder!

df %>% .$x

df %>% .[[1]]

# If we try to access a non‑existent column, 
# we get a warning and the result is NULL

df$z

# Some older packages are not compatible with tibble. 
# In that case convert your data to a data.frame:

as.data.frame(df)


# 1.1 tibble - practice ----------------

# 1) Extract the color variable from the diamonds table
# a) by name!

# b) by position!


# 2) If a variable’s name is stored in another variable, how do you extract the 
# variable from a tibble? The mpg data contains the cty variable

var <- "cty"


# 3) Compare the following operations on a data.frame and on
# an equivalent tibble! What’s the difference? 
# What might be problematic about data.frame behavior?

df <- data.frame(abc = 1, xyz = "a")
df$x
df[, "xyz"]
df[, c("abc", "xyz")]

df_t <-  tibble(abc = 1, xyz = "a")
df_t$x
df_t[, "xyz"]
df_t[, c("abc", "xyz")]


# 2. Importing data  ------------------------------------


# 2.1 utils ----

# Note: Skip this in class, provided only for reference 
# read.csv(), read.delim(), read.table()

# The first argument of read functions is the file path:
# we must tell the function where the file to be loaded 
# into R is located.

heights <- read.csv("C://Users/BP/teaching/introduction_to_R/data/magassagok_1.txt")

# However, this can be inconvenient if we want the code
# to work on multiple machines.
# For example, on your machine it’s very likely this won’t work.
# The solution is to use an RStudio Project.

# In that case, the project folder containing the .RProj file will be the “starting point”. 
# This path will work on other machines too if the introduction_to_R.RProj project is open.

magas <- read.csv("data/magassagok_1.txt")

# File paths differ by operating system.
# file.path returns a path formatted for the given OS:

path <- file.path("data", "magassagok_1.txt")

magas <- read.csv(path)

# How does file.path know the correct format?
# Let’s look at the source!

file.path

# It checks the .Platform list

.Platform

# read.csv works well if decimals use a dot 
# and columns are separated by commas (English/US style)
# BUT: some locales use a comma as decimal mark (e.g., Hungarian)
# and separate columns with semicolons ;
# read.csv does not “understand” these:

path <- file.path("data", "magassagok_2.txt")

(magas_2 <- read.csv(path))

str(magas_2)

# That’s what read.csv2 is for:

(magas_2 <- read.csv2(path))

str(magas_2)

# What do read.csv and read.csv2 do?

read.csv

read.csv2

# They call read.table, 
# setting sep and dec to appropriate values

# 2.2 readr ----


# Most readr functions read text files:

# read_csv (comma‑separated) 
# read_tsv (tab‑separated) 
# read_csv2 (semicolon‑separated)
# read_delim (any delimiter)
# read_fwf (fixed‑width files)

# the first argument of read functions is the path to the file to read

read_csv("data/heights_1.txt")

data_path <- "data"

path <- file.path(data_path, "data/heights_1.txt")

read_csv(path)

# You can also provide a CSV as a literal string in the function call
# This helps to experiment with readr
# And to give reproducible examples to others (e.g., on Stack Overflow)

read_csv(
  "a,b,c
   1,2,3
   4,5,6"
)

# By default, readr interprets the first row as column names
# This can be overridden! When might this be needed?


# 1) metadata at the top of the file

read_csv(
  "The first line of metadata
   The second line of metadata
   x,y,z
   1,2,3", 
  skip = 2
)



read_csv(
  "# A comment I want to skip
   x,y,z
   1,2,3",
  comment = "#"
)

# 2) there is no header in the data

# a, tell it there is no header (\n denotes a line break)

read_csv("1,2,3\n4,5,6", col_names = FALSE)

# b, provide a header

read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z"))

# specifying missing value markers: na argument

read_csv("a,b,c\n1,2,.", na = ".")

# In 75% of cases the above is enough 
# to read CSV files!

# Compared to base R readers, readr:
# - is faster
# - reads into a tibble
# - does not automatically convert character columns to factors
# - does not use row names
# - is more reproducible (base R depends on OS and R options)




# 2.2.1 readr - practice -------------------------------------------------

# 1) In the data directory, digitspan_data.txt contains four people’s ages and digit spans. 
# The first two lines contain the time of data collection and the course name. We do not want to read these.
# We do want the first column to be named "age" and the second "digitspan". 
# Read digitspan_data.txt into a tibble accordingly!



# 2) What’s wrong with these CSVs given directly in code?

read_csv("a,b\n1,2,3\n4,5,6")
read_csv("a,b,c\n1,2\n1,2,3,4")
read_csv("a,b\n\"1")
read_csv("a,b\n1,2\na,b")
read_csv("a;b\n1;3")


# 2.3 Parsing vectors ---------------------------------------------------

# How does readr read files from disk?

# First let’s see how the parse_* functions work!
# We give them a character vector and they return a typed vector.

str(parse_logical(c("TRUE", "FALSE", "NA")))

str(parse_integer(c("1", "2", "3")))

str(parse_date(c("2010-01-01", "1979-10-14")))

# 1st arg: character vector to parse, 2nd arg: define how NA is marked

parse_integer(c("1", "231", ".", "456"), na = ".")

# What happens if parsing fails?

x <- parse_integer(c("123", "345", "abc", "123.45"))

# Where parsing failed, we get NA

x

# Review parsing failures:

problems(x)


# 2.3.1 Numbers ------------------------------------------------------------

# Why is this not so simple?


# a, the decimal mark can be . or , 

parse_double("1.23")

# Set locale‑specific options: locale

parse_double("1,23", locale = locale(decimal_mark = ","))

# b, sometimes there are special characters around numbers like $ %

# parse_number is very useful: it drops all non‑numeric characters

parse_number("$100")

parse_number("20%")

parse_number("It cost $123.45")


# c, different grouping marks 1'000 1,000 1 000

# parse_number with locale specifying the grouping mark:

# USA

parse_number("$123,456,789")

# Common in Europe:

parse_number("123.456.789", locale = locale(grouping_mark = "."))

# Switzerland:

parse_number("123'456'789", locale = locale(grouping_mark = "'"))



# 2.3.2 Character strings (strings) ------------------------------------------

# The same string can be represented in multiple ways

# How does R represent a string?

charToRaw("Hadley")

# Each hexadecimal number represents one byte of information.
# Character encoding maps hexadecimal numbers to characters.

# ASCII encoding is fine for English
# Other languages: 
#   Latin1 / ISO-8859-1 Western European languages 
#   Latin2 / ISO-8859-2 Central/Eastern European languages
# 
# Very widespread and covers almost everything: UTF-8
# readr uses UTF‑8 by default for reading and writing
# Problems arise if the data are not encoded in UTF‑8,
# then we will see strange strings:

x1 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"

x1

parse_character(x1, locale = locale(encoding = "Shift-JIS"))


# How do we figure out the encoding?
# Ideally from the documentation. 
# If not, guess_encoding can help (works better with more text)

text <- "Ez egy magyar nyelvű szöveg."

guess_encoding(charToRaw(text))



# 2.3.3 Factors (categorical variables) -----------------------------------

# The set of possible values is known

fruit <- c("apple", "banana")

parse_factor(c("apple", "banana", "bananana"), levels = fruit)

# If there are many problematic cases, it may be better to read as strings
# and clean them later instead of using factors


# 2.3.4 Date and time ------------------------------------------------------

# By default:

# a, parse_datetime expects ISO8601 format year, month, day, hour, minute, second

parse_datetime("2010-10-20 141345")

# If the time is missing, it assumes midnight

parse_datetime("20101010")

# b, parse_date expects year (4 digits) then - or /, then month, then - or /, then day:

parse_date("2010-10-01")

# c, parse_time expects hour:minute (optional :second and am/pm)

parse_time("01:10 am")

parse_time("20:10:01")

# If defaults don’t work, we can provide a custom format

# see details at https://r4ds.had.co.nz/data-import.html#readr-datetimes 


parse_date("01/02/15", "%d/%m/%y") # day/month/year, i.e., 1 February

parse_date("01/02/15", "%m/%d/%y") # month/day/year, i.e., 2 January

parse_date("Jan 23 2015", "%b %d %Y") # <month short name> <day> <year>



# 2.4 Parsing files -----------------------------------------------------

# How does readr guess variable types?
# It looks at the first 1000 rows and uses heuristics

# UPDATE: newer readr versions inspect all rows by default

guess_parser("2010-10-01")
guess_parser("15:01")
guess_parser(c("TRUE", "FALSE"))
guess_parser(c("1", "5", "9"))
guess_parser(c("12,352,561"))

# But the first 1000 rows can be special, e.g.
# - first 1000 rows are integers, but later there are decimals
# - first 1000 rows are NA, values appear later 

# Let’s see an example!

challenge <- read_csv(readr_example("challenge.csv"))

problems(challenge)

# What were the column types in the previous read?

# Let’s modify the column types!

challenge <- read_csv(
  readr_example("challenge.csv"), 
  col_types = cols(
    x = col_double(),
    y = col_character()
  )
)

# What about y?

challenge
tail(challenge)

# Let’s specify the correct type for this column too!

challenge <- read_csv(
  readr_example("challenge.csv"), 
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)

challenge
tail(challenge)

# If the data are already in R as a character vector: parse_xyz
# If we want to control readr’s reading:     col_xyz

# It’s a good idea to explicitly specify column types 
# to make data import more consistent and reproducible. 

# Another solution is to guess types based on more rows.

challenge_2 <- read_csv(
  readr_example("challenge.csv"), 
  guess_max = 3000
  
)

# Or read all columns as character, 

challenge_2 <- read_csv(
  readr_example("challenge.csv"), 
  col_types = cols(.default = col_character())
)

# And then let type_convert detect column types

type_convert(challenge_2)

# How does type_convert infer types? 
# http://r4ds.had.co.nz/data-import.html#parsing-a-file

# 2.4 parsing files - practice

# 1) In the data directory, recog_data.csv contains the results of a recognition test in a special format.
# The first column is the participant ID, the second is recognition accuracy in %, 
# and the third is the participant’s age. 
# Where age is missing, the table says "nem ismert" (“unknown”).
# The top row contains the experiment name.
# Read and process the data ensuring that
# - the experiment name is not part of the read tibble 
# - give meaningful column names already at read time 
# - missing data are read as NA
# - after reading, convert percentage accuracy to a decimal between 0 and 1 (mutate)





# 3. Writing to files ----------------------------------------------------------

# readr: write_tsv and write_csv

# They write easily readable files:
# - character strings encoded in UTF‑8
# - date and datetime in ISO8601 format

# Two args must always be given: which data and where to write

write_csv(challenge, "challenge_out.csv")

ch_again <- read_csv("challenge_out.csv")

# Column types have been lost in the process!
# When can this be annoying?

# Alternatives: write complete objects to file

# a, RDS (R’s own binary file format)

write_rds(challenge, "challenge_out.RDS")

(ch_rds <- read_rds("challenge_out.RDS"))

# b, feather (fast binary format understood by other languages) (requires feather package!)
# install.packages("feather)
# library(feather)

write_feather(challenge, "challenge.feather")

read_feather("challenge.feather")

# More data types (xls, xlsx, SPSS, SAS, Stata, ...) 
# http://r4ds.had.co.nz/data-import.html#other-types-of-data 
# https://cran.r-project.org/web/packages/XLConnect/vignettes/XLConnect.pdf