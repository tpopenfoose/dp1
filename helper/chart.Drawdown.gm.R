chart.Drawdown.gm <-
        function (R, geometric = TRUE, legend.loc = NULL, colorset = (1:12), ...)
        { # @author Peter Carl
                
                # DESCRIPTION:
                # A wrapper to create a chart demonstrating drawdowns from peak equity
                # attained through time.
                
                # To find the maximum drawdown in a return series, we need to first
                # calculate the cumulative returns and the maximum cumulative return to
                # that point.  Any time the cumulative returns dips below the maximum
                # cumulative returns, it's a drawdown.  Drawdowns are measured as a
                # percentage of that maximum cumulative return, in effect, measured from
                # peak equity.
                
                # Inputs:
                # R: a matrix, data frame, or timeSeries of returns
                # legend.loc: use this to locate the legend, e.g., "topleft".  If it's
                #   left as NULL, then no legend is drawn.
                # colorset: use the name of any of the palattes above.
                
                # Outputs:
                # A timeseries line chart of the drawdown series
                
                # FUNCTION:
                
                # Calculate drawdown level
                drawdown = Drawdowns(R, geometric)
                
                # workaround provided by Samuel Le to handle single-column input
                if(NCOL(R)==1)
                {
                        drawdown<-as.xts(drawdown)
                        colnames(drawdown)<-colnames(R)
                }
                
                # Chart the drawdown level
                chart.TimeSeries(drawdown*100, colorset = colorset, legend.loc = legend.loc, ...)
                
        }
