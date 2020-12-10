install.packages("tidyverse")
forestfire <- read_csv("forestfires.csv")
forestfire
month_vector <- c("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec")
day_vector <- c("mon", "tue", "wed", "thu", "fri", "sat", "sun")
forestfire <- forestfire %>% mutate(month = factor(month, levels = month_vector),
                                    day = factor(day, levels = day_vector))  
forestfire
countby_month <- forestfire %>% group_by(month) %>% summarise(total_fires = n())
countby_month
countby_day <- forestfire %>% group_by(day) %>% summarise(total_fires_day = n())
countby_day
countby_month %>% ggplot(aes(x = month, y = total_fires)) + geom_col() + labs(
  title = "Number of forest fires in data by month",
  y = "Fire count",
  x = "Month"
)
countby_day %>% ggplot(aes(x= day, y = total_fires_day)) + geom_col() + 
  labs ( title = "Numbeer of forest fires in data by day", 
         y = "fire count by days", x= "week_days")

forestfire_split_long <- forestfire %>% pivot_longer(cols = c(FFMC, DMC, DC, ISI, temp, RH, wind, rain),
               names_to = "fire_factors", values_to = "values")
forestfire_split_long
forestfire_split_long %>% ggplot(aes(x= month, y = values)) + geom_col() +
  facet_wrap(vars(fire_factors, scales = "free_y"))
forestfire_split_long %>% ggplot(aes(x= values, y = area)) + geom_point() +
  facet_wrap(vars(fire_factors, scales = "free_x"))
forestfire_split_long %>% filter(area < 300) %>% ggplot(aes(x= values, y = area))+ geom_point() + facet_wrap(vars(fire_factors, scales = "free_x"))
sum()