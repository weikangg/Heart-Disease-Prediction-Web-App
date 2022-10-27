library(markdown)
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(shinydashboard)
library(data.table)
library(RCurl)
library(tidyverse)
library(cvms)
library(caTools)
library(tibble)


#-----------------------------------Importing Trainset,Test Set and desired Model--------------------------------------------#

x <- getURL("https://raw.githubusercontent.com/weikangg/MyHealth/main/heart_failure_prediction_training.csv")
trainset <-fread(text = x)
trainset<- trainset[,-1]
trainset$FastingBS <- factor(trainset$FastingBS)
trainset$HeartDisease <- factor(trainset$HeartDisease)
summary(trainset)
y<- getURL("https://raw.githubusercontent.com/weikangg/MyHealth/main/brfss_train.csv")
brfss_trainset <-fread(text = y, stringsAsFactors = T)
names(brfss_trainset) <- tolower(names(brfss_trainset))
setnames(brfss_trainset, "heartdiseaseorattack", "HeartDiseaseorAttack")
summary(brfss_trainset)
#-------------------------------------------------Building the UI------------------------------------------------------------#


####################################
#          User interface          #
####################################
fluidPage(theme = shinytheme("darkly"),
          
    navbarPage("MyHealth",
               tabPanel("Predicting With General Values",
                  
                        # Input values
                        sidebarPanel(
                          style = "border-radius: 20px;",
                          HTML("<h3>Input Parameters</h3>"),
                          sliderTextInput(
                            inputId = "age",
                            label = "Age:",
                            choices = c(min(brfss_trainset$age): max(brfss_trainset$age)),
                            grid = TRUE),
                          selectInput("sex", label = "Sex:", 
                                      choices = list("Male" = "1", "Female" = "0"), 
                                      selected = "Male"),
                          selectInput("highbp", label = "High Blood Pressure:", 
                                      choices = list("Yes" = "1", "No" = "0"), 
                                      selected = "Yes"),
                          selectInput("highchol", label = "High Cholesterol:", 
                                      choices = list("Yes" = "1", "No" = "0"), 
                                      selected = "Yes"),
                          selectInput("smoker", label = "Smoker:", 
                                      choices = list("Yes" = "1", "No" = "0"), 
                                      selected = "Yes"),
                          selectInput("stroke", label = "Stroke:", 
                                      choices = list("Yes" = "1", "No" = "0"), 
                                      selected = "Yes"),
                          selectInput("diabetes", label = "Diabetes:", 
                                      choices = list("Yes" = "2", "Pre-Diabetes / Borderline Diabetes" = "1", "No Diabetes / Only During Pregnancy" = "0"), 
                                      selected = "Yes"),
                          selectInput("genhlth", label = "GenHlth:", 
                                      choices = list("1" = "1", "2" = "2", "3" = "3", "4" = "4", "5" = "5"), 
                                      selected = "3"),
                          sliderTextInput(
                            inputId = "menthlth",
                            label = "MentHlth:",
                            choices = c(min(brfss_trainset$menthlth): 30),
                            grid = TRUE),
                          sliderTextInput(
                            inputId = "physhlth",
                            label = "PhysHlth:",
                            choices = c(min(brfss_trainset$physhlth): max(brfss_trainset$physhlth)),
                            grid = TRUE),
                          sliderTextInput(
                            inputId = "income",
                            label = "Income:",
                            choices = c(min(brfss_trainset$income): max(brfss_trainset$income)),
                            grid = TRUE),
                          actionButton("submitbutton2", "Submit", class = "btn btn-primary")
                        ),
                        
                        mainPanel(
                          style = "border-radius: 5px;",
                          tags$label(h3('Status/Output')), # Status/Output Text Box
                          verbatimTextOutput('contents2'),
                          tags$label(h3('Probability')), # Status/Output Text Box
                          verbatimTextOutput('results2'), # Prediction results table
                          tags$label(h3('Final Prediction:')), # Status/Output Text Box
                          verbatimTextOutput('prob2'),
                        ),
               ),
              tabPanel("Predicting With Lab Values",
                
                # Input values
                sidebarPanel(
                  style = "border-radius: 20px;",
                  HTML("<h3>Input Parameters</h3>"),
                  selectInput("Sex", label = "Sex:", 
                              choices = list("Male" = "M", "Female" = "F"), 
                              selected = "Male"),
                  selectInput("ChestPainType", label = "ChestPainType:", 
                              choices = list("TypicalAngina" = "TA", "AtypicalAngina" = "ATA", "Non-AnginalPain" = "NAP", "Asymptomatic" = "ASY"), 
                              selected = "TypicalAngina"),
                  selectInput("FastingBS", label = "FastingBS (>120mg/dl)? :", 
                              choices = list("Yes" = "1", "No" = "0"), 
                              selected = "Yes"),
                  selectInput("ExerciseAngina", label = "ExerciseAngina:", 
                              choices = list("Yes" = "Y", "No" = "N"), 
                              selected = "Yes"),
                  sliderInput("Oldpeak", "Oldpeak:",
                              min = -2.6,
                              max = 5.6,
                              value = (-2.6 + 5.6/2)),
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