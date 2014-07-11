library(shiny)

shinyUI(fluidPage(
#         titlePanel("Dynamic Portfolio Backtesting Scenario I: No Asset Class Distinction"),
        
        sidebarLayout(
                sidebarPanel(
                        
                        h3("Initial Investment of $1000"),
                        
                        h3("Trading/Rebalancing Strategy"),
                        p("At the end of every month",
                        tags$ul(
                                tags$li("rank assets by an asset ranking method (see choices below)"), 
                                tags$li("sell assets (100% exist) in portfolio that are not among the top", strong(3), "ranked assets"), 
                                tags$li("buy or hold the top", strong(3), "ranked assets with equal weights")
                        )),
                        
                        p("Select asset ranking method:"),
                        radioButtons("rankFun", "",
                                     choices = c("average 2, 4, and 6 months returns",
                                                 "12 months returns minus 1 month returns")
                                     ),
                        
                        h3("Backtesting"),
                        p("The end of the backtesting period is set as 
                           Dec 31, 2013. Select the beginning:"),
                        radioButtons("dates", "",
                                     choices = c("05 years: Jan 2, 2009",
                                                 "10 years: Jan 2, 2004")),
                        br(),
                                                
                        actionButton("run", "Run"),
                        br()
                ),
                
                
                mainPanel(
                        h3("Portfolio holds top 3 ranked assets from these 
                            vanguard index funds:"),
                        
                        tags$head(
                                tags$link(rel = "stylesheet", type = "text/css", href = "dp1.css")
                        ),
                        
                        p(HTML("<ul id='navigation'>
                                  <li><a href='https://personal.vanguard.com/us/funds/snapshot?FundId=0085&FundIntExt=INT'><strong>VTSMX</strong></a> Total Stock Market</li>
                                  <li><a href='https://personal.vanguard.com/us/funds/snapshot?FundId=0113&FundIntExt=INT'><strong>VGTSX</strong></a> Total International Stock</li>
                                  <li><a href='https://personal.vanguard.com/us/funds/snapshot?FundId=0533&FundIntExt=INT'><strong>VEIEX</strong></a> Emerging Markets Stock</li>
                                  <li><a href='https://personal.vanguard.com/us/funds/snapshot?FundId=0123&FundIntExt=INT'><strong>VGSIX</strong></a> REIT</li>
                                  <li><a href='https://personal.vanguard.com/us/funds/snapshot?FundId=0119&FundIntExt=INT'><strong>VIPSX</strong></a> Inflation Protected Securities</li>
                                  <li><a href='https://personal.vanguard.com/us/funds/snapshot?FundId=0035&FundIntExt=INT'><strong>VFITX</strong></a> Intermediate Term Treasury</li>
                                  <li><a href='https://personal.vanguard.com/us/funds/snapshot?FundId=0083&FundIntExt=INT'><strong>VUSTX</strong></a> Long Term Treasury</li>
                                </ul>")),
                        
                        br(),
                        
                        plotOutput("plot", height = "600px")
                )
        )
))