#load necessary packages
library(httr2)
library(jsonlite)

#set working directory to the folder containing this file
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# Source the functions
source("claude_prompt_functions.R")

# Read in a match variables file
match_vars <- readRDS("Yareni_Vargas_vs_Raathey_Rajarajan_2025-12-12.rds")

# Extract the variables
player_name <- match_vars$player_name
player_gender <- match_vars$player_gender
opponent_name <- match_vars$opponent_name
all_match_stats_text <- match_vars$all_match_stats_text

# Build your prompt
prompt <- paste0(
  "You are a professional tennis analyst. Analyze this match between ",
  player_name, " (", player_gender, ") and ", opponent_name, ".\n\n",
  "Match Statistics:\n",
  all_match_stats_text, "\n\n",
  "Provide insights on key performance patterns and areas for improvement."
)

# Call Claude API (assuming you have this function in claude_prompt_functions.R)
response <- call_claude_api(
  prompt = prompt,
  api_key = Sys.getenv("ANTHROPIC_API_KEY")  # Make sure this is set
)

# View the response
cat(response)library(httr2)
library(jsonlite)

# Source the functions
source("claude_prompt_functions.R")

# Read in a match variables file
match_vars <- readRDS("Vika_Xu_vs_James_Liu_20250125.rds")

# Extract the variables
player_name <- match_vars$player_name
player_gender <- match_vars$player_gender
opponent_name <- match_vars$opponent_name
all_match_stats_text <- match_vars$all_match_stats_text

# Build your prompt
full_prompt <- paste0(
  "You are writing a tennis match performance report for ", player_name, 
  ".\n",
  "Tone: coaching voice. Write in the third person. No academic language and no em-dashes.\n\n",
  
  "Player Gender: ", player_gender, "\n",
  "Match vs ", opponent_name, "\n\n",
  
  "STATS:\n", all_match_stats_text, "\n\n",
  
  "Instructions for report sections:\n",
  "1) ExecutiveSummary: Write a concise 3-5 sentence summary of the match.\n",
  "2) ServeIQ: Provide key takeaways (3-4 bullets) and suggestions for improvement (2-3 bullets).\n",
  "3) ReturnIQ: Provide key takeaways (3-4 bullets) and suggestions for improvement (2-3 bullets).\n",
  "4) RallyDNA: Provide key takeaways (3-4 bullets) and suggestions for improvement (2-3 bullets).\n",
  "5) ClutchFactor: Provide key takeaways (3-4 bullets) and suggestions for improvement (2-3 bullets).\n",
  "6) NextMatchFocus: Provide 3 priorities with numeric or percentage goals (e.g., '- Priority (goal: 70%)').\n\n",
  
  "Output Format:\n",
  "Return ONLY valid JSON with the following structure:\n",
  "{\n",
  "  \"ExecutiveSummary\": \"\",\n",
  "  \"ServeIQ\": {\"KeyTakeaways\": [], \"Suggestions\": []},\n",
  "  \"ReturnIQ\": {\"KeyTakeaways\": [], \"Suggestions\": []},\n",
  "  \"RallyDNA\": {\"KeyTakeaways\": [], \"Suggestions\": []},\n",
  "  \"ClutchFactor\": {\"KeyTakeaways\": [], \"Suggestions\": []},\n",
  "  \"NextMatchFocus\": []\n",
  "}\n\n",
  
  "Do not include any extra text, explanations, or markdown. JSON only."
)

# Call Claude API
full_report <- call_claude_api(full_prompt)

  # Remove ```json or ``` if present
full_report <- gsub("^```json", "", full_report)
full_report <- gsub("```$", "", full_report)

# Trim whitespace
full_report <- trimws(full_report)

report_parsed <- fromJSON(full_report)

writeLines(full_report, "match_report.txt")

cat(toJSON(report_parsed, pretty = TRUE, auto_unbox = TRUE))


