wrangle_ccme_archive_generic <- function(ccme_archive_raw_df) {
    ccme_archive_raw_df |> 
        janitor::clean_names() |> 
        mutate(
            latino = case_when(
                latino == "YES" ~ TRUE,
                latino == "NO" ~ FALSE
            ),
            gun_related = case_when(
                gun_related == "Yes" ~ TRUE,
                gun_related == "No" ~ FALSE
            )
        )
}