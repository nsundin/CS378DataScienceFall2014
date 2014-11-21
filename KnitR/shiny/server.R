## Copyright 2014 Nicholas Sundin
## Do not remove this header

library(shiny)
library(ggplot2)
library(rJava)
library(RJDBC)

jdbcDriver <- JDBC(driverClass="oracle.jdbc.OracleDriver", classPath="/Library/Java/JavaVirtualMachines/jdk1.7.0_67.jdk/Contents/Home/ojdbc6.jar")
possibleError <- tryCatch(
  jdbcConnection <- dbConnect(jdbcDriver, "jdbc:oracle:thin:@128.83.138.158:1521/pdborcl", "CS378_bo3336", "orcl_bo3336"),
  error=function(e) e
)

shinyServer(function(input, output) {
  dataset <- reactive({
    dbGetQuery(jdbcConnection,
      paste(
       "select AGE, LATITUDE, LONGITUD, A.ST_CASE, ANOM_SVM_1_247_PROB,
           PREV_ACC, PREV_SUS, PREV_SPD, PREV_OTH, SPEEDREL, MEDIAN, DRUGS, SEX
       from OUTPUT_247 A
       inner join OUTPUT_5_247 B on A.ST_CASE = B.ST_CASE
       inner join OUTPUT_6_247 C on A.ST_CASE = C.ST_CASE
       where ANOM_SVM_1_247_PROB >=", input$minAnomaly, "and AGE != 999"
      )
    )
  })

  output$table <- renderDataTable({dataset()}, options = list(iDisplayLength = 8))

  output$plotMap <- renderPlot({
    b = map_data("state")
    map <- ggplot(dataset())
    map = map + geom_point(aes(x=LONGITUD, y=LATITUDE), size=4)
    map = map + coord_map(project="mercator") + xlim(-126, -67) + ylim(24, 50)
    map = map + geom_path(data=b, aes(x=long,y=lat,group=group), colour="black", alpha=0.5)
    print(map)
  }, height=1000, width=1500)
})
