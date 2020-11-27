nextflow.enable.dsl = 2

params.publishDir = 'results'

process GRID_RF {
    publishDir params.publishDir

    input:
    path(train_csv)

    output:
    path("*.csv")

    script:
    """
#!/usr/bin/env python3

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
plt.style.use('fivethirtyeight')
import warnings
warnings.filterwarnings('ignore')

data= pd.read_csv("${train_csv}")

train,test=train_test_split(data,test_size=0.3,random_state=0,stratify=data['Survived'])
train_X=train[train.columns[1:]]
train_Y=train[train.columns[:1]]
test_X=test[test.columns[1:]]
test_Y=test[test.columns[:1]]
X=data[data.columns[1:]]
Y=data['Survived']


train_X.to_csv("train_X.csv")
train_Y.to_csv("train_Y.csv")

test_X.to_csv("test_X.csv")
test_Y.to_csv("test_Y.csv")

model=svm.SVC(kernel='linear',C=0.1,gamma=0.1)
model.fit(train_X,train_Y)
prediction2=model.predict(test_X)
print('Accuracy for linear SVM is',metrics.accuracy_score(prediction2,test_Y))

    """
}

//================================================================================
// Module test
//================================================================================

workflow test {

    input_data_ch = channel.of("${baseDir}/${params.train_csv}")

    GRID_RF(input_data_ch)

}