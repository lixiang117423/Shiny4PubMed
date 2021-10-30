# source需要的安装包
source("./main/global.R")$value

# 定义颜色
style <- "color: #fff; background-color: 	#B22222; border-color: #2e6da4"

# 构建选项卡
sidebar <- dashboardSidebar(
  width = 230,
  sidebarMenu(
    id = "tabs",
    style = "position: relative; overflow: visible;",
    color = "olive",
    tags$style(
      ".tabname {
      font-size: 20px;
      #font-weight: bold;
      color: white;
    }
    #element {
      color: red;
    }
    "
    ),

    # Introduction Item
    menuItem(p(class = "tabname", "Search"),
      tabName = "search"
      #,icon = icon("bullhorn")
    )
  )
)

# 选项卡细节
body <- dashboardBody(
  tabItems(
    tabItem(
      tabName = "search",
      source("./main/search_ui.R", local = TRUE, encoding = "UTF-8")$value
    )
  )
)

# 合并选项卡及其细节
ui <- dashboardPage(
  skin = "green",
  dashboardHeader(title = "Shiny4PubMed"),
  sidebar = sidebar,
  body = body
)
