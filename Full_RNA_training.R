# NOTE: This script will perform best in a high-performance computing setting, as building RF models with 520 instances of >20,000 variables requires a lot of memory. I cannot guarantee it will complete with standard amounts of RAM (I recommend at least 100 GB).
# Additionally, you will need to run it from the command line with --max-ppsize set to at least 100000, or else R will not like loading the large dataset. This means this script in particular cannot be executed in IDEs that don't allow you to set command line arguments such as RStudio.

library("doParallel")
library("caret")
library("recipes")
# You can specify your number of cores here, though >8 cores is not recommended (only negligible gains are made by increasing the parallelization further).
registerDoParallel(cores=8)
set.seed("46290")

# Load the RNA data, do some simple pre-processing, and define the formula for training
load("rnatum_tx_grade_surv.Rda")
rna_tx_surv_tum$X2yr.RF.Surv. <- as.factor(rna_tx_surv_tum$X2yr.RF.Surv.)
levels(rna_tx_surv_tum$X2yr.RF.Surv.) <- c("n","y")
fo <- X2yr.RF.Surv. ~ .

# The classification methods to try (I recommend running one at a time)
#methods <- c("rf","wsrf","cforest")
methods <- c("rf")
# caret training control object
trControlCV <- trainControl(
	method = "cv", number = 10,
	classProbs = TRUE,
	summaryFunction = twoClassSummary
)
# Recipes pre-processing recipe, which removes variables with near-zero variance (NZV), variables with high-correlation, and ensures that there are no missing values in the data at each iteration of cross-validation
(traindata_rec <- recipe(fo,data = rna_tx_surv_tum) %>%
    step_nzv(all_predictors()) %>%
    step_corr(all_numeric(), threshold = 0.9) %>%
    check_missing(all_predictors()) %>%
    check_missing(all_outcomes()))

# loop through the classification methods, training models, printing the results to stdout, and saving the models as we go (saves progress not lost if we run out of memory)
fits <- list()
for(method in methods) {
	# The hyperparameter values you'd like to evaluate can be set on the next line with the "tuneGrid" argument, though multiple runs may need to be done depending on the computational resources available
	args <- c(list(traindata_rec,data=rna_tx_surv_tum,method=method,trControl=trControlCV,metric="ROC", tuneGrid=data.frame("mtry"=c(2,4,5,8))))#,100,140))))
	fits[[method]] <- do.call(train, args) 
	save(fits,file=paste0("fits_",method,"_txgrade_tuning.Rda"))
	gc()
	fits
}
