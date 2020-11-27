nextflow.enable.dsl = 2

params.VISUALIZATION_RESULTS_DIR = "$baseDir/reports/figures"



params.SURVIVAL_PLOTS = [
        publishDir: params.VISUALIZATION_RESULTS_DIR
]
include { SURVIVAL_PLOTS } from "../../modules/visualization/survival_plots/survival_plots.nf" addParams(params.SURVIVAL_PLOTS)


params.GENDER_SURVIVAL_PLOTS = [
        publishDir: params.VISUALIZATION_RESULTS_DIR
]
include { GENDER_SURVIVAL_PLOTS } from "../../modules/visualization/gender_survival_plots/gender_survival_plots.nf" addParams(params.GENDER_SURVIVAL_PLOTS)


params.PASSENGER_PCLASS_PLOTS = [
        publishDir: params.VISUALIZATION_RESULTS_DIR
]
include { PASSENGER_PCLASS_PLOTS } from "../../modules/visualization/passenger_pclass_plots/passenger_pclass_plots.nf" addParams(params.PASSENGER_PCLASS_PLOTS)


workflow GENERATE_PLOTS {
    take:
    data

    main:
    GENDER_SURVIVAL_PLOTS(data)
    SURVIVAL_PLOTS(data)
    PASSENGER_PCLASS_PLOTS(data)

}


//================================================================================
// Module test
//================================================================================

workflow test {

    input_data_ch = Channel.of(["${baseDir}/${params.train_csv}",
                                "${baseDir}/${params.test_csv}"])

    GENDER_SURVIVAL_PLOTS(input_data_ch)
    SURVIVAL_PLOTS(input_data_ch)
    PASSENGER_PCLASS_PLOTS(input_data_ch)


}
