library(rvest)
library(dplyr)

# Load the webpage
url <- "https://www.bbc.co.uk/sport/football/scottish-premiership/table"
webpage <- read_html(url)

# Extract the first table on the page
table_node <- html_node(webpage, "table")

# Convert it into a data frame
league_table <- html_table(table_node, fill = TRUE)

# View the result
print(league_table)
