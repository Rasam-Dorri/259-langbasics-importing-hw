#PSYC 259 Homework 1 - Data Import
#For full credit, provide answers for at least 6/8 questions

#List names of students collaborating with (no more than 2): 

#GENERAL INFO 
#data_A contains 12 files of data. 
#Each file (6192_3.txt) notes the participant (6192) and block number (3)
#The header contains metadata about the session
#The remaining rows contain 4 columns, one for each of 20 trials:
#trial_number, speed_actual, speed_response, correct
#Speed actual was whether the figure on the screen was actually moving faster/slower
#Speed response was what the participant report
#Correct is whether their response matched the actual speed

### QUESTION 1 ------ 

# Load the readr package

# ANSWER
library(readr)

### QUESTION 2 ----- 

# Read in the data for 6191_1.txt and store it to a variable called ds1
# Ignore the header information, and just import the 20 trials
# Be sure to look at the format of the file to determine what read_* function to use
# And what arguments might be needed

# ds1 should look like this:

# # A tibble: 20 × 4
#  trial_num    speed_actual speed_response correct
#   <dbl>       <chr>        <chr>          <lgl>  
#     1          fas          slower         FALSE  
#     2          fas          faster         TRUE   
#     3          fas          faster         TRUE   
#     4          fas          slower         FALSE  
#     5          fas          faster         TRUE   
#     6          slo          slower         TRUE
# etc..

# A list of column names are provided to use:

col_names  <-  c("trial_num","speed_actual","speed_response","correct")

# ANSWER
# Given column names:
col_names  <-  c("trial_num","speed_actual","speed_response","correct")

ds1 <- read_tsv(
  file = "data_A/6191_1.txt",
  col_names = col_names,
  skip = 12,     
  n_max = 20     # We only need 20 rows of data
)

ds1



### QUESTION 3 ----- 

# For some reason, the trial numbers for this experiment should start at 100
# Create a new column in ds1 that takes trial_num and adds 100
# Then write the new data to a CSV file in the "data_cleaned" folder

# ANSWER
# ANSWER
library(dplyr)

ds1 <- ds1 %>%
  mutate(trial_num_100 = trial_num + 100)

# Write the new data to data_cleaned folder
write_csv(ds1, file = "data_cleaned/6191_1.csv")


### QUESTION 4 ----- 

# Use list.files() to get a list of the full file names of everything in "data_A"
# Store it to a variable

# ANSWER

files <- list.files(path = "data_A", pattern = "*.txt", full.names = TRUE)
files


### QUESTION 5 ----- 

# Read all of the files in data_A into a single tibble called ds

# ANSWER
library(purrr)

ds <- map_dfr(
  files,
  ~ read_tsv(
    .x,
    col_names = col_names,
    skip = 12,     # Again, adjust as needed
    n_max = 20
  )
)

ds


### QUESTION 6 -----

# Try creating the "add 100" to the trial number variable again
# There's an error! Take a look at 6191_5.txt to see why.
# Use the col_types argument to force trial number to be an integer "i"
# You might need to check ?read_tsv to see what options to use for the columns
# trial_num should be integer, speed_actual and speed_response should be character, and correct should be logical
# After fixing it, create the column to add 100 to the trial numbers 
# (It should work now, but you'll see a warning because of the erroneous data point)

# ANSWER
ds <- map_dfr(
  files,
  ~ read_tsv(
    .x,
    col_names = col_names,
    skip = 12,
    n_max = 20,
    col_types = cols(
      trial_num = col_integer(),
      speed_actual = col_character(),
      speed_response = col_character(),
      correct = col_logical()
    )
  )
) %>%
  mutate(trial_num_100 = trial_num + 100)  # Now it should work

ds


### QUESTION 7 -----

# Now that the column type problem is fixed, take a look at ds
# We're missing some important information (which participant/block each set of trials comes from)
# Read the help file for read_tsv to use the "id" argument to capture that information in the file
# Re-import the data so that filename becomes a column

# ANSWER
ds <- map_dfr(
  files,
  ~ read_tsv(
    .x,
    col_names = col_names,
    skip = 12,
    n_max = 20,
    col_types = cols(
      trial_num = col_integer(),
      speed_actual = col_character(),
      speed_response = col_character(),
      correct = col_logical()
    ),
    id = "filename"  # This will add a column named "filename"
  )
)

ds


### QUESTION 8 -----

# Your PI emailed you an Excel file with the list of participant info 
# Install the readxl package, load it, and use it to read in the .xlsx data in data_B
# There are two sheets of data -- import each one into a new tibble

# ANSWER
# install.packages("readxl")  # if not installed
library(readxl)

# Suppose the Excel file is named "participant_info.xlsx" in data_B
sheet1 <- read_xlsx("data_B/participant_info.xlsx", sheet = 1)
sheet2 <- read_xlsx("data_B/participant_info.xlsx", sheet = 2)

sheet1
sheet2

