

library(ggplot2)
library(dplyr)
library(lattice)

setwd("D:/ISB Co 2018/Coursera/Data Science Specialization/Reproducible Research/Week 4/Project 2")
stormdata <- read.csv("stormdata.csv") # reading dataset into R
str(stormdata) # exploring dataset
colnames(stormdata) <- tolower(colnames(stormdata)) # converting all column names to lowercase

# Answering Q1 - since we're concerned with only the health impact of storm & weather events, we will focus only on relevant columns of the dataset, namely - evtype, fatalities & injuries

# plan to add the fatalitites & injuries and arrange datset in descending order of the same

q1_stormdata <- stormdata %>% group_by(evtype) %>% summarize(count=n(),fatalities=sum(fatalities), injuries=sum(injuries)) %>% mutate(health_impact = fatalities + injuries)

q1_stormdata_hi <- arrange(q1_stormdata,desc(health_impact))

# considering only the Top 10 in harmful heatlh impact and drawing plot

q1_stormdata_hi10 <- q1_stormdata_hi[1:10,]
q1_stormdata_hifi <- q1_stormdata_hi10$health_impact
q1_stormdata_hiev <- q1_stormdata_hi10$evtype

barplot(q1_stormdata_hi10,names.arg = q1_stormdata_hiev, las=2,cex.names = 0.5, ylab="Total Fatalities & Injuries", xlab = "Event Type", main = "Top 10 Events with Harmful Health Impact")


# From the barplot, we can conclude that Tornado has the most harmful health impact among the different storm & weather events in US.

# Answering Q2 - since we're concerned with only the economic impact of storm & weather events, we will focus only on relevant columns of the dataset, namely - evtype, propdmg, propdmgexp, cropdmg & cropdmgexp

q2_stormdata <- stormdata %>% select(evtype,propdmg,propdmgexp,cropdmg,cropdmgexp)

q2_stormdata$propdmgexp <- toupper(q2_stormdata$propdmgexp)
q2_stormdata$cropdmgexp <- toupper(q2_stormdata$cropdmgexp)

# propdmgexp & cropdmgexp have characters & numbers corresponding to specific multiples which need to be matched

prop_mult <-  c(" " = 10^0,"-" = 10^0,"+" = 10^0,"0" = 10^0,"1" = 10^1, "2" = 10^2, "3" = 10^3,"4" = 10^4, "5" = 10^5, "6" = 10^6, "7" = 10^7, "8" = 10^8, "9" = 10^9, "H" = 10^2, "K" = 10^3, "M" = 10^6,"B" = 10^9)

q2_stormdata$propdmgexp <- prop_mult[as.character(q2_stormdata$propdmgexp)]

q2_stormdata$propdmgexp[is.na(q2_stormdata$propdmgexp)] <- 10^0

crop_mult <- c(" " = 10^0,"?" = 10^0, "0" = 10^0,"K" = 10^3,"M" = 10^6, "B" = 10^9)

q2_stormdata$cropdmgexp <- crop_mult[as.character(q2_stormdata$cropdmgexp)]

q2_stormdata$cropdmgexp[is.na(q2_stormdata$cropdmgexp)] <- 10^0

# multiplying propdmg & propdmgexp to get property loss

q2_stormdata$proploss <- q2_stormdata$propdmg * q2_stormdata$propdmgexp

# multiplying propdmg & propdmgexp to get croploss

q2_stormdata$croploss <- q2_stormdata$cropdmg * q2_stormdata$cropdmgexp

# aggregating proploss & croploss per evtype into a new dataframe

q2_ecodata <- aggregate(cbind(proploss, croploss) ~ evtype, data=q2_stormdata, FUN=sum)

# adding total loss column to the new dataframe & arranging in descending order

q2_ecodata$tot_loss <- q2_ecodata$proploss + q2_ecodata$croploss
q2_ecodata <- arrange(q2_ecodata,desc(tot_loss))

# considering only the Top 10 in economic impact and drawing plot

q2_ecodata_10 <- q2_ecodata[1:10,]
q2_ecodata_loss10 <- q2_ecodata_10$tot_loss
q2_ecodata_ev <- q2_ecodata_10$evtype

barplot(q2_ecodata_loss10,names.arg = q2_ecodata_ev, las=2,cex.names = 0.5, ylab="Total Property & Crop Loss", xlab = "Event Type", main = "Top 10 Events with Most Economic Impact")

# From the barplot, we can conclude that Flood has the most economic health impact among the different storm & weather events in US.

