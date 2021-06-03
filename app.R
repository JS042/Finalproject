# Load packages 
library(shiny)
library(ggmap)
library(tidyverse)

# Load data
load("data/lotto.RData")

# User interface
ui <- fluidPage(
  titlePanel("서울시 복권 판매소 입지 선정"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("range",
                  label = "개수를 선택하세요",
                  min=1, max=101638, value=1, step=2500,
                  animate=
                    animationOptions(interval = 300, loop = TRUE)),
      
      checkboxInput("district",
                    label = "행정구역 표시", value = FALSE), 
      
      img(src = "0101.jpg", height = 200, width = 200)
    ),
    mainPanel(plotOutput("map"))
  ),

)
  
# Server logic
server <- function(input, output){
  
  lottoInput <- reactive({
    input$range
  })

  
  distInput <- reactive({
    if(input$district){
      return(p + geom_polygon(data = seoul_map, 
                              aes(x = long, y = lat,
                                  group = group),
                              fill = "#ffffe5", alpha = 0.7, 
                              color = "white"))
    }else{
      return(p)
    }
  })
  
  output$map <- renderPlot({
    distInput() + geom_point(data = 
                               shinydata %>% top_n(lottoInput(),bus), 
                             aes(long, lat), size = 2.5, colour = "#ffb825")
  })
}
  
# Run app
shinyApp(ui, server)
  