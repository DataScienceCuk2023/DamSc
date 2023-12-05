# -*- coding: utf-8 -*-

# -- Data Transformation With dplyr --

install.packages("tidyverse")

library(tidyverse)
#Once tidyverse is installed it comes with pre loaded dataset that we will be using for the session
#https://learnr.numbat.space/chapter5/ website to learn more on tidyverse.

# To  load "dplyr" package, making its functions and features available for use in the current R session
library(dplyr)
mtcars #this is one of the preloaded datasets

#example to show difference in |> and %>%
1:10 |> mean()#requires a function call and easy to read

1:10 %>% mean #popular pipe

# To compute the tables of summaries
mtcars %>% summarize(avg = mean(mpg))

# To count the no. of  each group in the 'cyl' column
mtcars |> count(cyl)

#   Grouped Cases
#  To group the dataset by the "cyl" variable, creating groups of data based on the number of cylinders and summsrizing the grouped data
mtcars |>group_by(cyl) |>
summarize(avg = mean(mpg))

# To  group data into individual rows
starwars |>
rowwise() |>
mutate(film_count = length(films))

mtcars %>% filter(mpg>20)

# Manipulate Cases Extract Cases
# To   filter the "mtcars" datasetto retain only the rows where the "mpg" > 20.
mtcars |> filter(mpg > 20)

# To extract distinct values from the "gear" column and provide a summary of the unique values for the no. of gears in the cars
mtcars |> distinct(gear)

#  To to select specific rows from the "mtcars" dataset. In this case, it's selecting rows 10 to 15.
mtcars |> slice(10:15)

# To  randomly select 5 rows from the "mtcars" dataset, with replacement
mtcars |> slice_sample(n = 5, replace = TRUE)

# To add a new row to the "cars" dataset with a speed of 1 and a distance of 1
cars |> add_row(speed = 1, dist = 1)

# -- importing data --

library(readr)


 
df= read_csv("real_estate_price_size_year.csv")
df

df |> summarize(avg = mean(price))

mx= read_csv("studentskcsedata.csv")
mx

library(readxl)
read_excel("regressiondata.xlsx")



library(googlesheets4)
# 
sheet_url <- "https://docs.google.com/spreadsheets/d/16-5gTlVspV8AkM7zfhop71mZIva2mQAOXQuG0LZlYI4/edit?usp=sharing"
gs4_deauth() #supports to ensure the google sheet does not seek an interation using passwords
read_sheet(sheet_url)


# -- Data tidying --

#Tibbles are a table format provided by the tibble package. They inherit the data frame class, but have improved behavior

library(tidyr)
library(tibble)

#Construct a Tibble by columns
tibble(
x = 1:3,
y = c("a", "b", "c")
)

#Construct a Tibble by rows this is a transposed tibble
tribble(
~x, ~y,
1, "a",
2, "b",
3, "c"
)

#Reshape Data
table4a
#this dataset is already preloaded in the tidyverse environment

#Column names move to a new names_to column and values to a new values_to column. The output of pivot_longer() will look like the following:
pivot_longer(table4a, cols = 2:3, names_to = "year", values_to = "cases")

#“Wexpaiden” data by nding two columns into several. 
#this dataset is already preloaded in the tidyverse environment
table2

pivot_wider(table2, names_from = type, values_from = count)

#Split Cells

table5
#this dataset is already preloaded in the tidyverse environment

unite(table5, century, year, col = "yr", sep = "")

table3

separate_wider_delim(table3, rate, delim = "/", names = c("cases", "pop"))

table3
#this dataset is already preloaded in the tidyverse environment

separate_longer_delim(table3, rate, delim = "/")

#Expand Tables
#this dataset is already preloaded in the tidyverse environment
mtcars

expand(mtcars, cyl, gear, carb)#Drop other variables.

 # Add missing possible combinations of values of variables listed
#in … Fill remaining variables with NA.
data=complete(mtcars, cyl, gear, carb)
data

#Handle Missing Values
x <- tribble(
~x1, ~x2,
"A", 1,
"B", NA,
"C", NA,
"D", 3,
"E", NA
)


drop_na(x, x2)

# fill(data,direction=down) 
fill(x, x2)


