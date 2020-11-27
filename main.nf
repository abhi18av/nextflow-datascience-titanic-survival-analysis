nextflow.enable.dsl = 2

params.PROCESSED_DATA_DIR = "$baseDir/data/processed"


//-------------------------------------
include { GENERATE_PLOTS } from "./workflows/generate_plots/generate_plots.nf"

//-------------------------------------
include { FEATURE_ENGINEERING } from "./workflows/feature_engineering/feature_engineering.nf"

//-------------------------------------
params.TEST_TRAIN_SPLIT = [

        publishDir: params.PROCESSED_DATA_DIR
]
include { TEST_TRAIN_SPLIT } from "./modules/data/test_train_split/test_train_split.nf" addParams(params.TEST_TRAIN_SPLIT)


//================================================================================
// Main workflow
//================================================================================

workflow MAIN {

    visualization_ch = Channel.of(["${baseDir}/${params.train_csv}",
                                   "${baseDir}/${params.test_csv}"])

    feature_engineering_ch = channel.of("${baseDir}/${params.train_csv}")


    GENERATE_PLOTS(visualization_ch)

    FEATURE_ENGINEERING(feature_engineering_ch)

    TEST_TRAIN_SPLIT(
            FEATURE_ENGINEERING.out
    )

}
