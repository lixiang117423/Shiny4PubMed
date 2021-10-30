navbarPage(
  "DownLoad",
  tabPanel(h4("Parameter Setting"),
           width = NULL,
           #height = 920,
           #title = "Download Module",
           status = "danger",
           solidHeader = TRUE,
           collapsible = TRUE,
           background = NULL,
           
           # 批量检索
           fileInput("upload_data",
                     label = h4("Upload Data"),
                     accept = c(".csv",".txt"),
                     buttonLabel = "View ... "),
           
           # 上传检索对象
           textInput("query",
                     label = h4("Query Input"),
                     value = "COVID 19"
           ),
           
           # 检索类型
           br(),
           selectInput("query_type",
                       label = h4("Query Type"),
                       choices = c(
                         "Author" = "author",
                         "Journal" = "Journal",
                         "Title/Abstract" = "Title/Abstract"
                       )),
           
           # 开始时间
           br(),
           textInput("time_start",
                     label = h4("Start Time"),
                     value = "1900-01-01"),
           
           # 终止时间
           br(),
           textInput("time_end",
                     label = h4("To Time"),
                     value = stringr::str_sub(Sys.time(),1,10)),
           
           # 过滤条件
           br(),
           selectInput("filter_by",
                       label = h4("Filter By"),
                       choices = c(
                         "None" = "none",
                         "Author" = "Authosss(s)",
                         "Journal" = "Journal",
                         "Affiliation" = "Affiliation"
                       )),
           
           # 过滤字符
           br(),
           textInput("filter_word",
                     label = h4("Filter Word"),
                     value = "test"),
           
           # 提交按钮
           fluidRow(
             column(
               width = 1,
               actionButton("submit",
                            label = h4("Submit"),
                            width = 100,
                            icon = NULL
               )
             ),
             
             # 下载结果
             column(
               width = 1,
               #offset = 0.5,
               downloadButton('download_zip',
                              label = h4('Download'),
                              width = 100)
             )
           ),
  tabPanel(h4("Search Preview"),
           width = NULL,
           #height = 920,
           #title = "Preview",
           status = "warning",
           solidHeader = TRUE,
           collapsible = TRUE,
           background = NULL,
           br(),
           dataTableOutput("doanload_preview"))
))