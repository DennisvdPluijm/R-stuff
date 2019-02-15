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

#TODO: girls
# Julia	797	1
# Emma	704	2
# Sophie	677	3
# Tess	669	4
# Zoë	659	5
# Mila	632	6
# Anna	550	7
# Sara	541	8
# Eva	530	9
# Noor	516	10

li_boys_names <- character()
for (i in 1:nrow(boys_names_2018)){
  li_boys_names <- append(li_boys_names, rep(boys_names_2018$Name[i], boys_names_2018$Frequency[i]))
}
df_boys <- li_boys_names %>%
  sample(., length(.)) %>%
  as.data.frame()
freqtbl_boys <- table(df_boys)



