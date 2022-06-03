library(targets)

source("R/wrangling_archive.R")
source("R/wrangling_esri.R")

tar_option_set(
    packages = c(
        "dplyr", "readr", "stringr", "tidyr",
        "ggmap", "sf",
        "tidygraph"
    )
)

list(
    # Cook County Boundary
    tar_target(
        cook_county_boundary_file,
        # https://hub-cookcountyil.opendata.arcgis.com/datasets/ea127f9e96b74677892722069c984198_1/explore
        "data/Cook_County_Border.geojson",
        format = "file"
    ),
    tar_target(
        cook_county_boundary,
        st_read(cook_county_boundary_file)
    ),
    # ESRI Zip Code Boundaries
    tar_target(
        esri_zip_code_boundaries_file,
        # https://www.arcgis.com/home/item.html?id=8d2012a2016e484dafaac0451f9aea24
        "data/USA_Zip_Code_Boundaries/v10/zip_poly.gdb",
        format = "file"
    ),
    tar_target(
        cook_county_zip_code_boundaries,
        wrangle_cook_county_zip_code_boundaries(esri_zip_code_boundaries_file, cook_county_boundary)
    ),
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
    ),
    tar_target(
        cook_zip_code_nodes,
        wrangle_cook_zip_code_nodes(zip_code_nodes_post_geocode)
    ),
    tar_target(
        cook_homicide_edges,
        wrangle_cook_homicide_edges(archive, cook_zip_code_nodes)
    ),
    tar_target(
        cook_homicide_graph,
        wrangle_cook_homicide_graph(cook_homicide_edges)
    )
)