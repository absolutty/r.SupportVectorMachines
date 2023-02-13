#Social_Network_Ads.csv stiahnute zo stranky:
#- https://www.kaggle.com/datasets/rakeshrau/social-network-ads
data <- read.csv('src/resources/Social_Network_Ads.csv')
data <- data[3:5]

str(data)
 # data.frame:	400 obs. of  3 variables:
 # $ Age            : int  19 35 26 27 19 27 27 32 25 35 ...
 # $ EstimatedSalary: int  19000 20000 43000 57000 65000 ...
 # $ Purchased      : int  0 0 0 0 0 0 0 1 0 0 ...

summary(data)
 #      Age        EstimatedSalary    Purchased
 # Min.   :18.00   Min.   : 15000   Min.   :0.0000
 # 1st Qu.:29.75   1st Qu.: 43000   1st Qu.:0.0000
 # Median :37.00   Median : 70000   Median :0.0000
 # Mean   :37.66   Mean   : 69743   Mean   :0.3575
 # 3rd Qu.:46.00   3rd Qu.: 88000   3rd Qu.:1.0000
 # Max.   :60.00   Max.   :150000   Max.   :1.0000

# encodovanie purchased ako faktor
data$Purchased <- factor(data$Purchased, levels = c(0, 1))
summary(data)
 #      Age        EstimatedSalary  Purchased
 # Min.   :18.00   Min.   : 15000   0:257
 # 1st Qu.:29.75   1st Qu.: 43000   1:143
 # Median :37.00   Median : 70000
 # Mean   :37.66   Mean   : 69743
 # 3rd Qu.:46.00   3rd Qu.: 88000
 # Max.   :60.00   Max.   :150000

# ak nie je caTools este nainstalovane, tak:
#   packageurl <- "https://cran.r-project.org/src/contrib/caTools_1.18.2.tar.gz"
#   install.packages(packageurl, repos=NULL, type="source")

library(caTools)
set.seed(123)
#data sa rozdelia do dvoch mnozin: 75% train, 25% test
split <- sample.split(data$Purchased, SplitRatio = 0.75)
train <- subset(data, split == TRUE)
test <- subset(data, split == FALSE)

#pouzitie scale(): kvoli premennym, kt. nemaju rovnake jednotky
train[-3] <- scale(train[-3])
test[-3] <- scale(test[-3])

# ak nie je ElemStatLearn este nainstalovane, tak:
#   packageurl <- "https://cran.r-project.org/src/contrib/Archive/ElemStatLearn/ElemStatLearn_2015.6.26.2.tar.gz"
#   install.packages(packageurl, repos=NULL, type="source")
set_visualisation <- function(set, name, classifier) {
  library(ElemStatLearn)
  # this section creates the background region red/green. It does that by the 'by' which you can think of as the steps in python, so each 0.01 is interpreted as 0 or 1 and is either green or red. The -1 and +1 give us the space around the edges so the dots are not jammed
  X1 = seq(min(set[, 1]) - 1, max(set[, 1]) + 1, by = 0.01)
  X2 = seq(min(set[, 2]) - 1, max(set[, 2]) + 1, by = 0.01)
  grid_set = expand.grid(X1, X2)
  # just giving a name to the X and Y
  colnames(grid_set) = c('Age', 'EstimatedSalary')
  # this is the MAGIC of the background coloring
  # here we use the classifier to predict the result of each of each of the pixel bits noted above
  y_gridL = predict(classifier, newdata = grid_set)
  # that's the end of the background
  # now we plat the actual data
  plot(set[, -3],
       main = name,
       xlab = 'Age', ylab = 'Estimated Salary',
       xlim = range(X1), ylim = range(X2)) # this bit creates the limits to the values plotted this is also a part of the MAGIC as it creates the line between green and red
  contour(X1, X2, matrix(as.numeric(y_gridL), length(X1), length(X2)), add = TRUE)
  # here we run through all the y_pred data and use ifelse to color the dots
  # note the dots are the real data, the background is the pixel by pixel determination of y/n
  # graph the dots on top of the background give you the image
  points(grid_set, pch = '.', col = ifelse(y_gridL == 1, 'springgreen3', 'tomato'))
  points(set, pch = 21, bg = ifelse(set[, 3] == 1, 'green4', 'red3'))
}

# install.packages('e1071')
library(e1071)

#################################LINEAR SVM##########################################
#pouzitie kernela: 'linear'
#type: 'C-classification', pretoze chceme pouzit regresnu klasifikaciu
classifierLinear <- svm(formula = Purchased ~ .,
                        data = train,
                        type = 'C-classification',
                        kernel = 'linear')

linearPrediction <- predict(classifierLinear, newdata = test[-3])

linearCMR <- table(test[, 3], linearPrediction)
library(caret)

sensitivity(linearCMR) #0.8142857
specificity(linearCMR) #0.7666667
linearCMR

#TRAIN SET VISUALISATION
set_visualisation(train, 'SVM Linear Kernel (Train set)', classifierLinear)
#TRAIN SET VISUALISATION
set_visualisation(test, 'SVM Linear Kernel (Test set)', classifierLinear)

#################################RADIAL SVM##########################################
#pouzitie kernela: 'radial'
#type: 'C-classification', pretoze chceme pouzit regresnu klasigikaciu
classifierRadial <- svm(formula = Purchased ~ .,
                        data = train,
                        type = 'C-classification',
                        kernel = 'radial')

radialPrediction <- predict(classifierRadial, newdata = test[-3])

radialCMR <- table(test[, 3], radialPrediction)

sensitivity(radialCMR)#0.9354839
specificity(radialCMR)#0.8421053
radialCMR

#TRAIN SET VISUALISATION
set_visualisation(train, 'SVM Radial Kernel (Train set)', classifierRadial)
#TRAIN SET VISUALISATION
set_visualisation(test, 'SVM Radial Kernel (Test set)', classifierRadial)
