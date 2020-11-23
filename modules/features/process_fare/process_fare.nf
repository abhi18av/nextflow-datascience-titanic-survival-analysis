nextflow.enable.dsl = 2

params.publishDir = 'results'
params.outputFileName = 'train_fe_family.csv'

process PROCESS_FARE{
    publishDir params.publishDir

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

data['Fare_Range']=pd.qcut(data['Fare'],4)

data['Fare_cat']=0
data.loc[data['Fare']<=7.91,'Fare_cat']=0
data.loc[(data['Fare']>7.91)&(data['Fare']<=14.454),'Fare_cat']=1
data.loc[(data['Fare']>14.454)&(data['Fare']<=31),'Fare_cat']=2
data.loc[(data['Fare']>31)&(data['Fare']<=513),'Fare_cat']=3

data.to_csv("${params.outputFileName}")
    """
}

//================================================================================
// Module test
//================================================================================

workflow test {


    input_data_ch = channel.of("${baseDir}/${params.train_csv}")

    PROCESS_FARE(input_data_ch)
}
