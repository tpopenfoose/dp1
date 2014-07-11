## BEGIN Loading Libraries and Helper Scripts

library(PerformanceAnalytics)
library(shiny)
source("helper/charts.Performance.R")
source("helper/chart.Drawdown.gm.R")
source("helper/chart.CumReturns.gm.R")

## END Loading Libraries and Helper Scripts

## BEGIN MAIN

# shiny server
shinyServer( function(input, output, session) {
                
        # chart of returns
        output$plot <- renderPlot({
                if(input$run==0) return(NULL)
                
                # load backtesting result based on user input
                begin = isolate(strsplit(input$dates, ":")[[1]][1])
                rankFun = isolate(input$rankFun)
                filename = paste("bt", begin, 1000, 3, rankFun, "rda", sep=".")
                load(filename)
                
                # load buy-and-hold backtesting result based on user input
                if (rankFun == "12 months returns minus 1 month returns")
                        fun = "12-1"
                if (rankFun == "average 2, 4, and 6 months returns")
                        fun = "ave3"
                bh.filename = paste("bh", begin, 1000, fun, "rda", sep=".")
                load(bh.filename)
                
#                 path = file.path(Sys.getenv("HOME"), "shiny-server/src/apps/dp1")
# #                 file1="bt.05 years.1000.3.12 months returns minus 1 month returns.rda"
#                 file1="bt.05 years.1000.3.average 2, 4, and 6 months returns.rda"
#                 load(file.path(path, file1))
#                 head(bt$returns)
# 
#                 file2="bh.05 years.1000.12-1.rda"
#                 load(file.path(path, file2))
                
                stopifnot(nrow(bt$returns[,"total"]) == 
                                  nrow(bt.bh$returns[21:nrow(bt.bh$returns),"total"]))
                
                returns = cbind(bt$returns[,"total"], 
                                bt.bh$returns[21:nrow(bt.bh$returns),"total"])
                colnames(returns) = c("Dynamic","BuyHold")
                
                # plot
                title = paste("Dynamic Portfolio End Value: $", bt$end.eq, "\n",
                              "Buy-Hold Portfolio End Value: $", bt.bh$end.eq, sep="")
                par(cex.lab=2.5, font.lab=1, cex.main=3)

                charts.Performance(returns, cex.axis=2, cex.legend=2.5,
                          geometric=FALSE, wealth.index=TRUE, xlab="",
                          main=title)

#                 chart.RiskReturnScatter(returns)

#                 charts.RollingPerformance(returns)
        })
        
})

## END MAIN