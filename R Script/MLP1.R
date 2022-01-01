# Predicting Sedimentation Volume Using Multilayer Perceptron

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
dataset <- read.csv('100mcross.csv')

# Data Preprocessing

# Data Cleansing
dataset <- dataset[dataset$Z != -9999, ]
dataset <- dataset[dataset$Year != 2006, ]

# Splitting the Dataset into the Training Set & Test Set
set.seed(123)
split <- sample(3, nrow(dataset), replace = T, prob = c(0.7, 0.15, 0.15))
training_set <- dataset[split == 1, 1:3]
validation_set <- dataset[split == 2, 1:3]
test_set <- dataset[split == 3, 1:3]
trainingtarget <- dataset[split == 1, 4]
validationtarget <- dataset[split == 2, 4]
testtarget <- dataset[split == 3, 4]

# Normalizing
year <- (1983:2041)
m_year <- mean(year)
sd_year <- sd(year)
m <- colMeans(training_set[, 2:3])
m_val <- colMeans(validation_set[, 2:3])
s_d <- apply(training_set[, 2:3], 2, sd)
s_d_val <- apply(validation_set[, 2:3], 2, sd)
training_set[, 2:3] <- scale(training_set[, 2:3], center = m, scale = s_d)
training_set[, 1] <- scale(training_set[, 1], center = m_year, scale = sd_year)
training_set <- as.matrix.data.frame(training_set)
validation_set[, 2:3] <- scale(validation_set[, 2:3], center = m_val, scale = s_d_val)
validation_set[, 1] <- scale(validation_set[, 1], center = m_year, scale = sd_year)
validation_set <- as.matrix.data.frame(validation_set)
test_set[, 2:3] <- scale(test_set[, 2:3], center = m, scale = s_d)
test_set[, 1] <- scale(test_set[, 1], center = m_year, scale = sd_year)
test_set <- as.matrix.data.frame(test_set)

# Creating MLP Model
model <- keras_model_sequential()
model %>%
  layer_dense(units = 25, kernel_initializer = 'uniform', activation = "relu", name = "hidden_1", input_shape = c(3)) %>%
  layer_dense(units = 25, kernel_initializer = 'uniform', activation = "sigmoid", name = "hidden_2") %>%
  layer_dense(units = 1, kernel_initializer = 'normal', name = "predictions")

# Compile
model %>% compile(loss = 'mean_squared_error',
                  optimizer = 'adam',
                  metrics = 'mae')

# Fitting MLP Model
MLP_model <- model %>%
  fit(training_set,
      trainingtarget,
      epochs = 150,
      bach_size = 50,
      validation_data = list(validation_set, validationtarget))

# Evaluating
model %>% evaluate(test_set, testtarget)

# Predicting the Test Set Results
pred <- model %>% predict(test_set)
MSE <- mean((testtarget - pred)^2)

# R Squared Error Metric
rsquare <- function(y_actual, y_prediction){
  cor(y_actual, y_prediction)^2
}
RSQUARE <- rsquare(testtarget, pred)

# Testing the Model for Another Set of Data for Year 2006

# Importing the Dataset
data_set <- read.csv('100mcross.csv')
data_set <- data_set[data_set$Z != -9999, ]
data_set <- data_set[data_set$Year != 2003, ]
data_set <- data_set[data_set$Year != 2010, ]
data_set <- data_set[data_set$Year != 2018, ]
data_set <- data_set[!duplicated(data_set$X), ]

# Splitting Data into Inputs and Output
Inputs <- data_set[, 1:3]
Output <- data_set[, 4]

# Normalizing
Inputs[, 1] <- scale(Inputs[, 1], center = m_year, scale = sd_year)
Inputs[, 2:3] <- scale(Inputs[, 2:3], center = m, scale = s_d)
Inputs <- as.matrix.data.frame(Inputs)

# Predicting Elevation For Year 2006 Dataset
predict_data <- model %>% predict(Inputs)

# Error Metrics
mse_shahrud <- mean((Output - predict_data)^2)
r2_shahrud <- rsquare(Output, predict_data)

# Predicting Data For Year 2026
# Creating Data
pred_data <- dataset[, 1:3]
pred_data <- pred_data[!duplicated(pred_data$X), ]
pred_data$Year <- 2026

# Normalizing
norm_data <- matrix(nrow =7243 , ncol =  3)
norm_data[, 1] <- scale(pred_data[, 1], center = m_year, scale = sd_year)
norm_data[, 2:3] <- scale(pred_data[, 2:3], center = m, scale = s_d)

# Predicting Elevation for Year 2026
sefidrood_pred <- model %>% predict(norm_data)

# Predicting Data For Year 2036
# Creating Data
pred_data36 <- dataset[, 1:3]
pred_data36 <- pred_data36[!duplicated(pred_data36$X), ]
pred_data36$Year <- 2036

# Normalizing
norm_data36 <- matrix(nrow =7243 , ncol =  3)
norm_data36[, 1] <- scale(pred_data36[, 1], center = m_year, scale = sd_year)
norm_data36[, 2:3] <- scale(pred_data36[, 2:3], center = m, scale = s_d)

# Predicting Elevation for Year 2036
sefidrood_pred36 <- model %>% predict(norm_data36)

# 3D Plotting
# install.packages('plot3D')
# install.packages('plot3Drgl')
library(plot3D)
library(rgl)
library(plot3Drgl)

# X, Y and Z Coordinates
x <- pred_data$X
y <- pred_data$Y
z <- sefidrood_pred

# 3D Plot
scatter3D(x, y, z,
          colvar = z,
          col = ramp.col(c('white', 'royalblue3', 'forestgreen', 'orangered4', 'burlywood4')),
          phi = 90, theta = 5,
          clab = c('Elevation (m)'),
          bty = 'n',
          expand =0)
myColorRamp <- function(colors, values) {
  v <- (values - min(values))/diff(range(values))
  x <- colorRamp(colors)(v)
  rgb(x[,1], x[,2], x[,3], maxColorValue = 400)
}
col <- myColorRamp(c('white', 'royalblue3', 'forestgreen', 'orangered4', 'burlywood4'), z)
plot2026 <- plot3d(x = x, y = y, z = z, col = col)
plot3d(x = (355958.410:356304.500), y = c(4069214.1180:4069408.430), z = (210:290), 
       col = "lightcoral", add = T)
plot2036 <- plot3d(x = pred_data36$X, y = pred_data36$Y, z = sefidrood_pred36, col = col)
plot3d(x = (355958.410:356304.500), y = c(4069214.1180:4069408.430), z = (210:290), 
       col = "lightcoral", add = T)
plot2003 <- plot3d(x = data_set$X, y = data_set$Y, z = predict_data, col = col)
