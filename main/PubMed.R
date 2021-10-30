extractPubMed <- function(queryInput, queryType) {
  query <- paste0(queryInput, "[", queryType, "]")

  entrez_id <- get_pubmed_ids(query)
  out.res <- fetch_pubmed_data(entrez_id, format = "xml")

  # 先提取全部文章
  all.in.list <- custom_grep(out.res, "PubmedArticle", "list")

  df.return <- NULL

  for (i in 1:length(all.in.list)) {
    res.temp <- all.in.list[[i]]

    # 提取标题
    title <- custom_grep(res.temp, "ArticleTitle", "char")

    # 提取期刊
    journal <- custom_grep(res.temp, "Title", "char")

    # 提取DOI
    doi <- custom_grep(res.temp, "ELocationID", "char")

    for (d in 1:length(doi)) {
      if (stringr::str_sub(doi[d], 1, 2) == "10") {
        DOI <- doi[d]
      } else {
        next
      }
    }

    # 提取日期
    time <- custom_grep(res.temp, "PubDate", "xml")
    year <- custom_grep(time, "Year", "char")
    month <- custom_grep(time, "Month", "char")
    day <- custom_grep(time, "Day", "char")

    tim.all <- paste0(year, "-", month, "-", day)

    # 提取摘要
    abstract <- custom_grep(res.temp, "AbstractText", "char")

    # 提取作者信息
    authors <- NULL
    affil <- NULL

    authors.list <- custom_grep(res.temp, "Author", "list")

    for (j in 1:length(authors.list)) {
      ForeName <- custom_grep(authors.list[[j]], "ForeName", "char")
      LastName <- custom_grep(authors.list[[j]], "LastName", "char")

      if (j == length(authors.list)) {
        name.temp <- paste0(ForeName, " ", LastName)
      } else {
        name.temp <- paste0(ForeName, " ", LastName, ";")
      }

      authors <- paste0(authors, ";", name.temp)

      affiliation.list <- custom_grep(authors.list[[j]], "Affiliation", "char")

      for (m in 1:length(affiliation.list)) {
        if (m == length(affiliation.list)) {
          affil <- paste0(affil, ";", affiliation.list[m])
        } else {
          affil <- paste0(affil, ";", affiliation.list[m], ";")
        }
      }
    }

    authors <- stringr::str_replace(authors, ";", "")
    authors <- stringr::str_replace_all(authors, ";;", ";")

    affil <- stringr::str_replace(affil, ";", "")

    # 提取关键词
    key.words <- NULL
    keywords <- custom_grep(res.temp, "Keyword", "char")

    for (n in 1:length(keywords)) {
      if (n == length(keywords)) {
        key.words <- paste0(key.words, ",", keywords[n])
      } else {
        key.words <- paste0(key.words, ",", keywords[n], ",")
      }
    }

    key.words <- stringr::str_replace(key.words, ",", "")

    df.res.temp <- data.frame(
      Title = ifelse(is.null(title), " ", title),
      Authors = ifelse(is.null(authors), " ", authors),
      Journal = ifelse(is.null(journal), " ", journal),
      KeyWords = ifelse(is.null(key.words), " ", key.words),
      Abstract = ifelse(is.null(abstract), " ", abstract),
      DOI = ifelse(is.null(DOI), " ", DOI),
      Date = ifelse(is.null(tim.all), " ", tim.all),
      Affiliation = ifelse(is.null(affil), " ", affil)
    )
    df.return <- rbind(df.return, df.res.temp)
  }
}