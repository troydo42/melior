## Gmail OAUTH
library(gmailr)
library(mboxr)
library(mongolite)
library(stringr)

remotes::install_github("rich-iannone/blastula")
clientID <- "523368976811-6qd08vrl9sekpdal583t99hs3467o7fi.apps.googleusercontent.com"
clientSecret <- "2MDr5xzN-ty32K7OGKutFzu0"

## Search Messages from Email
get_email <- function(term){
  search_results <- messages(search = term, num_results=100)
  messages <- search_results[[1]][["messages"]]
  length <- length(messages)
  messages_df <- data.frame(
    matrix(
      unlist(messages),
      nrow=length
    ),
    stringsAsFactors = FALSE
  )
  
  for(i in c(1:length)){
    print(i)
    try (
      message_body <- body(gmailr::message(messages_df$X1[i]))
    )
    messages_df$body[i] <- gsub('[\n\r]', ' ', message_body)
  } 
  return(messages_df)
}

## Send Email
send_email <- function(from, to, subject, body){
  email_content <- mime(
    from=from,
    to=to, 
    subject=subject, 
    body=body
  )
  send_message(email_content)
}

## Parse Email from Gmail
parse_email <- function(mbox_file){
  parsed <- read_mbox(mbox_file)
}

# Insert to Mongo
insertMongo <- function(data, collection) {
  db_url <- paste0("mongodb+srv://troydo42:milkyway42@melior-gebrv.mongodb.net/", collection,"?retryWrites=true")
  con <- mongo(collection, url = db_url)
  con$insert(data)
}

## Remove NA from our list
removeNA <- function(data){
  data <- str_remove(data,"NA")
  return(data)
}
