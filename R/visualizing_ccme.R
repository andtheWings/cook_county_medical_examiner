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
            stroke_width = 100
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
        filter(neighborhood %in% c(1:4,6))
    
    m <-
        mapdeck(
            style = "mapbox://styles/mapbox/dark-v10",
            pitch = 45
        ) |> 
        add_polygon(
            data = neighborhoods,
            fill_colour = "neighborhood",
            fill_opacity = 175,
            stroke_colour = "#FFFFFFFF",
            stroke_width = 100
        ) 
    
    return(m)
    
}