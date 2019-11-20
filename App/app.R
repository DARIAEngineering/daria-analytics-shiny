library(shiny)
library(highcharter)
library(dplyr)

# Define UI for data upload app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("DARIA Analytics"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Select a file ----
      fileInput("file1", "Choose CSV File",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      
      # Horizontal line ----
      tags$hr()
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      # Output: Data file ----
      h3("Patients by Month and Line"),
      highchartOutput("patients_by_month")
    )
  )
)

# Define server logic to read selected file ----
server <- function(input, output) {
    
    output$patients_by_month <- renderHighchart({
      req(input$file1)
      
      df <- read.csv(input$file1$datapath)
      
      # Clean Data
      df$Initial.Call.Date <- as.Date(as.character(paste(df$Initial.Call.Date)), format="%m/%d/%y")
      df$Initial.Call.MonthYear <- format(as.Date(df$Initial.Call.Date), "%Y-%m")
      df$Initial.Call.MonthYear <- as.Date(paste0(df$Initial.Call.MonthYear, '-01'), "%Y-%m-%d")
      df$pledged <- df$Pledge.sent == TRUE & df$Fund.pledge > 0 & !is.na(df$Fund.pledge)
      df$Line <- as.character(paste(df$Line))
      
      
      # Total Patients by Month
      monthly_patients <- df %>% 
        group_by(Initial.Call.MonthYear, Line) %>%
        summarise(freq = n())
      
      hc <- hchart(monthly_patients, "line", hcaes(x = Initial.Call.MonthYear, y = freq, group = Line)) %>%
        hc_add_theme(hc_theme_smpl())
      hc
    })
  
}

# Create Shiny app ----
shinyApp(ui, server)