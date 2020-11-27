nextflow.enable.dsl = 2

params.publishDir = 'results'
params.publishMode = 'copy'

params.train_X_csv = "train_X.csv"
params.train_Y_csv = "train_Y.csv"
params.test_X_csv = "test_X.csv"
params.test_Y_csv = "test_Y.csv"
params.X_csv = "X.csv"
params.Y_csv = "Y.csv"

process GRID_SVM {
    publishDir params.publishDir, mode: params.publishMode

    input:
    tuple path(train_X_csv), path(train_Y_csv), path(test_X_csv), path(test_Y_csv), path(X_csv), path(Y_csv)

    output:
    path("*_metrics.txt")

    script:
    """
#!/usr/bin/env python3

import pandas as pd
from sklearn import metrics
from sklearn import svm 
from sklearn.model_selection import GridSearchCV
import warnings
warnings.filterwarnings('ignore')

X = pd.read_csv("${X_csv}")
Y = pd.read_csv("${Y_csv}")

C=[0.05,0.1,0.2,0.3,0.25,0.4,0.5,0.6,0.7,0.8,0.9,1]
gamma=[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0]
kernel=['rbf','linear']
hyper={'kernel':kernel,'C':C,'gamma':gamma}
gd=GridSearchCV(estimator=svm.SVC(),param_grid=hyper,verbose=True)
gd.fit(X,Y)

with open("grid_svm_metrics.txt", "w") as metrics_file: 
    metrics_file.write("Best score: " + str(gd.best_score_))
    
    """
}

//================================================================================
// Module test
//================================================================================

workflow test {

    input_data_ch = channel.of(["${baseDir}/${params.train_X_csv}",
                                "${baseDir}/${params.train_Y_csv}",
                                "${baseDir}/${params.test_X_csv}",
                                "${baseDir}/${params.test_Y_csv}",
                                "${baseDir}/${params.X_csv}",
                                "${baseDir}/${params.Y_csv}"
    ])

    GRID_SVM(input_data_ch)

}
