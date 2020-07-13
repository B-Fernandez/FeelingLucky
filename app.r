library(shiny)
library(shinydashboard)
library(tidyverse)
library(ggplot2)
library(glue)
library(httr)
library(DT)
source("graph_func.R")
source("functions.r")

ui <- dashboardPage(
dashboardHeader(title="Punk API Shiny - Convex Tech Test"),
sidebar = dashboardSidebar(disable = TRUE),
 dashboardBody( fluidRow(
      h5("Feeling Lucky, Punk? Use this app to explore the Brewdog beer selection and discover the terms beer experts use to describe your favourite pint."),style="margin:20px"),
  fluidRow(
  textInput("food_terms", "What foods do you usually drink with beer?", "Salad"),
  actionButton("start","Find Beers!"),
  style="margin:20px"), 
  fluidRow(
  h5("A great beer is more than just data."), 
  h5("Since Brewdog have so much data on their beer, however, it would be rude not to have a look at the numbers behind your faviourite brew."),style="margin:20px"
            ),
  fluidRow(  
  conditionalPanel("output.dat_av_check==0", h3(textOutput("not_found"))),
  conditionalPanel("output.dat_av_check>0",
  fluidRow(
    column(width = 12,
    h5("The graph below shows the EBC and IBU of all the beers matching the search you made. Drag the pointer over the points to show combinations of EBC and IBU in the table on the right.")),
    style="margin:20px"),
       fluidRow(box(h5("The colour of beer is measured in EBCs. EBC stands for European Brewery Convention. One EBC corresponds to 1 ml of iodine in 100 ml of water.",background = "grey")),
        box(h5("You can measure the bitterness of a beer. In most cases this is measured in IBUs. IBU stands for International Bitterness Unit.",background = "grey")),
    style="margin:20px"),
    linkedScatterUI("scatterID"),
    linkedScatterUI("tableUI"))
)))

server <- function(input, output, session){
  output$dat_av_check <- renderText(-999)
  outputOptions(output, "dat_av_check", suspendWhenHidden = FALSE)
  output$not_found <- renderText(paste(input$food_terms," is not in the Brewdog database, try another one, like 'pizza'"))
  # Collect food terms to search
  observeEvent(input$start,{
  metric_graph_gen(input$food_terms)
  output$dat_av_check <- renderText(nrow(tibble(ebc=ebc,ibu=ibu)))
  
  callModule(linkedScatterSRV,
                      "scatterID",
                       reactive(tibble(ebc = ebc,
                                       ibu = ibu,
                                       Name = name,
                                       Description = description)))
  
  })
   
      }
  

shinyApp(ui, server)