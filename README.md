Data Dictionary:

Variable Name  | Variable Description | Variable Type
------------- | ------------- | ------------
artist_name  | The name of each artist. | String
edition_number  | The edition number of the textbook from either Janson's History
of Art or Gardner's Art Through the Ages. | Categorical
year | The year of publication for a given edition of Janson or Gardner. | Categorical
artist_nationality | The nationality of a given artist. | Categorical
artist_nationality_other | The nationality of the artist. Roughly 80% of of the total count of artists through all editions of Janson's History of Art and Gardner's Art Through the Ages account for French, Spanish, British, American and German. Therefore, the categorical strings of this variable are French, Spanish, British, American, German and Other| Categorical
artist_gender | The gender of the artist.| Categorical
artist_race | The race of the artist | Categorical
artist_race_nwi | The non-white indicator for artist race, meaning if an
artist's race is denoted as either white or non-white. | Categorical
artist_ethnicity | The ethnicity of the artist. | Categorical
book | Which book, either Janson or Gardner the particular artist at that
particular time was included.| Categorical
space_ratio_per_page_total | The area in centimeters squared of both the text and the figure of a particular artist in a given edition of Janson's History of Art divided by the area in centimeters squared of a single page of the respective edition.| Numeric
artist_unique_id | The unique identifying number assigned to artists across
books denoted in alphabetical order. | String
moma_count_to_date | The total count of exhibitions ever held by the Museum of Modern Art (MoMA) of a particular artist at a given year of publication.| Numeric
whitney_count_to_date | The count of exhibitions held by The Whitney of a particular artist at a particular moment of time, as highlighted by year. | Quantitative




