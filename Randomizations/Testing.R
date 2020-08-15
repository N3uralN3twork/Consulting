myTitlePanel <- function (title, windowTitle = title, color = "coral") {
  css <- paste(paste0("background-color:", color),
               "padding-left: 15px",
               "margin-left: -15px",
               "margin-right: -15px",
               sep = ";")
  tagList(tags$head(tags$title(windowTitle)), 
          h1(title, style = css))
}