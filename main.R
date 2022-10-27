#----------------------------------------------------Importing Libraries-----------------------------------------------------#
list.of.packages <- c("data.table", "shiny", "shinythemes", "RCurl", "tidyverse", "cvms", "caTools", "tibble", "markdown", "shinyWidgets", "shinydashboard")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

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
trainset <-fread(text = x,stringsAsFactors = T)
trainset<- trainset[,-1]
trainset$FastingBS <- factor(trainset$FastingBS)
trainset$HeartDisease <- factor(trainset$HeartDisease)
trainset %>% summary()

y<- getURL("https://raw.githubusercontent.com/weikangg/MyHealth/main/brfss_train.csv")
brfss_trainset <-fread(text = y, stringsAsFactors = T)
names(brfss_trainset) <- tolower(names(brfss_trainset))
setnames(brfss_trainset, "heartdiseaseorattack", "HeartDiseaseorAttack")
brfss_trainset %>% summary()

m1 <- readRDS("model.rds")
m3 <- readRDS("model3.rds")
summary(m3)
#-----------------------------------Testing whether the model works--------------------------------------------#

# brfss_testset <-fread("brfss_test.csv")
# brfss_testset$HeartDiseaseorAttack <- factor(brfss_testset$HeartDiseaseorAttack)
# brfss_testset$HighBP <- factor(brfss_testset$HighBP)
# brfss_testset$HighChol <- factor(brfss_testset$HighChol)
# brfss_testset$BMI <- factor(brfss_testset$BMI)
# brfss_testset$Smoker <- factor(brfss_testset$Smoker)
# brfss_testset$Stroke <- factor(brfss_testset$Stroke)
# brfss_testset$Diabetes <- factor(brfss_testset$Diabetes)
# brfss_testset$GenHlth <- factor(brfss_testset$GenHlth)
# brfss_testset$MentHlth <- factor(brfss_testset$MentHlth)
# brfss_testset$PhysHlth <- factor(brfss_testset$PhysHlth)
# brfss_testset$Sex <- factor(brfss_testset$Sex)
# brfss_testset$Age <- factor(brfss_testset$Age)
# brfss_testset$Income <- factor(brfss_testset$Income)
# brfss_testset %>% summary()
# 
# dataframe <- as.dataframe()
# cart.predict <- predict(m2, newdata = brfss_testset, type = "class")
# cart.predict
# table2 <- table(Testset.Actual = testset$HeartDiseaseorAttack, cart.predict, deparse.level = 2)
# table2
# round(prop.table(table2), 3)
# # Overall Accuracy
# mean(cart.predict == testset$HeartDiseaseorAttack)
# newdata <- data.frame(
#   Age = factor("8"), Sex = factor("1"), HighBP = factor("1"), HighChol = factor("1"), Smoker = factor("1"), Stroke = factor("1"),
#   Diabetes = factor("1"), GenHlth = factor("3"), MentHlth = factor("15"), PhysHlth = factor("15"), BMI = factor("30"), Income = factor("1")
# )
# # m3 %>% predict(newdata,type = "class")
# m3 %>% predict(newdata,type = "response")
# summary(m3)
#-------------------------------------------------Building the UI------------------------------------------------------------#


####################################
#          User interface          #
####################################
ui <- fluidPage(theme = shinytheme("darkly"),

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

####################################
#               Server             #
####################################

server <- function(input, output, session) {

  #------THIS PART IS FOR THE FIRST DATASET, HEART FAILURE PREDICTION-------#
  input_df <- reactive({
    data.frame(
               Sex = as.factor(input$Sex),
               ChestPainType = as.factor(input$ChestPainType),
               FastingBS = as.factor(input$FastingBS),
               ExerciseAngina = as.factor(input$ExerciseAngina),
               Oldpeak = as.numeric(input$Oldpeak),
               ST_Slope = as.factor(input$ST_Slope)
               )
  })
  
  pred <- reactive({
    Prob <- input_df()
    tt <- as.data.frame(predict(m1,Prob, type='response'))
    tt = tt[,1]
  })

  output$results <- renderPrint({
    if (input$submitbutton>0) { 
      tt <- pred()
      tt
    }
    else{
      return ("Server is ready for calculation.")
    }
  })
  output$prob <- renderPrint({
    if (input$submitbutton>0) { 
      tt <-pred()
      tt <- as.data.frame(tt)
      if(tt[,1] > 0.5){
        txt = ("At risk of heart disease!!!")
        print(txt)
      }
      else{
        txt = "All's good! Low Risk :)"
        print(txt)
      }
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  #------THIS PART IS FOR THE SECOND DATASET, BRFSS-------#
  input_df2 <- reactive({
    df <- data.frame(age = as.factor(input$age),
               sex = as.factor(input$sex),
               highchol = as.factor(input$highchol),
               smoker = as.factor(input$smoker),
               stroke = as.factor(input$stroke),
               diabetes = as.factor(input$diabetes),
               genhlth = as.factor(input$genhlth),
               menthlth = as.factor(input$menthlth),
               physhlth = as.factor(input$physhlth),
               income = as.factor(input$income),
               highbp = as.factor(input$highbp)
    )
    setnames(df, "age", "Age")
    setnames(df,"sex", "Sex")
    setnames(df,"highchol", "HighChol")
    setnames(df, "smoker", "Smoker")
    setnames(df,"stroke", "Stroke")
    setnames(df,"diabetes", "Diabetes")
    setnames(df, "genhlth", "GenHlth")
    setnames(df, "menthlth", "MentHlth")
    setnames(df, "physhlth", "PhysHlth")
    setnames(df, "income", "Income")
    setnames(df, "highbp", "HighBP")
    df
  })
  pred2 <- reactive({
    Prob2 <- input_df2()
    tt2 <- as.data.frame(predict(m3,Prob2, type='response'))
    tt2 = tt2[,1]
  })


  output$results2 <- renderPrint({
    if (input$submitbutton2>0) { 
      tt2 <- pred2()
      tt2
    }
    else{
      return ("Server is ready for calculation.")
    }
  })

  output$prob2 <- renderPrint({
    if (input$submitbutton2>0) { 
      tt2 <-pred2()
      tt2 <- as.data.frame(tt2)
      if(tt2[,1] > 0.5){
        txt = ("At risk of heart disease!!!")
        print(txt)
      }
      else{
        txt = "All's good! Low Risk :)"
        print(txt)
      }
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  # Status/Output Text Box
  output$contents2 <- renderPrint({
    if (input$submitbutton2>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  
}

####################################
#        Create the shiny app      #
####################################
shinyApp(ui = ui, server = server)

