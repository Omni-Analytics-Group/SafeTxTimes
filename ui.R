## Loading Libraries
library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(shinyWidgets)
library(bslib)
library(ggplot2)
library(DT)
useSweetAlert()

fluidPage(theme = bs_theme(bootswatch = "sandstone"),

    ## Custom CSS
    tags$style("#walladd {font-size:14px;height:50px;}"),
    tags$style(type='text/css', ".selectize-input { font-size: 14px;} .selectize-dropdown { font-size: 14px; }"),

sidebarLayout(

        ########################################################################
        ## Side Panel
        ########################################################################
        sidebarPanel(width=3,

            ## Logo
            tags$div(style = "text-align: center;", tags$img(src = "safe.png", height=80)),
            hr(),

            ## Label
            h3("SafeTxTime Visualiser",align="center"),

            ## Description
            fluidRow(column(12,h6("Dive deep into transaction dynamics."),align = "center")),
            helpText("Measure responsiveness of team confirmations and visualize confirmation delays. Enhance your operational efficiency with data-driven insights."),
            hr(),

            ## Wallet Address
            selectizeInput("walltype", label = h6("Select Chain"),choices = list(
                                                                                "Ethereum Mainnet" = "mainnet",
                                                                                "Optimism" = "optimism",
                                                                                "Arbitrum" = "arbitrum",
                                                                                "Avalanche" = "avalanche",
                                                                                "BNB Smart Chain" = "bsc",
                                                                                "Celo" = "celo",
                                                                                "Gnosis Chain" = "gnosis-chain",
                                                                                "Goerli" = "goerli",
                                                                                "Polygon" = "polygon"
                                                                        ), selected = 1,multiple = FALSE),
            textInput("walladd", label = h6("Enter Wallet Address"), value = "0x89C51828427F70D77875C6747759fB17Ba10Ceb0", placeholder = "Wallet Address ...."),
            fluidRow(column(12,actionBttn("wallproc", label = "Process",width=200,color="success",style="simple"),align = "center"))
        ),
        ########################################################################
        ########################################################################


        ########################################################################
        ## Main Panel
        ########################################################################
        mainPanel(width=9,tabsetPanel(id = "tabs1",
            tabPanel("Tx Times",
                withSpinner(plotOutput("p1")),
                withSpinner(dataTableOutput("d1"))
            ),
            tabPanel("Tx Sequence",fluidRow(column(12,
                                                        uiOutput("h2"),
                                                        br(),
                                                        withSpinner(uiOutput("o2"))
                                                        ,align = "center"
            )))
        )),

        ########################################################################
        ########################################################################
    )
)


