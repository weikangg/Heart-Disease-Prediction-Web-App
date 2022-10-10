library(rmarkdown)
library(shiny)
library(shinythemes)
library(data.table)
library(RCurl)
library(tidyverse)
library(cvms)
library(caTools)
library(tibble)

#-----------------------------------Importing Trainset,Test Set and desired Model--------------------------------------------#
trainset <-fread("heart_failure_prediction_training.csv", stringsAsFactors = TRUE)
trainset<- trainset[,-1]
trainset$FastingBS <- factor(trainset$FastingBS)
trainset$HeartDisease <- factor(trainset$HeartDisease)

#-------------------------------------------------Building the UI------------------------------------------------------------#


####################################
#          User interface          #
####################################
fluidPage(theme = shinytheme("darkly"),
                
                navbarPage("MyHealth",
                           tabPanel("Predictor",
                                    
                                    # Input values
                                    sidebarPanel(
                                      style = "border-radius: 20px;",
                                      HTML("<h3>Input Parameters</h3>"),
                                      sliderInput("Age", "Age:",
                                                  min = 0, max = 120,
                                                  value = 60),
                                      selectInput("Sex", label = "Sex:", 
                                                  choices = list("Male" = "M", "Female" = "F"), 
                                                  selected = "Male"),
                                      selectInput("ChestPainType", label = "ChestPainType:", 
                                                  choices = list("TypicalAngina" = "TA", "AtypicalAngina" = "ATA", "Non-AnginalPain" = "NAP", "Asymptomatic" = "ASY"), 
                                                  selected = "TypicalAngina"),
                                      sliderInput("RestingBP", "RestingBP:",
                                                  min = min(trainset$RestingBP),
                                                  max = max(trainset$RestingBP),
                                                  value = (min(trainset$RestingBP) + max(trainset$RestingBP))/2),
                                      sliderInput("Cholesterol", "Cholesterol:",
                                                  min = min(trainset$Cholesterol),
                                                  max = max(trainset$Cholesterol),
                                                  value = (min(trainset$Cholesterol) + max(trainset$Cholesterol))/2),
                                      selectInput("FastingBS", label = "FastingBS (>120mg/dl)? :", 
                                                  choices = list("Yes" = "1", "No" = "0"), 
                                                  selected = "Yes"),
                                      selectInput("RestingECG", label = "RestingECG:", 
                                                  choices = list("normal" = "Normal", "lvh" = "LVH", "st" = "ST"), 
                                                  selected = "normal"),
                                      sliderInput("MaxHR", "MaxHR:",
                                                  min = min(trainset$MaxHR),
                                                  max = max(trainset$MaxHR),
                                                  value = (min(trainset$MaxHR) + max(trainset$MaxHR))/2),
                                      selectInput("ExerciseAngina", label = "ExerciseAngina:", 
                                                  choices = list("Yes" = "Y", "No" = "N"), 
                                                  selected = "Yes"),
                                      sliderInput("Oldpeak", "Oldpeak:",
                                                  min = min(trainset$Oldpeak),
                                                  max = max(trainset$Oldpeak),
                                                  value = (min(trainset$Oldpeak) + max(trainset$Oldpeak))/2),
                                      selectInput("ST_Slope", label = "ST_Slope:", 
                                                  choices = list("Upslope" = "Up", "FlatSlope" = "Flat", "DownSlope" = "Down"), 
                                                  selected = "Upslope"),
                                      actionButton("submitbutton", "Submit", class = "btn btn-primary")
                                    ),
                                    
                                    mainPanel(
                                      style = "border-radius: 5px;",
                                      tags$label(h3('Status/Output')), # Status/Output Text Box
                                      verbatimTextOutput('contents'),
                                      tags$label(h3('Probability')), # Status/Output Text Box
                                      verbatimTextOutput('results'), # Prediction results table
                                      tags$label(h3('Final Prediction:')), # Status/Output Text Box
                                      verbatimTextOutput('prob'),
                                    )
                           ),
                           tabPanel("About",
                                    div(includeMarkdown("about.txt"), 
                                        align="justify")
                           )
                )         
)