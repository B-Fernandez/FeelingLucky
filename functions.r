# Obtain response
metric_graph_gen <- function(food_terms){
# ' Obtain and parse a response from the Brewdog PunkAPI
url <- glue("https://api.punkapi.com/v2/beers?food={food_terms}")
res <- httr::GET(url)
parsed_content <- content(res, as="parsed")
parse_metric(parsed_content, "ebc")
parse_metric(parsed_content, "ibu")
parse_metric(parsed_content, "name")
parse_metric(parsed_content, "description")
}

# Parse a response to obtain content
parse_metric <- function(content,metric){
# ' Take parsed content and a extract named list items two levels down.
# ' The extracted values are stored with the metic name and assigned to the global environment. 
# ' Empty (NULL) values are replaced with explicit missing values(NA).
# ' @content a parsed JSON object
# ' @metric a quoted string, one of 'abv', 'ebc', and 'ibu'.
met <- sapply(X = content,FUN="[[",...=metric)
met <- sapply(met,function(x){ifelse(is.null(x),NA,x)})
assign(x = metric, value = met,globalenv())
}
