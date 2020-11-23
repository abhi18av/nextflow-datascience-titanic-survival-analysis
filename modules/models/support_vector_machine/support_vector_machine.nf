nextflow.enable.dsl = 2

params.publishDir = 'results'

process MODELS_LOGISTIC_REGRESSION {
    publishDir params.publishDir

    input:
    tuple path(train_csv), path(test_csv)

    output:
    path('*.png')

    script:
    """
#!/usr/bin/env python3

from sklearn.linear_model import LogisticRegression 
from sklearn.model_selection import train_test_split 
from sklearn import metrics 
from sklearn.metrics import confusion_matrix 

import numpy as np
import pandas as pd
import warnings
warnings.filterwarnings('ignore')

data= pd.read_csv('train.csv')

f,ax=plt.subplots(1,2,figsize=(18,8))
data['Survived'].value_counts().plot.pie(explode=[0,0.1],autopct='%1.1f%%',ax=ax[0],shadow=True)
ax[0].set_title('Survived')
ax[0].set_ylabel('')
sns.countplot('Survived',data=data,ax=ax[1])
ax[1].set_title('Survived')
#plt.show()

plt.savefig('survival_plots.png')
    """
}

//================================================================================
// Module test
//================================================================================

workflow test {

    input_data_ch = Channel.of(["${baseDir}/${params.train_csv}",
                                "${baseDir}/${params.test_csv}"])

    MODELS_LOGISTIC_REGRESSION(input_data_ch)

}
