nextflow.enable.dsl = 2


include { GENERATE_PLOTS } from "./workflows/generate_plots/generate_plots.nf"


//================================================================================
// Module test
//================================================================================

workflow MAIN {

    input_data_ch = Channel.of(["${baseDir}/${params.train_csv}",
                                "${baseDir}/${params.test_csv}"])

    GENERATE_PLOTS(input_data_ch)


}
