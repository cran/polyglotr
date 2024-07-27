## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(polyglotr)

## -----------------------------------------------------------------------------
external_sources <- linguee_external_sources("hello", src = "en", dst = "de")

print(external_sources)

## -----------------------------------------------------------------------------
translation_examples <- linguee_translation_examples("hello", src = "en", dst = "de")

print(translation_examples)

## -----------------------------------------------------------------------------
word_translation <- linguee_word_translation("hello", source_language = "en", target_language = "de")

print(word_translation)

