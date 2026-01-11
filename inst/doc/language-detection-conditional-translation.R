## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ----setup--------------------------------------------------------------------
# library(polyglotr)
# library(dplyr)
# library(tibble)
# library(purrr)
# 

## ----basic_detection----------------------------------------------------------
# # Sample texts in different languages
# sample_texts <- c(
#   "Hello, how are you today?",           # English
#   "Bonjour, comment allez-vous?",        # French
#   "Hola, ¿cómo estás hoy?",             # Spanish
#   "Guten Tag, wie geht es Ihnen?",      # German
#   "Ciao, come stai oggi?"               # Italian
# )
# 
# # Detect languages
# detected_languages <- sapply(sample_texts, language_detect)
# print("Detected languages:")
# print(detected_languages)

## ----conditional_translation--------------------------------------------------
# translate_if_not_english <- function(text, target_language = "en") {
#   # Detect language of the input text
#   detected_lang <- language_detect(text)
# 
#   # Check if the detected language is English
#   is_english <- grepl("en", detected_lang, ignore.case = TRUE)
# 
#   if (is_english) {
#     # Return original text if already English
#     return(list(
#       original = text,
#       translated = text,
#       was_translated = FALSE,
#       detected_language = detected_lang
#     ))
#   } else {
#     # Translate to English if not English
#     translated_text <- google_translate(text, target_language = target_language, source_language = "auto")
#     return(list(
#       original = text,
#       translated = translated_text,
#       was_translated = TRUE,
#       detected_language = detected_lang
#     ))
#   }
# }
# 
# # Test the function
# test_text_fr <- "Bonjour, j'aimerais acheter un billet."
# result <- translate_if_not_english(test_text_fr)
# 
# print("Conditional translation result:")
# print(paste("Original:", result$original))
# print(paste("Translated:", result$translated))
# print(paste("Was translated:", result$was_translated))
# print(paste("Detected language:", result$detected_language))

## ----mixed_language_tibble----------------------------------------------------
# # Create a dataset with mixed languages (typical of user-generated content)
# mixed_data <- tibble(
#   id = 1:8,
#   user_feedback = c(
#     "Great product, very satisfied!",                    # English
#     "Excelente producto, muy satisfecho!",               # Spanish
#     "Produit fantastique, je le recommande!",            # French
#     "This service exceeded my expectations.",            # English
#     "Der Service war wirklich hervorragend.",            # German
#     "Servizio eccellente, davvero impressionante!",     # Italian
#     "The delivery was fast and reliable.",               # English
#     "La livraison était rapide et fiable."               # French
#   ),
#   rating = c(5, 5, 4, 5, 4, 5, 4, 4),
#   category = rep(c("product", "service"), 4)
# )
# 
# print("Original mixed-language dataset:")
# print(mixed_data)

## ----detect_and_translate-----------------------------------------------------
# # Function to process each text entry
# process_feedback <- function(text) {
#   result <- translate_if_not_english(text)
#   return(tibble(
#     original_text = result$original,
#     english_text = result$translated,
#     was_translated = result$was_translated,
#     detected_language = result$detected_language
#   ))
# }
# 
# # Apply to all feedback entries
# processed_results <- purrr::map_dfr(mixed_data$user_feedback, process_feedback)
# 
# # Combine with original data
# enhanced_data <- bind_cols(mixed_data, processed_results)
# 
# print("Enhanced dataset with language detection and translation:")
# print(enhanced_data)

## ----advanced_tidyverse-------------------------------------------------------
# library(stringr)
# 
# # Enhanced processing function with more details
# enhanced_language_processing <- function(df, text_column) {
#   df %>%
#     mutate(
#       # Detect language for each text entry
#       detected_lang = map_chr(!!rlang::sym(text_column),
#                              ~ tryCatch(language_detect(.x), error = function(e) "unknown")),
# 
#       # Determine if translation is needed
#       needs_translation = !str_detect(detected_lang, "en"),
# 
#       # Translate only non-English text
#       english_text = map2_chr(!!rlang::sym(text_column), needs_translation,
#                              ~ if (.y) {
#                                tryCatch(google_translate(.x, target_language = "en"),
#                                        error = function(e) .x)
#                              } else {
#                                .x
#                              }),
# 
#       # Add translation confidence/status
#       translation_status = case_when(
#         detected_lang == "unknown" ~ "detection_failed",
#         !needs_translation ~ "already_english",
#         english_text != !!rlang::sym(text_column) ~ "translated",
#         TRUE ~ "translation_failed"
#       )
#     )
# }
# 
# # Apply enhanced processing
# result_data <- enhanced_language_processing(mixed_data, "user_feedback")
# 
# print("Advanced processing results:")
# print(result_data %>% select(id, detected_lang, needs_translation, translation_status))

