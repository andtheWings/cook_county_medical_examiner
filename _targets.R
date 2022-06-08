library(targets)

source("R/wrangling_archive.R")
source("R/wrangling_esri.R")
source("R/describing_ccme.R")

tar_option_set(
    packages = c(
        "dplyr", "readr", "stringr", "tidyr",
        "ggmap", "sf",
        "tidygraph"
    )
)

list(
    # Medical Examiner Archive
    tar_target(
        ccme_archive_raw_file,
        "data/Medical_Examiner_Case_Archive.csv",
        format = "file"
    ),
    tar_target(
        ccme_archive_raw,
        read_ccme_archive_raw(ccme_archive_raw_file)
    ),
    tar_target(
        ccme_homicide_edges,
        wrangle_ccme_homicide_edges(ccme_archive_raw)
    ),
    tar_target(
        ccme_homicide_table_1,
        make_ccme_homicide_table_1(ccme_homicide_edges),
        format = "file"
    ),
    tar_target(
        ccme_homicide_graph,
        wrangle_ccme_homicide_graph(ccme_homicide_edges)
    ),
    tar_target(
        ccme_homicide_nodes,
        ccme_homicide_graph |> activate(nodes) |> as_tibble()
    ),
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
    # Combining
    tar_target(
        cook_county_homicide_vis_edges,
        wrangle_cook_county_homicide_vis_edges(cook_county_zip_code_boundaries, ccme_homicide_edges, ccme_homicide_nodes)
    ),
    tar_target(
        cook_county_homicide_vis_nodes,
        inner_join(cook_county_zip_code_boundaries, ccme_homicide_nodes, by = c("ZIP_CODE" = "name"))
    )
)