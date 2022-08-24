# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                     #  
# Introduction to R                                                   #
#                                                                     #
# taught by Amy Trost (atrost@montgomerycollege.edu)                  #
#                                                                     #
#                                                                     #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 


## -------------------------
## 1. Basic Commands
## -------------------------

n <- 1    # assigning the variable n the value of 1
N <- 15

n
N        # You can't swap upper and lower case in R
n + N

# try a list (called a vector. A list is a special kind of variable in R)
name <- c("hello","there","world")
name[1]
name[2]
name[3]

# try a simple function
test_scores <- c(90, 72, 85, 96, 84, 79)
test_average <- mean(test_scores)

# Statistical Functions
max(test_scores)        # Find the maximum value in x, excluding missing values
min(test_scores)        # minimum
mean(test_scores)       # mean
median(test_scores)     # median 
sum(test_scores)        # sum
sd(test_scores)         # standard deviation

# get help for a command
?mean


## -------------------------------------------------------------------------
## 2. Importing a data set
##
## We are working with four data files today
## Set the working directory under "session"
## to the place where the data files are
## before running the commands below
##
## Sources: 
## World Bank World Development Indicators
## https://en.wikipedia.org/wiki/Lists_of_organisms_by_population
## https://www.kaggle.com/datasets/zanderventer/
##       environmental-variables-for-world-countries
##                     
## -------------------------------------------------------------------------

species <- read.csv("wikipedia species list.csv")

countries <- read.csv("worldbank google country data.csv")


# Examining the data set
View(species)        # Note: Upper case V in View()
head(species)         # return the first parts of the data set 

class(species)          # type of data set

dim(species)                 # 1st: row number; 2nd: column number
nrow(species)                # number of rows
ncol(species)                # number of columns

colnames(species)            # name of columns (the variable names) in dataset  
rownames(species)            # row names

summary(species)
summary(countries)

# Selecting elements of a data set
countries[6,]         # 6th row
countries[6:10,]      # rows 6 to 10
countries[,1]         # first column
countries[10:20,1:3]  # a selection of rows and columns

species$common_name         # column by name
species$common_name[30:55]  # can combine selection types


## -------------------------------------------------------------------------
## 3. Data Types
## look in the "environment" panel on the right hand side to see
## data types for the variables we've created so far
##                     
## -------------------------------------------------------------------------

# changing from integer to numeric
countries$avg_elev_m <- as.numeric(countries$Avg_elev_m)

# turning a bunch of variables into factors (categories)
countries$Region <- as.factor(countries$Region)
countries$Income_class <- as.factor(countries$Income_class)

species$species_group <- as.factor(species$species_group)
species$IUCN_abbr <- as.factor(species$IUCN_abbr)
species$IUCN_category <- as.factor(species$IUCN_category)


# now view the newly organized data set
summary(countries)

levels(species$species_group) # view all of the categories

## -------------------------------------------------------------------------
## 4. Manipulating Data
## 
## We will use a package called dplyr with special commands
## Choose to install under the "Packages" tab in the
## lower left corner of the screen, and select "dplyr"
##
## -------------------------------------------------------------------------

library(dplyr)     # this lets our current session view 
                   # the package we just installed

##---------------------------------------------
## 4a. select()
## chooses just a few columns in a data set
##---------------------------------------------

treeinfo <- select(countries, Country, Region, tree_pct)

# can use pipes instead for same result
treeinfo <- countries %>% select(Country, Region, tree_pct)


##---------------------------------------------
## 4b. filter()
## chooses just a few rows in a data set
##---------------------------------------------

whales_dolphins <- species %>% filter(species_group == "cetacean")

# can filter on multiple categories
# just continue long commands on a new line
whales_dolphins_endangered <- species %>%
    filter(species_group =="cetacean",IUCN_abbr==c("CR","EN"))
    
# can also combine with select to get certain columns
whales_dolphins_endangered <- species %>%
    filter(species_group =="cetacean",IUCN_abbr==c("CR","EN")) %>%
    select(common_name, est_pop, IUCN_category, Trend)

# small enough result to view on the console
whales_dolphins_endangered

##-------------------------------------------------------------------
## 4c. group_by(), summarize(), and arrange()
##
## allows a summary of information by group
## 
##-------------------------------------------------------------------

