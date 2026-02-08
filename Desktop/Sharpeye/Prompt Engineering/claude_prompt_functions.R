call_claude_api <- function(prompt, api_key = Sys.getenv("ANTHROPIC_API_KEY")) {
  if (api_key == "") {
    stop("ANTHROPIC_API_KEY environment variable not set")
  }

  req <- request("https://api.anthropic.com/v1/messages") |>
    req_method("POST") |>
    req_headers(
      "x-api-key" = api_key,
      "anthropic-version" = "2023-06-01",
      "content-type" = "application/json"
    ) |>
    req_body_json(list(
      model = "claude-opus-4-5-20251101",
      max_tokens = 4096,
      messages = list(list(
        role = "user",
        content = prompt
      ))
    ))

  resp <- req_perform(req)

  resp |>
    resp_body_json() |>
    (\(x) x$content[[1]]$text)()
}