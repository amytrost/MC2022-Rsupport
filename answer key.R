# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                     #  
# Introduction to R: Answer Key                                       #
#                                                                     #
# Questions? Contact Amy Trost (atrost@montgomerycollege.edu)         #
#                                                                     #
#                                                                     #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 




## -------------------------
## Exercise 1
## -------------------------

#1. How many columns are in the endangered species data set? How many rows?
ncol(species)   # option 1    
nrow(species)

dim(species)    # option 2. Or just look in the environment pane on your screen.

#2. How could you select just the first 3 columns of the countries data set?
countries[1:3]

#3. How could you select just the latin names for the species data set?
species[3]            # option 1
species$latin_name    # option 2

#4. What kind of variable is the countries data set?
# (looking in the environment panel for info is totally OK too)
class(countries)       # high-level category
typeof(countries)      # low level category

#5. What kind of variable is cropland_pct in the countries data set?
class(countries$cropland_pct) # numeric variable
typeof(countries$cropland_pct) # double

#6. Use as.factor() to change the species data set. 
#   With 3 separate lines of code, turn species_group, IUCN_abbr, 
#   and IUCN_category into factors. Summarize the species data set 
#   when you are through. 
species$species_group <- as.factor(species$species_group)
species$IUCN_abbr <- as.factor(species$IUCN_abbr)
species$IUCN_category <- as.factor(species$IUCN_category)
summary(species)



## -------------------------
## Exercise 2
## -------------------------

# 1. Filter the species data to only include species with an estimated population 
#    of less than 10,000. Add select to this command with a pipe (%>%). Select 
#    just the common_name, the species_group, and the est_pop. 
species %>%
    filter(est_pop < 10000) %>%
    select(common_name, species_group, est_pop)

# 2. Group the country data by region, then summarize using the median rainfall 
#    in mm. Arrange from largest to smallest, using:
#    arrange(desc(variable name goes here))
#    Hint: Look at a class example with Income Class and Per capita Income.
            
countries %>% group_by(Region) %>%
    summarize(med_rain = median(rainfall_mm, na.rm=TRUE)) %>%
    arrange(desc(med_rain))


## -------------------------
## Exercise 3
## -------------------------


# 1. Filter the countries data set to include only data from South Asia. 
#    With this subset, create a bar chart that reports average rainfall 
#    in mm for each country.

South_Asia <- countries %>%
    filter(Region == "SOUTH ASIA")

average_rain <- South_Asia %>%
    ggplot(aes(x=Country, y=rainfall_mm)) +
    geom_col() 
average_rain

# 2. Create a scatter plot with the countries data set that shows the 
#    relationship between tree cover and rainfall. Color the dots by region, 
#    label the x & y axes, and give the chart a title.
trees_rain <- countries %>%
    ggplot(aes(x=rainfall_mm,y=tree_pct)) +
    labs(title = "Tree Cover vs. Rainfall",y="% Tree Cover", x="Rainfall (mm)") +
    geom_point(aes(col=Region))
trees_rain

