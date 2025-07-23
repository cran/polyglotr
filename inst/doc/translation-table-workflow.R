## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ----setup--------------------------------------------------------------------
#  library(polyglotr)
#  library(dplyr)

## ----basic_example------------------------------------------------------------
#  # Define phrases to translate
#  ui_phrases <- c("Welcome", "Login", "Password", "Submit", "Cancel", "Help")
#  
#  # Define target languages
#  languages <- c("es", "fr", "de", "it")
#  
#  # Create translation table
#  translation_table <- create_translation_table(ui_phrases, languages)
#  print(translation_table)

## ----api_comparison-----------------------------------------------------------
#  # Enhanced function to support multiple translation APIs
#  create_translation_table_multi_api <- function(words, languages, apis = c("google", "mymemory")) {
#    results <- data.frame(original_word = words)
#  
#    for (language in languages) {
#      for (api in apis) {
#        column_name <- paste0(language, "_", api)
#  
#        if (api == "google") {
#          results[[column_name]] <- sapply(words, function(x) {
#            google_translate(x, target_language = language, source_language = "en")
#          })
#        } else if (api == "mymemory") {
#          results[[column_name]] <- sapply(words, function(x) {
#            mymemory_translate(x, target_language = language, source_language = "en")
#          })
#        }
#      }
#    }
#  
#    return(results)
#  }
#  
#  # Sample phrases for comparison
#  phrases <- c("Good morning", "Thank you very much", "How are you today?")
#  
#  # Create comparison table with multiple APIs
#  comparison_table <- create_translation_table_multi_api(
#    words = phrases,
#    languages = c("fr", "es"),
#    apis = c("google", "mymemory")
#  )
#  
#  print(comparison_table)
#  
#  # You can also use the standard function and add MyMemory translations
#  google_table <- create_translation_table(phrases, c("fr", "es"))
#  
#  # Add MyMemory translations for comparison
#  google_table$fr_mymemory <- sapply(phrases, function(x) {
#    mymemory_translate(x, target_language = "fr", source_language = "en")
#  })
#  
#  google_table$es_mymemory <- sapply(phrases, function(x) {
#    mymemory_translate(x, target_language = "es", source_language = "en")
#  })
#  
#  print("Standard function with added MyMemory translations:")
#  print(google_table)

## ----advanced_workflow--------------------------------------------------------
#  # Define categories of phrases
#  navigation_phrases <- c("Home", "About", "Contact", "Services", "Portfolio")
#  form_phrases <- c("First Name", "Last Name", "Email Address", "Phone Number", "Message")
#  action_phrases <- c("Save", "Delete", "Edit", "Share", "Download", "Print")
#  
#  # Define comprehensive language set
#  target_languages <- c("es", "fr", "de", "it", "pt", "nl", "sv", "no")
#  
#  # Create separate translation tables for each category
#  navigation_table <- create_translation_table(navigation_phrases, target_languages)
#  form_table <- create_translation_table(form_phrases, target_languages)
#  action_table <- create_translation_table(action_phrases, target_languages)
#  
#  # Add category identifier
#  navigation_table$category <- "Navigation"
#  form_table$category <- "Forms"
#  action_table$category <- "Actions"
#  
#  # Combine into master translation table
#  master_table <- rbind(navigation_table, form_table, action_table)
#  
#  # Display summary
#  print(paste("Total phrases translated:", nrow(master_table)))
#  print(paste("Languages covered:", length(target_languages)))

## ----tidyverse_workflow-------------------------------------------------------
#  library(tibble)
#  library(dplyr)
#  
#  # Create a more structured approach
#  content_data <- tibble(
#    phrase_id = 1:8,
#    category = c("greetings", "greetings", "farewells", "farewells",
#                 "questions", "questions", "responses", "responses"),
#    priority = c("high", "medium", "high", "medium",
#                 "high", "medium", "high", "medium"),
#    english = c("Hello", "Good morning", "Goodbye", "See you later",
#                "What is your name?", "Where are you from?",
#                "My name is...", "I am from...")
#  )
#  
#  # Create translations for priority languages first
#  priority_languages <- c("es", "fr", "de")
#  translations <- create_translation_table(content_data$english, priority_languages)
#  
#  # Combine with original metadata
#  final_table <- bind_cols(content_data, translations[, -1])  # Remove duplicate original_word column
#  
#  # Filter and organize as needed
#  high_priority <- final_table %>%
#    filter(priority == "high") %>%
#    select(phrase_id, category, english, es, fr, de)
#  
#  print(high_priority)

## ----export_examples----------------------------------------------------------
#  # For web development - JSON-like structure
#  phrases <- c("Welcome", "Login", "Logout")
#  web_translations <- create_translation_table(phrases, c("es", "fr", "de"))
#  
#  # Create key-value structure for each language
#  create_json_structure <- function(table, lang) {
#    keys <- tolower(gsub(" ", "_", table$original_word))
#    values <- table[[lang]]
#    structure <- setNames(values, keys)
#    return(structure)
#  }
#  
#  spanish_json <- create_json_structure(web_translations, "es")
#  french_json <- create_json_structure(web_translations, "fr")
#  
#  print("Spanish translations:")
#  print(spanish_json)
#  
#  # For documentation purposes - wide format table
#  doc_table <- web_translations %>%
#    rename(English = original_word, Spanish = es, French = fr, German = de)
#  
#  print("Documentation table:")
#  print(doc_table)

