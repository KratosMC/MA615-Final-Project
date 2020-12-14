# Load the packages

library(shiny)
library(tidyverse)
library(tidyquant)

shinyServer(function(input, output) {

    stock_price <- read_csv("stock.csv")
    stock_price$date=as.Date(stock_price$date)
    stock_return <- read_csv("stock_return.csv")
    stock_return$date <- as.Date(stock_return$date)
    
    output$stock <- DT::renderDataTable({
        DT::datatable(stock_price, options = list(scrollX =TRUE, pageLength = 20))
    })
    
    observe({
        output$plot <- NULL
        output$warning <- NULL
        req(input$initPos, input$gild, input$pfe, input$bntx)
        if (sum(input$gild, input$pfe, input$bntx) != 1) {
            output$warning <- renderText(HTML("Warning: Total weight must equal to 1."))
        } else {
            initial_position <- input$initPos
            wts <- c(input$gild, input$pfe, input$bntx)
            
            portfolio_growth <- stock_return %>%
                tq_portfolio(assets_col   = symbol, 
                             returns_col  = monthly.return, 
                             weights      = wts, 
                             col_rename   = "investment.growth",
                             wealth.index = TRUE) %>%
                mutate(investment.growth = investment.growth * initial_position)
            
            gg <- portfolio_growth %>%
                ggplot(aes(x = date, y = investment.growth)) +
                geom_line(size = 2, color = palette_light()[[5]]) +
                labs(title = "Portfolio Performance",
                     subtitle = paste0("with ", input$gild * 100, "% GILD,", input$pfe * 100, "% PFE,",
                                       input$bntx * 100, "% BNTX"),
                     x = "", y = "Portfolio Value") +
                geom_smooth(method = "loess") +
                geom_text(aes(label = round(investment.growth)),nudge_x=0.1,nudge_y=0.1)+
                theme_tq() +
                scale_color_tq() +
                scale_y_continuous(labels = scales::dollar)
            
            output$plot <- renderPlot({print(gg)})
        }
    })

})
