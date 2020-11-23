nextflow.enable.dsl = 2

params.RAW_DATA_DIR = "../../data/raw"
params.INTERIM_DATA_DIR = "../../data/interim"
params.PROCESSED_DATA_DIR = "../../data/processed"


params.DERIVE_FEATURES = [
        publishDir: params.INTERIM_DATA_DIR
]
include { DERIVE_FEATURES } from "../../modules/features/derive_features/derive_features.nf" addParams(params.DERIVE_FEATURES)

params.PROCESS_NAN = [
        publishDir: params.INTERIM_DATA_DIR
]
include { PROCESS_NAN } from "../../modules/features/process_nan/process_nan.nf" addParams(params.PROCESS_NAN)

params.PROCESS_AGE = [
        publishDir: params.INTERIM_DATA_DIR
]
include { PROCESS_AGE } from "../../modules/features/process_age/process_age.nf" addParams(params.PROCESS_AGE)

params.PROCESS_FAMILY = [
        publishDir: params.INTERIM_DATA_DIR
]
include { PROCESS_FAMILY } from "../../modules/features/process_family/process_family.nf" addParams(params.PROCESS_FAMILY)

params.PROCESS_FARE = [
        publishDir: params.INTERIM_DATA_DIR
]
include { PROCESS_FARE } from "../../modules/features/process_fare/process_fare.nf" addParams(params.PROCESS_FARE)


params.REPLACE_FEATURES = [
        publishDir: params.PROCESSED_DATA_DIR
]
include { REPLACE_FEATURES } from "../../modules/features/replace_features/replace_features.nf" addParams(params.REPLACE_FEATURES)



workflow FEATURE_ENGINEERING {
    take:
    data

    main:
    DERIVE_FEATURES(input_data_ch)

    PROCESS_NAN(
            DERIVE_FEATURES.out
    )

    PROCESS_AGE(
            PROCESS_NAN.out
    )

    PROCESS_FAMILY(
            PROCESS_AGE.out
    )

    PROCESS_FARE(
            PROCESS_FAMILY.out
    )

    REPLACE_FEATURES(
            PROCESS_FARE.out
    )


}


//================================================================================
// Module test
//================================================================================

workflow test {

    input_data_ch = channel.of("${baseDir}/${params.train_csv}")

    DERIVE_FEATURES(input_data_ch)

    PROCESS_NAN(
            DERIVE_FEATURES.out
    )

    PROCESS_AGE(
            PROCESS_NAN.out
    )

    PROCESS_FAMILY(
            PROCESS_AGE.out
    )

    PROCESS_FARE(
            PROCESS_FAMILY.out
    )

    REPLACE_FEATURES(
            PROCESS_FARE.out
    )


}
