map_ccme_centrality <- function(centrality_var, cook_county_homicide_vis_nodes_df, cook_county_homicide_vis_edges_df) {
    
    m <-
        mapdeck(
            style = "mapbox://styles/mapbox/dark-v10",
            pitch = 45
        ) |> 
        add_polygon(
            data = cook_county_homicide_vis_nodes_df,
            fill_colour = centrality_var,
            fill_opacity = 175,
            stroke_colour = "#FFFFFFFF",
            stroke_width = 100,
            legend = list(fill_colour = TRUE, stroke_colour = FALSE)
        ) |> 
        add_arc(
            data = cook_county_homicide_vis_edges_df,
            origin = c("from_lon", "from_lat"),
            destination = c("to_lon", "to_lat"),
            stroke_from = paste0("from_", centrality_var),
            stroke_from_opacity = 175,
            stroke_to = paste0("to_", centrality_var),
            stroke_to_opacity = 175,
            stroke_width = "weight"
        )
        
    return(m)
        
}

map_ccme_neighborhoods <- function(cook_county_homicide_vis_nodes_df) {
    
    neighborhoods <-
        cook_county_homicide_vis_nodes_df |> 
        filter(neighborhood %in% c(1:7))
    
    m <-
        mapdeck(
            style = "mapbox://styles/mapbox/dark-v10",
            location = c(-87.749500, 41.816544),
            zoom = 5
        ) |> 
        add_polygon(
            data = neighborhoods,
            fill_colour = "neighborhood",
            fill_opacity = 175,
            stroke_colour = "#FFFFFFFF",
            stroke_width = 100,
            legend = list(fill_colour = TRUE, stroke_colour = FALSE),
            update_view = FALSE,
            tooltip = "neighborhood"
        ) 
    
    return(m)
    
}

map_ccme_subsets <- function(ccme_homicide_vis_nodes_sf, subset_df) {
    
    obj1 <-
        leaflet() |> 
        addProviderTiles("CartoDB.DarkMatter") |> 
        setView(lat = 41.816544, lng = -87.749500, zoom = 9) |> 
        leaflet.extras::addFullscreenControl() |> 
        addPolygons(
            data = cook_county_boundary,
            fillOpacity = 0 
        ) |> 
        addPolygons(
            data = inner_join(ccme_homicide_vis_nodes_sf, subset_df, by = c("ZIP_CODE" = "name")),
            stroke = FALSE,
            color = "yellow",
            fillOpacity = 0.5,
            label = ~ZIP_CODE
        ) 
    
    
    return(obj1)
    
}