# summary function 'n' counts the number of animals in each
# vulnerability group
species %>% group_by(IUCN_category) %>%
    summarize(n())

# if you put this in a variable, it creates a tibble,
# which is similar to a data frame but acts a little bit
# differently sometimes
sp_count <- species %>% group_by(IUCN_category) %>%
    summarize(n())

# using summary function 'median' to find the median
# income levels for countries in different income
# groups. Use NA.rm to remove missing values
countries %>% group_by(Income_class) %>%
    summarize(median(income_percap, na.rm=TRUE))

# Assign a variable name to the median income, then
# you can display the data in order
countries %>% group_by(Income_class) %>%
    summarize(med_income = median(income_percap, na.rm=TRUE)) %>%
    arrange(med_income)

##---------------------------------------------
## 4d. mutate()
## create new columns based on existing columns
##---------------------------------------------

# this will print the result back on the screen
countries %>% mutate(rainfall_in = rainfall_mm * .0393701)

# this will add a column to the countries table
countries <- countries %>%
    mutate(rainfall_in = rainfall_mm * .0393701)


## -------------------------------------------------------------------------
## 5. Visualizing data
## 
## We will use a package called ggplot2 with special commands
## Choose to install under the "Packages" tab in the
## lower left corner of the screen, and select "ggplot2"
##
## -------------------------------------------------------------------------

library(ggplot2)    # this lets our current session view 
                    # the package we just installed

# to see examples of all types of charts, pull in one more data set
# this one has life expectancy data
# instead of reading in a csv, this data is part of R, used for learning 
# purposes. Install the "gapminder" package then run the code below.

library("gapminder")
gapminder <- gapminder   # no need to do this, but it may be helpful
                         # so the variable elements are easier to view

##---------------------------------------------
## 5a. Scatter Plot
##---------------------------------------------

ggplot(countries, aes(x=income_percap,y=life_expect)) +
    geom_point()

# Pipes are a little bit simpler, can also create a new variable
country_scatter <- countries %>%
    ggplot(aes(x=income_percap,y=life_expect)) +
    geom_point()

# enter chart variable name to view
country_scatter

# make plot fancier
country_scatter <- countries %>%
    ggplot(aes(x=income_percap,y=life_expect)) +
    labs(title = "Life Expectancy vs. Income",y="Life Expectancy", x="Income") +
    geom_point(aes(col=Region)) +
    scale_color_brewer(palette="PRGn")
country_scatter

##---------------------------------------------
## 5b. Line Graph
##---------------------------------------------

life_line <- gapminder %>%
    ggplot(aes(x=year, y=lifeExp, by=country)) + 
    geom_line()
life_line

# Add titles, colors, filter down
life_line <- gapminder %>%
    filter(continent == "Oceania") %>%
    ggplot(aes(x=year, y=lifeExp, by=country)) + 
    labs(title = "Life Expectancy over Time",y="Life Expectancy", x="Year") + 
    geom_line(aes(col=country), size=1.5)
life_line

##---------------------------------------------
## 5c. Bar Graph
##---------------------------------------------

# species count, endangered species
most_endangered <- species %>%
    filter(IUCN_abbr == "CR") %>%
    ggplot(aes(x=common_name, y=est_pop)) +
    geom_col()
most_endangered

# remove biggest populations, sort by population
# add colors 
most_endangered <- species %>%
    arrange(est_pop) %>%
    filter(IUCN_abbr == "CR", est_pop <1000) %>%
    ggplot(aes(x=reorder(common_name, est_pop), y=est_pop)) +
    labs(title = "Critically Endangered species", y="Est. Population", x=NULL) + 
    geom_col(aes(fill=species_group)) 
most_endangered + coord_flip()



##---------------------------------------------
## 5d. Histogram
##---------------------------------------------
life_dist <- countries %>%
    ggplot(aes(x=life_expect)) +
    geom_histogram()
life_dist

# change color, set bin size
life_dist <- countries %>%
    ggplot(aes(x=life_expect)) +
    geom_histogram(fill="dark red", color="white", binwidth=2, alpha=0.8) +
    ggtitle("Average Life Expectancy: Distribution by Country")
life_dist


