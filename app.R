# Load packages 
library(shiny)
library(tidyverse)
library(plotly)

# Load data
load("data/lotto.RData")

map <- spTransform(map, CRSobj = CRS('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'))
new_map <- fortify(map, region = 'SIG_CD') #데이터프레임화
new_map$id <- as.numeric(new_map$id)
seoul_map <- new_map[new_map$id <= 11740,]

# User interface
ui <- fluidPage(
  titlePanel("서울시 복권 판매소 입지 선정"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("range",
                  label = "개수를 선택하세요",
                  min=1, max=1000, value=1, step=10,
                  animate=
                    animationOptions(interval = 300, loop = TRUE)),
      
      checkboxInput("district",
                    label = "행정구역 표시", value = FALSE), 
      
      img(src = "0101.jpg", height = 200, width = 200)
    ),
    mainPanel(plotlyOutput("map"))
  ),
  
  hr(),
  
  fluidRow(
    column(3),
    column(4),
    column(4)
  )
)
  
# Server logic
server <- function(input, output){
  
  lottoInput <- reactive({
    shinydata %>% top_n(input$range,bus)
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
  
  output$map <- renderPlotly({
    distInput() + geom_point(data = lottoInput(), aes(long,lat), color = "#ffb825" )
  })
}
  
# Run app
shinyApp(ui, server)
  