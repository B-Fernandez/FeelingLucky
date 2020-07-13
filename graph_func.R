library(shiny)
library(ggplot2)
library(magrittr)


linkedScatterUI <- function(id){
  ns <- NS(id)
  fluidRow(
    column(6, plotOutput(ns("scatter_plot"),brush=ns("brush"))),
    column(6, dataTableOutput(ns("table_ui"))))
}

linkedScatterSRV <- function(input, output,session,data){
  # See shiny documentation for more details :\
  dataSelection <- reactive({
    brushedPoints(data(),input$brush,allRows=TRUE)
  })
  output$scatter_plot <- renderPlot(scatterPlot(dataSelection()), height = 400, width = 400 )
  
  output$table_ui <- DT::renderDataTable({
  DT::datatable(dplyr::filter(dataSelection(),selected_) %>% select(Name,Description), options = list(scrollY="100vh", dom = 't'))})


}

# pictureSRV <- function(inpout, output, session,data){
#   #output$picture<-renderUI({
#     #tags$img(src = data() %>%sample_n(1) %>% pull(image_url))})
# }

  scatterPlot <- function(data){
    ggplot(data,aes(x = ebc,y=ibu))+
      geom_point(aes(color=selected_))+
      scale_colour_manual(values=c('black','green'),guide=FALSE)
  }
  
  
  