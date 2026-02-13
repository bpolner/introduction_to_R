###### Let's explore data visually with ggplot2! (continued)

require(tidyverse)



#### 6. Statistical transformations --------------------------------

# ggplot2 contains a built‑in dataset about diamonds
?diamonds

# Bar chart
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))

# What is on the x‑axis? And what is on the y‑axis?

# The y‑axis shows the counts – this is not even in the data table!
# Some geoms compute new values for plotting using an algorithm; 
# this is called the stat of the given geom.

# What values does geom_bar() calculate?


# geom and stat functions are interchangeable,
# because every geom has a default stat, and vice versa
ggplot(data = diamonds) + 
  stat_count(mapping = aes(x = cut))

## 6.1 Explicitly specifying statistical transformations ----------------

# Overriding the stat argument of geom_bar(): 


# a, show the raw values of a variable 

# We define a data table that already contains the counts of the cut types
# (we will look at this syntax in detail later!)
demo <- tribble(
  ~cut,         ~freq,
  "Fair",       1610,
  "Good",       4906,
  "Very Good",  12082,
  "Premium",    13791,
  "Ideal",      21551
)

ggplot(data = demo) +
  geom_bar(mapping = aes(x = cut, y = freq), stat = "identity")

# b, show another computed value 

# Let’s look at proportions instead of counts
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = stat(prop), group = 1))


# c, If we want to elaborate the statistical calculations more

# stat_summary(): statistical summary of y for each unique x value

ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )

# Overview on the ggplot2 cheatsheet:
# https://github.com/rstudio/cheatsheets/raw/master/data-visualization-2.1.pdf 

## 6.2 Practice - statistical transformations ----------------

# 1) What is the default geom of stat_summary()? 
# Reproduce the previous plot using a geom function!

# 2) What does geom_col() do? How does it differ from geom_bar()?

# 3) What values does stat_smooth() calculate? Which parameters control it?

# 4) Why is group=1 needed in the bar chart showing proportions?
# What is the problem with the two plots defined below?
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = stat(prop), group = 1))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = after_stat(prop)))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color, y = after_stat(prop)))

#### 7. Fine-tuning position --------------------------------

# What is the difference between the fill and colour arguments 
# for bar charts?
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, colour = cut))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))

# If we assign another variable to the fill argument
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))

# The bars have been automatically stacked
# Each rectangle shows a combination of cut and clarity

## 7.1 The position argument ----------------

# What other bar chart types can be created?

# a, "identity" places every object exactly where it falls 
# in the coordinate system
# because of overlap, this is not ideal for bar charts

# This is visible if we make the bars transparent
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
  geom_bar(alpha = 1/5, position = "identity")


# Or leave them unfilled
ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) + 
  geom_bar(fill = NA, position = "identity")

# b, position="fill" is good when comparing proportions
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

# Compare the plot with the frequency table!
table(diamonds$cut, diamonds$clarity)

# c, position = "dodge" places bars next to each other
# Very good for directly comparing values

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

# d, there is one more option that is great for scatterplots

# What could be the problem with a scatterplot like this?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))


# Add a little "noise" to the data so points don’t sit on top of each other
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")

# Same, shorter
ggplot(data = mpg) +
  geom_jitter(mapping = aes(x = displ, y = hwy), width = 0.1)

# Let's check which displ + hwy combinations have more overlapping points
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), alpha = 0.5)



## 7.2 Practice - position ----------------

# 1. What is the problem with this plot? How could we make it more meaningful?
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point()

# 2. How can you control the amount of jitter in geom_jitter()?

# 3. What is the difference between geom_jitter() and geom_count()?

#### 8. Coordinate systems  --------------------------------

# The default is the Cartesian coordinate system
# x and y values determine point locations
# but there are a few more options


# a, swapping the x and y axes with coord_flip()

# if x‑axis labels overlap or become unreadable

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()


ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() +
  coord_flip()


# b, "Polar" coordinate system via coord_polar()

bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()

## 8.1 Practice - coordinate systems ----------------

# 1) Turn a stacked bar chart into a pie chart using coord_polar()!




# 2) What does this plot reveal about the relationship 
# between city and highway mileage?
# Why is coord_fixed() important?
# What does geom_abline() do?

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed(xlim = c(5, 45), ylim = c(5, 45))

#### 9. Summary: the grammar of graphics in ggplot2  -------------------------------- 

# ggplot(data = <DATA>) + 
#     <GEOM_FUNCTION>(
#         mapping = aes(<MAPPINGS>),
#         stat = <STAT>, 
#         position = <POSITION>
#     ) +
#     <COORDINATE_FUNCTION> +
#     <FACET_FUNCTION>

# You must specify: data <DATA>, mappings <MAPPINGS>, and <GEOM>!
# Everything else has working defaults that can be overridden.


# 10. A bit of ggplot2 with another dataset -----------------------------------

# Now let’s look at the built-in swiss dataset!
# Loading it:
data(swiss)

# 1) How many rows and columns does the dataset have? 

# 2) What do the rows of the table represent?


# 3) Create a scatterplot showing the relationship 
# between the proportion of men working in agriculture 
# and the education indicator!


# 4) In another scatterplot, visualize the relationship between 
# the proportion of Catholics and the proportion achieving 
# the best score on the military examination (Examination)!


# 5) Plot a scatterplot of the proportion of agricultural workers 
# and the proportion achieving the best military examination score (Examination)!
# Use solid squares for the points, set their size to 5!
# Set the outline color and transparency of the squares as you like!
# Visualize the relationship in two separate facets for 
# predominantly Catholic and predominantly Protestant "provinces"!
# Let the fill color of the squares reflect the proportion of Catholics!
# Make the outlines thicker 
# (the geom_point documentation will tell you how)!


# 6) Plot the relationship between two arbitrary variables 
# not used in previous tasks, with grouping based on a third variable! 


# Additional suggested practice: running data() lists all built‑in datasets. 
# Running ?<DATASET NAME> shows the documentation.
# Running data(<DATASET NAME>) loads the dataset into the workspace.
# Using what you’ve learned so far, create plots from a dataset of your choice!
