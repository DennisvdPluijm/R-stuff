library(magrittr)
library(wordcloud)
# advised but not required if you have a (data) table instead of a document
library(tm)         #for text mining, to build a corpus
library(SnowballC)  #for text stemming, reducing words to root form

troonrede2018 <- readLines('troonrede2018.txt')
TrumpUN2018 <- readLines('Trump_UN_GeneralAssembly2018.txt')
# #example in case of data table
# branches_tbl <- table(Policies_Dataset$Branche_description)

# text transformation
#docs <- tm_map(docs, PlainTextDocument)        #required if not in plain text already
#docs <- tm_map(docs, gsub(pattern, " ", "/"))  #optionally replace special characters to e.g. spaces

#TODO surpress warnings
CreateDTM <- function(inputtext, s_language = "english"){
  text_Corpus <- Corpus(VectorSource(inputtext))                # Create a corpus
  text_Corpus %<>% tm_map(content_transformer(tolower))         # Convert the text to lower case
  text_Corpus %<>%  tm_map(removeNumbers)                       # Remove numbers
  text_Corpus %<>% tm_map(removeWords, stopwords(s_language))   # Remove common stopwords, language specific
  #text_Corpus %<>% tm_map(removeWords, c("blabla1", "blabla2")) # Remove your own stop words, TODO: include as argument
  text_Corpus %<>% tm_map(removePunctuation)                    # Remove punctuations
  text_Corpus %<>% tm_map(stripWhitespace)                      # Eliminate extra white spaces
  
  # stemming does not work well for wordclouds, not for English or Dutch: https://snowballstem.org/
  # if(s_language == "english"){
  #   text_Corpus <- tm_map(text_Corpus, stemDocument)            # Text stemming, to reduce words to their root
  # } 
  
  # Document-term matrix
  dtm <- TermDocumentMatrix(text_Corpus) %>%
    as.matrix
  df <- sort(rowSums(dtm), decreasing = TRUE) %>%
    data.frame(word = names(.), freq = .)
  # returns a df based on named num vector
  
  return(df)
}

dtm_troonrede <- CreateDTM(troonrede2018, "dutch")
head(dtm_troonrede, 10)

dtm_trump <- CreateDTM(TrumpUN2018)
head(dtm_trump, 10)

#set.seed(1)
par(mar = rep(0, 4))
wordcloud(words = dtm_troonrede$word, 
          freq = dtm_troonrede$freq, 
          min.freq = 2,
          max.words = 200,
          #scale = c(4,.1),
          random.order = FALSE,
          random.color = FALSE,
          rot.per = 0.35, 
          colors = brewer.pal(8, "Dark2"))
wordcloud(words = dtm_trump$word, 
          freq = dtm_trump$freq, 
          min.freq = 2,
          max.words = 200,
          #scale = c(4,.1),
          random.order = FALSE,
          random.color = FALSE,
          rot.per = 0.35, 
          colors = brewer.pal(8, "Dark2"))

# for tables
wordcloud(words = names(frequency_table), 
          freq = frequency_table, 
          scale = c(4,.1), 
          random.order = T, 
          random.color = F, 
          rot.per = 0.1, 
          colors = brewer.pal(8, "Dark2"), 
          use.r.layout = T)
