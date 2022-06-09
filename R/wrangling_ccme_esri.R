wrangle_ccme_homicide_zip_code_boundaries <- function(ccme_homicide_nodes_df, esri_zip_code_boundaries_gdb) {
    
    esri_zips <- st_read(esri_zip_code_boundaries_gdb)
    
    ccme_zips <- semi_join(esri_zips, ccme_homicide_nodes_df, by = c("ZIP_CODE" = "name"))
    
    return(ccme_zips)
}