library(tidyverse)
library(data.table)
library(dplyr)
library(tidyr)
library(ggplot2)

nflWarTable <- fread("2017WRwithWAR.csv")
nflAgeTable <- fread('2017WRAge.csv')
nflPlayerNames <- fread("2017PlayerNames.csv")

#Split columns to be later used as matching

nflWarTable <- separate(nflWarTable, Player_ID_Name, into=c('shortened_name','PlayerID'), sep='-', extra='merge')
nflAgeTable <- separate(nflAgeTable, Player, into=c('Player','pffID'), sep='/', extra='merge')

#Merge datasets together

nflWarTable <- merge(nflWarTable,nflPlayerNames,by.x = c('PlayerID'), by.y= c('GSIS_ID'),all.x=TRUE)
nflWarTable <- merge(nflWarTable, nflAgeTable, by.x = ('Player'), by.y = c('Player'), all.x = TRUE)

#Remove mismatches

nflWarTable <- drop_na(nflWarTable, Age)

#Graphs

ggplot(nflWarTable, aes(x=Age, y=total_WAR)) +
  geom_point()+
  geom_smooth() +
  ggtitle("Age vs Total WAR in 2017 Wide Receivers")

nflWarTable$`Ctch%` <- gsub("%",'',as.character(nflWarTable$`Ctch%`))
nflWarTable$`Ctch%` <- as.numeric(nflWarTable$`Ctch%`)

ggplot(nflWarTable, aes(x=`Y/Tgt`, y=total_WAR)) +
  geom_point()+
  geom_smooth()+
  ggtitle("Yards per target vs Total WAR in 2017 Wide Receivers")
