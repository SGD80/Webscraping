######### Libraries ######### 

library(rvest)
library(dplyr)

######### Courses ######### 

courses <- c("standrewsoldcourse", 
             "royaldornochgolfclubchamp",
             "turnberryailsa",
             "carnoustiech",
             "kingsgl",
             "northberwickgcthe",
             "castlestuartgolf",
             "royalaberdeengolfclub",
             "trumpinternationalgl",
             "crudenbaygc",
             "royaltroon",
             "lochlomondgc",
             "prestwickgcsc",
             "westerngailesgolfclub",
             "machrihanishgolfclub",
             "gleneagleskingsc",
             "nairngolfclub",
             "standrewscastle",
             "renaissancegcma",
             "gullanegcone",
             "carnegieclubskibocastle",
             "standrewsnewc",
             "dundonald",
             "thedukesstandrews",
             "gleneaglesresortqueens",
             "broragolfclub",
             "moraygcold",
             "dunbargc",
             "archerfieldlinksfidra",
             "speyvalleygcuk",
             "southernessgc",
             "lundingc",
             "blairgowriegcrosement",
             "glasgowgcgailes",
             "archerfieldlinksdirleton",
             "boatofgartengc",
             "murcarlinks",
             "levenlinksgc",
             "ladybankgc",
             "gullanegctwo",
             "centenaryc",
             "luffnessnewgc",
             "panmuregolfclub",
             "montrosegolflinks",
             "standrewsjubilee",
             "monifieth",
             "elie",
             "roxburghechampgolfcourse",
             "downfieldgc",
             "irvinegolfclub",
             "kingrobertbruce",
             "fraserburghgc",
             "scotscraiggolfclub",
             "balcomielinks",
             "crailgc",
             "kilmarnockbarassiegc",
             "kilbridegc",
             "prestwickstnicholasg",
             "nairnbunbargc",
             "golspie",
             "fortroserosemarkiegc",
             "longniddrygc",
             "fairmontstandrews",
             "taingolfclub",
             "eastrenfrewshire",
             "lanarkgolfclubuk",
             "newmachergchawkshill",
             "kilspindie",
             "blairgowrielandsdowne",
             "craigielawgolfclub",
             "theroyalburgessuk",
             "mortonhall",
             "carrick",
             "meldrumhousegolfclub",
             "stramraer",
             "dalmahoygcc",
             "powfoot",
             "musselburghgc",
             "glen",
             "portpatrickdunsky",
             "ranfulrycastle",
             "kilmacolm",
             "auchterarder",
             "pitlochrygc",
             "marhallhotelgspa",
             "alythgolfclub",
             "fairmontstandrewskittocks",
             "grantownonspey",
             "elgingcuk",
             "rowallangc",
             "royalmusselburghgc",
             "bruntsfieldlinks",
             "dumbarnielinksgc"
)

######### Loop ######### 

for (i in seq_along(courses)) {
  
  course_slug <- courses[i]
  
  # Optional: prettify course name for the course column
  course_name <- gsub("([a-z])([A-Z])", "\\1 \\2", course_slug)
  course_name <- gsub("gc$", " Golf Club", course_name)
  course_name <- tools::toTitleCase(gsub("-", " ", course_name))
  
  url <- paste0("https://course.bluegolf.com/bluegolf/course/course/", course_slug, "/detailedscorecard.htm")
  
  page <- read_html(url)
  
  # Extract the scorecard table from the webpage
  scorecard <- page %>%
    html_element("table") %>%
    html_table(fill = TRUE)
  
  # Transpose the scorecard so rows become columns and vice versa
  t_data <- t(scorecard)
  
  # Convert to data frame and assign proper column names
  df <- as.data.frame(t_data[-1, ], stringsAsFactors = FALSE)
  colnames(df) <- t_data[1, ]
  
  # Extract the Tee vector (first column, actual hole names like "1", "2", "Out", etc.)
  Tee <- df[, 1]
  
  # Remove the original Tee column to avoid duplication
  df <- df[, -1]
  
  # Add Tee back as the first column
  df <- cbind(Tee = Tee, df)
  
  # Set row names to exactly match the Tee vector
  rownames(df) <- Tee
  
  # Add course name column for later join/analysis
  df$course <- course_name
  
  # Save the data frame with unique names per course
  assign(paste0("df", i), df)
}

######### combining the datasets #########

df_names <- paste0("df", 1:93)  # adjust 3 to however many you have

# Use mget() to get the actual data frames as a list
df_list <- mget(df_names)

# Bind all rows together
combined_df <- bind_rows(df_list)

rownames(c) <- 1:nrow(combined_df)

########## View combined data frame ######### 

print(combined_df)

#write.csv(combined_df, "C:/Users/scott/OneDrive/Documents/Linkedin Github ideas/top93courses.csv")
