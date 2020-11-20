nextflow.enable.dsl = 2

params.VISUALIZATION_RESULTS_DIR = "../../reports/figures"



params.VISUALIZATION_SURVIVAL_PLOTS = [
        publishDir: params.VISUALIZATION_RESULTS_DIR
]
include { VISUALIZATION_SURVIVAL_PLOTS } from "../../modules/visualization/survival_plots/survival_plots.nf" addParams(params.VISUALIZATION_SURVIVAL_PLOTS)


params.VISUALIZATION_GENDER_SURVIVAL_PLOTS = [
        publishDir: params.VISUALIZATION_RESULTS_DIR
]
include { VISUALIZATION_GENDER_SURVIVAL_PLOTS } from "../../modules/visualization/gender_survival_plots/gender_survival_plots.nf" addParams(params.VISUALIZATION_GENDER_SURVIVAL_PLOTS)


params.VISUALIZATION_PASSENGER_PCLASS_PLOTS = [
        publishDir: params.VISUALIZATION_RESULTS_DIR
]
include { VISUALIZATION_PASSENGER_PCLASS_PLOTS } from "../../modules/visualization/passenger_pclass_plots/passenger_pclass_plots.nf" addParams(params.VISUALIZATION_PASSENGER_PCLASS_PLOTS)


workflow GENERATE_PLOTS {
    take:
    data

    main:
    VISUALIZATION_GENDER_SURVIVAL_PLOTS(data)
    VISUALIZATION_SURVIVAL_PLOTS(data)
    VISUALIZATION_PASSENGER_PCLASS_PLOTS(data)

}


//================================================================================
// Module test
//================================================================================

workflow test {

    input_data_ch = Channel.of(["${baseDir}/${params.train_csv}",
                                "${baseDir}/${params.test_csv}"])

    VISUALIZATION_GENDER_SURVIVAL_PLOTS(input_data_ch)
    VISUALIZATION_SURVIVAL_PLOTS(input_data_ch)
    VISUALIZATION_PASSENGER_PCLASS_PLOTS(input_data_ch)


}
