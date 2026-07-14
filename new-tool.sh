#!/usr/bin/env bash
# Scaffold a new Lab Tools entry.
#
#   ./new-tool.sh                 fully interactive, just answer the prompts
#   ./new-tool.sh "Gas manifold"  seeds the title, prompts for the rest
#
# Writes content/lab-tools/<slug>.md and creates the image folder.
# Press Enter to skip any link you don't have.

set -euo pipefail

[[ -d config ]] || { echo "Run this from the repo root (~/microbialquanta)"; exit 1; }

slugify() {
  echo "$1" | tr '[:upper:]' '[:lower:]' \
    | sed -e 's/[^a-z0-9]\+/-/g' -e 's/^-//' -e 's/-$//'
}

ask() {  # ask <prompt> <varname> [default]
  local prompt="$1" __var="$2" default="${3:-}" reply
  if [[ -n "$default" ]]; then
    read -r -p "$prompt [$default]: " reply
    reply="${reply:-$default}"
  else
    read -r -p "$prompt: " reply
  fi
  printf -v "$__var" '%s' "$reply"
}

TITLE="${1:-}"
[[ -n "$TITLE" ]] || ask "Tool name" TITLE
[[ -n "$TITLE" ]] || { echo "A name is required."; exit 1; }

SLUG=$(slugify "$TITLE")
FILE="content/lab-tools/${SLUG}.md"
IMGDIR="static/images/lab-tools/${SLUG}"

if [[ -e "$FILE" ]]; then
  echo "$FILE already exists. Edit it directly, or pick another name."
  exit 1
fi

echo
echo "Slug: $SLUG"
echo "One-paragraph pitch: what it does, what it replaces, what it costs."
ask "Description" DESC
ask "Weight (lower shows first)" WEIGHT "100"
ask "GitHub URL" GITHUB
ask "Thingiverse URL" THING
ask "Hackaday URL" HACKADAY
ask "Draft? (y/n)" DRAFT "n"

[[ "$DRAFT" =~ ^[Yy] ]] && DRAFT=true || DRAFT=false

mkdir -p "$IMGDIR"

# If photos are already sitting in the folder, list them. Otherwise leave
# commented placeholders and let sync-images.sh fill them in later.
IMAGES=""
shopt -s nullglob nocaseglob
for img in "$IMGDIR"/*.{jpg,jpeg,png,webp}; do
  IMAGES+="  - \"/images/lab-tools/${SLUG}/$(basename "$img")\""$'\n'
done
shopt -u nullglob nocaseglob
if [[ -z "$IMAGES" ]]; then
  IMAGES='  # - "/images/lab-tools/'"${SLUG}"'/01.jpg"
  # - "/images/lab-tools/'"${SLUG}"'/02.jpg"
  # - "/images/lab-tools/'"${SLUG}"'/03.jpg"'$'\n'
fi

cat > "$FILE" <<EOF
---
title: "${TITLE}"
date: $(date +%Y-%m-%d)
draft: ${DRAFT}
description: "${DESC}"
weight: ${WEIGHT}
images:
${IMAGES}github_url: "${GITHUB}"
thingiverse_url: "${THING}"
hackaday_url: "${HACKADAY}"
tags: []
---

EOF

echo
echo "  created  $FILE"
echo "  created  $IMGDIR/"
echo
echo "Next: drop photos in $IMGDIR/ then run ./sync-images.sh"
echo "Preview with: hugo server -D"
