read_archive_raw_csv <- function(archive_raw_csv) {
    
    parse_spec <-
        cols(
            `Case Number` = col_character(),
            `Date of Incident` = col_character(),
            `Date of Death` = col_character(),
            Age = col_double(),
            Gender = col_character(),
            Race = col_character(),
            Latino = col_logical(),
            `Manner of Death` = col_character(),
            `Primary Cause` = col_character(),
            `Primary Cause Line A` = col_character(),
            `Primary Cause Line B` = col_character(),
            `Primary Cause Line C` = col_character(),
            `Secondary Cause` = col_character(),
            `Gun Related` = col_logical(),
            `Opioid Related` = col_logical(),
            `Cold Related` = col_logical(),
            `Heat Related` = col_logical(),
            `Commissioner District` = col_double(),
            `Incident Address` = col_character(),
            `Incident City` = col_character(),
            `Incident Zip Code` = col_character(),
            longitude = col_double(),
            latitude = col_double(),
            location = col_character(),
            `Residence City` = col_character(),
            `Residence Zip` = col_character(),
            OBJECTID = col_double(),
            `Chicago Ward` = col_double(),
            `Chicago Community Area` = col_character(),
            `COVID Related` = col_logical()
        )
    
    df1 <- read_csv(archive_raw_csv, col_types = parse_spec)
    
    return(df1)
    
}

wrangle_archive <- function(archive_raw_df) {
    
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
        filter(residence_zip != "99999") 
        
    return(df1)
    
}

wrangle_zip_code_nodes_pre_geocode <- function(archive_df) {
    
    df1 <-
        tibble(
            zip_code = c(archive_df$incident_zip_code, archive_df$residence_zip)
        ) |> 
        distinct() |> 
        separate(
            zip_code,
            into = "zip_code_5",
            sep = "-",
            remove = FALSE,
            extra = "drop"
        ) |> 
        mutate(
            zip_code_query = paste(zip_code_5, "United States")
        )
    
    return(df1)
    
}

wrangle_cook_zip_code_nodes <- function(zip_code_nodes_post_geocode_df) {
    
    cook_county_border <- st_read("data/Cook_County_Border.geojson")
    
    all_zips_sf <-
        zip_code_nodes_post_geocode_df |> 
        st_as_sf(coords = c("lon", "lat")) |> 
        st_set_crs(4326) 
    
    cook_zips <-
        all_zips_sf |> 
        filter(
            st_intersects(
                all_zips_sf, cook_county_border,
                sparse = FALSE
            )[,1]
        )
    
    return(cook_zips)
    
}

wrangle_cook_homicide_edges <- function(archive_df, cook_zip_code_nodes_df) {
    
    df1 <-
        archive_df |> 
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
        ) |> 
        relocate(from, to) |> 
        filter(
            from %in% cook_zip_code_nodes_df$zip_code_5 | to %in% cook_zip_code_nodes_df$zip_code_5
        )
        
    return(df1)
    
}

wrangle_cook_homicide_graph <- function(wrangle_cook_homicide_edges_df) {
    
    df1 <-
        wrangle_cook_homicide_edges_df |> 
        as_tbl_graph(directed = TRUE) |> 
        activate(nodes) |> 
        mutate(
            degree = centrality_degree(),
            betweenness = centrality_betweenness()
        ) |> 
        morph(to_undirected) |> 
        mutate(
            closeness = centrality_closeness_harmonic(),
            neighborhood = group_louvain()
        ) |> 
        unmorph()
    
    return(df1)
    
}