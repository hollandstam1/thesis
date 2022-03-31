# load packages ----------------------------------------------------------------

library(tidyverse)
library(janitor)

# load data --------------------------------------------------------------------

# load gardner
gardner <- read_csv(here::here("raw-data/gardner.csv")) %>%
  janitor::clean_names()

# load janson
janson <- read_csv(here::here("raw-data/janson.csv")) %>%
  janitor::clean_names()

# load MoMA
moma <- read_csv(here::here("raw-data/moma.csv")) %>%
  janitor::clean_names() %>%
  filter(year != "MISSING YEAR") %>%
  mutate(year = as.numeric(year))

# load Whitney
whitney <- read_csv(here::here("raw-data/whitney.csv")) %>%
  janitor::clean_names()

# clean janson -----------------------------------------------------------------

janson <- janson %>%
  mutate(
    artist_nationality_other =
      case_when(
        artist_nationality == "French" ~ "French",
        artist_nationality == "British" ~ "British",
        artist_nationality == "American" ~ "American",
        artist_nationality == "Spanish" ~ "Spanish",
        artist_nationality == "German" ~ "German",
        TRUE ~ "Other"
      )
  ) %>%
  dplyr::select(
    "artist_name",
    "edition_number",
    "year",
    "artist_nationality",
    "artist_nationality_other",
    "artist_gender",
    "artist_race",
    "artist_ethnicity",
    "book",
    "space_ratio_per_page"
  )

# clean gardner ----------------------------------------------------------------

gardner <- gardner %>%
  mutate(
    artist_nationality_other =
      case_when(
        artist_nationality == "French" ~ "French",
        artist_nationality == "British" ~ "British",
        artist_nationality == "American" ~ "American",
        artist_nationality == "Spanish" ~ "Spanish",
        artist_nationality == "German" ~ "German",
        TRUE ~ "Other"
      )
  ) %>%
  dplyr::select(
    "artist_name",
    "edition_number",
    "year",
    "artist_nationality",
    "artist_nationality_other",
    "artist_gender",
    "artist_race",
    "artist_ethnicity",
    "book",
    "space_ratio_per_page"
  )

# combine gardner and janson ---------------------------------------------------

gardnerjanson <- gardner %>%
  bind_rows(janson)

sumgj <- gardnerjanson %>%
  arrange(artist_name, year, book) %>%
  group_by(artist_name, year, book) %>%
  summarize(space_ratio_per_page_total = sum(space_ratio_per_page), .groups = 'drop')

gardnerjanson <- gardnerjanson%>%
  left_join(sumgj)%>%
  dplyr::select(-space_ratio_per_page)%>%
  unique()

gardnerjanson <- gardnerjanson %>%
  group_by(artist_name)%>%
  mutate(artist_unique_id = cur_group_id())

# clean moma data --------------------------------------------------------------

moma_complete_years <- moma %>%
  count(artist_name, year)%>%
  mutate(count = 1)%>%
  arrange(artist_name, year)%>%
  group_by(artist_name)%>%
  ungroup() %>%
  complete(artist_name, year = c(min(year):max(year))) %>%
  mutate(
    moma_count = if_else(is.na(count), 0, count)
  ) %>%
  arrange(artist_name, year)%>%
  group_by(artist_name)%>%
  mutate(moma_count_to_year = cumsum(moma_count))%>%
  ungroup()%>%
  dplyr::select(artist_name, year, moma_count, moma_count_to_year)

# clean whitney data -----------------------------------------------------------

whitney_complete_years <- whitney %>%
  count(artist_name, year)%>%
  mutate(count = 1)%>%
  arrange(artist_name, year)%>%
  group_by(artist_name)%>%
  ungroup() %>%
  complete(artist_name, year = c(min(year):max(year))) %>%
  mutate(
    whitney_count = if_else(is.na(count), 0, count)
  ) %>%
  arrange(artist_name, year)%>%
  group_by(artist_name)%>%
  mutate(whitney_count_to_year = cumsum(whitney_count))%>%
  ungroup()%>%
  dplyr::select(artist_name, year, whitney_count, whitney_count_to_year)

# join museum data -------------------------------------------------------------

gardnerjanson_museums <- gardnerjanson %>%
  left_join(moma_complete_years, by = c("artist_name", "year")) %>%
  left_join(whitney_complete_years, by = c("artist_name", "year"))

gardnerjanson_museums[is.na(gardnerjanson_museums)] <- 0

gardnerjanson_museums <- gardnerjanson_museums %>%
  mutate(
    book = case_when(book == "janson" ~ "Janson", book == "gardner" ~ "Gardner"),
    artist_gender = if_else(artist_name == "Mele Sitani", "Female", artist_gender)
    ) %>%
  dplyr::select(-moma_count, -whitney_count) %>%
  mutate(
    artist_ethnicity = case_when(
      artist_ethnicity == "Hispanic or Latinx" ~ "Hispanic or Latino origin",
      artist_ethnicity == "Not Hispanic or Latinx" ~ "Not Hispanic or Latino origin"
      ),
    artist_race_nwi = if_else(artist_race == "White", "White", "Non-White")
    )

# write file -------------------------------------------------------------------

write_csv(gardnerjanson, file = here::here("processed-data/gardnerjanson.csv"))
write_csv(gardnerjanson_museums, file = here::here("processed-data/gardnerjanson_museums.csv"))
