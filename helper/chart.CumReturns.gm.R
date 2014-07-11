na.skip <- function (x, FUN=NULL, ...) # maybe add a trim capability?
{ # @author Brian Peterson
        
        # DESCRIPTION:
        
        # Time series data often contains NA's, either due to missing days, 
        # noncontiguous series, or merging multiple series,
        # 
        # Some Calulcations, such as return calculations, require data that 
        # looks like a vector, and needs the output of na.omit
        # 
        # It is often convenient to apply these vector-like functions, but 
        # you still need to keep track of the structure of the oridginal data.
        
        # Inputs
        # x        	the time series to apply FUN too
        # FUN	function to apply
        # ...	any additonal parameters to FUN
        
        # Outputs:
        # An xts time series that has the same index and NA's as the data 
        # passed in, after applying FUN
        
        nx <- na.omit(x)
        fx <- FUN(nx, ... = ...)
        if (is.vector(fx)) {
                result <- .xts(fx, .index(x), .indexCLASS = indexClass(x))
        }
        else {
                result <- merge(fx, .xts(, .index(x)))
        }
        return(result)
}

chart.CumReturns.gm <-
        function (R, wealth.index = FALSE, geometric = TRUE, legend.loc = NULL, colorset = (1:12), begin = c("first","axis"), ...)
        { # @author Peter Carl
                
                # DESCRIPTION:
                # Cumulates the returns given and draws a line graph of the results as
                # a cumulative return or a "wealth index".
                
                # Inputs:
                # R: a matrix, data frame, or timeSeries of returns
                # wealth.index:  if true, shows the "value of $1", starting the cumulation
                #    of returns at 1 rather than zero
                # legend.loc: use this to locate the legend, e.g., "topright"
                # colorset: use the name of any of the palattes above
                # method: "none"
                
                # Outputs:
                # A timeseries line chart of the cumulative return series
                
                # FUNCTION:
                
                # Transform input data to a matrix
                begin = begin[1]
                x = checkData(R)
                
                # Get dimensions and labels
                columns = ncol(x)
                columnnames = colnames(x)
                
                # Calculate the cumulative return
                one = 0
                if(!wealth.index)
                        one = 1
                
                ##find the longest column, calc cum returns and use it for starting values
                
                if(begin == "first") {
                        length.column.one = length(x[,1])
                        # find the row number of the last NA in the first column
                        start.row = 1
                        start.index = 0
                        while(is.na(x[start.row,1])){
                                start.row = start.row + 1
                        }
                        x = x[start.row:length.column.one,]
                        if(geometric)
                                reference.index = na.skip(x[,1],FUN=function(x) {cumprod(1+x)})
                        else
                                reference.index = na.skip(x[,1],FUN=function(x) {cumsum(x)})
                }
                for(column in 1:columns) {
                        if(begin == "axis") {
                                start.index = FALSE
                        } else {
                                # find the row number of the last NA in the target column
                                start.row = 1
                                while(is.na(x[start.row,column])){
                                        start.row = start.row + 1
                                }
                                start.index=ifelse(start.row > 1,TRUE,FALSE)
                        }
                        if(start.index){
                                # we need to "pin" the beginning of the shorter series to the (start date - 1 period) 
                                # value of the reference index while preserving NA's in the shorter series
                                if(geometric)
                                        z = na.skip(x[,column],FUN = function(x,index=reference.index[(start.row - 1)]) {rbind(index,1+x)})
                                else
                                        z = na.skip(x[,column],FUN = function(x,index=reference.index[(start.row - 1)]) {rbind(1+index,1+x)})
                        } else {
                                z = 1+x[,column] 
                        }
                        column.Return.cumulative = na.skip(z,FUN = function(x, one, geometric) {if(geometric) cumprod(x)-one else (1-one) + cumsum(x-1)},one=one, geometric=geometric)
                        if(column == 1)
                                Return.cumulative = column.Return.cumulative
                        else
                                Return.cumulative = merge(Return.cumulative,column.Return.cumulative)
                }
                if(columns == 1)
                        Return.cumulative = as.xts(Return.cumulative)
                colnames(Return.cumulative) = columnnames
                
                # Chart the cumulative returns series
                chart.TimeSeries((Return.cumulative-1)*100, colorset = colorset, legend.loc = legend.loc, ...)
                
        }
