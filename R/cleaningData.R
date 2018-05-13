# Creating a Corpus
createCorpus <- function(data){
  require('tm')
  file <- sprintf("data/%s.rds", data)
  text <- readRDS(file)
  de_corpus <- VCorpus(VectorSource(text))

  # Removing profanity.

  de_corpus <- tm_map(de_corpus, function(x) iconv(x, from='UTF-8', to="latin1"))
  de_corpus <- tm_map(de_corpus, removeNumbers)
  de_corpus <- tm_map(de_corpus, removePunctuation)
  de_corpus <- tm_map(de_corpus, stripWhitespace)
  de_corpus <- tm_map(de_corpus, PlainTextDocument)

  saveRDS(de_corpus, sprintf("data/%s.corpus.rds",data))
}

# Creating a document-term matrix.

createDTM <- function(corpus, ngrams){
  require('tm')
  de_corpus <- readRDS(sprintf("data/%s.corpus.rds",corpus))
  Tokenizer <- function(x) unlist(lapply(ngrams(words(x), ngrams), paste, collapse = " "), use.names = FALSE)
  de_tdm <- TermDocumentMatrix(de_corpus,  control=list(tokenize=Tokenizer))
  saveRDS(de_tdm, sprintf("data/%s.dtm.%i.rds",corpus,ngrams))
}

# Creating set of frequent n-grams

createTF <- function(corpus, ngrams){
  require('tm')
  require('stringi')
  de_dtm <- readRDS(sprintf("data/%s.dtm.%i.rds",corpus,ngrams))
  de_ft = findMostFreqTerms(de_dtm,min(c(nTerms(de_dtm)*0.5,2000*2**ngrams)))
  remove(de_dtm)
  de_ft_splitted = stri_split_fixed(names(de_ft$`character(0)`)," ",simplify = TRUE)
  freq <- unname(de_ft$`character(0)`)
  de_tf <- cbind(de_ft_splitted,freq,deparse.level = 0)
  saveRDS(de_tf, sprintf("data/%s.tf.%i.rds",corpus,ngrams))
}

# Joining frequecy of words

createTotalTF <- function(corpus){
  de_tf_4 <- readRDS(sprintf("data/%s.tf.%i.rds",corpus,4))
  de_tf_3 <- readRDS(sprintf("data/%s.tf.%i.rds",corpus,3))
  de_tf_2 <- readRDS(sprintf("data/%s.tf.%i.rds",corpus,2))
  de_tf_1 <- readRDS(sprintf("data/%s.tf.%i.rds",corpus,1))
  completeTF <- function(tf){
    cbind(matrix(rep.int(NA,dim(tf)[1]),nrow = dim(tf)[1], ncol = 5 - dim(tf)[2]),tf)
  }
  de_tf_total <- rbind(de_tf_4,completeTF(de_tf_3),completeTF(de_tf_2),completeTF(de_tf_1))
  saveRDS(de_tf_total, sprintf("data/%s.tf_total.rds",corpus))
}