## ----batch_filtering----------------------------------------------------------
# # Create larger sample dataset
# large_dataset <- tibble(
#   id = 1:20,
#   content = c(
#     # Mix of English and non-English content
#     "Amazing service quality",                           # EN
#     "Fantástico servicio al cliente",                   # ES
#     "Service client exceptionnel",                      # FR
#     "Great user experience",                            # EN
#     "Esperienza utente eccellente",                     # IT
#     "Ausgezeichnete Benutzerführung",                  # DE
#     "Fast shipping and delivery",                       # EN
#     "Livraison rapide et efficace",                    # FR
#     "Excellent product quality",                        # EN
#     "Qualità del prodotto superiore",                  # IT
#     "Easy to use interface",                           # EN
#     "Interfaz muy fácil de usar",                      # ES
#     "Highly recommend this product",                    # EN
#     "Je recommande vivement ce produit",               # FR
#     "Outstanding customer support",                     # EN
#     "Soporte al cliente sobresaliente",                # ES
#     "Very satisfied with purchase",                     # EN
#     "Sehr zufrieden mit dem Kauf",                     # DE
#     "Will definitely buy again",                       # EN
#     "Sicuramente acquisterò di nuovo"                  # IT
#   ),
#   timestamp = Sys.time() + sample(-1000:1000, 20),
#   priority = sample(c("high", "medium", "low"), 20, replace = TRUE)
# )
# 
# # Efficient batch processing workflow
# batch_process_languages <- function(df, text_col, batch_size = 5) {
#   # First, detect languages for all entries
#   df_with_detection <- df %>%
#     mutate(
#       row_id = row_number(),
#       detected_lang = map_chr(!!rlang::sym(text_col),
#                              ~ tryCatch(language_detect(.x), error = function(e) "en")),
#       is_english = str_detect(detected_lang, "en")
#     )
# 
#   # Separate English and non-English content
#   english_content <- df_with_detection %>% filter(is_english)
#   non_english_content <- df_with_detection %>% filter(!is_english)
# 
#   # Process non-English content in batches
#   if (nrow(non_english_content) > 0) {
#     non_english_content <- non_english_content %>%
#       mutate(
#         batch_id = ceiling(row_number() / batch_size),
#         english_text = map_chr(!!rlang::sym(text_col),
#                               ~ tryCatch(google_translate(.x, target_language = "en"),
#                                         error = function(e) .x))
#       )
#   } else {
#     non_english_content <- non_english_content %>%
#       mutate(batch_id = integer(0), english_text = character(0))
#   }
# 
#   # For English content, keep original text
#   english_content <- english_content %>%
#     mutate(
#       batch_id = NA_integer_,
#       english_text = !!rlang::sym(text_col)
#     )
# 
#   # Combine results
#   result <- bind_rows(english_content, non_english_content) %>%
#     arrange(row_id) %>%
#     select(-row_id)
# 
#   return(result)
# }
# 
# # Apply batch processing
# processed_large <- batch_process_languages(large_dataset, "content", batch_size = 3)
# 
# # Summary statistics
# summary_stats <- processed_large %>%
#   summarise(
#     total_entries = n(),
#     english_entries = sum(is_english),
#     translated_entries = sum(!is_english),
#     translation_rate = mean(!is_english),
#     unique_languages = n_distinct(detected_lang)
#   )
# 
# print("Processing summary:")
# print(summary_stats)
# 
# print("Sample of processed data:")
# print(processed_large %>%
#       select(id, detected_lang, is_english, content, english_text) %>%
#       head(10))

