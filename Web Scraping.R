######### Libraries ######### 

library(rvest)
library(tidyverse)
library(httr)

######### Url ######### 

url <- "https://www.golfshake.com/course/top100/england/"

webpage <- read_html(url)

titles <- html_nodes(webpage, "h2") %>%  html_text() 

titles1 <- as.data.frame(titles)

df_even <- titles1[seq(2, nrow(titles1), by = 2), ]
df_even <- as.data.frame(df_even)

#write.csv(df_even, "C:/Users/scott/OneDrive/Documents/Linkedin Github ideas/topengcourses.csv")

######### ######### 

years <- html_nodes(webpage, "") %>%  html_text() 
genre <- html_nodes(webpage, "") %>%  html_text()
rating <- html_nodes(webpage, "") %>%  html_text()
desc <- html_nodes(webpage, "") %>%  html_text()
votes <- html_nodes(webpage, "") %>%  html_text()

######### ######### 

length(titles)
length(genre)
length(rating)
length(desc)
length(votes)

data <- as.data.frame(
  title = titles,
  year = years,
  genre = genre,
  rating = rating, 
  desc = desc, 
  votes = votes)

view(data)

######### Creating a loop ######### 

dataloop <- data.frame()

for (i in seq(from = 1, to = 100, by = 50)) {
  urlloop <- paste0("", i, "")
  webpageloop <- read_html(urlloop)
  
  titles = html_nodes(webpageloop, "") %>%  html_text()
  years <- html_nodes(webpageloop, "") %>%  html_text() %>% str_replace_all()
  
  genre <- html_nodes(webpageloop, "") %>%  html_text()
  rating <- html_nodes(webpageloop, "") %>%  html_text()
  desc <- html_nodes(webpageloop, "") %>%  html_text()
  votes <- html_nodes(webpageloop, "") %>%  html_text()
  
  page_data <- data.frame(title, year, ratings, votes, desc)
  dataloop <- bind_rows(dataloop, page_data)
  
  Sys.sleep(3)
}

view(dataloop)

######### end of code ######### 





