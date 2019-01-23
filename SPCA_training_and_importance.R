
library("doParallel")
library("caret")
library("recipes")
registerDoParallel(cores=4)
set.seed(123)

# creating caret object to control training/resampling procedure to estimate out-of-sample performance
trControl <- trainControl(
  method = "repeatedcv", number = 10, repeats = 5,
  classProbs = TRUE,
  summaryFunction = twoClassSummary
)
# making a list of the models we want to train
methods <-  c("wsrf","cforest","rf")

# loading in clinical variables
load("clintum_tx_grade.Rda")
for (numcom in c(5,10,15,25,50)) {
  # Load in the appropriate SPCA components
  load(paste0("spca",numcom,"components.Rda"))
  current <- get(paste0("spca_vals",numcom))
  
  # add the treatment outcome to the frame
  current$outcome <- as.factor(current$outcome)
  levels(current$outcome) <- c("n","y")
  # create a frame with the SPCs, tumor grading, and the outcome
  dataset <- cbind(current,clintum_tx_grade)
  
  # this formula indicates that the "outcome" variable is the classification goal
  fo <- outcome ~ .
  
  # train all methods in sequence for this data, store the results in a list of models fits
  fits <- list()
  for (method in methods) {
    start_time <- Sys.time()
    fits[[method]] <- train(fo, data=dataset,
                            method=method,
                            trControl=trControl,
                            metric="ROC")
    # save the fit object after each classifier
    save(fits,file=paste("model_fits/spca",numcom,"_fits_txgrade_",method,".Rda",sep=""))
    # print run time of the classifier on the current dataset
    print(paste0("Runtime for ",numcom,"SPCs with classification method ",method))
    print(Sys.time()-start_time)
  }
  (varImp(fits$cforest))
  (varImp(fits$rf))
  (varImp(fits$wsrf))
}

# to get AUROC values and error margins as well as other information about the model fit:
load("model_fits/spca50_fits_txgrade_rf.Rda") # modify this line to load the desired "fit" object
# Since the "rf" model was last in the list of methods, the "rf" fits file contains the final 
# "fit" object written to disk, which contains the model fits for all three models.
fits$wsrf
fits$rf
fits$cforest
