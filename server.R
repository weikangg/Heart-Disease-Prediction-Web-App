library(data.table)

m1 <- readRDS("model.rds")


shinyServer(function(input, output, session) {
  
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
})