# 定义颜色
style <- "color: #fff; background-color: 	#B22222; border-color: #2e6da4"

shinyServer(function(input,output,session){
  source("./main/search_server.R", local = TRUE, encoding = "UTF-8")$value
})