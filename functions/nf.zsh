# List all submissions (JSON)
alias nf-list='curl -s -u ":$ADMIN_PASSWORD" "$NF_SERVER/submissions" | jq .'

# Get one submission by ID
# usage: nf-get <id>
nf-get() {
  curl -s -u ":$ADMIN_PASSWORD" "$NF_SERVER/submissions/$1" | jq .
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
