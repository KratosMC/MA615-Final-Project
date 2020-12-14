# Load the packages
library(shiny)
library(shinydashboard)

shinyUI(dashboardPage(
    dashboardHeader(title = "Portfolio Analysis on Healthcare Stocks", titleWidth = 400),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Stock Price", tabName = "stock_price"),
            menuItem("Portfolio Performance", tabName = "performance")
        )
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = "stock_price",
                    box(
                        title = "Stock Price",
                        status = "primary",
                        collapsible = FALSE,
                        solidHeader = TRUE,
                        width = 12,
                        DT::dataTableOutput("stock")
                    )),
            tabItem(tabName = "performance",
                    box(
                        title = "Portfolio Performance",
                        status = "primary",
                        collapsible = FALSE,
                        solidHeader = TRUE,
                        width = 12,
                        fluidRow(
                            column(
                                4,
                                tags$h3("Initial Position in $"),
                                numericInput("initPos", NULL, 250000, 20000, 1000000, 5000)
                            ),
                            column(
                                8,
                                tags$h3("Weight of Individual Stock"),
                                fluidRow(
                                    column(2, tags$h4("GILD:")),
                                    column(2, numericInput("gild", NULL, 0.1, 0, 1, step = 0.05)),
                                    column(2, tags$h4("PFE:")),
                                    column(2, numericInput("pfe", NULL, 0.4, 0, 1, step = 0.05)),
                                    column(2, tags$h4("BNTX:")),
                                    column(2, numericInput("bntx", NULL, 0.5, 0, 1, step = 0.05))
                                ),
                                tags$div(style = "color:red;",
                                         textOutput("warning"))
                                
                            )
                        ),
                        plotOutput("plot")))
        )
    )
))
