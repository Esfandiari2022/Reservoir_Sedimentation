# Predicting Volume-Height Using Multilayer Perceptron

# Importing Libraries
# install.packages('keras')
library (keras)
library(tensorflow)
# install.packages('mlbench')
library(mlbench)
# install.packages('dplyr')
library(dplyr)
# install.packages('magrittr')
library(magrittr)
# install.packages('neuralnet')
library(neuralnet)
# install.packages('caTools')
library(caTools)

# Importing the Dataset
dataset <- read.csv('volum-height.csv')

# Data Preprocessing

# Data Cleansing
dataset <- dataset[dataset$Year != 2006, ]

# Splitting the Dataset into the Training Set & Test Set
set.seed(123)
split <- sample(3, nrow(dataset), replace = T, prob = c(0.7, 0.1, 0.2))
training_set <- dataset[split == 1, 1:2]
validation_set <- dataset[split == 2, 1:2]
test_set <- dataset[split == 3, 1:2]
trainingtarget <- dataset[split == 1, 3]
validationtarget <- dataset[split == 2, 3]
testtarget <- dataset[split == 3, 3]

# Normalizing
year <- (1983:2041)
m_year <- mean(year)
sd_year <- sd(year)
m <- mean(training_set[, 2])
m_val <- mean(validation_set[, 2])
s_d <- sd(training_set[, 2])
s_d_val <- sd(validation_set[, 2])
training_set[, 1] <- scale(training_set[, 1], center = m_year, scale = sd_year)
training_set[, 2] <- scale(training_set[, 2], center = m, scale = s_d)
training_set <- as.matrix.data.frame(training_set)
validation_set[, 1] <- scale(validation_set[, 1], center = m_year, scale = sd_year)
validation_set[, 2] <- scale(validation_set[, 2], center = m_val, scale = s_d_val)
validation_set <- as.matrix.data.frame(validation_set)
test_set[, 1] <- scale(test_set[, 1], center = m_year, scale = sd_year)
test_set[, 2] <- scale(test_set[, 2], center = m, scale = s_d)
test_set <- as.matrix.data.frame(test_set)

# Creating MLP Model
model <- keras_model_sequential()
model %>%
  
  layer_dense(units = 380, kernel_initializer = 'uniform', activation = "elu", name = "hidden_1", input_shape = c(2)) %>%
  layer_dense(units = 150, kernel_initializer = 'uniform', activation = "relu", name = "hidden_2") %>%
  layer_dense(units = 25, kernel_initializer = 'uniform', activation = "elu", name = "hidden_3") %>%
  layer_dense(units = 1, kernel_initializer = 'normal', name = "predictions")

# Compile
model %>% compile(loss = 'mean_squared_error',
                  optimizer = 'adam',
                  metrics = 'mae')

# Fitting MLP Model
MLP_model <- model %>%
  fit(training_set,
      trainingtarget,
      epochs = 300,
      bach_size = 2,
      validation_data = list(validation_set, validationtarget))

# Evaluating
model %>% evaluate(test_set, testtarget)

# Predicting the Test Set Results
pred <- model %>% predict(test_set)
MSE <- mean((testtarget - pred)^2)
plot(testtarget, pred[, 1])

# R Squared Error Metric
rsquare <- function(y_actual, y_prediction){
  cor(y_actual, y_prediction)^2
}
RSQUARE <- rsquare(testtarget, pred)

# Testing the Model for Another Set of Data for Year 2006

# Importing the Dataset
data_set <- read.csv('volum-height.csv')
data_set <- data_set[data_set$Year != 1983, ]
data_set <- data_set[data_set$Year != 1993, ]
data_set <- data_set[data_set$Year != 2003, ]
data_set <- data_set[data_set$Year != 2010, ]
data_set <- data_set[data_set$Year != 2018, ]

# Splitting Data into Inputs and Output
Inputs <- data_set[, 1:2]
Output <- data_set[, 3]

# Normalizing
Inputs[, 1] <- scale(Inputs[, 1], center = m_year, scale = sd_year)
Inputs[, 2] <- scale(Inputs[, 2], center = m, scale = s_d)
Inputs <- as.matrix.data.frame(Inputs)

# Predicting Elevation For Year 2006 Dataset
predict_data <- model %>% predict(Inputs)

# Error Metrics
mse2006 <- mean((Output - predict_data)^2)
r2_2006 <- rsquare(Output, predict_data)

# Predicting Data For Year 2026
# Creating Data
pred_data <- data_set[, 1:2]
pred_data$Year <- 2026

# Normalizing
norm_data <- matrix(nrow =53 , ncol =  2)
norm_data[, 1] <- scale(pred_data[, 1], center = m_year, scale = sd_year)
norm_data[, 2] <- scale(pred_data[, 2], center = m, scale = s_d)

# Predicting Elevation for Year 2026
sefidrood_pred <- model %>% predict(norm_data)

# Predicting Data For Year 2036
# Creating Data
pred_data36 <- data_set[, 1:2]
pred_data36$Year <- 2036

# Normalizing
norm_data36 <- matrix(nrow =53 , ncol =  2)
norm_data36[, 1] <- scale(pred_data36[, 1], center = m_year, scale = sd_year)
norm_data36[, 2] <- scale(pred_data36[, 2], center = m, scale = s_d)

# Predicting Elevation for Year 2036
sefidrood_pred36 <- model %>% predict(norm_data36)
