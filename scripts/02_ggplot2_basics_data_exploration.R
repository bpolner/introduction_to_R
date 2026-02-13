###### Let's explore data visually with ggplot2!


#### 0. Preparations ----------------  

# Load the tidyverse package 
# This includes ggplot2 and a bunch of other useful stuff

library(tidyverse)

#### 1. First look at the data ---------------- 

# Today we will play with the mpg dataframe.

# What does it look like?
mpg

# What does it contain? You can find a description in the help.
?mpg

# How many rows (~observations)? How many columns (~variables)? 
nrow(mpg)
ncol(mpg)
dim(mpg)

# What is its structure? str() is a very useful function.
str(mpg)

# What does the beginning and the end look like? Worth checking after loading.
head(mpg)
tail(mpg)

#### 2. Let's plot!  --------------------------------

# What relationship might exist between car fuel consumption and engine displacement?

# The first line creates a coordinate system to which we can add layers
ggplot(data = mpg) +
  # We add a layer where we assign variables to the x and y coordinates of points
  geom_point(mapping = aes(x = displ, y = hwy))

# Every geom function has a mapping argument.
# The mapping is always given using the aes() function.
# ggplot2 looks for variables specified in the mapping 
# within the data provided in the data argument. 

# General form:
# ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

## 2.1 Practice - basics of plotting ----------------

# 1) What does the drv variable show? 

# 2) Create a scatterplot of the hwy and cty variables!



#### 3. Setting aesthetic parameters --------------------------------

# Some cars seem to “stand out” from the typical trend of the sample. 
# In what sense might those cars be special?
# Display the different car classes with different colors!

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, colour = class))

# Every unique level of the variable assigned to colour gets its own color on the plot
# A legend is automatically created as well

# We can assign a variable to other aesthetic parameters as well

# For transparency (although here it doesn't make much sense)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

# How would you assign class to point size?


# And to point shape?


# We can also set aesthetic parameters manually.
# In that case, outside aes(), by assigning a value to an argument 
# of the geom function, we control appearance. 

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "darkblue")

# Colors: string
# Size: number (mm)
# Shape: integer

# What shapes can we choose from?

toy_data <- data.frame(x = 0:25, 
                       y = 0:25, 
                       z = factor(0:25)
)

ggplot(data = toy_data) +
  geom_point(aes(x = x, y = y, shape = z), colour = "black", fill = "red", size = 8) + 
  scale_shape_manual(values = 0:25)


## 3.1 Practice - aesthetic parameters ----------------

# 1) Why aren’t the points blue?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))

# 2) Which variables in mpg are continuous and which are categorical? 


# 3) How do color, shape, and size behave when mapped to a continuous variable?


# 4) What happens if a variable is mapped to multiple aesthetic parameters?


# 5) What happens if we don't simply use a variable for an aesthetic?
# e.g. aes(color = displ < 5) ?


# 6) Why do these codes not work?

ggplot(data = mpg) 
+ geom_point(mapping = aes(x = displ, y = hwy))


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue")

# 7) Create a scatterplot where displ is on the x-axis and hwy on the y-axis.
# Use points of size 10! What might be the problem with this plot?
# How could you improve it without changing the point size?



#### 4. Facets --------------------------------

# We can display additional variables not only with aesthetics.
# We can create the same plot for subsets of the data.

# If we want subsets along a single categorical variable,
# use facet_wrap!

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  # Its first argument is a formula (a data structure in R):
  # format: ~ <variable name>
  facet_wrap( ~ class, nrow = 2)

# If we want to combine two variables to create subsets,
# use facet_grid!

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  # formula format for facet_grid:
  # <variable for y-axis> ~ <variable for x-axis>
  facet_grid(drv ~ class)

# facet_grid can be used with only one variable as well:

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(. ~ cyl)

## 4.1 Practice - facets ----------------

# 1) What happens if we assign a continuous variable to facet?


# 2) What do the empty cells in the facet_grid(drv ~ class) plot represent?
