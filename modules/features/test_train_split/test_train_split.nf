nextflow.enable.dsl = 2

params.publishDir = 'results'

process TEST_TRAIN_SPLIT {
    publishDir params.publishDir

    input:
    path(data_csv)

    output:
    path("*csv")

    script:
    """
#!/usr/bin/env python3

import pandas as pd
from sklearn.model_selection import train_test_split 
import warnings
warnings.filterwarnings('ignore')

data= pd.read_csv("${data_csv}")

train,test=train_test_split(data,test_size=0.3,random_state=0,stratify=data['Survived'])

train_X=train[train.columns[1:]]
train_X.to_csv("train_X.csv")

train_Y=train[train.columns[:1]]
train_Y.to_csv("train_Y.csv")

test_X=test[test.columns[1:]]
test_X.to_csv("test_X.csv")

test_Y=test[test.columns[:1]]
test_Y.to_csv("test_Y.csv")

X=data[data.columns[1:]]
X.to_csv("X.csv")

Y=data['Survived']
Y.to_csv("Y.csv")


    """
}

//================================================================================
// Module test
//================================================================================

workflow test {

    input_data_ch = channel.of("${baseDir}/${params.data_csv}")

    TEST_TRAIN_SPLIT(input_data_ch)

}
