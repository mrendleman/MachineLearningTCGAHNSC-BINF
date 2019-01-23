library('foreign')
library('party')

noimp = read.arff("data_arffs/no_imputation_20171101.arff")
rfimp = read.arff("data_arffs/rf_imputation_20171101.arff")

i <- 0

num_trees = 50
runs = 50

while (i < runs) {
	i = i+1;
	cf1 = cforest(RF_surv~.,data=noimp,control=cforest_unbiased(ntree=num_trees))
	cf2 = cforest(RF_surv~.,data=rfimp,control=cforest_unbiased(ntree=num_trees))
	
	cat("Calculating importance for run %d...\n",i)

	imp_no=varimp(cf1,conditional=TRUE)
	imp_rf=varimp(cf2,conditional=TRUE)

	if (i == 1) {
		imp_no_frame = data.frame(imp_no)
		imp_rf_frame = data.frame(imp_rf)
	} else {
		imp_no_frame[sprintf("imp%d",i)] = imp_no
		imp_rf_frame[sprintf("imp%d",i)] = imp_rf
	}
}

write.csv(imp_no_frame,"raw_importance_noimp.csv")
write.csv(imp_rf_frame,"raw_importance_rfimp.csv")
