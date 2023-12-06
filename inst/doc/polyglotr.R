## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(polyglotr)

## ----translate text-----------------------------------------------------------
text <- "Hello, how are you?"

# Translate using MyMemory Translation API
translation_mymemory <- mymemory_translate(text, target_language = "fr", source_language = "en")

# Translate using Google Translate
translation_google <- google_translate(text, target_language = "fr", source_language = "en")

cat(translation_mymemory)
cat(translation_google)

## ----translate file-----------------------------------------------------------
# Translate the content of a file using Google Translate
# translate_file("path/to/file.txt", target_language = "fr", source_language = "en", overwrite = TRUE)

