nextflow.enable.dsl = 2

params.FEATURE_ENGINEERING_RESULTS_DIR = "../../data/processed"


params.FEATURE_ENGINEERING = [
        publishDir: params.FEATURE_ENGINEERING_RESULTS_DIR
]
include { FEATURE_ENGINEERING } from "../../modules/features/feature_engineering/feature_engineering.nf" addParams(params.FEATURE_ENGINEERING)


workflow ENGINEER_FEATURES {
    take:
    data

    main:
    FEATURE_ENGINEERING(data)

}


//================================================================================
// Module test
//================================================================================

workflow test {

    input_data_ch = Channel.of(["${baseDir}/${params.train_csv}",
                                "${baseDir}/${params.test_csv}"])

    FEATURE_ENGINEERING(input_data_ch)

}
