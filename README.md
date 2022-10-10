# Heart-Disease-Prediction-Web-App

### Setup
```
To test on local drive, download the zip file/clone the repo and run the code in main.R, change the wd() accordingly.
```

### Website
```
https://my-healthh.herokuapp.com/
```

### Files
```
- main.R -> Test on Local System
- ui.R -> FrontEnd Design of the Web App
- server.R -> Backend with the logic and the model pre-built
- about.txt -> Documentation and information for about page
- heart_failure_prediction_training.csv -> Training data for the model to fit and predict on with the user's input values
- init.R -> Install required packages
- run.R -> Run the Shiny App and define the small details like ports and host
```

### Business Problem
```
Currently, National Heart Centre Singapore (NHCS) experiences a high wastage of time and resources to run diagnostic tests for 70% <br>
of all referrals from polyclinics who turn out to have no salient cardiac irregularities and did not need to see a specialist.
```

### Solution & Business Opportunity 
```
Patients do not have to make so many unnecessary visits to NHCS and the heart centre can direct its resources and care to patients who require it most. Given that most patients have been established to be going for checkups simply for “peace of mind”, building an app that utilizes Analytics and Machine Learning models with high accuracy in identifying whether an individual has heart disease from certain independent variables would be beneficial for patients. Moreover, this also allows individuals who feel that they are currently healthy to also check on their risk status just in case they have any heart issues that they are unaware of.
```
### Predictor Model
```
Logistic Regression in R, using glm function in R, with a prediction accuracy of **86%-89%**!
```
