nextflow.enable.dsl = 2


params.publishDir = 'results'
params.publishMode = 'copy'
params.outputFileName = 'train_fe_replaced.csv'

process REPLACE_FEATURES{
    publishDir params.publishDir, mode: params.publishMode

    input:
    path(train_csv)

    output:
    path("${params.outputFileName}")

    script:
    """
#!/usr/bin/env python3

import pandas as pd
import warnings
warnings.filterwarnings('ignore')

data= pd.read_csv("${train_csv}")

data['Sex'].replace(['male','female'],[0,1],inplace=True)
data['Embarked'].replace(['S','C','Q'],[0,1,2],inplace=True)
data['Initial'].replace(['Mr','Mrs','Miss','Master','Other'],[0,1,2,3,4],inplace=True)

data.drop(['Name','Age','Ticket','Fare','Cabin','Fare_Range','PassengerId'],axis=1,inplace=True)

data.to_csv("${params.outputFileName}", index=False)
    """
}

//================================================================================
// Module test
//================================================================================

workflow test {

    input_data_ch = channel.of("${baseDir}/${params.train_csv}")

    REPLACE_FEATURES(input_data_ch)
}
