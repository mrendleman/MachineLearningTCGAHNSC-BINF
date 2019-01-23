# This script is concerned with calcuating Sparse Principal Components,
# examining their explained variances, and 

library(dplyr)
library(elasticnet)
load("rnatum_tx_grade_surv.Rda")

# selecting only the columns with RNA variables
rnaData <- rna_tx_surv_tum %>% select(1:20531)

# a function to take a sparse PCA object and process it into a useful dataframe
frameSPCs <- function(sp,rna,full) {
  u <- sp$loadings
  spc <- data.matrix(rna) %*% u
  outcome <- rna_tx_surv_tum$X2yr.RF.Surv.
  spca_frame <- data.frame(spc,outcome)
  rownames(spca_frame) <- rownames(rna)
  spca_frame$outcome <- as.factor(spca_frame$outcome)
  spca_frame
}

sparse5 <- arrayspc(rnaData,K=5,para=c(175,125,100,64,50))
spca_vals5 <- frameSPCs(sparse5,rnaData,rna_tx_surv_tum)
save(spca_vals5,file="spca5components.Rda")

sparse10 <- arrayspc(rnaData,K=10,para=c(175,125,100,64,50,38,21,15,10,5))
spca_vals10 <- frameSPCs(sparse10,rnaData,rna_tx_surv_tum)
save(spca_vals10,file="spca10components.Rda")

sparse15 <- arrayspc(rnaData,K=15,para=c(175,125,100,64,50,38,21,15,10,5,3,2,1,0.25,0.125))
spca_vals15 <- frameSPCs(sparse15,rnaData,rna_tx_surv_tum)
save(spca_vals15,file="spca15components.Rda")

sparse25 <- arrayspc(rnaData,K=25,para=c(175,125,100,64,50,38,21,15,10,5,3,2,1,0.25,0.125,
                                         0.1,0.08,0.06,0.04,0.035,0.028,0.023,0.02,0.015,0.01))
spca_vals25 <- frameSPCs(sparse25,rnaData,rna_tx_surv_tum)
save(spca_vals25,file="spca25components.Rda")

sparse50 <- arrayspc(rnaData,K=50,para=c(seq(175,115,-10),seq(100,70,-5),64,60,55,seq(50,18,-4),
                                         seq(15,3,-3),seq(2,0.5,-0.25),0.25,0.125,0.1,0.08,0.06,
                                         0.04,0.035,0.028,0.023,0.02,0.015,0.01))
spca_vals50 <- frameSPCs(sparse50,rnaData,rna_tx_surv_tum)
save(spca_vals50,file="spca50components.Rda")

# to obtain explained variances
sum(sparse5$pev)
sum(sparse10$pev)
sum(sparse15$pev)
sum(sparse25$pev)
sum(sparse50$pev)

# to examine non-zero loadings for a specific SPC:
X4loads <- sparse10$loadings[,4]
X4loads[which(abs(X4loads) >0.1)]