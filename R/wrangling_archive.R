wrangle_ccme_homicide_edges <- function(archive_raw_df) {
    
    df1 <-
        archive_raw_df |> 
        janitor::clean_names() |>
        # Remove entries without zip codes listed
        filter(
            !is.na(incident_zip_code)
        ) |> 
        filter(
            !is.na(residence_zip)
        ) |>
        # Validate zip codes as length 5 digits
        filter(
            str_detect(incident_zip_code, "[:digit:]{5}")
        ) |> 
        filter(
            !str_detect(incident_zip_code, "[:digit:]{6,}")
        ) |> 
        filter(
            str_detect(residence_zip, "[:digit:]{5}")
        ) |> 
        filter(
            !str_detect(residence_zip, "[:digit:]{6,}")
        ) |> 
        # Take out fake zip codes
        filter(incident_zip_code != "00000") |> 
        filter(incident_zip_code != "99999") |> 
        filter(residence_zip != "00000") |> 
        filter(residence_zip != "99999") |> 
        filter(manner_of_death == "HOMICIDE") |> 
        separate(
            incident_zip_code,
            into = "from",
            sep = "-",
            remove = FALSE,
            extra = "drop"
        ) |> 
        separate(
            residence_zip,
            into = "to",
            sep = "-",
            remove = FALSE,
            extra = "drop"
        )
        
    return(df1)
    
}

wrangle_ccme_homicide_graph <- function(ccme_homicide_edges_df) {
    
    df1 <-
        ccme_homicide_edges_df |> 
        as_tbl_graph(directed = TRUE) |> 
        activate(nodes) |> 
        mutate(
            homicide_degree = centrality_degree(mode = "out"),
            residence_degree = centrality_degree(mode = "in"),
            std_residence_homicide_diff = (residence_degree - homicide_degree)/(residence_degree + homicide_degree),
            homicide_degree_perc_rank = percent_rank(homicide_degree),
            residence_degree_perc_rank = percent_rank(residence_degree),
            betweenness = centrality_betweenness(),
            betweenness_perc_rank = percent_rank(betweenness)
        ) |> 
        morph(to_undirected) |> 
        mutate(
            closeness = centrality_closeness_harmonic(),
            neighborhood = group_louvain()
        ) |> 
        unmorph()
    
    return(df1)
        
}

wrangle_ccme_homicide_vis_edges <- function(ccme_homicide_zip_code_boundaries_sf, ccme_homicide_edges_df, ccme_homicide_nodes_df) {
    
    zip_cent_coords <-
        ccme_homicide_zip_code_boundaries_sf |> 
        select(ZIP_CODE) |> 
        mutate(centroid = st_centroid(Shape)) |> 
        st_drop_geometry() |> 
        st_as_sf()
    
    zip_cent_coords <-
        bind_cols(zip_cent_coords, st_coordinates(zip_cent_coords)) |> 
        st_drop_geometry()
    
    vis_edges <-
        ccme_homicide_edges_df |> 
        group_by(from, to) |> 
        summarize(weight = n()) |> 
        inner_join(zip_cent_coords, by = c("from" = "ZIP_CODE")) |> 
        rename(
            from_lon = X,
            from_lat = Y
        ) |> 
        inner_join(zip_cent_coords, by = c("to" = "ZIP_CODE")) |>
        rename(
            to_lon = X,
            to_lat = Y
        ) |>
        inner_join(ccme_homicide_nodes_df, by = c("from" = "name")) |>
        rename(
            from_residence_degree = residence_degree,
            from_homicide_degree = homicide_degree,
            from_residence_homicide_diff = std_residence_homicide_diff,
            from_betweenness = betweenness,
            from_closeness = closeness,
            from_neighborhood = neighborhood
        ) |>
        inner_join(ccme_homicide_nodes_df, by = c("to" = "name")) |>
        rename(
            to_residence_degree = residence_degree,
            to_homicide_degree = homicide_degree,
            to_residence_homicide_diff = std_residence_homicide_diff,
            to_betweenness = betweenness,
            to_closeness = closeness,
            to_neighborhood = neighborhood
        ) 
    
    return(vis_edges)
    
}
