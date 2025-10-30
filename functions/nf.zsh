# List all submissions (JSON)
alias nf-list='curl -s -u ":$ADMIN_PASSWORD" "$NF_SERVER/submissions" | jq .'

# Get one submission by ID
# usage: nf-get <id>
nf-get() {
  curl -s -u ":$ADMIN_PASSWORD" "$NF_SERVER/submissions/$1" | jq .
}

# usage: nf-files <submission-id>
nf-getfile() {
  local arg="$1"
  if [[ -z "$arg" ]]; then
    echo "usage: nf-getfile <submission-id | stored_path>"; return 1
  fi

  # Heuristic: if it looks like a file path (has a dot or a slash), treat as stored_path
  if [[ "$arg" == *.* || "$arg" == */* ]]; then
    curl -f -O "$NF_SERVER/files/$arg" || {
      echo "download failed for path: $arg"; return 1;
    }
    return 0
  fi

  # Otherwise assume submission ID and fetch all attachments
  local data
  data=$(curl -s -u ":$ADMIN_PASSWORD" "$NF_SERVER/submissions/$arg")
  echo "$data" | jq -e '.files and (.files | length > 0)' >/dev/null || {
    echo "No files found for submission id: $arg"; return 1;
  }
  echo "$data" | jq -r '.files[].url' | while read -r p; do
    curl -f -O "$NF_SERVER$p" || echo "failed: $p"
  done
}

# Remove one or many
# usage: nf-remove <id1> <id2> <id3> ...
nf-remove() {
  ids=("$@")
  json=$(printf '"%s",' "${ids[@]}" | sed 's/,$//')
  curl -s -u ":$ADMIN_PASSWORD" \
    -H "Content-Type: application/json" \
    -d "{\"ids\":[${json}]}" \
    "$NF_SERVER/remove" | jq .
}
