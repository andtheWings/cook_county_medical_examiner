make_ccme_homicide_table_1 <- function(ccme_homicide_edges_df) {
    
    ccme_homicide_edges_df |> 
        select(age, gender, race, latino) |> 
        gtsummary::tbl_summary() |> 
        gtsummary::as_gt() |> 
        gt::gtsave("outputs/ccme_homicide_table_1.html")
    
    return("outputs/ccme_homicide_table_1.html")
    
}