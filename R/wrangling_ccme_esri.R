wrangle_ccme_homicide_zip_code_boundaries <- function(ccme_homicide_nodes_df, esri_zip_code_boundaries_gdb) {
    
    esri_zips <- st_read(esri_zip_code_boundaries_gdb)
    
    ccme_zips <- semi_join(esri_zips, ccme_homicide_nodes_df, by = c("ZIP_CODE" = "name"))
    
    return(ccme_zips)
}

wrangle_ccme_homicide_nodes <- function(ccme_homicide_tbl_graph, ccme_homicide_zip_code_boundaries_sf) {
    
    df1 <-
        ccme_homicide_tbl_graph |> 
        activate(nodes) |> 
        as_tibble()
    
    df2 <-
        ccme_homicide_zip_code_boundaries_sf |> 
        st_drop_geometry() |> 
        select(ZIP_CODE, PO_NAME, STATE)
    
    df3 <- left_join(df1, df2, by = c("name" = "ZIP_CODE")) |> 
        relocate(
            PO_NAME, STATE
        )
    
    return(df3)
    
}