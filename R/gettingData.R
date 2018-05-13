

# Getting data
getData <- function(zipfile){
  f <- file.path(getwd(), zipfile)
  
  # Reading the files
  for (src in c('blogs', 'news', 'twitter')) {
    file <- sprintf("final/de_DE/de_DE.%s.txt",src)
    text <- read.table(unz(f,file), header=F, sep = "\n",stringsAsFactors = F,encoding="UTF-8")   
    saveRDS(text, sprintf("data/%s_org.rds", src))
  }
}


# Basic Statistics
statText <- function(data){
  leng <- c()
  n_words <- c()
  m_words <- c()
  size<-c()
  for (src in data) {
    library(stringi)
    file <- sprintf("data/%s.rds", src)
    text <- readRDS(file)
    leng[src] <- length(text)
    words <- stri_count_words(text$V1)
    n_words[src] <- sum(words) 
    m_words[src] <- mean(words) 
    size[src] <- file.info(file)$size/1024^2
    remove(text)
  }
  basic_stats <- data.frame(source = data,
                            file_size_MB = size,
                            lines = leng,
                            num_words = n_words,
                            mean_num_words = m_words)
  return(basic_stats)
}


# Sampling the data

getSample <- function(porc_train, porc_test){
  set.seed(85)
  de_train <- data.frame()
  de_test <- data.frame()
  for (src in c('blogs', 'news', 'twitter')){
    text <- readRDS(sprintf("data/%s_org.rds", src))
    de_train <-rbind(de_train,data.frame(V1=text$V1[sample(length(text$V1), round(length(text$V1)*porc_train/100))],stringsAsFactors = FALSE))
    de_test <- rbind(de_test,data.frame(V1=text$V1[sample(length(text$V1), round(length(text$V1)*porc_test/100))],stringsAsFactors = FALSE))
    remove(text)
  }
  saveRDS(de_train, "data/train.rds")
  saveRDS(de_test, "data/test.rds")
}

