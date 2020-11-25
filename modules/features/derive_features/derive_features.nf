nextflow.enable.dsl = 2


params.publishDir = 'results'
params.outputFileName = 'train_fe_derived.csv'

process DERIVE_FEATURES {
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

data['Initial']=0
for i in data:
    data['Initial']=data.Name.str.extract('([A-Za-z]+)\\.') #lets extract the Salutations

data['Initial'].replace(['Mlle','Mme','Ms','Dr','Major','Lady','Countess','Jonkheer','Col','Rev','Capt','Sir','Don'],['Miss','Miss','Miss','Mr','Mr','Mrs','Mrs','Other','Other','Other','Mr','Mr','Mr'],inplace=True)

data.to_csv("${params.outputFileName}", index=False)

    """
}

//================================================================================
// Module test
//================================================================================

workflow test {

    input_data_ch = channel.of("${baseDir}/${params.train_csv}")

    DERIVE_FEATURES(input_data_ch)
}
