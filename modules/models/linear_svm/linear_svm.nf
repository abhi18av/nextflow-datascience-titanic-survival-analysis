nextflow.enable.dsl = 2

params.publishDir = 'results'
params.publishMode = 'copy'

params.train_X_csv = "train_X.csv"
params.train_Y_csv = "train_Y.csv"
params.test_X_csv = "test_X.csv"
params.test_Y_csv = "test_Y.csv"



process LINEAR_SVM {
    publishDir params.publishDir, mode: params.publishMode

    input:
    tuple path(train_X_csv), path(train_Y_csv), path(test_X_csv), path(test_Y_csv), path(X_csv), path(Y_csv)

    output:
    path("*_metrics.txt")

    script:
    """
#!/usr/bin/env python3

import pandas as pd
from sklearn import svm 
from sklearn import metrics
import warnings
warnings.filterwarnings('ignore')

train_X = pd.read_csv("${train_X_csv}")
train_Y = pd.read_csv("${train_Y_csv}")

test_X = pd.read_csv("${test_X_csv}")
test_Y = pd.read_csv("${test_Y_csv}")

model= svm.SVC(kernel='linear',C=0.1,gamma=0.1)
model.fit(train_X,train_Y)

prediction2= model.predict(test_X)

accuracy = metrics.accuracy_score(prediction2,test_Y)

print('Accuracy for linear SVM is: ', accuracy)

with open("linear_svm_metrics.txt", "w") as metrics_file: 
    metrics_file.write("Accuracy: " + str(accuracy))

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

    LINEAR_SVM(input_data_ch)

}
