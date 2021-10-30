# 读取用户输入的数据并保存
user_data_seqrch <- eventReactive(input$submit,{
  if (input$submit > 0) {
    if (input$upload_data$datapath != "") {
      table.blast <- fread(input$upload_data$datapath,
                           header = FALSE,
                           stringsAsFactors = TRUE,
                           encoding = "UTF-8"
      )
    }
  }
  table.blast <<- table.blast
})

# 展示数据
output$doanload_preview <- renderDataTable(df.preview(),
  options = list(pageLength = 20)
)

df.preview <- eventReactive(input$submit, {
  if (input$submit > 0) {

    # 清空结果文件夹
    file.remove("./UserData/user.upload.txt")
    file.remove("./UserResults/user.result.txt")
    
    # 保存用户数据
    if (input$upload_data$datapath != "") {
      fwrite(user_data_seqrch(),
             file = "./UserData/user.upload.txt",
             row.names = FALSE, col.names = FALSE, quote = FALSE
      )
    }
    
    # 开始运行函数
    source("./main/PubMed.R")
    
    df.input = user_data_seqrch()
    
    res_all = NULL

    if (input$upload_data$datapath != "") {
      for (i in unique(df.input$V1)) {
        res_temp = extractPubMed(queryInput = i, queryType = input$query_type)
        res_all = rbind(res_all, res_temp)
      }
    }else{
      res_all = extractPubMed(queryInput = input$query, queryType = ionput$query_type)
    }
    
    # 筛选
    res_all = res_all %>% 
      dplyr::mutate(Authors_temp = tolower(Authors)) %>% 
      dplyr::mutate(Authors_temp = stringr::str_replace_all(Authors," ",""))

     }
  df
})

# 下载数据
output$download_zip <- downloadHandler(
  filename = function() {
    "Your.results.zip"
  },
  content = function(file) {
    file.copy("./UserResults/Your.results.zip", file)
  }
)
