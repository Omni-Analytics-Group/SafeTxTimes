## Loading Libraries
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(bslib)
library(ggplot2)
library(shinycssloaders)

fluidPage(theme = bs_theme(bootswatch = "sandstone"),

    ## Custom CSS
    tags$style("#walladd {font-size:12px;height:50px;}"),

sidebarLayout(

        ########################################################################
        ## Side Panel
        ########################################################################
        sidebarPanel(width=3,
            
            ## Logo
            tags$div(style = "text-align: center;", tags$img(src = "safe.png", height=80)),
            hr(),

            ## Label
            h3("SafeTxTime Visauliser",align="center"),
            
            ## Description
            fluidRow(column(12,h6("Dive deep into transaction dynamics."),align = "center")),
            helpText("Measure responsiveness of team confirmations and visualize confirmation delays. Enhance your operational efficiency with data-driven insights."),
            hr(),

            ## Wallet Address
            textInput("walladd", label = NULL, value = "0x89C51828427F70D77875C6747759fB17Ba10Ceb0", placeholder = "Wallet Address ...."),
            fluidRow(column(12,actionBttn("wallproc", label = "Process",width=200,color="success",style="simple"),align = "center"))
        ),
        ########################################################################
        ########################################################################


        ########################################################################
        ## Main Panel
        ########################################################################
        mainPanel(width=9,tabsetPanel(id = "tabs1",
            tabPanel("Tx Times",withSpinner(plotOutput("p1"))),
            tabPanel("Tx Sequence",fluidRow(column(12,
                                                        uiOutput("h2"),
                                                        br(),
                                                        withSpinner(plotOutput("p2",width = "100%"))
                                                        ,align = "center"
            )))
        )),
        
        ########################################################################
        ########################################################################
    )
)


