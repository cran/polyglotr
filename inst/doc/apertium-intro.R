## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ----setup--------------------------------------------------------------------
# library(polyglotr)

## ----basic-usage--------------------------------------------------------------
# # Basic translation from English to Spanish
# result <- apertium_translate(
#   text = "Hello, world!",
#   target_language = "es",
#   source_language = "en"
# )
# print(result)
# 
# # Translation from Spanish to English
# result <- apertium_translate(
#   text = "Hola, mundo!",
#   target_language = "en",
#   source_language = "es"
# )
# print(result)

## ----list-pairs, eval=FALSE---------------------------------------------------
# # Get available language pairs
# pairs <- apertium_get_language_pairs()
# 
# # The response contains an array of objects like:
# # {"sourceLanguage":"en","targetLanguage":"es"}
# head(pairs, 10)
# 

## ----multiple-texts-----------------------------------------------------------
# # Vector of texts to translate
# texts <- c(
#   "Good morning",
#   "How are you?",
#   "Thank you very much",
#   "See you later"
# )
# 
# # Translate each text
# translations <- sapply(texts, function(text) {
#   apertium_translate(
#     text = text,
#     target_language = "es",
#     source_language = "en"
#   )
# })
# 
# # Display results
# data.frame(
#   English = texts,
#   Spanish = translations,
#   stringsAsFactors = FALSE
# )

## ----custom-host--------------------------------------------------------------
# # Using default host (https://apertium.org/apy)
# apertium_translate("Hello", "es", "en")
# 

## ----error-handling-----------------------------------------------------------
# # Example of handling potential errors
# tryCatch({
#   result <- apertium_translate("Hello", "invalid-lang", "en")
#   print(result)
# }, error = function(e) {
#   cat("Translation error:", e$message, "\n")
# })

## ----comparison---------------------------------------------------------------
# # Compare translations across services
# text <- "The weather is beautiful today"
# 
# # Apertium translation
# apertium_result <- apertium_translate(text, "es", "en")
# 
# # MyMemory translation (also free, but different approach)
# mymemory_result <- mymemory_translate(text, "es", "en")
# 
# data.frame(
#   Service = c("Apertium", "MyMemory"),
#   Translation = c(apertium_result, mymemory_result),
#   stringsAsFactors = FALSE
# )

## ----best-practices-----------------------------------------------------------
# # Example of robust translation function
# safe_apertium_translate <- function(text, target_lang, source_lang, max_retries = 3) {
#   for (attempt in 1:max_retries) {
#     tryCatch({
#       result <- apertium_translate(text, target_lang, source_lang)
#       return(result)
#     }, error = function(e) {
#       if (attempt == max_retries) {
#         stop("Translation failed after ", max_retries, " attempts: ", e$message)
#       }
#       Sys.sleep(1)  # Wait before retry
#     })
#   }
# }
# 
# # Usage
# result <- safe_apertium_translate("Hello world", "es", "en")
# print(result)

