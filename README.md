# MachineLearningTCGAHNSC-BINF
Supplementary materials and code for the BMC Bioinformatics journal article "Machine learning with the TCGA-HNSC dataset: Improving performance by addressing inconsistency, sparsity, and high-dimensionality" by authors Michael C. Rendleman, B.S.E.; John M. Buatti, MD; Terry A. Braun, Ph.D.; Brian J. Smith, Ph.D.; Bart Brown; Chibuzo Nwakama; Reinhard Beichel, Ph.D.; Thomas L. Casavant, Ph.D.

To install the necessary dependencies for the R scripts, we supply the ```install_prereqs.R``` script.
Any questions about this analysis or the manuscript can be sent to michael-rendleman@uiowa.edu.

# Supplied Data

## Clinical Data
Preprocessed pre-imputation and post-imputation datasets are provided in .arff format (WEKA's attribute-relation file format) in ```clinical_NO_imp.arff``` and ```clinical_rf_imp.arff```, respectively. Importance values for these datasets are provided in ```raw_importance_noimp.csv``` and ```raw_importance_rfimp.csv```.

Tumor grading variables and corresponding patient outcomes are stored in ```clintum_tx_grade.Rda``` for convenience of use in R-based SPCA experiments. Only the 520 patients with tumor expression data are included in this data frame.

## Raw Solid-Tumor RNA Expression Data and Transformations
RNA expression data for the 520 patients (alongside tumor grading and treatment information) is supplied in ```rnatum_tx_grade_surv.Rda```. 

Transformations of RNA expression data via SPCA can be found in ```spcaXXcomponents.Rda```, where XX is the number of components. These data were transformed from the ```rnatum_tx_grade_surv.Rda``` data using the ```SPCA_generation.r``` script.



# Experiments

## Treatment variable imputation experiments
Classifier training on pre- and post-imputation data can be done in WEKA as described in our manuscript: https://pubmed.ncbi.nlm.nih.gov/31208324/

Importance values for these variables can be calculated with ```CIRF_importance.r```, though the raw (pre_averaged) results can be examined in the ```raw_importance_noimp.csv``` and ```raw_importance_rfimp.csv``` files.

## Full RNA training
Classifier training on the full set of solid-tumor RNA expression data can be replicated with the ```Full_RNA_training.R``` script. The models from this script are not supplied, as they can be quite large (on the order of hundreds of MB to GB). This script requires a high-performance computing environment, and we recommend no less than 100 GB of memory to ensure training will complete.

## SPCA transformation of RNA: training, importance, and timing
Training of classifiers, calculations of variable importance, and training timing for the SPCA-transformed data can be performed using the ```SPCA_training_and_importance.R``` script, though the resulting models are also available in the ```model_fits/``` directory. 

## Gene Ontology Enrichment Analysis
SPC gene weights can be obtained from the ```SPCA_generation.r``` file. For our analysis, genes with absolute weight greater than 0.1 are considered contributors. 
After obtaining the genes comprising the SPC under consideration, GOEA can be performed here: http://geneontology.org/page/go-enrichment-analysis


