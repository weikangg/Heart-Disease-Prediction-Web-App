install.packages('rsconnect')
library(rsconnect)
rsconnect::setAccountInfo(name='weikang', token='A04975A900526EE9A60201EE0FF8E10E', secret='IdYM81VulwRTi+t3YOYVoa9WATML+sxVYOPQYuXi')
# rsconnect::deployApp("C:/Users/Wei Kang/OneDrive - Nanyang Technological University/Year 2/Sem 1/BC2406 Analytics I/BC2406 Course Materials/Group Project/Codes/MyHealth")
#----------------------------------------------------Importing Libraries-----------------------------------------------------#
list.of.packages <- c("data.table", "shiny", "shinythemes", "RCurl", "tidyverse", "cvms", "caTools", "tibble", "markdown")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(markdown)
library(shiny)
library(shinythemes)
library(data.table)
library(RCurl)
library(tidyverse)
library(cvms)
library(caTools)
library(tibble)
#---------------------------------------------Setting Working Directory------------------------------------------------------#
setwd("C:/Users/Wei Kang/OneDrive - Nanyang Technological University/Year 2/Sem 1/BC2406 Analytics I/BC2406 Course Materials/Group Project/Codes/MyHealth")

#-----------------------------------Importing Trainset,Test Set and desired Model--------------------------------------------#
trainset <-fread("heart_failure_prediction_training.csv", stringsAsFactors = TRUE)
trainset<- trainset[,-1]
trainset$FastingBS <- factor(trainset$FastingBS)
trainset$HeartDisease <- factor(trainset$HeartDisease)

testset <-fread("heart_failure_prediction_test.csv", stringsAsFactors = TRUE)
testset <- testset[,-1]
testset$FastingBS <- factor(testset$FastingBS)
testset$HeartDisease <- factor(testset$HeartDisease)

m1 <- readRDS("model.rds")
threshold1 <-0.5
prob.test <- predict(m1, newdata = testset, type = 'response')
m1.predict.test <- ifelse(prob.test > threshold1, "1", "0")
table2 <- table(Testset.Actual = testset$HeartDisease, m1.predict.test, deparse.level = 2)
table2
cfm2 <- as_tibble(table2)
cfm2
plot_confusion_matrix(cfm2, 
                      target_col = "Testset.Actual", 
                      prediction_col = "m1.predict.test",
                      counts_col = "n",
                      place_x_axis_above = FALSE,
                      add_col_percentages = FALSE,
                      add_row_percentages = FALSE)

# Overall Accuracy
accuracy = mean(m1.predict.test == testset$HeartDisease)
accuracy

#-------------------------------------------------Building the UI------------------------------------------------------------#


####################################
#          User interface          #
####################################
ui <- fluidPage(theme = shinytheme("darkly"),

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

####################################
#               Server             #
####################################

server <- function(input, output, session) {
  
  input_df <- reactive({
    data.frame(Age = as.numeric(input$Age),
               Sex = as.factor(input$Sex),
               ChestPainType = as.factor(input$ChestPainType),
               RestingBP = as.numeric(input$RestingBP),
               Cholesterol = as.numeric(input$Cholesterol),
               FastingBS = as.factor(input$FastingBS),
               RestingECG = as.factor(input$RestingECG),
               MaxHR = as.numeric(input$MaxHR),
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
  
  
}

####################################
#        Create the shiny app      #
####################################
shinyApp(ui = ui, server = server)


