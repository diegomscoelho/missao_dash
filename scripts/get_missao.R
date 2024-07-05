#################
# GET LIVE DATA #
#################

old_data <- read.csv("./data/mbl.csv", header = T)

# POST
library(httr)
library(dplyr)
library(stringr)

url <- GET("https://sapf.tse.jus.br/sapf-consulta/paginas/principal")
ck <- cookies(url)

# Regular expression to extract the value
pattern <- 'name="javax.faces.ViewState" id="[^"]+" value="([^"]+)"'

# Extract the value
matches <- str_match(content(url, "text"), pattern)

# The extracted value is in the second element of the matches
view_state_value <- matches[2]

# URL
url <- "https://sapf.tse.jus.br/sapf-consulta/paginas/principal"

# Headers
headers <- c(
  'Accept' = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
  'Accept-Language' = 'en-US,en;q=0.9',
  'Cache-Control' = 'max-age=0',
  'Connection' = 'keep-alive',
  'Content-Type' = 'application/x-www-form-urlencoded',
  'Cookie' = paste0(ck[1,]$name,"=",ck[1,]$value,";",
                    ck[2,]$name,"=",ck[2,]$value,";",
                    ck[3,]$name,"=",ck[3,]$value,";",
                    ck[4,]$name,"=",ck[4,]$value),
  'Origin' = 'https://sapf.tse.jus.br',
  'Referer' = 'https://sapf.tse.jus.br/',
  'Sec-Fetch-Dest' = 'document',
  'Sec-Fetch-Mode' = 'navigate',
  'Sec-Fetch-Site' = 'same-origin',
  'Sec-Fetch-User' = '?1',
  'Upgrade-Insecure-Requests' = '1',
  'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36',
  'sec-ch-ua' = '"Not/A)Brand";v="8", "Chromium";v="126", "Google Chrome";v="126"',
  'sec-ch-ua-mobile' = '?0',
  'sec-ch-ua-platform' = '"Windows"'
)

data <- list(
  'j_idt25' = 'j_idt25',
  'PrincipalForm' = 'PrincipalForm',
  'javax.faces.ViewState' = view_state_value
)

# Perform the POST request
response <- POST(url, add_headers(.headers = headers), body = data, encode = "form")

# URL
url <- "https://sapf.tse.jus.br/sapf-consulta/paginas/partidoFormacao/listar"

# Headers
headers <- c(
  'Accept' = 'application/xml, text/xml, */*; q=0.01',
  'Accept-Language' = 'en-US,en;q=0.9',
  'Connection' = 'keep-alive',
  'Content-Type' = 'application/x-www-form-urlencoded; charset=UTF-8',
  'Cookie' = paste0(ck[1,]$name,"=",ck[1,]$value,";",
                    ck[2,]$name,"=",ck[2,]$value,";",
                    ck[3,]$name,"=",ck[3,]$value,";",
                    ck[4,]$name,"=",ck[4,]$value),
  'Faces-Request' = 'partial/ajax',
  'Origin' = 'https://sapf.tse.jus.br',
  'Referer' = 'https://sapf.tse.jus.br/',
  'Sec-Fetch-Dest' = 'empty',
  'Sec-Fetch-Mode' = 'cors',
  'Sec-Fetch-Site' = 'same-origin',
  'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36',
  'X-Requested-With' = 'XMLHttpRequest',
  'sec-ch-ua' = '"Not/A)Brand";v="8", "Chromium";v="126", "Google Chrome";v="126"',
  'sec-ch-ua-mobile' = '?0',
  'sec-ch-ua-platform' = '"Windows"'
)

# Form Data
form_data <- list(
  'javax.faces.partial.ajax' = 'true',
  'javax.faces.source' = 'partidoDataList',
  'javax.faces.partial.execute' = 'partidoDataList',
  'javax.faces.partial.render' = 'partidoDataList',
  'partidoDataList' = 'partidoDataList',
  'partidoDataList_pagination' = 'true',
  'partidoDataList_first' = '0',
  'partidoDataList_rows' = '25',
  'partidoDataList_skipChildren' = 'true',
  'partidoDataList_encodeFeature' = 'true',
  'ListarPartidosForm' = 'ListarPartidosForm',
  'partidoDataList_rppDD' = '25',
  'javax.faces.ViewState' = view_state_value
)

# Perform the POST request
response <- POST(url, add_headers(.headers = headers), body = form_data, encode = "form")

########

headers <- c(
  'Accept' = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
  'Accept-Language' = 'en-US,en;q=0.9',
  'Cache-Control' = 'max-age=0',
  'Connection' = 'keep-alive',
  'Content-Type' = 'application/x-www-form-urlencoded',
  'Cookie' = paste0(ck[1,]$name,"=",ck[1,]$value,";",
                    ck[2,]$name,"=",ck[2,]$value,";",
                    ck[3,]$name,"=",ck[3,]$value,";",
                    ck[4,]$name,"=",ck[4,]$value),
  'Origin' = 'https://sapf.tse.jus.br',
  'Referer' = 'https://sapf.tse.jus.br/',
  'Sec-Fetch-Dest' = 'document',
  'Sec-Fetch-Mode' = 'navigate',
  'Sec-Fetch-Site' = 'same-origin',
  'Sec-Fetch-User' = '?1',
  'Upgrade-Insecure-Requests' = '1',
  'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36',
  'sec-ch-ua' = '"Not/A)Brand";v="8", "Chromium";v="126", "Google Chrome";v="126"',
  'sec-ch-ua-mobile' = '?0',
  'sec-ch-ua-platform' = '"Windows"'
)

# Data
form_data <- list(
  'ListarPartidosForm' = 'ListarPartidosForm',
  'partidoDataList_rppDD' = '25',
  'javax.faces.ViewState' = view_state_value,
  'partidoDataList:12:j_idt36' = 'partidoDataList:12:j_idt36'
)

# Perform the POST request
response <- POST(url, add_headers(.headers = headers), body = form_data, encode = "form")

# Check the response
response <- content(response, "text")

##########

# Define the pattern
pattern <- "Total de aptos:\\s*(\\d+)"

# Find all matches
matches <- str_match_all(response, pattern)

# Extract the numbers
numbers <- unlist(lapply(matches, function(x) x[,2]))
votos <- as.numeric(numbers[-1])
abbrev_state <- c("AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO",
                  "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI",
                  "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO")

df <- data.frame(abbrev_state, votos, Sys.Date())
colnames(df) <- c("ABBREV_STATE", "APO_N","DATE")

## Remove today's data

old_data$DATE <- as.Date(old_data$DATE)
df <- old_data %>% filter(DATE != Sys.Date()) %>% rbind(., df)


## Store file
write.csv(df, file = paste0("./data/mbl.csv"), row.names = F, quote = F)