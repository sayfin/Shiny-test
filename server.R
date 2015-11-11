library(shiny)

x_fx<- log_ret_mthly$FXavg
x_brent <- log_ret_mthly$Brent
t<- as.data.frame(cbind(c("x_brent", "x_fx"), c("Brent", "FX")))
colnames(t)<-c("variables", "labels")


shinyServer(function(input, output) {

  output$distPlot <- renderPlot({
    if(input$selection == "Brent"){x<-x_brent}
    if(input$selection == "FX"){x<-x_fx}
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    h<-hist(x, breaks = bins, col = 'darkgray', border = 'white')
    xfit<-seq(min(x),max(x),length=40)
    yfit<-dnorm(xfit,mean=mean(x),sd=sd(x))
    yfit <- yfit*diff(h$mids[1:2]) * length(x)

    if (input$checkbox == TRUE ){
    h
    lines(xfit, yfit, col="blue", lwd=2)
    }
    else {h}
  }
  )
  output$Prices_table<- renderDataTable(spot_mthly)
      
  })