replace_na(x, list(x2 = 2))



# -- forcats --

#R represents categorical data with factors. A factor is an integer vector with a levels attribute that stores a
#set of mappings between integers and categorical values. When you view a factor, R displays not the
#integers but the levels associated with them
library(forcats)

f <- factor(c("a", "c", "b", "a"), levels = c("a", "b", "c"))# Convert a vector to a factor

levels(f)#Return its levels
levels(f) <- c("x", "y", "z")#Re assigns levels

#Inspect Factors

fct_count(f)#Count the number of values with each level.

fct_match(f, "x")# Check for levels in f

fct_unique(f)#Return the unique values, removing duplicates.

#Combine Factors

f1 <- factor(c("a", "c"))
f2 <- factor(c("b", "a"))
fct_c(f1, f2)#fct_c(...) : Combine factors with different levels

fct_unify(list(f2, f1))#Standardize levels across a list of factors.

#Change the order of levels

fct_relevel(f, c("b", "c", "a"))#Manually reorder factor levels

f3 <- factor(c("c", "c", "a"))
fct_infreq(f3)#Reorder levels by the frequency in which they appear in the data(highest frequency first)

fct_inorder(f2)#Reorder levels by order in which they appear in the data.

f4 <- factor(c("a","b","c"))
fct_rev(f4)#Reverse level order

fct_shift(f4)#Shift levels to left or right, wrapping around end

fct_shuffle(f4)#Randomly permute order of factor levels.

PlantGrowth
boxplot(PlantGrowth, weight ~ fct_reorder(group, weight))#Reorder levels by their relationship with another variable.

#Reorder levels by their final values when plotted with two other variables.
ggplot(
diamonds,
aes(carat, price, color = fct_reorder2(color, carat, price))
) +
geom_smooth()

#Change the value of levels

#Manually change levels.
fct_recode(f, v = "a", x = "b", z = "c")
fct_relabel(f, ~ paste0("x", .x))

fct_anon(f)#Anonymize levels with random integers.

fct_collapse(f, x = c("x", "y"))#Collapse levels into manually defined groups.

fct_lump_min(f, min = 2)# Lumps together factors that appear fewer than min times

fct_other(f, keep = c("z", "y"))#Replace levels with “other.”

#Add or drop levels

f5 <- factor(c("a","b"),c("a","b","x"))
f6 <- fct_drop(f5) #Drop unused levels.
f6

fct_expand(f6, "k")# Add levels to a factor.

f <- factor(c("a", "b", NA))
fct_na_value_to_level(f, level = "(blank)")#Assigns a level to NAs to ensure they appear in plots

# -- Strringr --

library(stringr)

# Detect Matches

fruit <- c("apple", "berries", "avocado", "mangoes", "lemons", "passons", "cherries", "oranges")

#  : Detect the presence of a pattern match in a string.
str(fruit,"a")

# Find the indeces of strings that contain a pattern match.
str_starts(fruit, "a")

#: Locate the positions of pattern matches in a string
str_locate(fruit, "a")

# Mutate Strings


str_to_lower(sentences)

str_to_upper(sentences)

str_to_title(sentences)

# Join and Split

str_c(letters, LETTERS)

# END

# -- purr --

library(purrr)

#purrr enhances R’s functional programming (FP) toolkit by providing a complete and consistent set of tools
#for working with functions and vectors. If you’ve never heard of FP before, the best place to start is the
#family of map() functions which allow you to replace many for loops with code that is both more succinct
#and easier to read. The best place to learn about the map() functions is the iterationchapter in R for Data
#Science.

# Map Functions

x <- list(a = 1:10, b = 11:20, c = 21:30)
y <- list(1, 2, 3)
z <- list(4, 5, 6)

l1 <- list(x = c("a", "b"), y = c("c", "d"))
l2 <- list(x = "a", y = "z")

# Apply a function to each element of a list of vector, and return a list.
map(l1, sort, decreasing = TRUE)

# Apply a function to groups of elements from a list of lists or vectors, return a list.
pmap(list(x, y, z), function(first, second, third) first * (second + third))

# Reduce

a <- list(1, 2, 3, 4)
reduce(a, sum)

