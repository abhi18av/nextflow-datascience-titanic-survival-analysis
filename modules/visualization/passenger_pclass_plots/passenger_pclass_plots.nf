nextflow.enable.dsl = 2

params.publishDir = 'results'

process PASSENGER_PCLASS_PLOTS {
    publishDir params.publishDir

    input:
    tuple path(train_csv), path(test_csv)

    output:
    path('*.png')

    script:
    """
#!/usr/bin/env python3

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

plt.style.use('fivethirtyeight')
import warnings

warnings.filterwarnings('ignore')

data = pd.read_csv('train.csv')

f, ax = plt.subplots(1, 2, figsize=(18, 8))
data['Pclass'].value_counts().plot.bar(color=['#CD7F32', '#FFDF00', '#D3D3D3'], ax=ax[0])
ax[0].set_title('Number Of Passengers By Pclass')
ax[0].set_ylabel('Count')
sns.countplot('Pclass', hue='Survived', data=data, ax=ax[1])
ax[1].set_title('Pclass:Survived vs Dead')
# plt.show()

plt.savefig('passenger_pclass_plots.png')
    
    """
}

//================================================================================
// Module test
//================================================================================

workflow test {

    input_data_ch = Channel.of(["${baseDir}/${params.train_csv}",
                                "${baseDir}/${params.test_csv}"])

    PASSENGER_PCLASS_PLOTS(input_data_ch)

}
