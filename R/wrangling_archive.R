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
        rename(
            from = `Incident Zip Code`,
            to = `Residence Zip`
        ) |> 
        filter(
            !is.na(from) &
                str_detect(from, "[:digit:]{5}") &
                !str_detect(from, "[:digit:]{6,}") &
                !is.na(to) &
                str_detect(to, "[:digit:]{5}") &
                !str_detect(to, "[:digit:]{6,}")
        )
    
    return(df1)
    
}

wrangle_zip_code_nodes_pre_geocode <- function(archive_df) {
    
    df1 <-
        tibble(
            zip_code = c(archive_df$from, archive_df$to)
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