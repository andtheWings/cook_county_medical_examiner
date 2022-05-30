library(targets)

source("R/wrangling_archive.R")

tar_option_set(
    packages = c(
        "dplyr", "readr", "stringr", "tidyr",
        "ggmap"
    )
)

list(
    # Medical Examiner Archive
    tar_target(
        archive_raw_file,
        "data/Medical_Examiner_Case_Archive.csv",
        format = "file"
    ),
    tar_target(
        archive_raw,
        read_archive_raw_csv(archive_raw_file)
    ),
    tar_target(
        archive,
        wrangle_archive(archive_raw)
    ),
    tar_target(
        zip_code_nodes_pre_geocode,
        wrangle_zip_code_nodes_pre_geocode(archive)
    ),
    tar_target(
        zip_code_nodes_post_geocode,
        mutate_geocode(
            zip_code_nodes_pre_geocode,
            zip_code_query
        )
    )
    # tar_target(
    #     opencage_zip_code_query,
    #     ggmap::mutate_geocode(zip_code_nodes_pre_opencage, zip_code_query)
    # )
)