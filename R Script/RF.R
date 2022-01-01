# Predicting Sedimentation 3D Pattern Using Random Forest Regression

# Importing Libraries
# install.packages('randomForest')
library(randomForest)

# Importing the Dataset
dataset <- read.csv('Data (long and cross).csv')

# Data Preprocessing

# Data Cleansing
dataset <- dataset[dataset$Z != -9999, ]
dataset <- dataset[dataset$Year != 2006, ]

# Splitting the Dataset into the Training Set & Test Set
set.seed(1234)
split <- sample(2, nrow(dataset), replace = T, prob = c(0.8, 0.2))
training_set <- dataset[split == 1, ]
test_set <- dataset[split == 2, ]


# Fitting Random Forest Regression to the Data Set
regressor <- randomForest(Z ~ ., data = training_set, ntree = 68)
regressor
plot(x = 1:68, regressor$mse)
which.min(regressor$mse)
# Predicting the Test Set Result
pred_test <- predict(regressor, test_set[, 1:3])
plot(test_set$Z, pred_test)

# Error Metrics
MSE <- mean((test_set[, 4] - pred_test)^2)
rsquare <- function(y_actual, y_prediction){
  cor(y_actual, y_prediction)^2
}
RSQUARE <- rsquare(test_set[, 4], pred_test)

# Testing the Model for Another Set of Data for Year 2006

# Importing the Dataset
data_set <- read.csv('Data (long and cross).csv')
data_set <- data_set[data_set$Z != -9999, ]
data_set <- data_set[data_set$Year != 2003, ]
data_set <- data_set[data_set$Year != 2010, ]
data_set <- data_set[data_set$Year != 2018, ]
data_set <- data_set[!duplicated(data_set$X), ]

# Splitting Data into Inputs and Output
Inputs <- data_set[, 1:3]
Output <- data_set[, 4]

# Predicting Elevation For  Year 2006 Dataset
predict_data <- predict(regressor, Inputs)

# Error Metrics
mse <- mean((Output - predict_data)^2)
r2 <- rsquare(Output, predict_data)

# Predicting For Year 2026
pred_data <- Inputs[, 1:3]
pred_data$Year <- 2026
y_pred <- predict(regressor, pred_data)

# Predicting For Year 2036
pred_data36 <- Inputs[, 1:3]
pred_data36$Year <- 2036
y_pred36 <- predict(regressor, pred_data36)

# 3D Plotting
# install.packages('plot3D')
# install.packages('plot3Drgl')
library(plot3D)
library(rgl)
library(plot3Drgl)

# X, Y and Z Coordinates
x <- pred_data$X
y <- pred_data$Y
z <- y_pred

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
plot2036 <- plot3d(x = pred_data36$X, y = pred_data36$Y, z = y_pred36, col = col)
plot2003 <- plot3d(x = data_set$X, y = data_set$Y, z = predict_data, col = col)