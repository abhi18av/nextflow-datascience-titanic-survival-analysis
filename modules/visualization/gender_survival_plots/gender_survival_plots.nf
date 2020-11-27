nextflow.enable.dsl = 2


params.publishDir = 'results'

process GENDER_SURVIVAL_PLOTS {
    publishDir params.publishDir

    input:
    tuple path(train_csv), path(test_csv)

    output:
    path('*.png')

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

data= pd.read_csv('train.csv')

f,ax=plt.subplots(1,2,figsize=(18,8))
data[['Sex','Survived']].groupby(['Sex']).mean().plot.bar(ax=ax[0])
ax[0].set_title('Survived vs Sex')
sns.countplot('Sex',hue='Survived',data=data,ax=ax[1])
ax[1].set_title('Sex:Survived vs Dead')

#plt.show()

plt.savefig('gender_survival_plots.png')
    """
}

//================================================================================
// Module test
//================================================================================

workflow test {

    input_data_ch = Channel.of(["${baseDir}/${params.train_csv}",
                                "${baseDir}/${params.test_csv}"])

    GENDER_SURVIVAL_PLOTS(input_data_ch)

}
