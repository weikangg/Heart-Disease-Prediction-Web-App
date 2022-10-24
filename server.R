library(data.table)

m1 <- readRDS("model.rds")
m3 <- readRDS("model3.rds")

shinyServer(function(input, output, session) {
  
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
})