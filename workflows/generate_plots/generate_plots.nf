nextflow.enable.dsl = 2


include { VISUALIZATION_SURVIVAL_PLOTS } from "../../modules/visualization/survival_plots/survival_plots.nf"

include { VISUALIZATION_GENDER_SURVIVAL_PLOTS } from "../../modules/visualization/gender_survival_plots/gender_survival_plots.nf"


//================================================================================
// Module test
//================================================================================

workflow test {

    input_data_ch = Channel.of(["${baseDir}/${params.train_csv}",
                                "${baseDir}/${params.test_csv}"])

    VISUALIZATION_GENDER_SURVIVAL_PLOTS(input_data_ch)
    VISUALIZATION_SURVIVAL_PLOTS(input_data_ch)


}
