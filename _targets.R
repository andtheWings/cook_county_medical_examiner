library(targets)

sapply(
    paste0("R/", list.files("R/")),
    source
)

tar_option_set(
    packages = c(
        "dplyr", "lubridate", "readr", "stringr", "tidyr",
        "ggmap", "sf", "mapdeck", "leaflet",
        "tidygraph"
    )
)

list(
    # Cook County Medical Examiner Archive
    # Downloaded on 2022-10-02
    # https://hub-cookcountyil.opendata.arcgis.com/datasets/4f7cc9f13542463c89b2055afd4a6dc1_0/explore
    tar_target(
        ccme_archive_raw_file,
        "data/Medical_Examiner_Case_Archive,_2014_to_present.csv",
        format = "file"
    ),
    tar_target(
        ccme_archive_raw,
        read_ccme_archive_raw(ccme_archive_raw_file)
    ),
    tar_target(
        ccme_archive_generic,
        wrangle_ccme_archive_generic(ccme_archive_raw)
    )
    # tar_target(
    #     ccme_homicide_edges,
    #     wrangle_ccme_homicide_edges(ccme_archive_raw)
    # ),
    # tar_target(
    #     ccme_homicide_table_1,
    #     make_ccme_homicide_table_1(ccme_homicide_edges),
    #     format = "file"
    # ),
    # tar_target(
    #     ccme_homicide_graph,
    #     wrangle_ccme_homicide_graph(ccme_homicide_edges)
    # ),
    # tar_target(
    #     ccme_homicide_nodes_no_labels,
    #     ccme_homicide_graph |> activate(nodes) |> as_tibble()
    # ),
    # # Cook County Boundary
    # tar_target(
    #     cook_county_boundary_file,
    #     # https://hub-cookcountyil.opendata.arcgis.com/datasets/ea127f9e96b74677892722069c984198_1/explore
    #     "data/Cook_County_Border.geojson",
    #     format = "file"
    # ),
    # tar_target(
    #     cook_county_boundary,
    #     st_read(cook_county_boundary_file)
    # ),
    # # ESRI Zip Code Boundaries
    # tar_target(
    #     esri_zip_code_boundaries_file,
    #     # https://www.arcgis.com/home/item.html?id=8d2012a2016e484dafaac0451f9aea24
    #     "data/USA_Zip_Code_Boundaries/v10/zip_poly.gdb",
    #     format = "file"
    # ),
    # tar_target(
    #     ccme_homicide_zip_code_boundaries,
    #     wrangle_ccme_homicide_zip_code_boundaries(ccme_homicide_nodes_no_labels, esri_zip_code_boundaries_file)
    # ),
    # # Combining
    # tar_target(
    #     ccme_homicide_nodes,
    #     wrangle_ccme_homicide_nodes(ccme_homicide_graph, ccme_homicide_zip_code_boundaries)
    # ),
    # tar_target(
    #     ccme_homicide_vis_edges,
    #     wrangle_ccme_homicide_vis_edges(ccme_homicide_zip_code_boundaries, ccme_homicide_edges, ccme_homicide_nodes)
    # ),
    # tar_target(
    #     ccme_homicide_vis_nodes,
    #     inner_join(ccme_homicide_zip_code_boundaries, ccme_homicide_nodes, by = c("ZIP_CODE" = "name"))
    # ),
    # tar_target(
    #     ccme_homicide_degree_map,
    #     map_ccme_centrality("homicide_degree", ccme_homicide_vis_nodes, ccme_homicide_vis_edges)
    # ),
    # tar_target(
    #     ccme_homicide_closeness_map,
    #     map_ccme_centrality("closeness", ccme_homicide_vis_nodes, ccme_homicide_vis_edges)
    # ),
    # tar_target(
    #     ccme_homicide_betweenness_map,
    #     map_ccme_centrality("betweenness", ccme_homicide_vis_nodes, ccme_homicide_vis_edges)
    # ),
    # tar_target(
    #     ccme_homicide_neighborhood_map,
    #     map_ccme_neighborhoods(ccme_homicide_vis_nodes)
    # ),
    # # Mapping
    # tar_target(
    #     base_leaflet,
    #     leaflet() |> 
    #         addProviderTiles("CartoDB.DarkMatter") |> 
    #         setView(lat = 41.816544, lng = -87.749500, zoom = 9) |> 
    #         leaflet.extras::addFullscreenControl()
    # )
)