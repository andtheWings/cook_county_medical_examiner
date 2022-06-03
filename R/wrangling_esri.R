wrangle_cook_county_zip_code_boundaries <- function(esri_zip_code_boundaries_gdb, cook_county_boundary_sf) {
    
    sf1 <-
        st_read(esri_zip_code_boundaries_gdb) |> 
        filter(STATE == "IL")
    
    sf2 <-
        sf1 |> 
        filter(
            st_intersects(
                sf1, cook_county_boundary_sf,
                sparse = FALSE
            )[,1]
        )
    
    return(sf2)
}