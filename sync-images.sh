#!/usr/bin/env bash
# Rewrite the `images:` block of every lab tool from whatever photos are
# actually sitting in static/images/lab-tools/<slug>/.
#
#   ./sync-images.sh              every tool
#   ./sync-images.sh gas-manifold just that one
#
# Drop photos in the folder, run this, done. Sorted by filename, so name them
# 01.jpg, 02.jpg, ... to control the order. The first image is the main one.

set -euo pipefail

[[ -d config ]] || { echo "Run this from the repo root (~/microbialquanta)"; exit 1; }

only="${1:-}"

for file in content/lab-tools/*.md; do
  slug=$(basename "$file" .md)
  [[ "$slug" == "_index" ]] && continue
  [[ -n "$only" && "$slug" != "$only" ]] && continue

  dir="static/images/lab-tools/${slug}"
  [[ -d "$dir" ]] || { echo "  skip   $slug (no image folder)"; continue; }

  shopt -s nullglob nocaseglob
  photos=("$dir"/*.{jpg,jpeg,png,webp})
  shopt -u nullglob nocaseglob

  if [[ ${#photos[@]} -eq 0 ]]; then
    echo "  skip   $slug (folder empty)"
    continue
  fi

  IFS=$'\n' photos=($(sort <<<"${photos[*]}")); unset IFS

  block=""
  for p in "${photos[@]}"; do
    block+="  - \"/images/lab-tools/${slug}/$(basename "$p")\""$'\n'
  done

  # Replace everything between `images:` and the next top-level frontmatter key.
  python3 - "$file" "$block" <<'PY'
import re, sys
path, block = sys.argv[1], sys.argv[2]
src = open(path).read()
new = re.sub(
    r"^images:\n(?:[ \t#-].*\n|\n)*",
    "images:\n" + block,
    src, count=1, flags=re.M)
if new == src and "images:" not in src:
    sys.exit(f"  ERROR  no images: key in {path}")
open(path, "w").write(new)
PY

  echo "  ok     $slug (${#photos[@]} photo$([[ ${#photos[@]} -ne 1 ]] && echo s))"
done

echo
echo "Preview: hugo server -D"
