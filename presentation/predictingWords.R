tf_total <- readRDS("data/train.tf_total.rds")

require(stringi)
require(tm)

WORDS_TO_RECOMMEND <- 3

# Start sentence
extractLastWords <- function(text){
  last_words <- words(stri_extract(text, regex = "\\w+( \\w+){0,2}$"))
  last_words <-append(rep.int(NA,max(3 - length(last_words),0)),last_words)
  return(last_words)
}

# Start sentence
IsStartOfSentence <- function(text){
  if (length(text) == 0)
    return(TRUE)
  text <- stri_trim(text, pattern = "\\P{Wspace}")
  if (stri_extract_last(text,regex = "[\\W+]") %in% c("!",","))
    return(TRUE)
  return(FALSE)
}

# Finding W in N-Grams
find3SeqWords <- function(word_3,word_2,word_1){
  tf_filter <- subset(tf_total, tf_total[,3] == word_1 & tf_total[,2] == word_2
                      & tf_total[,1] == word_3 )
  return(tf_filter[0:min(c(dim(tf_filter)[1],3)),4])
}

# Finding W only with last word
find2SeqWords <- function(word_2,word_1){
  tf_filter <- subset(tf_total, tf_total[,3] == word_1 & tf_total[,2] == word_2
                      & is.na(tf_total[,1]) == TRUE)
  return(tf_filter[0:min(c(dim(tf_filter)[1],3)),4])
}

# Finding W only with last word
find1SeqWords <- function(word_1){
  tf_filter <- subset(tf_total, tf_total[,3] == word_1 & is.na(tf_total[,2]) == TRUE
                      & is.na(tf_total[,1]) == TRUE)
  return(tf_filter[0:min(c(dim(tf_filter)[1],3)),4])
}


# Finding partial matches N-Grams
find2Words <- function(word_3,word_2,word_1){
  tf_filter <- subset(tf_total,
                      (tf_total[,2] == word_2 & tf_total[,1] == word_3) |
                      (tf_total[,1] == word_3 & tf_total[,3] == word_1) )
  return(tf_filter[0:min(c(dim(tf_filter)[1],3)),4])
}


# Most common words
mostCommonWords <- function(){
  tf_filter <- subset(tf_total, is.na(tf_total[,3]))
  return(tf_filter[0:min(c(dim(tf_filter)[1],3)),4])
}

# Predict next word
nextWords <- function(text){
  if (IsStartOfSentence(text) == TRUE)
    return(mostCommonWords())
  else{
    word_3 <- extractLastWords(text)[1]
    word_2 <- extractLastWords(text)[2]
    word_1 <- extractLastWords(text)[3]
    next_words <- find3SeqWords(word_3,word_2,word_1)
    if (length(next_words) < WORDS_TO_RECOMMEND)
      next_words <-unique(c(next_words,find2SeqWords(word_2,word_1)))
    if (length(next_words) < WORDS_TO_RECOMMEND)
      next_words <-unique(c(next_words,find1SeqWords(word_1)))
    if (length(next_words) < WORDS_TO_RECOMMEND)
      next_words <-unique(c(next_words,find2Words(word_3,word_2,word_1)))
    if (length(next_words) < WORDS_TO_RECOMMEND)
      next_words <-unique(c(next_words,mostCommonWords()))
  }
  return(next_words[1:WORDS_TO_RECOMMEND])
}

