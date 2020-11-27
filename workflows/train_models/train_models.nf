nextflow.enable.dsl = 2

//================================================================================
// Global params
//================================================================================

params.MODELS_DIR = "$baseDir/models/"


//================================================================================
// Include the modules
//================================================================================


params.LINEAR_SVM = [
        publishDir: params.MODELS_DIR
]
include { LINEAR_SVM } from "../../modules/models/linear_svm/linear_svm.nf" addParams(params.LINEAR_SVM)


params.GRID_SVM = [
        publishDir: params.MODELS_DIR
]
include { GRID_SVM } from "../../modules/models/grid_svm/grid_svm.nf" addParams(params.GRID_SVM)

//================================================================================
// Main workflow
//================================================================================

workflow TRAIN_MODELS {
    take:
    train_test_data

    main:
    LINEAR_SVM(train_test_data)
    GRID_SVM(train_test_data)

}


//================================================================================
// Module test
//================================================================================

workflow test {

    input_data_ch = channel.of(["${baseDir}/${params.train_X_csv}",
                                "${baseDir}/${params.train_Y_csv}",
                                "${baseDir}/${params.test_X_csv}",
                                "${baseDir}/${params.test_Y_csv}",
                                "${baseDir}/${params.X_csv}",
                                "${baseDir}/${params.Y_csv}"
    ])

    TRAIN_MODELS(input_data_ch)

}
