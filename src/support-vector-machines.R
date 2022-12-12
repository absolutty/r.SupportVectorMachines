set.seed(10111) #setting random seed 

#matrix X, normally distributed with 20 observations in 2 classes on 2 variables
#[1:20, 1:2]
x <- matrix(rnorm(40), 20, 2)

#variable Y, it's either -1 or 1 with 10 in each class
y <- rep(c(-1, 1), c(10, 10)) #matrix Y, size 1x20
x[y == 1,] = x[y == 1,] + 1
plot(x, col = y + 3, pch = 19)

install.packages("e1071")
library(e1071)

# DF is being unpacked into two columns (X1, X2)
dat <- data.frame(x, y = as.factor(y))#making DF, turns Y into factor varable
# kernel is "linear" and tune-in parameter cost is 10
svmfit <- svm(y ~ ., data = dat, kernel = "linear", cost = 10, scale = FALSE)

plot(svmfit, dat)

make.grid = function(x, n = 75) {
  grange = apply(x, 2, range)
  x1 = seq(from = grange[1,1], to = grange[2,1], length = n)
  x2 = seq(from = grange[1,2], to = grange[2,2], length = n)
  expand.grid(X1 = x1, X2 = x2)
}

xgrid = make.grid(x)
xgrid[1:10,]

ygrid = predict(svmfit, xgrid)
plot(xgrid, col = c("red","blue")[as.numeric(ygrid)], pch = 20, cex = .2)
points(x, col = y + 3, pch = 19)
points(x[svmfit$index,], pch = 5, cex = 2)

beta = drop(t(svmfit$coefs)%*%x[svmfit$index,])
beta0 = svmfit$rho

plot(xgrid, col = c("red", "blue")[as.numeric(ygrid)], pch = 20, cex = .2)
points(x, col = y + 3, pch = 19)
points(x[svmfit$index,], pch = 5, cex = 2)
abline(beta0 / beta[2], -beta[1] / beta[2])
abline((beta0 - 1) / beta[2], -beta[1] / beta[2], lty = 2)
abline((beta0 + 1) / beta[2], -beta[1] / beta[2], lty = 2)