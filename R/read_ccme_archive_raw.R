read_ccme_archive_raw <- function(ccme_archive_raw_file_csv) {
    
    parse_spec <-
        cols(
            X = col_double(),
            Y = col_double(),
            CASENUMBER = col_character(),
            INCIDENT_DATE = col_datetime(format = "%Y/%m/%d %H:%M:%S%z"),
            DEATH_DATE = col_datetime(format = "%Y/%m/%d %H:%M:%S%z"),
            AGE = col_double(),
            GENDER = col_factor(levels = c("Male", "Female")),
            RACE = col_factor(levels = c("Black", "White", "Asian", "Other", "Am. Indian")),
            LATINO = col_character(),
            MANNER = col_character(),
            PRIMARYCAUSE = col_character(),
            PRIMARYCAUSE_LINEA = col_character(),
            PRIMARYCAUSE_LINEB = col_character(),
            PRIMARYCAUSE_LINEC = col_character(),
            SECONDARYCAUSE = col_character(),
            COLD_RELATED = col_character(),
            HEAT_RELATED = col_character(),
            INCIDENT_STREET = col_character(),
            INCIDENT_CITY = col_character(),
            INCIDENT_ZIP = col_character(),
            RESIDENCE_CITY = col_character(),
            RESIDENCE_ZIP = col_character(),
            CommDistrict = col_double(),
            AGE_GROUP = col_character(),
            OPIOID_RELATED = col_character(),
            GUN_RELATED = col_character(),
            chi_ward = col_double(),
            chi_commarea = col_character(),
            last_edited_date = col_character(),
            OBJECTID = col_double(),
            longitude = col_double(),
            latitude = col_double(),
            COVID_RELATED = col_character(),
            Shape = col_logical()
        )
    
    read_csv(ccme_archive_raw_file_csv, col_types = parse_spec)
    
}