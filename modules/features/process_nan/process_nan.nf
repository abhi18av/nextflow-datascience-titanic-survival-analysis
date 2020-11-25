nextflow.enable.dsl = 2


params.publishDir = 'results'
params.outputFileName = 'train_fe_nan.csv'

process PROCESS_NAN{
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

data['Embarked'].fillna('S',inplace=True)

data.to_csv("${params.outputFileName}", index=False)

    """
}

//================================================================================
// Module test
//================================================================================

workflow test {

    input_data_ch = Channel.of("${baseDir}/${params.train_csv}")

    PROCESS_NAN(input_data_ch)

}
