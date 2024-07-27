## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(polyglotr)
library(purrr)
library(dplyr)
library(text2vec)

## ----reviews------------------------------------------------------------------
df <- head(movie_review, 10)
glimpse(df)

## show reviews
df$review

## ----translated---------------------------------------------------------------
# Translate the review column to French
translated_reviews <- df %>%
  dplyr::mutate(french_review = purrr::map_chr(review, ~ google_translate(.x, target_language = "fr", source_language = "en")))

## ----results------------------------------------------------------------------
glimpse(translated_reviews)

translated_reviews$french_review

