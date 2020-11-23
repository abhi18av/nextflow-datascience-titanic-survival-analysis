nextflow.enable.dsl = 2


include { GENERATE_PLOTS } from "./workflows/generate_plots/generate_plots.nf"

include { FEATURE_ENGINEERING } from "./workflows/feature_engineering/feature_engineering.nf"


//================================================================================
// Main workflow
//================================================================================

workflow MAIN {

    visualization_ch = Channel.of(["${baseDir}/${params.train_csv}",
                                   "${baseDir}/${params.test_csv}"])

    feature_engineering_ch = channel.of("${baseDir}/${params.train_csv}")


    GENERATE_PLOTS(visualization_ch)

    FEATURE_ENGINEERING(feature_engineering_ch)


}
