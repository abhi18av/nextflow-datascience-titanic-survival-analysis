nextflow.enable.dsl = 2


params.publishDir = 'results'
params.outputFileName = 'train_fe_family.csv'

process PROCESS_FAMILY{
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

data['Family_Size']=0
data['Family_Size']=data['Parch']+data['SibSp'] 
data['Alone']=0
data.loc[data.Family_Size==0,'Alone']=1 

data.to_csv("${params.outputFileName}")

    """
}

//================================================================================
// Module test
//================================================================================

workflow test {

    input_data_ch = channel.of("${baseDir}/${params.train_csv}")

    PROCESS_FAMILY(input_data_ch)

}
