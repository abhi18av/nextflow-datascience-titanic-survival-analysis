nextflow.enable.dsl = 2

params.publishDir = 'results'

process GRID_RF {
    publishDir params.publishDir

    input:
    path(train_csv)

    output:
    path("${params.outputFileName}")

    script:
    """
#!/usr/bin/env python3

import pandas as pd
from sklearn.model_selection import train_test_split 
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


data.to_csv("${params.outputFileName}")
    """
}

//================================================================================
// Module test
//================================================================================

workflow test {

    input_data_ch = channel.of("${baseDir}/${params.train_csv}")

    GRID_RF(input_data_ch)

}
