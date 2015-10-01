#==================================
#  Append sentiment to your tweets
#==================================
  
library(dplyr)
library(magrittr) 
library(data.table)
library(sentiment)

# Read in the data to a data.table

txt<-read.csv("twitter_sentiment.csv")          
txt<-data.table(txt)

# Save the original text in a new column
txt[, original := text]

# Remove all weird formatting from the text and convert it to lower case, etc
txt[, text := gsub("@", "", text)]
txt[, text := gsub("_", " ", text)]
txt[, text := gsub("http[.:/a-zA-Z0-9]+", "", text)]
txt[, text := gsub("[[:digit:]]", "", text)]
txt[, text := gsub("[[:punct:]]", "", text)]
txt[, text := gsub("[ \t]{2,}", "", text)]
txt[, text := gsub("^\\s+|\\s+$", "", text)]
txt[, text := tolower(text)]

# Classify the tweets as either positive or negative
class_pol = classify_polarity(txt[, text], algorithm="bayes")

# Assign the positive or negative column to the txt data
txt[, polarity := class_pol[,4]]

# Write to a file
write.csv(txt, "tw_sent_attached.csv", row.names = FALSE)    ####change the name of the output file
