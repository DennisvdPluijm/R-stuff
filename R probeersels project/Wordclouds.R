library(magrittr)

source("wordcloudfunctions.R")

# #examples for plain text
troonrede2018 <- readLines('troonrede2018.txt')
TrumpUN2018 <- readLines('Trump_UN_GeneralAssembly2018.txt')

# #example in case of data table
# branches_tbl <- table(Policies_Dataset$Branche_description)



dtm_troonrede <- CreateDTM(troonrede2018, "dutch")
head(dtm_troonrede, 10)

dtm_trump <- CreateDTM(TrumpUN2018)
head(dtm_trump, 10)

#type: plaintext or table
#if plaintext, first CreateDRM;
#if table, use frequency_table
# CreateWordcloud(input = troonrede2018, type = 'text')
# CreateWordcloud(input = Dutchnames, type = 'table')

#troonrede
CreateWordcloud(words_input = dtm_troonrede$word, freq_input = dtm_troonrede$freq)
#Trump
CreateWordcloud(words_input = dtm_trump$word, freq_input = dtm_trump$freq)

# #Most common Dutch boys and girls names
#As an example, first create an arbitrary data frame (column) with unarranged levels/factors
boys_names_2018 <- matrix(c(1:10, 
                            c("Lucas","Levi","Finn","Sem","Noah","Daan","Luuk","Bram","Mees","Milan"), 
                            c(681,641,634,633,624,619,596,571,568,558)),10,3) %>% 
  as.data.frame(stringsAsFactors = F)
colnames(boys_names_2018) <- c("Place","Name","Frequency")

girls_names_2018 <- matrix(c(1:20, 
                            c("Julia","Emma","Sophie","Tess","Zoë","Mila","Anna","Sara","Eva","Noor",
                              "Nora","Evi","Saar","Lotte","Lieke","Yara","Olivia","Liv","Lauren","Nova"), 
                            c(797,704,677,669,659,632,550,541,530,516,516,513,500,478,463,462,461,444,439,412)),20,3) %>% 
  as.data.frame(stringsAsFactors = F)
colnames(girls_names_2018) <- c("Place","Name","Frequency")

li_boys_names <- character()
li_girls_names <- character()
for (list in c(li_boys_names, li_girls_names)) {
  paste0(gsub(pattern = "li_", "", deparse(substitute(li_boys_names))),"_2018")
  get(paste0(gsub(pattern = "li_", "", deparse(substitute(li_boys_names))),"_2018"))$Name[1]
  deparse(substitute(lijst[1]))
  for (i in 1:nrow(boys_names_2018)){
    list <- append(list, rep(boys_names_2018$Name[i], boys_names_2018$Frequency[i]))
  }  
}

df_boys <- li_boys_names %>%
  sample(., length(.)) %>%
  as.data.frame()
freqtbl_boys <- table(df_boys)

wordcloud(words = names(freqtbl_boys), 
          freq = freqtbl_boys, 
          #scale = c(4,.1), 
          random.order = T, 
          random.color = F, 
          rot.per = 0.1, 
          colors = brewer.pal(8, "Dark2"), 
          use.r.layout = T)

